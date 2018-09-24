..
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

About The Workshop
===============================================================================

.. image:: /images/osgeo.png
    :align: center
    :target: http://www.osgeo.org/

This workshop uses several FOSS4G tools. Most of FOSS4G software is
related to other open source projects and it would go too far to list them all
here.

.. contents:: Chapter Contents


pgRouting Overview
-------------------------------------------------------------------------------

.. image:: /images/pgrouting.png
    :align: center
    :target: http://pgrouting.org

pgRouting extends the PostGIS / PostgreSQL geospatial database to provide
geospatial routing functionality.

Advantages of the database routing approach are:

* Data and attributes can be modified by many clients, like QGIS and uDig
  through JDBC, ODBC, or directly using Pl/pgSQL. The clients can either be PCs
  or mobile devices.
* Data changes can be reflected instantaneously through the routing engine.
  There is no need for precalculation.
* The “cost” parameter can be dynamically calculated through SQL and its value
  can come from multiple fields or tables.

pgRouting library contains following core features:

* `Dijkstra Algorithm <https://en.wikipedia.org/wiki/Dijkstra's_algorithm>`__
* `Johnson's Algorithm <https://en.wikipedia.org/wiki/Johnson's_algorithm>`__
* `Floyd-Warshall Algorithm
  <https://en.wikipedia.org/wiki/Floyd%E2%80%93Warshall_algorithm>`__
* `A* Algorithm <https://en.wikipedia.org/wiki/A*_search_algorithm>`__
* `Bi-directional Algorithms
  <https://en.wikipedia.org/wiki/Bidirectional_search>`__
  * Bi-directional Dijkstra
  * Bi-directional A*
* `Traveling Sales Person
  <https://en.wikipedia.org/wiki/Travelling_salesman_problem>`__
* Driving Distance
* Turn Restricted Shortest Path (TRSP)
* many more!!!

pgRouting is Open Source, available under the GPLv2 license and is supported and
maintained by `Georepublic <http://georepublic.info>`__, `iMaptools
<http://imaptools.com/>`_ and a broad user community.

pgRouting is an `OSGeo Community Projects <http://wiki.osgeo.org/wiki/OSGeo_Community_Projects>`__ project
of the `OSGeo Foundation <http://osgeo.org>`__ and included on `OSGeoLive
<http://live.osgeo.org/>`__.

:Website: http://www.pgrouting.org
:OSGeoLive: https://live.osgeo.org/en/overview/pgrouting_overview.html


osm2pgrouting Overview
-------------------------------------------------------------------------------

.. image:: /images/osm2pgrouting.png
    :align: center
    :width: 150
    :target: https://github.com/pgRouting/osm2pgrouting/wiki

osm2pgrouting is a command line tool that imports OpenStreetMap data into a
pgRouting database. It builds the routing network topology automatically and
creates tables for feature types and road classes. osm2pgrouting was primarily
written by Daniel Wendt and is now hosted on the pgRouting project site.

osm2pgrouting is available under the GPLv2 license.

Wiki: https://github.com/pgRouting/osm2pgrouting/wiki


OpenStreetMap Overview
-------------------------------------------------------------------------------

.. image:: /images/osm_logo.png
    :align: center
    :target: https://live.osgeo.org/en/overview/osm_dataset_overview.html


"OpenStreetMap is a project aimed squarely at creating and providing free
geographic data such as street maps to anyone who wants them. The project was
started because most maps you think of as free actually have legal or technical
restrictions on their use, holding back people from using them in creative,
productive or unexpected ways."

(Source: http://wiki.openstreetmap.org/index.php/Press)

OpenStreetMap is an adequate  data source for pgRouting, because has no
technical restrictions in terms of processing the data. Data availability still
varies from country to country, but the worldwide coverage is improving day by
day.

OpenStreetMap uses a topological data structure:

* Nodes are points with a geographic position.
* Ways are lists of nodes, representing a poly line or polygon.
* Relations are groups of nodes, ways and other relations which can be assigned
  certain properties.
* Properties can be assigned to nodes, ways or relations and consist of
  :code:`name=value` pairs.

OpenStreetMap website: http://www.openstreetmap.org
