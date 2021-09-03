..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Data for Sustainable Development Goals
###############################################################################

.. image:: ../basic/images/chapter4/prepareData.png
  :align: center

To be able to use pgRouting, data has to be imported into a database.

.. contents:: Chapter Contents

Work Directory for pgRouting data manipulation
===============================================================================

.. code-block:: bash 

   mkdir ~/Desktop/workshop 
   cd ~/Desktop/workshop

Mumbai database
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
-------------------------------------------------------------------------------


The pgRouting workshop will make use of OpenStreetMap data of an area in Mumbai
City. The instructions for downloading the data are given below


Downloading Mumbai data from OpenStreetMap
...............................................................................

.. literalinclude:: ../scripts/un_sdg/sdg3/get_mumbai.sh 
    :start-after: get_mumbai from-here 
    :end-before:  get_mumbai to-here 
    :language: bash 
    :linenos:


Upload Mumbai data to the database
-------------------------------------------------------------------------------

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



Bangladesh database
===============================================================================



Create Bangladesh area database compatible with pgRouting
-------------------------------------------------------------------------------

.. literalinclude:: ../scripts/un_sdg/sdg11/create_bangladesh.sh 
  :start-after: create_bangladesh from-here
  :end-before:  create_bangladesh to-here 
  :language: bash
  :linenos:

Get the Bangladesh Data 
-------------------------------------------------------------------------------




Downloading Bangladesh data from OpenStreetMap
...............................................................................



Upload Bangladesh data to the database
-------------------------------------------------------------------------------



Importing Bangladesh Waterways
...............................................................................