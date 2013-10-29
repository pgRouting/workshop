.. 
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _about:

About
===============================================================================

This workshop makes use of several FOSS4G tools, a lot more than the workshop title mentions. Also a lot of FOSS4G software is related to other open source projects and it would go too far to list them all. These are the four FOSS4G projects this workshop will focus on:

.. image:: images/osgeo.png
	:align: center


pgRouting
-------------------------------------------------------------------------------

adds routing and other network analysis functionality. A predecessor of pgRouting – pgDijkstra, written by Sylvain Pasche from `Camptocamp <http://camptocamp.com>`_, was later extended by `Orkney <http://www.orkney.co.jp>`_ and renamed to pgRouting. The project is now supported and maintained by `Georepublic <http://georepublic.info>`_, `iMaptools <http://imaptools.com/>`_ and a broad user community.

pgRouting is an `OSGeo Labs <http://wiki.osgeo.org/wiki/OSGeo_Labs>`_ project of the `OSGeo Foundation <http://osgeo.org>`_ and included on `OSGeo Live <http://live.osgeo.org/>`_. 

pgRouting provides functions for:

* All Pairs Shortest Path, Johnson’s Algorithm :sup:`[1]`
* All Pairs Shortest Path, Floyd-Warshall Algorithm :sup:`[1]`
* Shortest Path A*
* Bi-directional Dijkstra Shortest Path :sup:`[1]`
* Bi-directional A* Shortest Path :sup:`[1]`
* Shortest Path Dijkstra
* Driving Distance
* K-Shortest Path, Multiple Alternative Paths :sup:`[1]`
* K-Dijkstra, One to Many Shortest Path :sup:`[1]`
* Traveling Sales Person
* Turn Restriction Shortest Path (TRSP) :sup:`[1]`
* Shortest Path Shooting Star :sup:`[2]`

Advantages of the database routing approach are:

* Data and attributes can be modified by many clients, like `QGIS" <http://live.osgeo.org/en/overview/qgis_overview.html>`_ and `uDig <http://live.osgeo.org/en/overview/udig_overview.html>`_ through JDBC, ODBC, or directly using Pl/pgSQL. The clients can either be PCs or mobile devices.
* Data changes can be reflected instantaneously through the routing engine. There is no need for precalculation.
* The "cost" parameter can be dynamically calculated through SQL and its value can come from multiple fields or tables.

pgRouting is available under the GPLv2 license and is supported by a growing community of individuals, businesses and organizations.

pgRouting website: http://www.pgrouting.org

| :sup:`[1]` **New** in pgRouting 2.0.0
| :sup:`[2]` Discontinued in pgRouting 2.0.0


OpenStreetMap
-------------------------------------------------------------------------------

*"OpenStreetMap is a project aimed squarely at creating and providing free geographic data such as street maps to anyone who wants them. The project was started because most maps you think of as free actually have legal or technical restrictions on their use, holding back people from using them in creative, productive or unexpected ways."* (Source: http://wiki.openstreetmap.org/index.php/Press)

.. image:: images/osm_logo.png
	:align: center

OpenStreetMap is a perfect data source to use for pgRouting, because it's freely available and has no technical restrictions in terms of processing the data. Data availability still varies from country to country, but the worldwide coverage is improving day by day.

OpenStreetMap uses a topological data structure:

* Nodes are points with a geographic position.
* Ways are lists of nodes, representing a polyline or polygon.
* Relations are groups of nodes, ways and other relations which can be assigned certain properties.
* Tags can be applied to nodes, ways or relations and consist of name=value pairs.

OpenStreetMap website: http://www.openstreetmap.org


osm2pgrouting
-------------------------------------------------------------------------------

osm2pgrouting is a command line tool that makes it easy to import OpenStreetMap data into a pgRouting database. It builds the routing network topology automatically and creates tables for feature types and road classes. osm2pgrouting was primarily written by Daniel Wendt and is now hosted on the pgRouting project site.

osm2pgrouting is available under the GPLv2 license.

Project website: http://www.pgrouting.org/docs/tools/osm2pgrouting.html


OpenLayers 3
-------------------------------------------------------------------------------

OpenLayers 3 brings geospatial data to any modern desktop or mobile web browser. 
ol3 is a complete rewrite, featuring WebGL and 3D. Like `OpenLayers 2 <http://openlayers.org/>`_, it supports a huge variety of data formats and layer types.
But unlike OpenLayers 2, it is built from scratch relying on latest browser technologies like HTML5, WebGL and CSS3.

ol3 is sill a work in progress; all the features of OpenLayers 2 are not yet ported to the new version.

OpenLayers 3 website: http://www.ol3js.org
