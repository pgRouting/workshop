..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************


Prepare Data
###############################################################################

.. image:: /images/prepareData.png
  :align: center

To be able to use pgRouting, data has to be imported into a database.

.. contents:: Chapter Contents


Prepare the database
===============================================================================

pgRouting is installed as extension. This requires:

* PostgreSQL 9.4 or higher
* PostGIS 2.x installed as extension

These requirements are met on OSGeoLive, then open a terminal window :code:`ctrl-alt-t`  and
follow the instructions.

.. note:: If OSGeo Live is not being used.

  OSGeo Live's account name on the database is ``"user"``. To easily use the workshop when not using
  OSGeo Live this extra steps are needed:

  .. code-block:: bash

    # work on the home folder
    cd

    # login to postgres
    psql -U postgres

    -- Create "user"
    CREATE ROLE "user" SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN PASSWORD 'user';

    -- exit psql
    \q

    # Add the user to .pgpass
    echo :5432:*:user:user >> .pgpass

.. foo*


Create a pgRouting compatible database.
-------------------------------------------------------------------------------

.. note:: Depending on the postgres configureation :code:`-U <user>` is needed on :code:`psql` commands

::

  # Create the database
  createdb city_routing

  # login as user "user"
  psql city_routing

  -- add PostGIS functions
  CREATE EXTENSION postgis;

  -- add pgRouting functions
  CREATE EXTENSION pgrouting;

  -- Inspect the pgRouting installation
  \dx+ pgrouting

  -- View pgRouting version
  SELECT pgr_version();

  -- exit psql
  \q


Get the Workshop Data
===============================================================================

.. TODO get date

The pgRouting workshop will make use of OpenStreetMap data, which is already
available on `OSGeo Live <http://live.osgeo.org>`_. This workshop will use the
``Bucharest`` city data and is a snapshot of August-2018.

Make a directory for pgRouting data manipulation
-------------------------------------------------------------------------------

.. code-block:: bash

  mkdir ~/Desktop/workshop
  cd ~/Desktop/workshop

Getting the data
-------------------------------------------------------------------------------

Option 1) When using OSGeo Live
...............................................................................

OSGeo Live comes with osm data from the city of Bucharesti.

.. code-block:: bash

  CITY="Bucaresti_RO"
  bzcat ~/data/osm/$CITY.osm.bz2 > $CITY.osm

Option 2) Download data form OSGeo Live website
...............................................................................

The exact same data can be found on the OSGeo Live download page.

.. code-block:: bash

  CITY="Bucaresti_RO"
  wget -N --progress=dot:mega \
      "http://download.osgeo.org/livedvd/data/osm/$CITY/$CITY.osm.bz2"
  bunzip2 $CITY.osm.bz2

Option 3) Download using Overpass XAPI.
...............................................................................

The following downloads the latest OSM data on using the same area.
Using this data in the workshop can generate variations on the results,
due to changes since Jun-2017.

.. code-block:: bash

  CITY="Bucaresti_RO"
  BBOX="26.0535,44.4058,26.1468,44.4566"
  wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"

More information how to download OpenStreetMap information can be found in
http://wiki.openstreetmap.org/wiki/Downloading_data

An alternative for very large areas is to use the download services of
`Geofabrik <http://download.geofabrik.de>`_.


Upload Data to the database
==============================================================================

The next step is to run ``osm2pgrouting`` converter, which is a command line
tool that inserts your data in the database, "ready" to be used with pgRouting.
Additional information about ``osm2pgrouting`` can be found at the :ref:`osm2pgrouting`

For this step:

* the osm2pgrouting default ``mapconfig.xml`` configuration file is used
* and the ``~/Desktop/workshop/Bucaresti_RO.osm`` data.
* with the ``city_routing`` database

From a terminal window :code:`ctrl-alt-t`.

Run the osm2pgrouting converter
-------------------------------------------------------------------------------


.. code-block:: bash

  cd ~/Desktop/workshop
  osm2pgrouting \
      -f Bucaresti_RO.osm \
      -d city_routing \
      -U user

.. note:: Depending on the osm2pgrouting version `-W password` is needed

.. TODO update code/osm2pgroutingOutput.txt

.. rubric:: Output:

.. literalinclude:: code/osm2pgroutingOutput.txt

.. rubric:: Tables on the database

::

    psql -d city_routing -c "\d"

If everything went well the result should look like this:

.. code-block:: sql

                  List of relations
   Schema |           Name           |   Type   | Owner
   --------+--------------------------+----------+-------
   public | configuration            | table    | user
   public | configuration_id_seq     | sequence | user
   public | geography_columns        | view     | user
   public | geometry_columns         | view     | user
   public | pointsofinterest         | table    | user
   public | pointsofinterest_pid_seq | sequence | user
   public | raster_columns           | view     | user
   public | raster_overviews         | view     | user
   public | spatial_ref_sys          | table    | user
   public | ways                     | table    | user
   public | ways_gid_seq             | sequence | user
   public | ways_vertices_pgr        | table    | user
   public | ways_vertices_pgr_id_seq | sequence | user
   (13 rows)
