=============================================================================================================
About
=============================================================================================================

This workshop makes use of several FOSS4G tools, a lot more than the workshop title mentions. Also a lot of FOSS4G software is related to other open source projects and it would go too far to list them all. These are the four FOSS4G projects this workshop will focus on:

.. image:: images/osgeo.png

-------------------------------------------------------------------------------------------------------------
pgRouting
-------------------------------------------------------------------------------------------------------------

pgRouting is an extension of PostGIS and adds routing functionality to PostGIS/PostgreSQL. pgRouting is a further development of pgDijkstra (by `Camptocamp SA <http://www.camptocamp.com>`_). It was extended by `Orkney Inc. <http://www.orkney.co.jp>`_, and is currently developed and maintained by `Georepublic <http://georepublic.de>`_.

.. image:: images/pgrouting.gif

pgRouting provides functions for:

* Shortest Path Dikstra: routing algorithm without heuristics
* Shortest Path A-Star: routing for large datasets (with heuristics)
* Shortest Path Shooting-Star: routing with turn restrictions (with heuristics)
* Traveling Salesperson Problem (TSP)
* Driving Distance calculation (Isolines)

Advantages of the database routing approach are:

* Accessible by multiple clients through JDBC, ODBC, or directly using Pl/pgSQL. The clients can either be PCs or mobile devices.
* Uses PostGIS for its geographic data format, which in turn uses OGC's data format Well Konwn Text (WKT) and Well Known Binary (WKB). This allows usage of existing open * data converters.
* Open Source software like qGIS and uDig can modify the data/attributes,
* Data changes can be reflected instantaneously through the routing engine. There is no need for precalculation.
* The "cost" parameter can be dynamically calculated through SQL and its value can come from multiple fields or tables.

pgRouting is available under the GPLv2 license.

pgRouting website: http://www.pgrouting.org


-------------------------------------------------------------------------------------------------------------
OpenStreetMap
-------------------------------------------------------------------------------------------------------------

*"OpenStreetMap is a project aimed squarely at creating and providing free geographic data such as street maps to anyone who wants them. The project was started because most maps you think of as free actually have legal or technical restrictions on their use, holding back people from using them in creative, productive or unexpected ways."* (Source: http://wiki.openstreetmap.org/index.php/Press)

.. image:: images/osm_logo.png

OpenStreetMap is a perfect data source to use for pgRouting, because it's freely available and has no technical restrictions in terms of processing the data. Data availability still varies from country to country, but the worldwide coverage is improving day by day.

OpenStreetMap uses a topological data structure:

* Nodes are points with a geographic position.
* Ways are lists of nodes, representing a polyline or polygon.
* Relations are groups of nodes, ways and other relations which can be assigned certain properties.
* Tags can be applied to nodes, ways or relations and consist of name=value pairs.

OpenStreetMap website: http://www.openstreetmap.org


-------------------------------------------------------------------------------------------------------------
osm2pgrouting
-------------------------------------------------------------------------------------------------------------

osm2pgrouting is a command line tool that makes it easy to import OpenStreetMap data into a pgRouting database. It builds the routing network topology automatically and creates tables for feature types and road classes. osm2pgrouting was primarily written by Daniel Wendt and is now hosted on the pgRouting project site.

osm2pgrouting is available under the GPLv2 license.

Project website: http://pgrouting.postlbs.org/wiki/tools/osm2pgrouting


-------------------------------------------------------------------------------------------------------------
GeoExt
-------------------------------------------------------------------------------------------------------------

GeoExt is a "JavaScript Toolkit for Rich Web Mapping Applications". GeoExt brings together the geospatial know how of `OpenLayers <http://www.openlayers.org>`_ with the user interface savvy of `Ext JS <http://www.sencha.com>`_ to help you build powerful desktop style GIS apps on the web with JavaScript.

.. image:: images/GeoExt.png

GeoExt is available under the BSD license and is supported by a growing community of individuals, businesses and organizations.

GeoExt website: http://www.geoext.org
