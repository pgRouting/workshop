..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

###############################################################################
Writing a pl/pgsql Stored Procedures
###############################################################################

.. image:: /images/route.png
  :width: 250pt
  :align: center

Other kind of functions are `pl/pgsql <https://www.postgresql.org/docs/current/plpgsql.html>`__.
As the applications requirements become more complex, using wrappers of previously defined functions
becomes necessary for clarity.

.. contents:: Chapter contents

Requirements for routing from A to B
===============================================================================

.. rubric:: Chapter problem:

* Create a function ``wrk_fromAtoB`` that allows routing from 2 geometries.
* The function takes latitude/longitude points as input parameters.
* Returns a  route that includes a geometry so that if can be displayed, for example, in QGIS.
* Will also return some other attributes.

The detailed description:

.. rubric:: Input parameters

* Table or view name.
* ``x1``, ``y1`` for start point.
* ``x2``, ``y2`` for end point.

.. rubric::  Output columns

============= =================================================
Column          Description
============= =================================================
*seq*           For ordering purposes.
*gid*           The edge identifier that can be used to JOIN the results to the ``ways`` table.
*name*          The street name.
*azimuth*       Between start and end node of an edge.
*length*        In kilometers.
*costs*         Costs in minutes.
*route_geom*    The road geometry with corrected directionality.
============= =================================================


For this chapter, the following points will be used for testing.

* (lat,lon) = (@POINT1_LAT@, @POINT1_LON@)
* (lat,lon) = (@POINT2_LAT@, @POINT2_LON@)

Saving this information on a table:

* The ``X`` value of a geometry is the longitude.
* The ``Y`` value of a geometry is the latitude.
* Natural language to form the point is ``(latitude, longitude)``.
* For geometry processing to form the point is ``(longitude, latitude)``.
* lines **4** and **6** show the inverse order of the (lat,lon) pairs.

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :emphasize-lines: 4,6
  :start-after: 8.1.1
  :end-before: 8.2.1.1


The Vertex Table
===============================================================================

Graphs have a `set of edges` and a `set of vertices` associated to it.

`osm2pgrouting` provides the `ways_vertices_pgr` table which is associated with
the `ways` table.

When a subset of `edges` is used like in ``vehicle_net`` or in ``small_net``,
the set of vertices associated to each one must be used in order to, for example,
locate the nearest vertex to a lat/lon location.

Exercise 1: Number of Vertices
-------------------------------------------------------------------------------

.. rubric:: Problem

* Calculate the number of vertices in a graph.

Depending on the graph calculate the number of vertices of:

* ``ways``
* ``vehicle_net``
* ``little_net``

.. rubric:: Solution

* For ``ways``:

  * `osm2pgrouting` automatically created the ``ways_vertices_pgr`` table that contains
    all the vertices in ``ways`` table.
  * Using `aggregate function <https://www.postgresql.org/docs/current/functions-aggregate.html>`__
    ``count``. (line **1**)
  * Count all the rows of ``ways_vertices_pgr`` table. (line **2**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 1-2
    :start-after: 8.2.1.1
    :end-before: 8.2.1.2

* For ``vehicle_net``:

  * Extract the vertices identifiers of the ``source`` column. (line **3**)
  * Extract the vertices identifiers of the ``target`` column. (line **8**)
  * `UNION <https://www.postgresql.org/docs/current/typeconv-union-case.html>`__ both results (line **6**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 3,6,8
    :start-after: 8.2.1.2
    :end-before: 8.2.1.3


* For ``little_net``:

  * Similar solution as in previous query but on ``little_net``. (lines **4** and **9**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 4, 9
    :start-after: 8.2.1.3
    :end-before: 8.2.2.1

|

:ref:`Query results for chapter 8 exercise 1`

Exercise 2: Vertices on a table
-------------------------------------------------------------------------------

.. rubric:: Problem

* Create a vertices table.
* Follow the suffix naming ``_vertices_pgr``.

Depending on the graph create a vertices table of:

* ``ways``
* ``vehicle_net``
* ``little_net``

The vertices table should contain:

=========  =====
Column      Description
=========  =====
osm_id     OSM Identifier of the vertex.
the_geom   The geometry of the vertex.
=========  =====

.. rubric:: Solution

* For ``ways``:

  * `osm2pgrouting` automatically created the ``ways_vertices_pgr`` table that contains
    all the vertices in ``ways`` table.
  * The vertices are already on a table.
  * The table suffix follows is as requested.
  * There is no need to create a table.

* For ``vehicle_net``:

  * Using the query ``id_list`` from :ref:`Exercise 1: Number of Vertices`. (lines **2** to **8**)
  * ``JOIN`` with ``ways_vertices_pgr`` that has the OSM identifier and the geometry information. (line **13**)
  * Extract the ``osm_id`` and ``the_geom``. (line **10**)
  * Save in table ``vehicle_net_vertices_pgr``. (line **11**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 10,11,13
    :start-after: 8.2.2.1
    :end-before: 8.2.2.2

* For ``little_net``:

  * Similar solution as in previous query but on ``little_net``. (lines **3**, **8** and **11**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 3,8,11
    :start-after: 8.2.2.2
    :end-before: 8.2.3

|

:ref:`Query results for chapter 8 exercise 2`

Exercise 3: Nearest Vertex
-------------------------------------------------------------------------------

.. rubric:: Problem

* Calculate the OSM identifier of the nearest vertex to a point.

In particular use the following (lat,lon) value:  ``(@POINT1_LAT@, @POINT1_LON@)``.

* calculate the nearest OSM identifier of the vertex to:

  * ``ways_vertices_pgr``
  * ``vehicle_net_vertices_pgr``
  * ``little_net_vertices_pgr``

.. rubric:: Solution

* For ``ways_vertices_pgr``:

  * Get the osm_id. (line **1**)
  * Using the distance operator `<-> <https://postgis.net/docs/geometry_distance_knn.html>`__ to order by distance. (line **3**)
  * Get only the first row, to obtain the nearest OSM identifier of the vertex. (line **4**)

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :emphasize-lines: 1,3,4
  :start-after: 8.2.3.1
  :end-before: 8.2.3.2

* For ``vehicle_net_vertices_pgr``:

  * Similar solution as in previous query but on ``vehicle_net_vertices_pgr``. (line **2**)

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :emphasize-lines: 2
  :start-after: 8.2.3.2
  :end-before: 8.2.3.3

* For ``little_net_vertices_pgr``:

  * Similar solution as in previous query but on ``little_net_vertices_pgr``. (line **2**)

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :emphasize-lines: 2
  :start-after: 8.2.3.3
  :end-before: 8.2.4

|

:ref:`Query results for chapter 8 exercise 3`

Exercise 4: Nearest vertex function
-------------------------------------------------------------------------------

.. rubric:: Problem

* Create a function that calculates the OSM identifier of the nearest vertex to a point.
* Function name: ``wrk_NearestOSM``.


The input parameters:

============  ==========  ===
Column        type        Description
============  ==========  ===
vertex_table  REGCLASS    Table name identifier.
lat           NUMERIC     The latitude of a point.
lon           NUMERIC     The longitude of a point.
============  ==========  ===

The output:

=========  =====
type       Description
=========  =====
BIGINT     the OSM identifier that is nearest to (lat,lon).
=========  =====

.. rubric:: Solution

* The function returns only one value. (line **5**)
* Using `format <ihttps://www.postgresql.org/docs/12/functions-string.html#FUNCTIONS-STRING-FORMAT>`__ to build the query. (line **10**)

  * The structure of the query is similar to :ref:`Exercise 3: Nearest Vertex` solutions. (lines **12** to **16**)
  * ``%1$I`` for the table name identifier. (line **13**)
  * ``%2$s`` and ``%3$s`` for the latitude and longitude.

    * The point is formed with (lon/lat) ``(%3$s, %2$s)``. (line **15**)

  * The additional parameters of function ``format``, are the parameters of the function we are creating. (line **19**)

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :linenos:
  :emphasize-lines: 5, 10, 12-16, 19
  :start-after: 8.2.4
  :end-before: 8.2.5.1

|

:ref:`Query results for chapter 8 exercise 4`


Exercise 5: Test nearest vertex function
-------------------------------------------------------------------------------

.. rubric:: Problem


In particular use the following (lat,lon) values:  ``(@POINT1_LAT@, @POINT1_LON@)``.

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :start-after: 8.2.5.1
  :end-before: 8.2.5.2

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :start-after: 8.2.5.2
  :end-before: 8.2.5.3

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :start-after: 8.2.5.3
  :end-before: 8.3.1


:ref:`Query results for chapter 8 exercise 5`


wrk_fromAtoB function
===============================================================================

Incorporating all the requirements into the function ``wrk_fromAtoB``.
Additionally, it will show the query that is being executed, with the ``NOTICE`` statement.

Exercise 6: Creating the function
-------------------------------------------------------------------------------

.. rubric:: Create the function ``wrk_fromAtoB`` .

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :linenos:
  :start-after: 8.3.1
  :end-before: 8.3.2.1

:ref:`Query results for chapter 8 exercise 6`

Exercise 7: Using the function
-------------------------------------------------------------------------------

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :start-after: 8.3.2.1
  :end-before: 8.3.2.2

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :start-after: 8.3.2.2
  :end-before: 8.3.2.3

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :start-after: 8.3.2.3

:ref:`Query results for chapter 8 exercise 7`

