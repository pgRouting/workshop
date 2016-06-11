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

**osm2pgrouting** is a command line tool that allows to import OpenStreetMap data into a pgRouting database.
It builds the routing network topology automatically and creates tables for feature types and road classes.
osm2pgrouting was primarily written by Daniel Wendt and is currently hosted on the pgRouting project site: http://www.pgrouting.org/docs/tools/osm2pgrouting.html
The current documentation is at: https://github.com/pgRouting/osm2pgrouting/wiki/Documentation-for-osm2pgrouting-v2.1

.. note::

    There are some limitations, especially regarding the network size.
    The current version of osm2pgrouting needs to load all data into memory,
    which makes it fast but also requires a lot or memory for large datasets.
    An alternative tool to osm2pgrouting without the network size limitation is **osm2po** (http://osm2po.de). It's available under "Freeware License".


Raw OpenStreetMap data contains much more features and information than needed for routing.
Also the format is not suitable for pgRouting out-of-the-box.
An ``.osm`` XML file consists of three major feature types:

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
If you have installed the template databases as described in the previous chapter, creating a pgRouting-ready database is done with some simple commands. Open a terminal window and run:

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

    osm2pgrouting \
        -f data/sampledata.osm \
        -d pgrouting-workshop \
        -U user

.. Note:: If you are running an older version:

    .. code-block:: bash

        osm2pgrouting
            -file "data/sampledata.osm" \
            -conf "/usr/share/osm2pgrouting/mapconfig.xml" \
            -dbname pgrouting-workshop \
            -user user \
            -host localhost \
            -clean

Depending on the size of your network the calculation and import may take a while. After it's finished connect to your database and check the tables that should have been created:

.. rubric:: Run: ``psql -U user -d pgrouting-workshop -c "\d"``

If everything went well the result should look like this:

.. code-block:: sql

                    List of relations
   Schema |           Name           |   Type   | Owner
  --------+--------------------------+----------+-------
   public | classes                  | table    | user
   public | geography_columns        | view     | user
   public | geometry_columns         | view     | user
   public | nodes                    | table    | user
   public | raster_columns           | view     | user
   public | raster_overviews         | view     | user
   public | relation_ways            | table    | user
   public | relations                | table    | user
   public | spatial_ref_sys          | table    | user
   public | types                    | table    | user
   public | way_tag                  | table    | user
   public | ways                     | table    | user
   public | ways_vertices_pgr        | table    | user
   public | ways_vertices_pgr_id_seq | sequence | user
  (14 rows)

.. note::

  osm2pgrouting creates more tables and imports more attributes than we will use in this workshop. Some of them have been just added recently and are still lacking proper documentation.
