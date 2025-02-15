# Postgres Indexing

Updated: 02/2022

## IDENTITY COLUMN (Auto-Increment)

After experiments and performance tests, we concluded to use integer 
as IDENTITY, which is the faster and easiest way to generate primary key for 
tables.

The syntax to define such field

    pk BIGINT GENERATED ALWAYS AS IDENTITY


### Example

    CREATE TABLE public.gcs_telemetry (
    pk BIGINT GENERATED ALWAYS AS IDENTITY,
    rcv_time DOUBLE PRECISION DEFAULT 0,
    param_name VARCHAR,
    param_index INTEGER DEFAULT 0,
    );

    CREATE INDEX gcs_telemetry_idx_rcv_time ON public.gcs_telemetry
      USING btree (rcv_time);

    CREATE INDEX gcs_telemetry_idx_param_name ON public.gcs_telemetry
      USING btree (param_name);



### UUID (128-bit / String)

https://www.postgresql.org/docs/current/datatype-uuid.html

The data type uuid stores Universally Unique Identifiers (UUID) as 
defined by RFC 4122, ISO/IEC 9834-8:2005, and related standards. 
(Some systems refer to this data type as a globally unique identifier, 
or GUID, instead.) This identifier is a 128-bit quantity that is 
generated by an algorithm chosen to make it very unlikely that the 
same identifier will be generated by anyone else in the known universe 
using the same algorithm. Therefore, for distributed systems, these 
identifiers provide a better uniqueness guarantee than sequence generators, 
which are only unique within a single database.

A UUID is written as a sequence of lower-case hexadecimal digits, 
in several groups separated by hyphens, specifically a group of 8 digits 
followed by three groups of 4 digits followed by a group of 12 digits, 
for a total of 32 digits representing the 128 bits. An example of a UUID 
in this standard form is:

    a0eebc99-9c0b-4ef8-bb6d-6bb9bd380a11


https://www.javatpoint.com/postgresql-uuid

https://www.postgresqltutorial.com/postgresql-uuid/

https://www.postgresql.org/docs/current/uuid-ossp.html


### UUID - Version 4 (random)

https://en.wikipedia.org/wiki/Universally_unique_identifier#Version_4_(random)

A version 4 UUID is randomly generated. As in other UUIDs, 4 bits are used to 
indicate version 4, and 2 or 3 bits to indicate the variant 
(102 or 1102 for variants 1 and 2 respectively). Thus, for variant 1 
(that is, most UUIDs) a random version-4 UUID will have 6 predetermined 
variant and version bits, leaving 122 bits for the randomly generated part, 
for a total of 2122, or 5.3×1036 (5.3 undecillion) possible version-4 variant-1 UUIDs. 
There are half as many possible version-4 variant-2 UUIDs (legacy GUIDs) 
because there is one fewer random bit available, 3 bits being consumed for the variant. 


### Postgres - How to create UUID values in PostgreSQL

https://www.javatpoint.com/postgresql-uuid

PostgreSQL enables us to store and equate the UUID values, but it does not contain 
the functions, and creates the UUID values in its core.
And rather than it depends on the third-party modules that deliver the 
particular algorithms to create the UUIDs, such as the uuid-ossp module contains 
some accessible functions, which perform standard algorithms for creating UUIDs.
We will use the following CREATE EXTENSION command to install the uuid-ossp module in 
the Javatpoint Database.

	CREATE EXTENSION IF NOT EXISTS "uuid-ossp"; 
	
These functions are supported, for v1 and v4:

	SELECT uuid_generate_v1();
	SELECT uuid_generate_v4();


### Creating a table with UUID column (example)

We will create a table whose primary key is UUID data type. 
In addition, the values of the primary key column will be generated 
automatically using the uuid_generate_v4() function.

First, create the contacts table using the following statement:


	CREATE TABLE contacts (
		contact_id uuid DEFAULT uuid_generate_v4 (),
		first_name VARCHAR NOT NULL,
		last_name VARCHAR NOT NULL,
		email VARCHAR NOT NULL,
		phone VARCHAR,
		PRIMARY KEY (contact_id)
	);


	INSERT INTO contacts (
		first_name,
		last_name,
		email,
		phone
	)
	VALUES
		(
			'John',
			'Smith',
			'john.smith@example.com',
			'408-237-2345'
		)
		
		
### Postgres UUID Examples

https://stackoverflow.com/questions/12505158/generating-a-uuid-in-postgres-for-insert-statement

	INSERT INTO items VALUES( gen_random_uuid(), 54.321, 31, 'desc 1', 31.94 ) ;
	
	
### Postgres - Manually insert UUID

https://stackoverflow.com/questions/64914884/syntax-to-manually-insert-a-uuid-value-in-postgres

	
Syntax to manually insert a UUID value in Postgres

	CREATE TABLE IF NOT EXISTS DIM_Jour (
		jour_id uuid NOT NULL,
		AAAA int,
		MM int,
		JJ int,
		Jour_Semaine int,
		Num_Semaine int,

		PRIMARY KEY (jour_id)
	);
	
	
Insert

	INSERT INTO DIM_Jour (jour_id, AAAA, MM, JJ, Jour_Semaine, Num_Semaine) VALUES (
		'292a485f-a56a-4938-8f1a-bbbbbbbbbbb1',
		2020,
		11,
		19,
		4,
		47
	)
	
	
But it's probably a good practice to be explicit about it and perform the cast yourself

	INSERT INTO DIM_Jour (jour_id, AAAA, MM, JJ, Jour_Semaine, Num_Semaine) VALUES (
		'292a485f-a56a-4938-8f1a-bbbbbbbbbbb1'::UUID,
		2020,
		11,
		19,
		4,
		47
	);	
	

### UUID - MATLAB - Implemented in AstroPack Component class

	function Result = newUuid()
		% Generate Uuid using java package, such as '3ac140ba-19b5-4945-9d75-ff9e45d00e91'
		% Output:  Uuid char array (36 chars)
		% Example: U = Component.newUuid()            
		Temp = java.util.UUID.randomUUID;

		% Convert java string to char
		Result = string(Temp.toString()).char;
	end



	Temp = java.util.UUID.randomUUID

	Temp =

	828e55aa-8d22-437f-a5af-2d8ca176db13
	

	>> class(Temp)

	ans =

		'java.util.UUID'
	
	
### UUID - MATLAB - Using Java
	
	https://www.mathworks.com/matlabcentral/answers/391490-how-can-i-represent-a-hexadecimal-string-in-a-128-bit-format-in-matlab

	
	% Get UUID and store as character
	uuid=char(java.util.UUID.randomUUID);
	val=uuid;
	
	% Remove the '-' to get the hexadecimal values
	val(val == '-') = '';
	
	% Turn 'val' into string elements each representing bytes
	% reshape(val,2,16) gives a 2x16 char array
	% permute(reshapedvalue,[2 1])' gives a 1x16 string array with each element
	% of the string representing a byte
	byte_hex = string(permute(reshape(val,2,16),[2 1]))';
	
	% Create an array of bytes
	bytes_vector = uint8(hex2dec(byte_hex));
	
	% dec2hex is to verify that the byte set is as expected
	dec2hex(bytes_vector);
	
	
### UUID - Python

https://docs.python.org/3/library/uuid.htm


	uuid.uuid1(node=None, clock_seq=None)

		Generate a UUID from a host ID, sequence number, and the current time. 
		If node is not given, getnode() is used to obtain the hardware address. 
		If clock_seq is given, it is used as the sequence number; otherwise a 
		random 14-bit sequence number is chosen.

	uuid.uuid3(namespace, name)

		Generate a UUID based on the MD5 hash of a namespace identifier 
		(which is a UUID) and a name (which is a string).

	uuid.uuid4()

		Generate a random UUID.

	uuid.uuid5(namespace, name)

		Generate a UUID based on the SHA-1 hash of a namespace identifier 
		(which is a UUID) and a name (which is a string).



	def new_uuid():
		s = str(uuid.uuid1())
		return s


	In [7]: uuid.uuid1()
	Out[7]: UUID('8523447d-9e1e-11ec-b5d5-005056c00008')


## Data Types


### Numeric Types

https://www.postgresql.org/docs/current/datatype-numeric.html


### Geometric Types

https://www.postgresql.org/docs/current/datatype-geometric.html


	point 	16 bytes 	Point on a plane 	(x,y)
	
	
Points are the fundamental two-dimensional building block for geometric types. 
Values of type point are specified using either of the following syntaxes:

	( x , y )
	x , y

where x and y are the respective coordinates, as floating-point numbers.

Points are output using the first syntax.


### Create table with point data type

http://www.java2s.com/Code/PostgreSQL/Data-Type/Createtablewithpointdatatype.htm

	postgres=# CREATE TABLE cities (
	postgres(#    name            varchar(80),
	postgres(#    location        point
	postgres(# );
	CREATE TABLE
	postgres=#
	postgres=# drop table cities;
	DROP TABLE
	postgres=#
	postgres=#


http://www.java2s.com/Code/PostgreSQL/Data-Type/UsePointdatatypeininsertstatement.htm

	postgres=#
	postgres=# CREATE TABLE cities (
	postgres(#    name            varchar(80),
	postgres(#    location        point
	postgres(# );
	CREATE TABLE
	postgres=#
	postgres=# INSERT INTO cities VALUES ('San Francisco', '(-194.0, 53.0)');
	INSERT 0 1
	postgres=#
	postgres=# select * from cities;
		 name      | location
	---------------+-----------
	 San Francisco | (-194,53)
	(1 row)

	postgres=#
	postgres=# drop table cities;
	DROP TABLE
	postgres=#


### Geoname

https://tapoueh.org/blog/2018/05/postgresql-data-types-point/


### SP-GiST

https://habr.com/en/company/postgrespro/blog/446624/

#### SP-GiST

First, a few words about this name. 
The «GiST» part alludes to some similarity with the same-name access method. 
The similarity does exist: both are generalized search trees that provide a 
framework for building various access methods.
«SP» stands for space partitioning. 
The space here is often just what we are used to call a space, 
for example, a two-dimensional plane. But we will see that any search space 
is meant, that is, actually any value domain.

SP-GiST is suitable for structures where the space can be recursively 
split into non-intersecting areas. This class comprises quadtrees, k-dimensional 
trees (k-D trees), and radix trees.

#### Structure

So, the idea of SP-GiST access method is to split the value domain into 
non-overlapping subdomains each of which, in turn, can also be split. 
Partitioning like this induces non-balanced trees (unlike B-trees and regular GiST).


	postgres=# create table points(p point);

	postgres=# insert into points(p) values
	  (point '(1,1)'), (point '(3,2)'), (point '(6,3)'),
	  (point '(5,5)'), (point '(7,8)'), (point '(8,6)');

	postgres=# create index points_quad_idx on points using spgist(p);


### BRIN Index Type

https://www.cybertec-postgresql.com/en/brin-indexes-correlation-correlation-correlation/?gclid=Cj0KCQiAmpyRBhC-ARIsABs2EAoQdxayenamUtgXj7IC8ODxGw794_1mnAK_03SofsXOZfnpz2vVZasaAjS2EALw_wcB

https://www.percona.com/blog/2019/07/16/brin-index-for-postgresql-dont-forget-the-benefits/


BRIN Index is a revolutionary idea in indexing first proposed by PostgreSQL contributor 
Alvaro Herrera. BRIN stands for “Block Range INdex”. A block range is a group of pages 
adjacent to each other, where summary information about all those pages is stored in Index.  
For example, Datatypes like integers – dates where sort order is linear – can be stored as min 
and max value in the range. Other database systems including Oracle announced similar 
features later. BRIN index often gives similar gains as Partitioning a table.

BRIN usage will return all the tuples in all the pages in the particular range. 
So the index is lossy and extra work is needed to further filter out records. 
So while one might say that is not good, there are a few advantages.

Since only summary information about a range of pages is stored, BRIN indexes 
are usually very small compared to B-Tree indexes. So if we want to squeeze the 
working set of data to shared_buffer, this is a great help.
Lossiness of BRIN can be controlled by specifying pages per range 
(discussed in a later section)
Offloads the summarization work to vacuum or autovacuum. So the overhead of 
index maintenance on transaction / DML operation is minimal.


Limitation:

BRIN indexes are efficient if the ordering of the key values follows the 
organization of blocks in the storage layer. In the simplest case, this 
could require the physical ordering of the table, which is often the 
creation order of the rows within it, to match the key’s order. Keys on generated 
sequence numbers or created data are best candidates for BRIN index.


### Partial Index

https://www.gojek.io/blog/the-postgres-performance-tuning-manual-indexes

Postgres supports an index over a subset of the rows of a table 
(known as a partial index). It’s often the best way to index our data 
if we want to repeatedly analyse rows that match a given WHERE clause. 
Let us see how we can enhance the performance of Postgres using partial 
indexing.


### Hash Index

https://hakibenita.com/postgresql-hash-index

https://dba.stackexchange.com/questions/259477/hash-index-vs-btree-index-performance-on-inserts-and-updates

https://devcenter.heroku.com/articles/postgresql-indexes


### Data Folder Structure

https://www.postgresql.org/docs/current/storage-file-layout.html


### Performance - More

https://devcenter.heroku.com/categories/postgres-performance

