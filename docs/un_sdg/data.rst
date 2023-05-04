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

To be able to use pgRouting, data has to be imported into a database. This chapter
will use ``osm2pgrouting`` to get that the data from OpenStreetMaps(OSM). This data will
be used for exercises in further chapters.

.. contents:: Chapter Contents

Work Directory for pgRouting data manipulation
===============================================================================

.. code-block:: bash

   mkdir ~/Desktop/workshop
   cd ~/Desktop/workshop

Mumbai database
===============================================================================

pgRouting is pre-installed as an extension which requires:

* Supported PostgreSQL version
* Supported PostGIS version

These requirements are met on OSGeoLive. When the required software is
installed, open a terminal window by pressing ``ctrl-alt-t`` and follow the
instructions.  Information about installing OSGeoLive can be found in
:doc:`../general-intro/osgeolive` of this workshop.

.. note:: If you don't have pgRouting installed. You can find the installation
  procedure at this `link
  <https://docs.pgrouting.org/latest/en/pgRouting-installation.html>`__


Create Mumbai database compatible with pgRouting
-------------------------------------------------------------------------------

Use the following command to create ``mumbai`` database

.. code-block::

        createdb mumbai

To connect to the database do the following

.. code-block::

        psql mumbai

After connecting to the database, first step is to create ``EXTENSION`` to enable
pgRouting and PostGIS in the database. Then add the ``SCHEMA`` for each table.

.. literalinclude:: ../scripts/un_sdg/sdg3/create_mumbai.sh
  :start-after: -- Commands inside the database
  :end-before:  -- create_mumbai to-here
  :language: postgresql
  :linenos:

Get the Mumbai Data
-------------------------------------------------------------------------------
The pgRouting workshop will make use of OpenStreetMap data of an area in Mumbai
City. The instructions for downloading the data are given below.

Downloading Mumbai data from OSGeo
...............................................................................

The following command is used to download the snapshot of the Mumbai area data
used in this workshop, using the download service of OSGeo.

.. note:: The Mumbai data for this workshop depends on this `snapshot
   <http://download.osgeo.org/pgrouting/workshops/mumbai.osm.bz2>`__.

.. literalinclude:: ../scripts/get_data/get_all_data.sh
    :start-after: mumbai data from-here
    :end-before:  mumbai data to-here
    :language: bash
    :linenos:

Downloading Mumbai data from OpenStreetMap (OSM)
...............................................................................
The following command is used to download the OpenStreetMap data of the area in Mumbai, India.

OpenStreetMap data changes on a day to day basis, therefore if this data is used,
the results might change and some queries might need adjustments.
The command was used to take the snapshot of the data on June 2021.

.. literalinclude:: ../scripts/un_sdg/sdg3/get_mumbai.sh
    :start-after: get_mumbai from-here
    :end-before:  get_mumbai to-here
    :language: bash
    :linenos:

Upload Mumbai data to the database
-------------------------------------------------------------------------------

The next step is to run ``osm2pgrouting`` converter, which is a command line
tool that inserts the data in the database, "ready" to be used with pgRouting.
See :doc:`../appendix/appendix-3` for additional information about ``osm2pgrouting``.

For this step the following is used:

* ``mumbai_buildings.xml`` and ``mumbai_roads.xml`` configuration files for osm2pgrouting.
* ``~/Desktop/workshop/mumbai.osm`` - OSM data from the previous step
* ``mumbai`` database.

Contents of the configuration files are given in the `Appendix`_. Create a XML file
using these contents and save it into the root directory ``~/Desktop/workshop``.

Open a terminal window by ``ctrl-alt-t`` and move to the workshop directory by ``cd ~/Desktop/workshop``.
The following ``osm2pgrouting`` command will be used to convert the osm files to
pgRouting friendly format which we will use for further exercises.

Importing Mumbai Roads
...............................................................................

The following ``osm2pgrouting`` command will be used to import the Roads
from OpenStreetMaps file to pgRouting database which we will use for further exercises.


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

Similar to Roads, ``osm2pgrouting`` command will be used to import the Buildings
from OpenStreetMaps file to pgRouting database which we will use for further exercises.


.. literalinclude:: ../scripts/un_sdg/sdg3/import_mumbai_buildings.sh
    :start-after: from-here
    :end-before:  to-here
    :language: bash
    :linenos:

.. note:: Depending on the osm2pgrouting version `-W password` is needed

.. rubric:: Output:

.. literalinclude:: ../scripts/un_sdg/sdg3/import_mumbai_buildings.txt
    :language: bash
    :linenos:

To connect to the database, type the following in the terminal.

.. code-block:: bash

  psql mumbai


Bangladesh database
===============================================================================

Now download the data for an area in Bangladesh by  following the same steps like
that of Mumbai.

Create Bangladesh area database compatible with pgRouting
-------------------------------------------------------------------------------

Use the following command to create ``bangladesh`` database

.. code-block::

        createdb bangladesh

To connect to the database do the following

.. code-block::

        psql bangladesh


After connecting to the database, first step is to create ``EXTENSION`` to enable
pgRouting and PostGIS in the database. Then add the ``SCHEMA`` for each table.

.. literalinclude:: ../scripts/un_sdg/sdg11/create_bangladesh.sh
  :start-after: -- Commands inside the database
  :end-before:  -- create_bangladesh to-here
  :language: postgresql
  :linenos:

Get the Bangladesh Data
-------------------------------------------------------------------------------

Downloading Bangladesh data from OSGeo
...............................................................................

The following command is used to download the snapshot of the Bangladesh area data
used in this workshop, using the download service of OSGeo.

.. note:: The Bangladesh data for this workshop depends on this `snapshot
   <http://download.osgeo.org/pgrouting/workshops/bangladesh.osm.bz2>`__.

.. literalinclude:: ../scripts/get_data/get_all_data.sh
    :start-after: bangladesh data from-here
    :end-before:  bangladesh data to-here
    :language: bash
    :linenos:

Downloading Bangladesh data from OpenStreetMap
...............................................................................
The following command is used to download the OSM data of the area in Munshigang,
Bangladesh.

.. literalinclude:: ../scripts/un_sdg/sdg11/get_bangladesh.sh
    :start-after: get_bangladesh from-here
    :end-before:  get_bangladesh to-here
    :language: bash
    :linenos:

See  :ref:`basic/data:Option 3) Download using Overpass XAPI`

Upload Bangladesh data to the database
-------------------------------------------------------------------------------

The next step is to run ``osm2pgrouting`` converter, which is a command line
tool that inserts the data in the database, "ready" to be used with pgRouting.
See :doc:`../appendix/appendix-3` for additional information about ``osm2pgrouting``.

For this step the following is used:

* ``waterways.xml`` configuration file
* ``~/Desktop/workshop/bangladesh.osm`` - OSM data from the previous step
* ``bangladesh`` database

Contents of the configuration files are given in the `Appendix`_. Create a XML file
using these contents and save it into the root directory ``~/Desktop/workshop``.

Open a terminal window by ``ctrl-alt-t`` and move to the workshop directory by ``cd ~/Desktop/workshop``.


Importing Bangladesh Waterways
...............................................................................

The following ``osm2pgrouting`` command will be used to import the Waterways
from OpenStreetMaps file to pgRouting database which we will use for further exercises.

.. literalinclude:: ../scripts/un_sdg/sdg11/import_bangladesh_waterways.sh
    :start-after: from-here
    :end-before:  to-here
    :language: bash
    :linenos:

.. note:: Depending on the osm2pgrouting version `-W password` is needed

.. rubric:: Output:

.. literalinclude:: ../scripts/un_sdg/sdg11/import_bangladesh_waterways.txt
    :language: bash
    :linenos:

To connect to the database, type the following in the terminal.

.. code-block:: bash

  psql bangladesh



Appendix
===============================================================================

Configuration information for Buildings
-------------------------------------------------------------------------------

.. literalinclude:: ../scripts/un_sdg/sdg3/buildings.xml
    :language: xml
    :linenos:


Configuration information for Waterways
-------------------------------------------------------------------------------

.. literalinclude:: ../scripts/un_sdg/sdg3/waterways.xml
    :language: xml
    :linenos:
