..
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: https://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

About The Workshop
===============================================================================

.. image:: images/chapter2/osgeo.png
    :align: center
    :target: https://www.osgeo.org/


This workshop use several free and open source software for geospatial tools. Most of the free and open source software for geospatial tools are
related to other open source software projects and it would not be feasible to list all of them.

.. contents:: Chapter Contents


pgRouting Overview
-------------------------------------------------------------------------------

.. image:: images/chapter2/pgrouting.png
    :align: center
    :target: https://pgrouting.org

pgRouting extends the PostGIS / PostgreSQL geospatial database to provide
geospatial routing functionality.

Advantages of the database routing approach are:

* Data and attributes can be modified by many clients, like QGIS or by directly using PL/pgSQL. The clients can either be personal computers
  or mobile devices.
* Data changes can be reflected instantaneously through the routing engine.
  There is no need for precalculation.
* The “cost” parameter can be dynamically calculated through SQL and its value
  can come from multiple fields or tables.

Some of the pgRouting library core features are:

* `Dijkstra Algorithm <https://docs.pgrouting.org/latest/en/pgr_dijkstra.html>`__
* `Johnson's Algorithm <https://docs.pgrouting.org/latest/en/pgr_johnson.html>`__
* `Floyd-Warshall Algorithm <https://docs.pgrouting.org/latest/en/pgr_floydWarshall.html>`__
* `A* Search Algorithm <https://docs.pgrouting.org/latest/en/pgr_aStar.html>`__
* `Bi-directional Dijkstra <https://docs.pgrouting.org/latest/en/pgr_bdDijkstra.html>`__
* `Bi-directional A* <https://docs.pgrouting.org/latest/en/pgr_bdAstar.html>`__
* `Traveling Salesperson Problem <https://docs.pgrouting.org/latest/en/pgr_TSP.html>`__
* `Driving Distance <https://docs.pgrouting.org/latest/en/pgr_drivingDistance.html>`__
* many more!!!

pgRouting is an Open Source Software, available under the GPLv2 license and is supported and
maintained by |georepublic|, |paragon| and a broad user community.

pgRouting is a part of `OSGeo Community Projects <https://wiki.osgeo.org/wiki/OSGeo_Community_Projects>`__ of the `OSGeo Foundation <https://www.osgeo.org>`__ and included on `OSGeoLive
<https://live.osgeo.org/en/overview/pgrouting_overview.html>`__.

:Website: https://pgrouting.org
:OSGeoLive: https://live.osgeo.org/en/overview/pgrouting_overview.html


osm2pgrouting Overview
-------------------------------------------------------------------------------

.. image:: images/chapter2/osm2pgrouting.png
    :align: center
    :width: 150
    :target: https://github.com/pgRouting/osm2pgrouting/wiki

osm2pgrouting is a command line tool that imports OpenStreetMap data into a
pgRouting database. It builds the routing network topology automatically and
creates tables for feature types and road classes. osm2pgrouting was primarily
written by Daniel Wendt and is now hosted on the pgRouting project site.

osm2pgrouting is available under the GPLv2 license.

:Wiki: https://github.com/pgRouting/osm2pgrouting/wiki


OpenStreetMap Overview
-------------------------------------------------------------------------------

.. image:: images/chapter2/osm_logo.png
    :align: center
    :target: https://www.openstreetmap.org


"OpenStreetMap (OSM) is dedicated to creating and providing geographic data, such as street maps, worldwide, for free. Most maps considered "free" actually have legal or technical restrictions on their use. These restrictions hold back anyone from using them in creative, productive or unexpected ways, and make every map a silo of data and effort."

(Source: https://wiki.openstreetmap.org/wiki/Press)

OpenStreetMap is an adequate  data source for pgRouting, because it has no
technical restrictions in terms of processing the data. Data availability still
varies from country to country, but the worldwide coverage is improving day by
day.

OpenStreetMap uses a topological data structure:

* Nodes are points with a geographic position.
* Ways are lists of nodes, representing a polyline or polygon.
* Relations are groups of nodes, ways and other relations which can be assigned
  certain properties.
* Properties can be assigned to nodes, ways or relations and consist of
  :code:`name = value` pairs.

:Website: https://www.openstreetmap.org
