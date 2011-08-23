==============================================================================================================
osm2pgrouting Import Tool
==============================================================================================================

**osm2pgrouting** is a command line tool that makes it very easy to import OpenStreetMap data into a pgRouting database. It builds the routing network topology automatically and creates tables for feature types and road classes. osm2pgrouting was primarily written by Daniel Wendt and is currently hosted on the pgRouting project site: http://www.pgrouting.org/docs/tools/osm2pgrouting.html

.. note::

	There are some limitations, especially regarding the network size. The current version of osm2pgrouting needs to load all data into memory, which makes it fast but also requires a lot or memory for large datasets. An alternative tool to osm2pgrouting without the network size limitation is **osm2po** (http://osm2po.de). It's available under "Freeware License".
	

Raw OpenStreetMap data contains much more features and information than need for routing. Also the format is not suitable for pgRouting out-of-the-box. An ``.osm`` XML file consists of three major feature types:

* nodes
* ways
* relations

The data of sampledata.osm for example looks like this:

.. literalinclude:: code/osm_sample.osm
	:language: xml

Detailed description of all possible OpenStretMap types and classes can be found here:  http://wiki.openstreetmap.org/index.php/Map_features.

When using osm2pgrouting, we take only nodes and ways of types and classes specified in ``mapconfig.xml`` file that will be imported into the routing database:

.. literalinclude:: code/mapconfig_sample.xml
	:language: xml

The default ``mapconfig.xml`` is installed in ``/usr/share/osm2pgrouting/``.


-------------------------------------------------------------------------------------------------------------
Create routing database
-------------------------------------------------------------------------------------------------------------

Before we can run osm2pgrouting we have to create a database and load PostGIS and pgRouting functions into this database. 
If you have installed the template databases as described in the previous chapter, creating a pgRouting-ready database is done with a single command. Open a terminal window and run:

.. code-block:: bash

	createdb -U postgres -T template_routing routing
	
... and you're done.

Alternativly you can use **PgAdmin III** and SQL commands. Start PgAdmin III (available on the LiveDVD), connect to any database and open the SQL Editor and then run the following SQL command:

.. code-block:: sql

	-- create routing database
	CREATE DATABASE "routing" TEMPLATE "template_routing";


Otherwise you need to manually load several files into your database. See :ref:`previous chapter <installation_load_functions>`.

	
-------------------------------------------------------------------------------------------------------------
Run osm2pgrouting
-------------------------------------------------------------------------------------------------------------

The next step is to run ``osm2pgrouting`` converter, which is a command line tool, so you need to open a terminal window.

We take the default ``mapconfig.xml`` configuration file and the ``routing`` database we created before. Furthermore we take ``~/Desktop/pgrouting-workshop/data/sampledata.osm`` as raw data. This file contains only OSM data from downtown Denver to speed up  data processing time.

The workshop data is available as compressed file, which needs to be extracted first either using file manager or with this command:

.. code-block:: bash

	cd ~/Desktop/pgrouting-workshop/
	tar -xvzf data.tar.gz

Then run the converter:
	
.. code-block:: bash

	osm2pgrouting -file "data/sampledata.osm" \
				  -conf "/usr/share/osm2pgrouting/mapconfig.xml" \
				  -dbname routing \
				  -user postgres \
				  -clean
					
List of all possible parameters:

.. list-table::
   :widths: 15 15 60 10

   * - **Parameter**
     - **Value**
     - **Description**
     - **Required**
   * - -file
     - <file>
     - name of your osm xml file
     - yes
   * - -dbname
     - <dbname>
     - name of your database
     - yes
   * - -user
     - <user>
     - name of the user, which have write access to the database
     - yes
   * - -conf
     - <file>
     - name of your configuration xml file
     - yes
   * - -host
     - <host>
     - host of your postgresql database (default: 127.0.0.1)
     - no
   * - -port
     - <port>
     - port of your database (default: 5432)
     - no
   * - -passwd
     - <passwd>
     - password for database access
     - no
   * - -clean
     - 
     - drop peviously created tables
     - no

.. note::

	If you get permission denied error for postgres users you can set connection method to ``trust`` in ``/etc/postgresql/8.4/main/pg_hba.conf`` and restart PostgreSQL server with ``sudo service postgresql-8.4 restart``.


Depending on the size of your network the calculation and import may take a while. After it's finished connect to your database and check the tables that should have been created:

.. rubric:: Run: ``psql -U postgres -d routing -c "\d"``	

If everything went well the result should look like this:
	
.. code-block:: sql

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

	

