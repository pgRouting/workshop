..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

.. _prepareData:

Prepare Data
===============================================================================

.. image:: images/prepareData.png
  :align: center

To be able to use pgRouting, data has to be imported into a database.

This chapter covers:

* :ref:`prepare_database`
* :ref:`get_data`
* :ref:`run_osm2pgrouting`

.. _prepare_database:

Prepare the database
-------------------------------------------------------------------------------

Since **version 2.0** pgRouting functions are installed as extension. This
requires:

* PostgreSQL 9.1 or higher
* PostGIS 2.x installed as extension

These requirements are met, then open a terminal window :code:`ctrl-alt-t`  and
follow the instructions:

.. rubric:: If OSGeo Live is not being used.

OSGeo Live's account is ``user``. To easily use the workshop when not using
OSGeo Live this extra steps are needed:

.. code-block:: bash

  # login to postgres
  psql -U postgres

  # Create "user"
  CREATE ROLE "user" SUPERUSER LOGIN;

  # exit psql
  \q

.. rubric:: Create a pgRouting compatible database.

.. code-block:: bash

  # login as user "user"
  psql -U user

  -- create routing database
  CREATE DATABASE city_routing;
  \c city_routing

  -- add PostGIS functions
  CREATE EXTENSION postgis;

  -- add pgRouting functions
  CREATE EXTENSION pgrouting;

  -- Inspect the pgRouting installation
  \dx+ pgRouting

  -- View pgRouting version
  SELECT pgr_version();

  # exit psql
  \q

.. _get_data:

Get the Workshop Data
-------------------------------------------------------------------------------

The pgRouting workshop will make use of OpenStreetMap data, which is already
available on `OSGeo Live <http://live.osgeo.org>`_. This workshop will use the
``Bonn`` city data.

.. rubric:: Make a directory for pgRouting data manipulation

.. code-block:: bash

  mkdir ~/Desktop/workshop
  cd ~/Desktop/workshop

.. rubric:: When using OSGeo Live

.. code-block:: bash

  CITY="BONN_DE"
  cp ~/data/osm/$CITY.osm.bz2 .
  bunzip2 $CITY.osm.bz2

.. rubric:: Download data form OSGeo Live website

.. code-block:: bash

  CITY="BONN_DE"
  wget -N --progress=dot:mega \
      "http://download.osgeo.org/livedvd/data/osm/$CITY/$CITY.osm.bz2"
  bunzip2 $CITY.osm.bz2

.. rubric:: Download using Overpass XAPI.

.. code-block:: bash

  CITY="BONN_DE"
  BBOX="7.097,50.6999,7.1778,50.7721"
  wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"

More information how to download OpenStreetMap information can be found in
http://wiki.openstreetmap.org/wiki/Downloading_data

An alternative for very large areas is to use the download services of
`Geofabrik <http://download.geofabrik.de>`_.

.. _run_osm2pgrouting:

Run osm2pgrouting
-------------------------------------------------------------------------------

The next step is to run ``osm2pgrouting`` converter, which is a command line
tool that inserts your data into your database.

For this workshop:

* Use the osm2pgrouting default ``mapconfig.xml`` configuration file
* Use ``city_routing`` database installed above.
* Use ``~/Desktop/workshop/BONN_DE.osm`` (see: :ref:`get_data`)

From a terminal window :code:`ctrl-alt-t`.

.. rubric:: Run the converter:

.. code-block:: bash

  cd ~/Desktop/workshop
      osm2pgrouting \
      -f BONN_DE.osm \
      -d city_routing \
      -U user

.. rubric:: Output:

.. literalinclude:: code/osm2pgroutingOutput.txt
  :language: bash

.. rubric:: Run: :code:`psql -U user -d city_routing -c "\d"`

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
