.. 
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _osm2pgrouting:

osm2pgrouting Import Tool
===============================================================================

**osm2pgrouting** is a command line tool that allows to import OpenStreetMap data into a pgRouting database. It builds the routing network topology automatically and creates tables for feature types and road classes. osm2pgrouting was primarily written by Daniel Wendt and is currently hosted on the pgRouting project site: http://www.pgrouting.org/docs/tools/osm2pgrouting.html

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


Create routing database
-------------------------------------------------------------------------------

Before we can run osm2pgrouting we have to create a database and load PostGIS and pgRouting functions into this database. 
If you have installed the template databases as described in the previous chapter, creating a pgRouting-ready database is done with a single command. Open a terminal window and run:

.. code-block:: bash

  # Optional: Drop database
  dropdb -U user pgrouting-workshop

  # Create a new routing database
  createdb -U user pgrouting-workshop
  psql -U user -d pgrouting-workshop -c "CREATE EXTENSION postgis;"
  psql -U user -d pgrouting-workshop -c "CREATE EXTENSION pgrouting;"

... and you're done.

Alternativly you can use **PgAdmin III** and SQL commands. Start PgAdmin III (available on the LiveDVD), connect to any database and open the SQL Editor and then run the following SQL command:

.. code-block:: sql

  -- create pgrouting-workshop database
  CREATE DATABASE "pgrouting-workshop";
  \c pgrouting-workshop

  CREATE EXTENSION postgis;
  CREATE EXTENSION pgrouting;


Run osm2pgrouting
-------------------------------------------------------------------------------

The next step is to run ``osm2pgrouting`` converter, which is a command line tool, so you need to open a terminal window.

We take the default ``mapconfig.xml`` configuration file and the ``pgrouting-workshop`` database we created before. Furthermore we take ``~/Desktop/pgrouting-workshop/data/sampledata.osm`` as raw data. This file contains only OSM data for a small area to speed up data processing time.

The workshop data is available as compressed file, which needs to be extracted first either using file manager or with this command:

.. code-block:: bash

	cd ~/Desktop/pgrouting-workshop/
	tar -xvzf data.tar.gz

Then run the converter:
	
.. code-block:: bash

	osm2pgrouting --file "data/sampledata.osm" \
                  --host localhost \
				  --dbname pgrouting-workshop \
				  --username user \
				  --clean
					
List of all possible parameters:

.. list-table::
   :widths: 15 15 60 10

   * - **Parameter**
     - **Value**
     - **Description**
     - **Required**
   * - --file
     - <file>
     - name of your osm xml file
     - yes
   * - -host
     - <host>
     - host of your postgresql database (default: localhost)
     - no
   * - --port
     - <port>
     - port of your database (default: 5432)
     - no
   * - --dbname
     - <dbname>
     - name of your database
     - yes
   * - --schema
     - <schema>
     - name of the schema where to install the data
     - no
   * - --username
     - <user>
     - name of the user, which have write access to the database
     - yes
   * - --password
     - <passwd>
     - password for database access
     - yes
   * - -conf
     - <file>
     - name of your configuration xml file (default: mapconfig.xml)
     - no
   * - --prefix
     - <prefix>
     - add at the beginning of table names
     - no
   * - --suffix
     - <suffix
     - add at the end of table names
     - no
   * - --addnodes
     - 
     - import the nodes table
     - no
   * - --clean
     - 
     - drop peviously created tables
     - no


Depending on the size of your network the calculation and import may take a while. After it's finished connect to your database and check the tables that should have been created:

.. rubric:: Run: ``psql -U user -d pgrouting-workshop -c "\d"``	

If everything went well the result should look like this:
	
.. code-block:: sql

                    List of relations
   Schema |           Name           |   Type   | Owner 
  --------+--------------------------+----------+-------
   public | geography_columns        | view     | user
   public | geometry_columns         | view     | user
   public | osm_nodes                | table    | user
   public | osm_nodes_node_id_seq    | sequence | user
   public | osm_relations            | table    | user
   public | osm_way_classes          | table    | user
   public | osm_way_tags             | table    | user
   public | osm_way_types            | table    | user
   public | raster_columns           | view     | user
   public | raster_overviews         | view     | user
   public | relations_ways           | table    | user
   public | spatial_ref_sys          | table    | user
   public | ways                     | table    | user
   public | ways_gid_seq             | sequence | user
   public | ways_vertices_pgr        | table    | user
   public | ways_vertices_pgr_id_seq | sequence | user
  (16 rows)

.. note::

  osm2pgrouting creates more tables and imports more attributes than we will use in this workshop. Some of them have been just added recently and are still lacking proper documentation.
