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
instructions.  Information about installing OSGeoLive can be found in Chapter 3
:ref:`Installation` of this workshop.

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
City. The instructions for downloading the data are given below


Downloading Mumbai data from OpenStreetMap(OSM)
...............................................................................
The following command is used to download the OpenStreetMaps data of the area in Mumbai, India.

.. literalinclude:: ../scripts/un_sdg/sdg3/get_mumbai.sh 
    :start-after: get_mumbai from-here 
    :end-before:  get_mumbai to-here 
    :language: bash 
    :linenos:

Refer to Section 1.2.1.3. from Chapter 1 :ref:`Option 3) Download using Overpass XAPI`

Upload Mumbai data to the database
-------------------------------------------------------------------------------

The next step is to run ``osm2pgrouting`` converter, which is a command line
tool that inserts the data in the database, "ready" to be used with pgRouting.
Additional information about ``osm2pgrouting`` can be found `here
<https://workshop.pgrouting.org/2.6/en/chapters/osm2pgrouting.html#osm2pgrouting>`_


For this step the following is used:

* ``mumbai_buildings.xml`` and ``mumbai_roads.xml`` configuration files for osm2pgrouting.
* ``~/Desktop/workshop/mumbai.osm`` - OSM data from the previous step
* ``mumbai`` database.

Contents of the configuration files are given in :ref:`Appendix`. Create a XML file
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

Downloading Bangladesh data from OpenStreetMap
...............................................................................
The following coomand is used to download the OSM data of the area in Munshigang,
Bangladesh.

.. literalinclude:: ../scripts/un_sdg/sdg11/get_bangladesh.sh 
    :start-after: get_bangladesh from-here 
    :end-before:  get_bangladesh to-here 
    :language: bash 
    :linenos:

Refer to Section 1.2.1.3. from Chapter 1 :ref:`Option 3) Download using Overpass XAPI`

Upload Bangladesh data to the database
-------------------------------------------------------------------------------

The next step is to run ``osm2pgrouting`` converter, which is a command line
tool that inserts the data in the database, "ready" to be used with pgRouting.
Additional information about ``osm2pgrouting`` can be found `here
<https://workshop.pgrouting.org/2.6/en/chapters/osm2pgrouting.html#osm2pgrouting>`_

For this step the following is used:

* ``waterways.xml`` configuration file 
* ``~/Desktop/workshop/bangladesh.osm`` - OSM data from the previous step
* ``bangladesh`` database

Contents of the configuration files are given in :ref:`Appendix`. Create a XML file
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

.. code-block:: xml

        <?xml version="1.0" encoding="UTF-8"?>
        <configuration>
          <tag_name name="building" id="1">
            <!-- Buildigs are grouped based on the population density in each category -->

            <!-- Negligible -->
            <tag_value name="terrace" id="1" />
            <tag_value name="shrine" id="2" />
            <tag_value name="service" id="3" />
            <tag_value name="transformer_tower" id="4" />
            <tag_value name="water_tower" id="5" />
            <tag_value name="military" id="6" />
            <tag_value name="ruins" id="7" />
            <tag_value name="tree_house" id="8" />
            <tag_value name="hangar" id="9" />
            <tag_value name="digester" id="10" />
            <tag_value name="barn" id="11" />
            <tag_value name="farm_auxiliary" id="12" />
            <tag_value name="slurry_tank" id="13" />
            <tag_value name="stable" id="14" />
            <tag_value name="sty" id="15" />
            <tag_value name="grandstand" id="16" />
            <tag_value name="pavilion" id="17" />
            <tag_value name="riding_hall" id="18" />
            <tag_value name="sports_hall" id="19" />
            <tag_value name="stadium" id="20" />
            <tag_value name="parking" id="21" />
            <tag_value name="greenhouse" id="22" />
            <tag_value name="kiosk" id="23" />
            <tag_value name="carport" id="24" />
            <tag_value name="garage" id="25" />
            <tag_value name="garages" id="26" />
            <tag_value name="container" id="27" />
            <tag_value name="roof" id="28" />
            <tag_value name="user defined" id="29" />
            <tag_value name="toilets" id="30" />
            <tag_value name="cowshed" id="31" />

            <!-- Very Sparse -->
            <tag_value name="farm" id="101" />
            <tag_value name="warehouse" id="102" />
            <tag_value name="conservatory" id="103" />
            <tag_value name="train_station" id="104" />
            <tag_value name="transportation" id="105" />
            <tag_value name="houseboat" id="106" />
            <tag_value name="industrial" id="107" />
            <tag_value name="temple" id="108" />
            <tag_value name="chapel" id="109" />
            <tag_value name="monastery" id="110" />
            <tag_value name="presbytery" id="111" />
            <tag_value name="religious" id="112" />
            <tag_value name="synagogue" id="113" />
            <tag_value name="cathedral" id="114" />
            <tag_value name="church" id="115" />
            <tag_value name="mosque" id="116" />
            <tag_value name="bakehouse" id="117" />
            <tag_value name="office" id="118" />
            <tag_value name="retail" id="119" />
            <tag_value name="public" id="120" />
            <tag_value name="kindergarten" id="121" />
            <tag_value name="school" id="122" />
            <tag_value name="government" id="123" />
            <tag_value name="commercial" id="124" />
            <tag_value name="civic" id="125" />
            <tag_value name="bridge" id="126" />

            <!-- Sparse -->
            <tag_value name="university" id="201" />
            <tag_value name="college" id="202" />

            <!-- Moderate -->
            <tag_value name="tent" id="301" />
            <tag_value name="cabin" id="302" />
            <tag_value name="detached" id="303" />
            <tag_value name="ger" id="304" />
            <tag_value name="semidetached_house" id="305" />
            <tag_value name="static_caravan" id="306" />
            <tag_value name="fire_station" id="307" />
            <tag_value name="hut" id="308" />
            <tag_value name="shed" id="309" />
            <tag_value name="bunker" id="310" />
            <tag_value name="construction" id="311" />
            <tag_value name="gatehouse" id="312" />
            <tag_value name="bungalow" id="313" />
            <tag_value name="hotel" id="314" />
            <tag_value name="house" id="315" />
            <tag_value name="dormitory" id="316" />
            <tag_value name="supermarket" id="317" />
            <tag_value name="hospital" id="318" />

          
            <!-- Dense -->
            <tag_value name="residential" id="401" />
            <tag_value name="yes" id="402" />


            <!-- Very Dense -->
            <tag_value name="apartments" id="501" />
          </tag_name>
         
        </configuration>


Configuration information for Roads
-------------------------------------------------------------------------------

.. code-block:: xml

        <?xml version="1.0" encoding="UTF-8"?>
        <configuration>
          <tag_name name="highway" id="1">
            <tag_value name="road" id="100" />
            <tag_value name="motorway" id="101" />
            <tag_value name="motorway_link" id="102" />
            <tag_value name="motorway_junction" id="103" />
            <tag_value name="trunk" id="104" />
            <tag_value name="trunk_link" id="105" />    
            <tag_value name="primary" id="106" />
            <tag_value name="primary_link" id="107" />    
            <tag_value name="secondary" id="108" />
            <tag_value name="secondary_link" id="124" />
            <tag_value name="tertiary" id="109" />
            <tag_value name="tertiary_link" id="125" />
            <tag_value name="residential" id="110" />
            <tag_value name="living_street" id="111" />
            <tag_value name="service" id="112" />
            <tag_value name="track" id="113" />
            <tag_value name="pedestrian" id="114" />
            <tag_value name="services" id="115" />
            <tag_value name="bus_guideway" id="116" />
            <tag_value name="path" id="117" />
            <tag_value name="cycleway" id="118" />
            <tag_value name="footway" id="119" />
            <tag_value name="bridleway" id="120" />
            <tag_value name="byway" id="121" />
            <tag_value name="steps" id="122" />
            <tag_value name="unclassified" id="123" />
          </tag_name>
          <tag_name name="cycleway" id="2">
            <tag_value name="lane" id="201" />
            <tag_value name="track" id="202" />
            <tag_value name="opposite_lane" id="203" />
            <tag_value name="opposite" id="204" />
          </tag_name>  
          <tag_name name="tracktype" id="3">
            <tag_value name="grade1" id="301" />
            <tag_value name="grade2" id="302" />
            <tag_value name="grade3" id="303" />
            <tag_value name="grade4" id="304" />
            <tag_value name="grade5" id="305" />
          </tag_name>  
          <tag_name name="junction" id="4">
            <tag_value name="roundabout" id="401" />
          </tag_name>  
        </configuration>


Configuration information for Waterways(Rivers)
-------------------------------------------------------------------------------

.. code-block:: xml

        <?xml version="1.0" encoding="UTF-8"?>
        <configuration>
          <tag_name name="waterway" id="1">
            <tag_value name="river" id="101" />
            <tag_value name="riverbank" id="102" />
            <tag_value name="stream" id="103" />
            <tag_value name="tidal_channel" id="104" />
            <tag_value name="canal" id="105" />    
            <tag_value name="fairway" id="106" />
          </tag_name> 
        </configuration>
          