..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Prepare Data for Sustainable Development Goal 3
###############################################################################

.. image:: ../basic/images/chapter4/prepareData.png
  :align: center

To be able to use pgRouting, data has to be imported into a database.

.. contents:: Chapter Contents

Prepare the Mumbai database
===============================================================================

pgRouting is installed as an extension. This requires:

* Supported PostgreSQL version * Supported PostGIS version

These requirements are met on OSGeoLive. When the required software is
installed, open a terminal window by pressing:code:`ctrl-alt-t` and follow the
instructions.  Information about installing OSGeoLive can be found in `Chapter 3
<https://workshop.pgrouting.org/2.6/en/chapters/installation.html>`_ of
pgRouting Workshop 

.. note:: If you don't have pgRouting installed. You can find the installation
  procedure at `here
  <https://docs.pgrouting.org/latest/en/pgRouting-installation.html>`__


Create Mumbai area database compatible with pgRouting
-------------------------------------------------------------------------------


.. literalinclude:: ../scripts/un_sdg/sdg3/create_mumbai.sh 
  :start-after: create_mumbai from-here 
  :end-before:  create_mumbai to-here 
  :language: bash
  :linenos:



Get the Mumbai Data
===============================================================================


The pgRouting workshop will make use of OpenStreetMap data of an area in Mumbai
City. The instructions for downloading the data are given below

Work Directory for pgRouting data manipulation
-------------------------------------------------------------------------------

.. code-block:: bash 

   mkdir ~/Desktop/workshop 
   cd ~/Desktop/workshop


Getting Mumbai data
-------------------------------------------------------------------------------

Downloading Mumbai data from OpenStreetMap
...............................................................................

.. literalinclude:: ../scripts/un_sdg/sdg3/get_mumbai.sh 
    :start-after: get_mumbai from-here 
    :end-before:  get_mumbai to-here 
    :language: bash 
    :linenos:


Upload Mubai data to the database
==============================================================================

The next step is to run ``osm2pgrouting`` converter, which is a command line
tool that inserts the data in the database, "ready" to be used with pgRouting.
Additional information about ``osm2pgrouting`` can be found `here
<https://workshop.pgrouting.org/2.6/en/chapters/osm2pgrouting.html#osm2pgrouting>`_

For this stepi the follwing is used:

* The ``mumbai_buildings.xml`` and ``mumbai_roads.xml`` configuration files 
  for osm2pgrouting.
* The ``~/Desktop/workshop/mumbai.osm`` data from the previous step
* The ``mumbai`` database.
* The terminal window :code:`ctrl-alt-t`.

Run the osm2pgrouting converter on Mumbai data
-------------------------------------------------------------------------------

Importing Mumbai Roads
...............................................................................

.. literalinclude:: ../scripts/un_sdg/sdg3/import_mumbai_roads.sh 
    :start-after: from-here 
    :end-before: to-here 
    :language: bash 
    :linenos:

.. note:: Depending on the osm2pgrouting version `-W password` is needed

.. rubric:: Output:

.. literalinclude:: ../scripts/un_sdg/sdg3/import_mumbai_roads.txt 
    :linenos:


Importing Mumbai Buildings
...............................................................................

.. literalinclude:: ../scripts/un_sdg/sdg3/import_mumbai_buildings.sh 
    :start-after: from-here 
    :end-before:  to-here 
    :language: bash 
    :linenos:

.. note:: Depending on the osm2pgrouting version `-W password` is needed

.. rubric:: Output:

.. literalinclude:: ../scripts/un_sdg/sdg3/import_mumbai_buildings.txt 
    :linenos:

To connect to the database, type the following in the terminal.

.. code-block:: bash

  psql mumbai


TODO move to chapter 3 Setting the Search Path
...............................................................................
Set the search path of the `Roads` and `Buildings` to their respective schemas.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg1.sql
    :start-after: \o setting_search_path.txt 
    :end-before:  \o count_roads_and_buildings.txt
    :linenos:




TODO move to chapter 3 Counting the number of Roads and Buildings
...............................................................................

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg1.sql
    :start-after: \o count_roads_and_buildings.txt
    :end-before:  \o preprocessing_buildings.txt
    :linenos:


TODO move to chapter 3 Preprocessing Buildings
...............................................................................
Polygons with less than 3 points/vertices are not considered valid polygons in PostgreSQL. Hence, they need to be cleaned up.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg1.sql
    :start-after: \o preprocessing_buildings.txt
    :end-before:  \o discard_disconnected_roads.txt
    :linenos:


TODO move to chapter 3 Process to discard disconnected roads
...............................................................................
pgRouting algorithms are only useful when the road netowrk belongs to a single graph (or all the roads are connected to each other). Hence, the disconnected roads have to be removed from ther network to get accurate results.
This image gives an example of the diconnected edges.

..image:: /images/Entry_points_of_proposed_locations.png
:align: center

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg1.sql
    :start-after: -- Process to discard disconnected roads
    :end-before:  \o population_residing_along_the_road.txt
    :language: sql 
    :linenos:

 
TODO move to chapter 3 Calculating the population residing along the road
...............................................................................
More hospitals are needed in the areas where more people live. To solve this problem we will first have to estimate the population of each building.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg1.sql
    :start-after: \o population_residing_along_the_road.txt
    :end-before:  \o
    :linenos:

