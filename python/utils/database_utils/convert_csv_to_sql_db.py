#
# Generate SQL scripts from CSV files downloaded from Google Sheets tabs
#
#
# See: https://gist.github.com/antivanov/59e00f6129725e9b4404

# Instructions

import os, glob, time, argparse, shutil, csv, json, yaml, openpyxl
from datetime import datetime

# Log message to file
LOG_PATH = 'c:/temp/'
logfile = open(os.path.join(LOG_PATH, 'convert_csv_to_sql_db.log'), 'a')
def log(msg, dt = False):
    global logfile
    if msg == '': dt = False
    if dt: msg = datetime.now().strftime('%d/%m/%y %H:%M:%S.%f')[:-3] + ' ' + msg
    print(msg)
    if logfile:
        logfile.write(msg)
        logfile.write("\n")
        logfile.flush()


'''
CREATE TABLE public."table" (
  "RawImageID" INTEGER NOT NULL,
  "RA_Center" DOUBLE PRECISION,
  str1 VARCHAR(250),
  CONSTRAINT table_pkey PRIMARY KEY("RawImageID")
) ;

ALTER TABLE public."table"
  ALTER COLUMN "RawImageID" SET STATISTICS 0;

ALTER TABLE public."table"
  ALTER COLUMN "RA_Center" SET STATISTICS 0;

ALTER TABLE public."table"
  ALTER COLUMN str1 SET STATISTICS 0;

ALTER TABLE public."table"
  OWNER TO postgres;

'''


def get_field_type(field_name, text):
    ftype = ''
    text = text.split(' ')[0]
    text = text.replace('Enumeration:', '').strip().lower()
    if text == 'int8' or text == 'int16' or text == 'int32':
        ftype = 'INTEGER'
    elif text == 'int64':
        ftype = 'BIGINT'
    elif text == 'single' or text == 'double':
        ftype = 'DOUBLE PRECISION'
    elif text == 'bool':
        ftype = 'BOOLEAN'
    elif text == 'string' or text == 'text':
        ftype = 'VARCHAR'

    # Special field: UUID
    elif text == 'uuid':
        ftype = 'VARCHAR'
    else:
        ftype = '???'

        # Special case: Hierarchical Triangular Mesh
        if field_name.startswith('HTM_ID'):
            ftype = 'VARCHAR'
        else:
            log('Unknown field type: ' + text)

    return ftype


class Field:

    def __init__(self):
        self.field_name = ''
        self.field_type = ''
        self.data_type = ''
        self.comments = ''
        self.metadata = ''
        self.json = None
        self.yaml = None
        self.primary_key = False
        self.index = False
        self.index_method = 'btree'
        self.is_common = False


def get_csv(row, column, _default = '', _strip = True):
    if column in row:
        if row[column]:
            value = row[column]
        else:
            value = ''
        if _strip:
            value = value.strip()
    else:
        value = _default

    return value


class DatabaseDef:

    #
    def __init__(self):
        self.field_list = []
        self.field_dict = {}
        self.def_path = ''
        self.db_name = ''
        self.table_name = ''
        self.source_filename = ''
        self.set_statistics = False
        self.set_owner = False
        self.sql_filename = ''
        self.outf = None


    #
    def set_db(self, filename: str) -> None:

        # Split file name to database name and table name, i.e.
        # 'image_tables - processed_cropped_images.csv'
        log('set_db: ' + filename)

        self.source_filename = filename
        path, fname = os.path.split(filename)
        fn, ext = os.path.splitext(fname)
        self.def_path = path

        # Get database name from last part of folder name
        self.db_name = os.path.split(path)[1]
        log('database name: ' + self.db_name)

        # Get table name from tab name
        tab_name = fn.split('-')
        prefix = tab_name[0].strip()
        if len(tab_name) > 1:
            self.table_name = tab_name[1].strip()
        else:
            self.table_name = ''

        log('table name: ' + self.table_name)

        # Prepare output SQL file name
        self.sql_filename = os.path.join(path, '__' + self.db_name + '.sql')
        log('sql output file: ' + self.sql_filename)

        # Field does not exist yet, need to add 'create database' commands
        need_create = False
        if not os.path.exists(self.sql_filename):
            log('sql output file does not exist, creating new database: ' + self.db_name)
            need_create = True

        # Open file for append
        self.outf = open(self.sql_filename, 'a')
        self.write('\n')

        if need_create:
            self.create_db()


    def create_db(self):

        log('create_db started : ' + self.db_name)

        # Check if we have specific file for our database
        fname = os.path.join(self.def_path, 'create_database.sql')

        # Not found, use general file
        if not os.path.exists(fname):
            fname = os.path.join(self.def_path, '../..', 'create_database.sql')

            if not os.path.exists(fname):
                log('create_db: database definition file not found: ' + fname)
                return

        log('using database file: ' + fname)

        self.write('--\n')
        self.write('-- Automatic Generated File by convert_csv_to_sq_db.py\n')
        self.write('-- Source file: ' + fname + '\n')
        self.write('--\n')
        self.write('\n\n\n')

        with open(fname) as f:
            lines = f.read().splitlines()

        for line in lines:
            line = line.rstrip()

            # Replace database name macro
            if line.find('$DatabaseName$') > -1:
                line = line.replace('$DatabaseName$', self.db_name)
                log('replaced $DatabaseName$: ' + line)

            self.write(line)
            self.write('\n')

        log('create_db done: ' + self.db_name)
        log('')


    #
    def get_include_filename(self, filename: str, include: str) -> str:
        path, fname = os.path.split(filename)
        fn, ext = os.path.splitext(fname)
        db = fname.split('-')
        include_filename = os.path.join(path, db[0].strip() + ' - ' + include + '.csv')
        return include_filename


    # Load table definition from specified csv file
    def load_table_csv(self, filename: str) -> None:

        log('load_table_csv started: ' + filename)
        self.source_filename = filename

        # [Tab Name] in brackets indicates common fields (not a table)
        is_common = False
        if filename.find('(') > -1:
            is_common = True

        f = open(filename, newline='')
        rdr = csv.DictReader(f)
        field_count = 0

        for row in rdr:
            try:
                field = Field()
                field.field_name = get_csv(row, 'Field Name')

                # Skip empty rows
                if field.field_name == '':
                    continue

                # Load include file (common fields)
                # Note: Recursive call
                if field.field_name.find('(') > -1:
                    include_filename = self.get_include_filename(filename, field.field_name)
                    if include_filename != '' and os.path.exists(include_filename):
                        log('loading include file: ' + include_filename)
                        self.load_table_csv(include_filename)
                    continue


                field.description = get_csv(row, 'Description')
                field.field_type = get_csv(row, 'Data Type')
                field.comments = get_csv(row, 'Comments')
                field.metadata = get_csv(row, 'Metadata')
                field.is_common = is_common

                # Load field metadata as YAML data
                field.yaml = yaml.load('{' + field.metadata + '}', Loader=yaml.FullLoader)

                # Parse metadata
                if 'index_method' in field.yaml:
                    field.index_method = field.yaml['index_method']

                # Field type
                field.data_type = get_field_type(field.field_name, field.field_type)
                if field.data_type == '':
                    field.data_type = '???'
                    log('WARNING: unknown field type, field ignored: ' + field.field_name)
                    continue

                # Primary key
                if field.field_name.find('**') > -1:
                    field.field_name = field.field_name.replace('**', '')
                    field.primary_key = True

                # Index
                if field.field_name.find('*') > -1:
                    field.field_name = field.field_name.replace('*', '')
                    field.index = True

                # Check if field already seen
                if field.field_name in self.field_dict:
                    log('field already defined, ignored: ' + field.field_name)
                    continue


                self.field_list.append(field)
                self.field_dict[field.field_name] = field
                field_count += 1

            except:
                print('ex')

        log('load_table_csv done: ' + filename + ' - fields loaded: ' + str(field_count))
        log('')


    # Create table from self.field_list
    def create_table(self):

        if len(self.field_list) == 0:
            return

        log('create_table started: ' + self.table_name + ' - fields: ' + str(len(self.field_list)))

        self.write('--\n')
        self.write('-- Automatic Generated Table Definition\n')
        self.write('-- Source file: ' + self.source_filename + '\n')
        self.write('--\n')
        self.write('\n')

        self.write('CREATE TABLE public.{} (\n'.format(self.table_name))
        #self.write('CREATE TABLE public."{}" (\n'.format(self.table_name))

        primary_key = []

        for field in self.field_list:

            # Debug only
            prefix = ''
            #if field.is_common:
            #    prefix = 'Common_'

            field_def = field.data_type

            if field.primary_key:
                primary_key.append(field.field_name)
                field_def += ' NOT NULL'

            field_def += ','

            self.write('{}{} {}\n'.format(prefix, field.field_name, field_def))
            #self.write('"{}{}" {}\n'.format(prefix, field.field_name, field_def))


        # Primary key
        if len(primary_key) > 0:
            log('primary key: ' + str(primary_key))
            self.write('\nCONSTRAINT {} PRIMARY KEY({})\n'.format(self.table_name + '_pkey', ', '.join(primary_key)))
            #self.write('\nCONSTRAINT {} PRIMARY KEY("{}")\n'.format(self.table_name + '_pkey', ', '.join(primary_key)))

        self.write(');\n\n')

        # SET STATISTICS 0
        if self.set_statistics:
            for field in self.field_list:
                self.write('ALTER TABLE public.{}\n  ALTER COLUMN {} SET STATISTICS 0;\n\n'.format(self.table_name, field.field_name))
                #self.write('ALTER TABLE public."{}"\n  ALTER COLUMN "{}" SET STATISTICS 0;\n\n'.format(self.table_name, field.field_name))

        # Index
        for field in self.field_list:
            if field.index:
                index_name = self.table_name + '_idx_' + field.field_name
                self.write('CREATE INDEX {} ON public.{}\n  USING {} ({});\n\n'.format(index_name, self.table_name, field.index_method, field.field_name))
                #self.write('CREATE INDEX {} ON public."{}"\n  USING {} ("{}");\n\n'.format(index_name, self.table_name, field.index_method, field.field_name))

        # OWNER
        if self.set_owner:
            self.write('ALTER TABLE public.{}\n  OWNER TO postgres;\n'.format(self.table_name))
            #self.write('ALTER TABLE public."{}"\n  OWNER TO postgres;\n'.format(self.table_name))

        self.outf.close()
        log('create_table done: ' + self.table_name)
        log('')


    def write(self, text):
        #print(text)
        self.outf.write(text)
        self.outf.flush()

#============================================================================

# Extract all sheets from xlsx file to output folder
def extract_xlsx(filename):
    log('extract_csv started: ' + filename)
    path, fname = os.path.split(filename)
    fn, ext = os.path.splitext(fname)

    db = fn.split('__')[0]
    out_path = os.path.join(path, db)
    if not os.path.exists(out_path):
        os.path.makedirs(out_path)

    # Open
    wb = openpyxl.load_workbook(filename)
    log('sheet count: ' + str(len(wb.sheetnames)))
    log('sheets: ' + str(wb.sheetnames))

    # Scan sheets
    for i, sheet_name in enumerate(wb.sheetnames):
        sheet = wb.worksheets[i]
        csv_fname = os.path.join(out_path, db + ' - ' + sheet_name + '.csv')
        log('write csv: ' + csv_fname)
        with open(csv_fname, 'w', newline="") as f:
            c = csv.writer(f)
            for r in sheet.rows:
                c.writerow([cell.value for cell in r])

    log('extract_csv done: ' + filename)


# Process folder with CSV database definition files
def process_folder(fpath, ext_list, subdirs = True):
    if subdirs:
        flist = glob.glob(os.path.join(fpath, '**/*.*'), recursive=True)
    else:
        flist = glob.glob(os.path.join(fpath, '*.*'), recursive=False)

    # Step 1:
    for filename in flist:
        filename_lower = filename.lower()
        path, fname = os.path.split(filename_lower)

        # Prepare list of common fields
        for ext in ext_list:
            ext = ext.lower()
            if filename_lower.endswith(ext):

                if ext == '.xlsx':
                    extract_xlsx(filename_lower)

                elif ext == '.csv':

                    # Skip [common fields csv files]
                    if fname.find('(') == -1:

                        # Set database from file name
                        log('')
                        db = DatabaseDef()
                        db.set_db(filename_lower)
                        db.load_table_csv(filename_lower)
                        if len(db.field_list) > 0:
                            db.create_table()


#============================================================================

def main():

    # Read command line options
    parser = argparse.ArgumentParser()

    # Arguments
    #parser.add_argument('-d',           dest='dir',         default=None,                                   help='pcap folder')
    #parser.add_argument('-s',           dest='subdirs',     action='store_true',    default=True,   help='Process pcap files in subfolders')
    #args = parser.parse_args()

    folder = './db/'

    process_folder(folder, ['.xlsx'], True)

    process_folder(folder, ['.csv'], True)


if __name__ == '__main__':
    main()
