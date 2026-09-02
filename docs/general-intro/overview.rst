:file: This file is part of the pgRouting project.
:copyright: Copyright (c) 2010-2026 pgRouting developers
:license: Creative Commons Attribution-Share Alike 3.0 https://creativecommons.org/licenses/by-sa/3.0

Software and Data Source Overview
===============================================================================

.. image:: /images/logos/osgeo.png
    :align: center
    :target: https://www.osgeo.org/


pgRouting is a community project of OSGeo.

This workshop uses several free and open source software tools for geospatial analysis.
Most of these tools are related to other open source software projects. Here
we mention the most important ones.

.. contents:: Chapter Contents

pgRouting Overview
-------------------------------------------------------------------------------

.. image:: /images/logos/pgrouting.png
    :align: center
    :target: https://pgrouting.org

pgRouting extends the PostGIS / PostgreSQL geospatial database to provide
geospatial routing functionality.

Advantages of the database routing approach are:

* Data and attributes are stored on a PostreSQL database and as such they can be
  modified by many clients.
* Data changes can be reflected instantaneously through the routing engine.
  There is no need for pre-calculation.
* The “cost” parameter can be dynamically calculated through SQL and its value
  can come from multiple fields or tables.

Some of the pgRouting library core features are:

* `Functions based on Dijkstra Algorithm <https://docs.pgrouting.org/latest/en/dijkstra-family.html>`__
* `Functions based on `A* Search Algorithm <https://docs.pgrouting.org/latest/en/aStar-family.html>`__
* `Graph component functions <https://docs.pgrouting.org/latest/en/components-family.html>`__
* `and many more <https://docs.pgrouting.org/latest/en/routingFunctions.html>`_

pgRouting is an open source software available under the GPLv2 license and is
supported and maintained by the pgRouting community.

`pgRouting <https://pgrouting.org>`_ is part of `OSGeo Community Projects
<https://wiki.osgeo.org/wiki/OSGeo_Community_Projects>`__ under `OSGeo
Foundation <https://www.osgeo.org>`__. It is included on `OSGeoLive
<https://live.osgeo.org/en/overview/pgrouting_overview.html>`__.

:Check it out on OSGeoLive: https://live.osgeo.org/en/overview/pgrouting_overview.html


osm2pgrouting Overview
-------------------------------------------------------------------------------

.. image:: /images/logos/osm2pgrouting.png
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

.. image:: /images/logos/osm_logo.png
    :align: center
    :target: https://www.openstreetmap.org

OpenStreetMap is an incredible data source for pgRouting because it has no
technical restrictions in terms of processing the data. Data availability still
varies from country to country, but the worldwide coverage is improving day by
day. In its own words:

  OpenStreetMap (OSM) is dedicated to creating and providing geographic
  data, such as street maps, worldwide, for free.

  Most maps considered 'free' actually have legal or technical restrictions on their use.
  These restrictions hold back anyone from using them in creative,
  productive or unexpected ways, and make every map a silo of data and effort.

  -- `Source: OSM Press Wiki <https://wiki.openstreetmap.org/wiki/Press>`_

OpenStreetMap uses a topological data structure:

* Nodes are points with a geographic position.
* Ways are lists of nodes, representing a polyline or polygon.
* Relations are groups of nodes, ways and other relations which can be assigned
  certain properties.
* Properties can be assigned to nodes, ways or relations and consist of
  :code:`name = value` pairs.

:Website: https://www.openstreetmap.org
