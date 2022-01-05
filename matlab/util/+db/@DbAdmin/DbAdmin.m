% DbAdmin - PostgresSQL Database Administrator Class
%
% Basic usage:
%
%
%
% PostgreSQL V14 - Installation instructions for Linux:
%
%     https://techviewleo.com/how-to-install-postgresql-database-on-ubuntu/
%
% Create database on remote server (password: 'Passw0rd')
%
%     psql -h gauss -p 5432 -U admin -W -d postgres -f unittest.sql
%
%--------------------------------------------------------------------------

classdef DbAdmin < Component

    % Properties
    properties (SetAccess = public)

        % Connection details
        Conn            = []        % DbConnection
        Query           = []        % DbQuery, required to execute statements
        Host            = ''        % 
        Port            = 5432      %                               
        DatabaseName    = ''        % Use 'postgres' to when creating databases or for general
        UserName        = ''        %
        Password        = ''        %
        TableName       = ''        %        
    end

    %----------------------------------------------------------------------
    methods % Constructor

        % Constructor
        function Obj = DbAdmin(Args)
            % Create new DbAdmin obeject
            % Input:
            %    'DbCon'     -
            %    'Host'      -
            %    'Database'  -
            %    'UserName'  -
            %    'Password'  - 
            %    'Port'      - 
            %    'TableName' - 
            %
            % Examples:
            %   % Create query object for 'UnitTest' database alias 'UnitTest'
            %   Q = DbAdmin('UnitTest')
            %
            arguments
                Args.DbQuery       = []        %
                Args.DbCon         = []        % DbConnection object
                Args.Host          = ''        %
                Args.Port          = 5432      %                               
                Args.DatabaseName  = ''        % Use 'postgres' to when creating databases or for general
                Args.UserName      = ''        %
                Args.Password      = ''        %
                Args.TableName     = ''        %
            end

            % Setup component
            Obj.setName('DbAdmin');
            Obj.needUuid();
            Obj.DebugMode = true;
            %Obj.msgLog(LogLevel.Debug, 'created: %s', Obj.Uuid);

            % Set connection
            if ~isempty(Args.DbQuery)
                Obj.setConn(Args.DbQuery.Conn);
            elseif ~isempty(Args.DbCon)
                Obj.setConn(Args.DbCon);
            else
                
                NewCon = db.DbConnection('Host', Args.Host, 'Port', Args.Port, ...
                    'DatabaseName', Args.DatabaseName, 'UserName', Args.UserName, 'Password', Args.Password);
                
                Obj.setConn(NewCon);
            end
                       
            % Override TableName and set other properties
            %Obj.setProps(Args);
            
            Obj.Query = db.DbQuery(Obj.Conn);

        end


        % Destructor
        function delete(Obj)
            Obj.clear();
            Obj.msgLog(LogLevel.Debug, 'deleted: %s', Obj.Uuid);
        end
        
        
        function Result = setConn(Obj, Conn)
            % Input:   Conn - 
            % Output:  true on success
            % Example: Obj.setConn(DbCon);
            
            Obj.Conn = Conn;            
            Obj.Host = Conn.Host;
            Obj.Port = Conn.Port;
            Obj.DatabaseName = Conn.DatabaseName;
            Obj.UserName = Conn.UserName;
            Obj.Password = Conn.Password;
            Result = true;            
        end
    end

    %----------------------------------------------------------------------    
    methods % Database creating & modification
        
        function Result = createDatabase(Obj, Args)
            % Create database
            % Input:   
            %    'XlsFileName' - When specified, 
            %
            % 'DatabaseName'  - 
            %          'SqlFileName'   -
            %          
            % Output:  true on success
            % Example: -            
            % Instructions
            
            arguments
                Obj
                Args.XlsFileName    = ''        %
                Args.DatabaseName   = ''        %
                Args.Script         = ''        % Script text
                Args.SqlFileName    = ''        %
                
            end
            
            % Execute SQL file using psql
            if ~isempty(Args.SqlFileName)
                if isfile(Args.SqlFileName)
                    Obj.runPsql('SqlFileName', Args.SqlFileName);
                end
                
            % Extract database definition from XLS file and execute the
            % resulting SQL file using psql
            elseif ~isempty(Args.XlsFileName)
                SqlFileName = Obj.xls2sql(Args.XlsFileName);
                if ~isempty(SqlFileName) && isfile(SqlFileName)
                    Obj.runPsql(SqlFileName);
                end
            else
                
            end

        end

        
        function Result = createConnection(Obj, DatabaseName, Args)
            % Create database connection in config/local/Database.DbConnections.UnitTest.yml
            % Input:   DbName
            % Output:  true on success
            % Example: db.DbAdmin.createConnection()
            % Database.DbConnections.UnitTest.yml
            
            arguments
                Obj
                DatabaseName                            %
                Args.Host           = 'localhost'       % Host name or IP address
                Args.Port           = 5432
                Args.DriverName     = 'postgres'        % Driver name
                Args.UserName       = ''                % Login user
                Args.Password       = ''                % Login password
            end
            
        end
              
        
        function Result = createTable(Obj, Args)
            % Create database table, @Todo
            % Input:   
            % Output:  
            % Example: db.DbAdmin.createTable('unittest', )
            % https://www.postgresql.org/docs/8.0/sql-createuser.html
            arguments
                Obj
                Args.SqlText        = ''
                Args.SqlFileName    = ''
                Args.TableName      = ''
                Args.PrimaryKeyDef  = ''
            end

%         DROP TABLE IF EXISTS customers CASCADE;
% 
%         CREATE TABLE customers (
%             id SERIAL PRIMARY KEY,
%             customer_name VARCHAR NOT NULL
%         );

            % Read input file
            SqlText = '';
            if ~isempty(Args.SqlText)
                SqlText = Args.SqlText;
            elseif ~isempty(Args.SqlFileName)
                SqlText = fileread(Args.SqlFileName);
            else                
                SqlText = sprintf('CREATE TABLE %s (%s PRIMARY KEY)', TableName, PrimaryKeyDef);
            end
            
            if ~isempty(SqlText)
                Obj.exec(SqlText);            
            end
        end
        
        
        function Result = addColumn(Obj, TableName, ColumnName, DataType, ColumnDef)
            % Add single or multiple columns to table
            % Input:   
            % Output:  
            % Example: Obj.addColumn('master_table', 'MyColA', 'INTEGER', 'DEFAULT 0')
            % Refs:    https://www.postgresqltutorial.com/postgresql-add-column/
            % SQL:     ALTER TABLE table_name
            %          ADD COLUMN column_name1 data_type constraint,
            %          ADD COLUMN column_name2 data_type constraint,
            %          ...
            %          ADD COLUMN column_namen data_type constraint;
            arguments
                Obj
                TableName               %
                ColumnName              %
                DataType                %
                ColumnDef               %                            
            end

            % Validate input
            assert(numel(ColumnName) == numel(DataType));
            assert(numel(ColumnName) == numel(ColumnDef));
            
            SqlText = sprintf('ALTER TABLE %s ', TableName);

            for i=1:numel(ColumnName)
                SqlText = sprintf('%s ADD COLUMN %s %s %s', ColumnName(i), DataType(i), ColumnDef(i));
                if i == numel(ColumnName)
                    SqlText = strcat(SqlText, ';');
                else
                    SqlText = strcat(SqlText, ',');
                end
            end
            
            Result = Obj.exec(SqlText);

        end

        
        function Result = addIndex(Obj, TableName, IndexName, IndexDef)
            % Add single index to table, may include one or multiple fields
            % Input:   TableName - Table name to be altered
            %          IndexName - Unique index name, usually composed as
            %                      TableName_idx_FieldNames, for example 'master_table_idx_FDouble2'
            %          IndexDef  - Index definition text with list of fields, for example: 'USING btree (FDouble2)'
            %
            % Output:  true on sucess
            % Example: addIndex('master_table', 'master_table_idx_FDouble2', 'USING btree (FDouble2)');
            % Refs:    https://www.postgresql.org/docs/9.1/sql-createindex.html
            %          https://www.postgresqltutorial.com/postgresql-indexes/postgresql-create-index/
            % SQL:     CREATE INDEX index_name ON table_name [USING method]
            %          (
            %             column_name [ASC | DESC] [NULLS {FIRST | LAST }],
            %             ...
            %          );
            arguments
                Obj                 %
                TableName           %
                IndexName           %                
                IndexDef            %
            end           
                        
            SqlText = sprintf('CREATE INDEX %s ON %s %s', IndexName, TableName, IndexDef);            
            Result = Obj.exec(SqlText);            
        end        
        
    end
    
    %----------------------------------------------------------------------        
    methods % User Management
        
        % https://www.postgresql.org/docs/14/user-manag.html
        %
        % PostgreSQL manages database access permissions using the concept of roles. 
        % A role can be thought of as either a database user, or a group of database 
        % users, depending on how the role is set up. Roles can own database objects 
        % (for example, tables and functions) and can assign privileges on those 
        % objects to other roles to control who has access to which objects. 
        % Furthermore, it is possible to grant membership in a role to another role, 
        % thus allowing the member role to use privileges assigned to another role.
        %
        % The concept of roles subsumes the concepts of “users” and “groups”.
        % In PostgreSQL versions before 8.1, users and groups were distinct kinds 
        % of entities, but now there are only roles. Any role can act as a user, 
        % a group, or both.
        %
        %
        % Database roles are conceptually completely separate from operating 
        % system users. In practice it might be convenient to maintain a 
        % correspondence, but this is not required. Database roles are global 
        % across a database cluster installation (and not per individual database). 
        %         
        % Every connection to the database server is made using the name of 
        % some particular role, and this role determines the initial access 
        % privileges for commands issued in that connection. 
        % The role name to use for a particular database connection is indicated 
        % by the client that is initiating the connection request in an 
        % application-specific fashion. For example, the psql program uses 
        % the -U command line option to indicate the role to connect as. 
        % Many applications assume the name of the current operating system 
        % user by default (including createuser and psql). 
        % Therefore it is often convenient to maintain a naming correspondence 
        % between roles and operating system users.
        %
        %
        % 
        % CREATE ROLE admin WITH LOGIN SUPERUSER CREATEDB CREATEROLE PASSWORD 'Passw0rd';
        %
        % 
        
        
        function Result = addUser(Obj, UserName, Password, Args)
            % Add database user
            % Input:   UserName       -
            %          Password       - 
            %          'DatabaseName' - 
            %          'Permission'   - 'read', 'write'
            % Output:  true on sucess
            % Example: db.DbAdmin.addUser('robert', 'pass123')
            % Refs:    https://www.postgresql.org/docs/8.0/sql-createuser.html
            % SQL:     CREATE USER user user_name WITH ENCRYPED PASSWORD 'mypassword';
            %          GRANT ALL PRIVILEGES ON DATABASE sample_db TO user_name;                        
            arguments
                Obj                     %
                UserName                %
                Password                %
                Args.DatabaseName = ''  %
                Args.Permission = ''    %
            end
            
            SqlText = sprintf('CREATE USER %s WITH PASSWORD ''%s''', UserName, Password);
            Result = Obj.exec(SqlText);
            
            if ~isempty(Args.DatabaseName)
                SqlText = sprintf('GRANT ALL PRIVILEGES ON %s TO %s', Args.DatabaseName, UserName);
                Result = Obj.exec(SqlText);
            end
            
            % Read-only 
            % https://ubiq.co/database-blog/how-to-create-read-only-user-in-postgresql/
            if strcmp(Args.Permission, 'read')

                Text = sprintf('CREATE USER %s WITH PASSWORD ''%s''', UserName, Password);

                Text = sprintf('GRANT CONNECT ON DATABASE %s TO %s', UserName);
                Text = sprintf('GRANT USAGE ON SCHEMA public TO %s', UserName);

                Text = sprintf('GRANT SELECT ON ALL TABLES IN SCHEMA public TO %s', UserName);

                %ALTER DEFAULT PRIVILEGES IN SCHEMA public
                %GRANT SELECT ON TABLES TO user2;



            else
            end
        end
        
        
        function Result = removeUser(Obj, UserName)
            % Remove user
            % Input:   
            % Output:  
            % Example: db.DbAdmin.removeUser('robert')
            % Refs:    https://www.postgresql.org/docs/9.4/sql-dropuser.html
            % SQL:     DROP USER [ IF EXISTS ] name [, ...]            
            arguments
                Obj                 %
                UserName            %
            end

            SqlText = sprintf('DROP USER IF EXISTS %s', UserName);
            Result = Obj.exec(SqlText);
        end        
        
        
        function Result = getUserList(Obj)
            % Get columns list of specified table as cell array
            % Input:   -
            % Output:  Cell array
            % Example: List = Obj.getTablesList()
            % Refs:    https://www.postgresqltutorial.com/postgresql-list-users/
            
            Text = [...
                'SELECT usename AS role_name, '...
                '  CASE '...
                '     WHEN usesuper AND usecreatedb THEN '...
                '       CAST(''superuser, create database'' AS pg_catalog.text) '...
                '     WHEN usesuper THEN '...
                '        CAST(''superuser'' AS pg_catalog.text) '...
                '     WHEN usecreatedb THEN '...
                '        CAST(''create database'' AS pg_catalog.text) '...
                '     ELSE '...
                '        CAST('''' AS pg_catalog.text) '...
                '  END role_attributes '...
                'FROM pg_catalog.pg_user '...
                'ORDER BY role_name desc; '...
                ];
            
            Result = Obj.Query.selectColumn(Text, 'role_name');
        end

    end
    %----------------------------------------------------------------------        
    
    methods(Hidden)    
        
        function Result = exec(Obj, SqlText)
            % Execute SQL statement, by calling Obj.Query.exec()
            % Input:   SqlText - Statement text
            % Output:  true on success
            % Example: Obj.exec('DROP USER IF EXISTS user1')
            Result = Obj.Query.exec(SqlText);
        end
        
        
        function Result = writeLocalConfig(Obj, Args)
            % Write configuration file
            % config/local/Database.DbConnections.UnitTest.yml
            % Input: 
            %    DatabaseName 
            %    'UserName'        = ''       %
            %    'Password'        = ''       %
            %    'Host'            = ''       %
            %    'Port'            = 5432     %
            %    'ServerSharePath' = ''       % Path to shared folder on the server, for COPY statements

            % Output: true on success
            % Example: Obj.writeLocalConfig()
            
            arguments
                Obj
                Args.FileName        = ''       %
                Args.DatabaseName    = ''       %
                Args.UserName        = ''       %
                Args.Password        = ''       %
                Args.Host            = ''       %
                Args.Port            = 5432     %
                Args.ServerSharePath = ''       % Path to shared folder on the server, for COPY statements
            end
            
            Result = false;
            
            % Prepare file name
            if isempty(Args.FileName)
                ConfigPath = fullfile(tools.os.getAstroPackConfigPath(), local);
                Args.FileName = fullfile(ConfigPath, strcat('Database.DbConnections.', Args.DatabaseName, '.yml'));
            end
            
            % Create file
            Fid = fopen(Args.FileName, 'wt');
            if Fid > -1
                fprintf(Fid, '# %s\n', Args.FileName);
                fprintf(Fid, 'DatabaseName    : ''%s''        # Database name\n', Args.DatabaseName);
                fprintf(Fid, 'Host            : ''%s''        # Host name or IP address\n', Args.Host);
                fprintf(Fid, 'Port            : %d            # Port number\n', Args.Port);            
                fprintf(Fid, 'DriverName      : ''postgres''  # Driver name\n');
                fprintf(Fid, 'UserName        : ''%s''        # Login user\n', Args.UserName);
                fprintf(Fid, 'Password        : ''%s''        # Login password\n', Args.Password);
                fclose(Fid);
                
                if isfile(FileName)
                    Result = true;
                end
            end
            
        end        

        
        
        function SqlFileName = xls2sql(Obj, XlsFileName)
            % Convert XLSX file downloaded from Google Drive to SQL file
            % Input:   XlsFileName
            % Output:  
            % Example: db.DbQuery.xls2sql('c:\temp\_xls\unittest.xlsx')
            arguments
                Obj
                XlsFileName
            end
            
            SqlFileName = '';
            if ~isfile(XlsFileName)
                return;
            end
                
            PWD = pwd;
            try
                
                [Path, FName] = fileparts(XlsFileName);
                cd(Path);
                Py = fullfile(tools.os.getAstroPackPath, 'python', 'utils', 'database_utils', 'xlsx2sql.py');
                Cmd = sprintf('python3 %s -f %s', Py, XlsFileName);
                io.msgLog(LogLevel.Info, 'xlsx2sql.py: %s', Cmd);
                [Status, Output] = system(Cmd);
                io.msgLog(LogLevel.Info, '%d', Status);
                io.msgLog(LogLevel.Info, '%s', Output);
                
                SqlFileName = sprintf('%s%s%s.sql', FName, filesep, FName);
                if ~isfile(SqlFileName)
                    SqlFileName = '';
                end
                
            catch Ex
            end
            cd(PWD);
        end
        
        
        function Result = runPsql(Obj, Args)
            % 
            % Input:   XlsFileName
            % Output:  
            % Example: db.DbAdmin.runPsql(
            % psql -h gauss -p 5432 -U admin -W -d postgres -f unittest.sql
            arguments
                Obj
                Args.Host          = ''        %
                Args.Port          = 0         %                               
                Args.DatabaseName  = ''        % Use 'postgres' to when creating databases or for general
                Args.UserName      = ''        %
                Args.Password      = ''        %
                Args.SqlFileName   = ''        %
                Args.Params        = ''        %                
                Args.TableName     = ''        %
            end

            Result = false;
            
            if isempty(Args.Host)
                Args.Host = Obj.Host;
            end
            
            if Args.Port == 0
                Args.Port = Obj.Port;
            end            

            if isempty(Args.DatabaseName)
                Args.DatabaseName = Obj.DatabaseName;
            end

            if isempty(Args.UserName)
                Args.UserName = Obj.UserName;
            end
        
            if isempty(Args.Password)
                Args.Password = Obj.Password;
            end

            try
                                
                % Prepare command line
                Cmd = sprintf('psql -h %s -p %d -U %s -w', Args.Host, Args.Port, Args.UserName);
                
                % -d
                if ~isempty(Args.DatabaseName)
                    Cmd = sprintf('%s -d %s', Cmd, Args.DatabaseName);
                end
                
                % -f
                if ~isempty(Args.SqlFileName)
                    Cmd = sprintf('%s -f %s', Cmd, Args.SqlFileName);
                end
                
                % Additional params
                if ~isempty(Args.Params)
                    Cmd = sprintf('%s %s', Cmd, Args.Params);
                end                
                
                % Password
                if ~isempty(Args.Password)
                    
                    % Windows - note that we MUST NOT have a spaces next to '&&'
                    if tools.os.iswindows()
                        Cmd = sprintf('set PGPASSWORD=%s&&%s', Args.Password, Cmd);
                        
                    % Linux - use 'export'
                    else
                        Cmd = sprintf('export PGPASSWORD=''%s'' ; %s', Args.Password, Cmd);
                    end
                end
                
                io.msgLog(LogLevel.Info, 'psql: %s', Cmd);
                [Status, Output] = system(Cmd);
                io.msgLog(LogLevel.Info, 'psql: %d', Status);
                io.msgLog(LogLevel.Info, 'psql: %s', Output);
                Result = true;
            catch Ex
                io.msgLogEx(LogLevel.Info, Ex, 'psql');
            end
        end
                
    end


    methods(Static) % Unit-Tests

        Result = unitTest()
            % Unit-Test

    end
end
