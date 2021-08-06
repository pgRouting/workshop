Prepare Data
###############################################################################

.. image:: /images/prepareData.png
  :align: center

To be able to use pgRouting, data has to be imported into a database.

.. contents:: Chapter Contents


\o setting_search_path.txt
-- Enumerate all the schemas
\dn


-- Show the current search path
SHOW search_path;

-- Set the search path
SET search_path TO roads,buildings,public;
SHOW search_path;


-- Enumerate all the tables
\dt

\o count_roads_and_buildings.txt
-- Counting the number of Edges of roads
SELECT count(*) FROM roads_ways;

-- Counting the number of Vertices of roads
SELECT count(*) FROM roads_ways_vertices_pgr;


-- Counting the number of buildings 
SELECT count(*) FROM buildings_ways;


-- Showing the structure of the table
\dS+ buildings_ways



Prepare the database
===============================================================================

pgRouting is installed as an extension. This requires:

* Supported PostgreSQL version
* Supported PostGIS version

These requirements are met on OSGeoLive. When the required software is installed, open a terminal window by pressing:code:`ctrl-alt-t` and follow the instructions.
Information about installing OSGeoLive can be found in `Chapter 3 <https://workshop.pgrouting.org/2.6/en/chapters/installation.html>`_ of pgRouting Workshop 

.. note:: If you don't have pgRouting installed. You can find the installation procedure at `here <https://docs.pgrouting.org/3.1/en/pgRouting-installation.html>`_


.. foo*


Create a pgRouting compatible database
-------------------------------------------------------------------------------

.. note:: Depending on the postgres configuration :code:`-U <user>` is needed on :code:`psql` commands

.. literalinclude:: ../scripts/un_sdg/create_mumbai.sh
   :start-after: create_mumbai from-here
   :end-before:  create_mumbai to-here
   :language: bash
   :linenos:



Get the Workshop Data
===============================================================================

.. TODO get date

The pgRouting workshop will make use of OpenStreetMap data of an area in Mumbai City. The instructions for downloading the data are given below

2.2.1. Make a directory for pgRouting data manipulation
...............................................................................

.. code-block:: bash
  mkdir ~/Desktop/workshop
  cd ~/Desktop/workshop


Getting the data
-------------------------------------------------------------------------------

Downloading the data from OpenStreetMaps
...............................................................................

The exact same data can be found on the OSGeoLive download page.

.. literalinclude:: ../scripts/un_sdg/get_mumbai.sh
   :start-after: get_mumbai from-here
   :end-before:  get_mumbai to-here
   :language: bash
   :linenos:


Upload data to the database
==============================================================================

The next step is to run ``osm2pgrouting`` converter, which is a command line
tool that inserts the data in the database, "ready" to be used with pgRouting.
Additional information about ``osm2pgrouting`` can be found `here <https://workshop.pgrouting.org/2.6/en/chapters/osm2pgrouting.html#osm2pgrouting>`_

For this step:

* the osm2pgrouting ``mumbai_buildings.xml`` and  ``mumbai_roads.xml`` configuration files are used
* and the ``~/Desktop/workshop/mumbai.osm`` data
* with the ``mumbai`` database

From a terminal window :code:`ctrl-alt-t`.

Run the osm2pgrouting converter
-------------------------------------------------------------------------------

Importing the Roads
...............................................................................

.. literalinclude:: ../scripts/un_sdg/import_mumbai_roads.sh
   :start-after: from-here
   :end-before:  to-here
   :language: bash
   :linenos:

.. note:: Depending on the osm2pgrouting version `-W password` is needed

.. rubric:: Output:

.. literalinclude:: ../scripts/un_sdg/import_mumbai_roads.txt
   :linenos:


Importing the Buildings
...............................................................................

.. literalinclude:: ../scripts/un_sdg/import_mumbai_buildings.sh
   :start-after: from-here
   :end-before:  to-here
   :language: bash
   :linenos:

.. note:: Depending on the osm2pgrouting version `-W password` is needed

.. rubric:: Output:

.. literalinclude:: ../scripts/un_sdg/import_mumbai_buildings.txt
   :linenos:

To connect to the database, type the following in the terminal.

.. codeblock::
  psql mumbai