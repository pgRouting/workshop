==============================================================================================================
osm2pgrouting Import Tool
==============================================================================================================

.. literalinclude:: code/mapconfig_sample.xml
	:language: xml


Detailed description of all possible types and classes can be found here:  http://wiki.openstreetmap.org/index.php/Map_features.

When using the osm2pgrouting converter (see later), we take only nodes and ways of types and classes specified in "mapconfig.xml" file to be converted to pgRouting table format:


For Cape Town the OpenStreetMap data is very comprehensive with many details. A compilation of the greater Cape Town area created with JOSM is available as capetown_20080829.osm.


This tool makes it easy to import OpenStreetMap data and use it with pgRouting. It creates topology automatically and creates tables for feature types and road classes. osm2pgrouting was primarily written by Daniel Wendt and is now hosted on the pgRouting project site: http://pgrouting.postlbs.org/wiki/tools/osm2pgrouting

How to install (Ubuntu 8.04)

Check out the latest version from SVN repository:

.. code-block:: sql

	svn checkout http://pgrouting.postlbs.org/svn/pgrouting/tools/osm2pgrouting/trunk osm2pgrouting
	Required packages/libraries:

	1. PostgreSQL 2. PostGIS 3. pgRouting 4. Boost library 5. Expat library 6. libpq library

	Note: if you already compiled pgRouting point 1. to 4. should already be installed.

	Then compile

	cd osm2pgrouting
	make
	How to use

	1. First you need to create a database and add PostGIS and pgRouting functions:

	createdb -U postgres osm
	createlang -U postgres plpgsql osm

	psql -U postgres -f /usr/share/postgresql-8.3-postgis/lwpostgis.sql osm
	psql -U postgres -f /usr/share/postgresql-8.3-postgis/spatial_ref_sys.sql osm

	psql -U postgres -f /usr/share/postlbs/routing_core.sql osm
	psql -U postgres -f /usr/share/postlbs/routing_core_wrappers.sql osm
	psql -U postgres -f /usr/share/postlbs/routing_topology.sql osm
	2. You can define the features and attributes to be imported from the OpenStreetMap XML file in the configuration file (default: mapconfig.xml)

	3. Open a terminal window and run osm2pgrouting with the following paramters

	./osm2pgrouting -file /home/foss4g/capetown_20080829.osm \
					-conf mapconfig.xml \
					-dbname osm \
					-user postgres \
					-clean
	Other available parameters are:

	 * required: 
		-file 	<file>  	-- name of your osm xml file
		-dbname <dbname> 	-- name of your database
		-user 	<user> 		-- name of the user, which have write access to the database
		-conf 	<file> 		-- name of your configuration xml file
	 * optional:
		-host 	<host>  	-- host of your postgresql database (default: 127.0.0.1)
		-port 	<port> 		-- port of your database (default: 5432)
		-passwd <passwd> 	--  password for database access
		-clean 				-- drop peviously created tables
	4. Connect to your database and see the tables that have been created

	psql -U postgres osm
	\d
		             List of relations
	 Schema |        Name         |   Type   |  Owner   
	--------+---------------------+----------+----------
	 public | classes             | table    | postgres
	 public | geometry_columns    | table    | postgres
	 public | nodes               | table    | postgres
	 public | spatial_ref_sys     | table    | postgres
	 public | types               | table    | postgres
	 public | vertices_tmp        | table    | postgres
	 public | vertices_tmp_id_seq | sequence | postgres
	 public | ways                | table    | postgres
	(8 rows)
	Note: If tables are missing you might have forgotten to add PostGIS or pgRouting functions to your database.

	Let's do some more advanced routing with those extra information about road types and road classes.
