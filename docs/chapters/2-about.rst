.. 
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _about:

About
===============================================================================


.. image:: images/osgeo.png
    :align: center
    :target: http://www.osgeo.org/

This workshop makes use of several FOSS4G tools, there are a lot more than the workshop title mentions.
Also most of FOSS4G software is related to other open source projects and it would go too far to list them all.
This workshop will focus on the following four FOSS4G projects:

* :ref:`about_pgRouting`
* :ref:`about_osm`
* :ref:`about_osm2pgrouting`
* :ref:`about_OpenLayers`


.. _about_pgRouting:

pgRouting
-------------------------------------------------------------------------------

.. image:: images/pgrouting.png
    :align: center
    :target: http://pgrouting.org/

pgRouting adds routing and other network analysis functionality.
The predecessor of pgRouting – pgDijkstra, written by Sylvain Pasche from `Camptocamp <http://camptocamp.com>`_, was later extended by `Orkney <http://www.orkney.co.jp>`_ and renamed to pgRouting.
The project is now supported and maintained by `Georepublic <http://georepublic.info>`_, `iMaptools <http://imaptools.com/>`_ and a broad user community.

pgRouting is an `OSGeo Labs <http://wiki.osgeo.org/wiki/OSGeo_Labs>`_ project of the `OSGeo Foundation <http://osgeo.org>`_ and included on `OSGeo Live <http://live.osgeo.org/>`_. 

pgRouting provides functions for:

* `Dijkstra Algorithm <https://en.wikipedia.org/wiki/Dijkstra's_algorithm>`_
* `Johnson's Algorithm <https://en.wikipedia.org/wiki/Johnson's_algorithm>`_
* `Floyd-Warshall Algorithm <https://en.wikipedia.org/wiki/Floyd%E2%80%93Warshall_algorithm>`_
* `A* Algorithm <https://en.wikipedia.org/wiki/A*_search_algorithm>`_

* `Bi-directional Algorithms <https://en.wikipedia.org/wiki/Bidirectional_search>`_

  * Bi-directional Dijkstra
  * Bi-directional A*

* `Traveling Sales Person <https://en.wikipedia.org/wiki/Travelling_salesman_problem>`_
* Driving Distance
* Turn Restricted Shortest Path (TRSP)
* many more!!!

Advantages of the database routing approach are:

* Data and attributes can be modified by many clients, like:

  * `QGIS <http://live.osgeo.org/en/overview/qgis_overview.html>`_ 
  * `uDig <http://live.osgeo.org/en/overview/udig_overview.html>`_

  through JDBC, ODBC, or directly using Pl/pgSQL.


* The clients can either be PCs or mobile devices.
* Data changes can be reflected instantaneously through the routing engine. There is no need for precalculation.
* The "cost" parameter can be dynamically calculated through SQL and its value can come from multiple fields or tables.

pgRouting is available under the GPLv2 license and is supported by a growing community of individuals, businesses and organizations.

pgRouting website: http://www.pgrouting.org


.. _about_osm:

OpenStreetMap
-------------------------------------------------------------------------------

.. image:: images/osm_logo.png
    :align: center
    :target: http://www.openstreetmap.org

*"OpenStreetMap is a project aimed squarely at creating and providing free geographic data such as street maps to anyone who wants them. The project was started because most maps you think of as free actually have legal or technical restrictions on their use, holding back people from using them in creative, productive or unexpected ways."* (Source: http://wiki.openstreetmap.org/index.php/Press)

OpenStreetMap is a perfect data source to use for pgRouting, because it's freely available and has no technical restrictions in terms of processing the data.
Data availability still varies from country to country, but the worldwide coverage is improving day by day.

OpenStreetMap uses a topological data structure:

* Nodes are points with a geographic position.
* Ways are lists of nodes, representing a polyline or polygon.
* Relations are groups of nodes, ways and other relations which can be assigned certain properties.
* Tags can be applied to nodes, ways or relations and consist of name=value pairs.

OpenStreetMap website: http://www.openstreetmap.org

.. _about_osm2pgrouting:

osm2pgrouting
-------------------------------------------------------------------------------

osm2pgrouting is a command line tool that makes it easy to import OpenStreetMap data into a pgRouting database.
It builds the routing network topology automatically and creates tables for feature types and road classes.
osm2pgrouting was primarily written by Daniel Wendt and is now hosted on the pgRouting project site.

osm2pgrouting is available under the GPLv2 license.

Project documentation: https://github.com/pgRouting/osm2pgrouting/wiki/Documentation-for-osm2pgrouting-v2.1


.. _about_openLayers:

OpenLayers
-------------------------------------------------------------------------------

.. image:: images/openlayers_logo.png
    :align: center
    :target: http://openlayers.org/

OpenLayers 3 brings geospatial data to any modern desktop or mobile web browser. 
Featuring WebGL and 3D,. it supports a huge variety of data formats and layer types,
relying on latest browser technologies like HTML5, WebGL and CSS3.

OpenLayers website: http://openlayers.org/
