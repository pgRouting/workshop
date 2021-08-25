..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Prepare Data for SDG11
###############################################################################

To be able to use pgRouting, data has to be imported into a database.

.. contents:: Chapter Contents

Prepare the database
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
<https://docs.pgrouting.org/3.1/en/pgRouting-installation.html>`_


.. foo*


Create a pgRouting compatible database
-------------------------------------------------------------------------------

.. note:: Depending on the postgres configuration :code:`-U <user>` is needed on
:code:`psql` commands

.. literalinclude:: ../scripts/un_sdg/sdg11/create_mumbai.sh 
:start-after: create_mumbai from-here 
:end-before:  create_mumbai to-here 
:language: bash
:linenos:



Get the Workshop Data
===============================================================================

.. TODO get date

The pgRouting workshop will make use of OpenStreetMap data of an area in Mumbai
City. The instructions for downloading the data are given below

2.2.1. Make a directory for pgRouting data manipulation
...............................................................................

.. code-block:: bash 
mkdir ~/Desktop/workshop cd ~/Desktop/workshop


Getting the data
-------------------------------------------------------------------------------

Downloading the data from OpenStreetMaps
...............................................................................

The exact same data can be found on the OSGeoLive download page.

.. literalinclude:: ../scripts/un_sdg/sdg11/get_mumbai.sh 
    :start-after: get_mumbai from-here 
    :end-before:  get_mumbai to-here 
    :language: bash 
    :linenos:


Upload data to the database
==============================================================================

The next step is to run ``osm2pgrouting`` converter, which is a command line
tool that inserts the data in the database, "ready" to be used with pgRouting.
Additional information about ``osm2pgrouting`` can be found `here
<https://workshop.pgrouting.org/2.6/en/chapters/osm2pgrouting.html#osm2pgrouting>`_

For this step:

* the osm2pgrouting ``waterways.xml`` and  ``city.xml``configuration files 
are used 
* and the ``~/Desktop/workshop/sdg11.osm`` data
* with the ``sdg11`` database

From a terminal window :code:`ctrl-alt-t`.

Run the osm2pgrouting converter
-------------------------------------------------------------------------------

Importing the Waterways
...............................................................................

.. literalinclude:: ../scripts/un_sdg/sdg11/import_sdg11_waterways.sh 
    :start-after: from-here 
    :end-before: to-here 
    :language: bash 
    :linenos:

.. note:: Depending on the osm2pgrouting version `-W password` is needed

.. rubric:: Output:

.. literalinclude:: ../scripts/un_sdg/sdg11/waterways.txt 
    :linenos:


Importing the Cities and Towns
...............................................................................

.. literalinclude:: ../scripts/un_sdg/sdg11/import_sdg11_city.sh 
    :start-after: from-here 
    :end-before:  to-here 
    :language: bash 
    :linenos:

.. note:: Depending on the osm2pgrouting version `-W password` is needed

.. rubric:: Output:

.. literalinclude:: ../scripts/un_sdg/sdg11/city.txt 
    :linenos:

To connect to the database, type the following in the terminal.

.. codeblock:: bash
psql sdg11


Setting the Search Path
...............................................................................
Set the search path of the `Roads` and `Buildings` to their respective schemas.

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o setting_search_path.txt 
    :end-before:  \o count_waterways_and_cities.txt
    :language: sql 
    :linenos:




Counting the number of Waterways and Cities/Towns
...............................................................................

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o count_waterways_and_cities.txt
    :end-before:  \o connected_components.txt
    :language: sql 
    :linenos:


Process to discard disconnected waterways
...............................................................................
pgRouting algorithms are only useful when the road network belongs to a single 
graph (or all the roads are connected to each other). Hence, the disconnected 
rivers have to be removed from ther network to get accurate results.

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: -- Process to discard disconnected waterways
    :end-before:  \o creating_buffers.txt
    :language: sql 
    :linenos: