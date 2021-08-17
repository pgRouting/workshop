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

* Supported PostgreSQL version
* Supported PostGIS version

These requirements are met on OSGeoLive. When the required software is installed, open a terminal window by pressing :code:`ctrl-alt-t` and follow the instructions.
Information about installing OSGeoLive can be found on :doc:`chapter-3`.

.. note:: If OSGeoLive is not being used, please refer to the chapter's appendix to set up the user "user".

.. foo*


Create a pgRouting compatible database
-------------------------------------------------------------------------------

.. note:: Depending on the postgres configuration :code:`-U <user>` is needed on :code:`psql` commands

.. literalinclude:: ../scripts/chapter_4/section-4.1.1.sh
   :start-after: 4.1.1 from-here
   :end-before:  4.1.1 to-here
   :language: bash
   :linenos:

Get the Workshop Data
===============================================================================

.. TODO get date

The pgRouting workshop will make use of OpenStreetMap data, which is already
available on `OSGeoLive <http://live.osgeo.org>`_. This workshop will use the
``@PGR_WORKSHOP_CITY@`` city data and is a snapshot of @DATE_OF_DATA@.

Getting the data
-------------------------------------------------------------------------------

Option 1) When using OSGeoLive
...............................................................................

OSGeoLive comes with osm data from the city of @PGR_WORKSHOP_CITY@.

.. code-block:: bash

  CITY="@PGR_WORKSHOP_CITY_FILE@"
  bzcat ~/data/osm/$CITY.osm.bz2 > $CITY.osm

Option 2) Download data form OSGeoLive website
...............................................................................

The exact same data can be found on the OSGeoLive download page.

.. literalinclude:: ../scripts/chapter_4/section-4.2.2.sh
   :start-after: 4.2.2 from-here
   :end-before:  4.2.2 to-here
   :language: bash
   :linenos:

Option 3) Download using Overpass XAPI
...............................................................................

The following downloads the latest OSM data on using the same area.
Using this data in the workshop can generate variations in the results,
due to changes since @DATE_OF_DATA@.

.. code-block:: bash

  CITY="@PGR_WORKSHOP_CITY_FILE@"
  BBOX="@PGR_WORKSHOP_CITY_BBOX@"
  wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"

More information about how to download OpenStreetMap data can be found in
https://wiki.openstreetmap.org/wiki/Downloading_data

An alternative for very large areas is to use the download services of
`Geofabrik <http://download.geofabrik.de>`_.


Upload data to the database
==============================================================================

The next step is to run ``osm2pgrouting`` converter, which is a command line
tool that inserts the data in the database, "ready" to be used with pgRouting.
Additional information about ``osm2pgrouting`` can be found at the :ref:`osm2pgrouting`

For this step:

* the osm2pgrouting default ``mapconfig.xml`` configuration file is used
* and the ``~/Desktop/workshop/@PGR_WORKSHOP_CITY_FILE@.osm`` data
* with the ``city_routing`` database

From a terminal window :code:`ctrl-alt-t`.

Run the osm2pgrouting converter
-------------------------------------------------------------------------------

.. literalinclude:: ../scripts/chapter_4/section-4.3.1.sh
   :start-after: 4.3.1 from-here
   :end-before:  4.3.1 to-here
   :language: bash
   :linenos:

.. note:: Depending on the osm2pgrouting version `-W password` is needed

.. rubric:: Output:

.. literalinclude:: ../scripts/chapter_4/section-4.3.1.txt
   :linenos:

Tables on the database
-------------------------------------------------------------------------------

.. literalinclude:: ../scripts/chapter_4/section-4.3.2.sh
   :start-after: 4.3.2 from-here
   :end-before:  4.3.2 to-here
   :language: bash

If everything went well the result should look like this:

.. literalinclude:: ../scripts/chapter_4/section-4.3.2.txt


Chapter: Appendix
===============================================================================


OSGeoLive's account name on the database is ``"user"``. To easily use the workshop when not using
OSGeoLive this extra steps are needed:

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

