:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2016-2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0


Prepare Data
###############################################################################

.. image:: images/data/prepareData.png
  :align: center

To be able to use pgRouting, data has to be imported into a database.

.. contents:: Chapter Contents


Prepare the database
===============================================================================

pgRouting is installed as extension. This requires:

* PostgreSQL
* PostGIS

These requirements are met on OSGeoLive. When the required software is
installed, open a terminal window by pressing :code:`ctrl-alt-t` and follow the
instructions.

Information about installing OSGeoLive can be found on
:doc:`../appendix/osgeolive`.

Create a pgRouting compatible database
-------------------------------------------------------------------------------

Create ``city_routing`` database that will be used on the workshop.

.. literalinclude:: ../scripts/get_data/setup_city_routing.sh
   :start-after: create city_routing
   :end-before: connect city_routing
   :language: bash

Connect to the database

.. code-block:: bash

   psql city_routing

Install pgRouting and its requirements. (optionally check the version that is
being used)

.. literalinclude:: ../scripts/get_data/setup_city_routing.sh
   :start-after: << EOF
   :end-before: EOF
   :language: bash

Exit the database

.. code-block:: bash

   \q

Get the Workshop Data
===============================================================================

This workshop will use the ``@PGR_WORKSHOP_CITY@`` city data and is a snapshot
of @DATE_OF_DATA@.

Get the data
-------------------------------------------------------------------------------

Download data form pgRouting download
...............................................................................

The exact same data can be found on the OSGeoLive download page.

.. literalinclude:: ../scripts/get_data/get_all_data.sh
   :start-after: city from-here
   :end-before:  city to-here
   :language: bash

Option 3) Download using Overpass XAPI
...............................................................................

The following downloads the latest OSM data on using the same area.
Using this data in the workshop can generate variations in the results,
due to changes since @DATE_OF_DATA@.

.. code-block:: bash

  CITY="@PGR_WORKSHOP_CITY_FILE@"
  BBOX="@PGR_WORKSHOP_CITY_BBOX@"
  wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=\$\{BBOX\}][@meta]"

More information about how to download OpenStreetMap data can be found
`here <https://wiki.openstreetmap.org/wiki/Downloading_data>`_.

An alternative for very large areas is to use the download services of
`Geofabrik <https://download.geofabrik.de>`_.

Upload data to the database
==============================================================================

The next step is to run ``osm2pgrouting`` converter, which is a command line
tool that inserts the data in the database, "ready" to be used with pgRouting.
Additional information about ``osm2pgrouting`` can be found at the :doc:`../appendix/appendix-3`

For this step:

* the osm2pgrouting default ``mapconfig.xml`` configuration file is used
* and the ``~/Desktop/workshop/@PGR_WORKSHOP_CITY_FILE@.osm`` data
* with the ``city_routing`` database

From a terminal window :code:`ctrl-alt-t`.

Run the osm2pgrouting converter
-------------------------------------------------------------------------------

.. literalinclude:: ../scripts/get_data/setup_city_routing.sh
   :start-after: import city from-here
   :end-before:  import city to-here
   :language: bash

.. note:: Depending on the osm2pgrouting version `-W password` is needed

.. collapse:: Output:

  .. literalinclude:: ../scripts/get_data/setup_city_routing.txt
     :start-after: import city from-here
     :end-before:  import city to-here

Compatibility with older osm2pgrouting versions
-------------------------------------------------------------------------------

Check the installed version:

.. code-block:: bash

   osm2pgrouting --version

If you are using version 2.x, the column names differ from those used in this
workshop:

- ``gid`` instead of ``id``
- ``the_geom`` instead of ``geom``

Run the following script to rename them:

.. collapse:: Script

   .. literalinclude:: ../scripts/get_data/osm2pgrouting_compat.sql
      :language: postgresql

Tables on the database
-------------------------------------------------------------------------------

To inspect the tables that were created during this process:

.. literalinclude:: ../scripts/basic/data/data.sh
   :start-after: city tables from-here
   :end-before: city tables to-here

.. collapse:: Output:

  .. literalinclude:: ../scripts/basic/data/data.txt
