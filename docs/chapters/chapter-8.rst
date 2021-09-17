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

============  ==========  ===
Column        type        Description
============  ==========  ===
edges_subset  REGCLASS    Edge table name identifier.
lat1          NUMERIC     The latitude of the `departure`  point.
lon1          NUMERIC     The longitude of the `departure`  point.
lat2          NUMERIC     The latitude of the `destination`  point.
lon2          NUMERIC     The longitude of the `destination`  point.
do_debug      BOOLEAN     Flag to create a ``WARNING`` with the query that is been executed
============  ==========  ===


.. rubric::  Output columns

============= =================================================
Column          Description
============= =================================================
*seq*           For ordering purposes.
*gid*           The edge identifier that can be used to JOIN the results to the ``ways`` table.
*name*          The street name.
*azimuth*       Between start and end node of an edge.
*length*        In meters.
*minutes*       Minutes taken to traverse the segment.
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
  :end-before: exercise_8_1_1.txt


The Vertex Table
===============================================================================

Graphs have a `set of edges` and a `set of vertices` associated to it.

`osm2pgrouting` provides the `ways_vertices_pgr` table which is associated with
the `ways` table.

When a subset of `edges` is used like in ``vehicle_net`` or in ``taxi_net``,
the set of vertices associated to each one must be used in order to, for example,
locate the nearest vertex to a lat/lon location.

Exercise 1: Number of vertices
-------------------------------------------------------------------------------

.. rubric:: Problem

* Calculate the number of vertices in a graph.

Depending on the graph calculate the number of vertices of:

* ``ways``
* ``vehicle_net``
* ``taxi_net``
* ``walk_net``

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
    :start-after: exercise_8_1_1.txt
    :end-before: exercise_8_1_2.txt

* For ``vehicle_net``:

  * Extract the vertices identifiers of the ``source`` column. (line **3**)
  * Extract the vertices identifiers of the ``target`` column. (line **8**)
  * `UNION <https://www.postgresql.org/docs/current/typeconv-union-case.html>`__ both results (line **6**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 3,6,8
    :start-after: exercise_8_1_2.txt
    :end-before: exercise_8_1_3.txt


* For ``taxi_net``:

  * Similar solution as in previous query but on ``taxi_net``. (lines **4** and **9**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 4, 9
    :start-after: exercise_8_1_3.txt
    :end-before: exercise_8_1_4.txt

* For ``walk_net``:

  * Similar solution as in previous query but on ``walk_net``. (lines **4** and **9**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 4, 9
    :start-after: exercise_8_1_4.txt
    :end-before: exercise_8_2_1.txt

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
* ``taxi_net``
* ``walk_net``

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
  * The source and target columns are in terms of ``id`` column of ``ways_vertices_pgr``

* For ``vehicle_net``:

  * Using the query ``id_list`` from :ref:`Exercise 1: Number of vertices`. (not highlighted lines **2** to **8**)
  * ``JOIN`` with ``ways_vertices_pgr`` that has the OSM identifier and the geometry information. (line **13**)
  * Extract the ``osm_id`` and ``the_geom``. (line **10**)
  * Save in table ``vehicle_net_vertices_pgr``. (line **11**)
  * The source and target columns values have the ``osm_id`` therefore the ``id`` column of ``vehicle_net_vertices_pgr``
    must also have the ``osm_id`` values

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 10,11,13
    :start-after: exercise_8_2_1.txt
    :end-before: exercise_8_2_2.txt

* For ``taxi_net``:

  * Similar solution as in previous query but on ``taxi_net``. (lines **3**, **8** and **11**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 3,8,11
    :start-after: exercise_8_2_2.txt
    :end-before: exercise_8_2_3.txt

* For ``walk_net``:

  * Similar solution as in previous query but on ``taxi_net``. (lines **3**, **8** and **11**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 3,8,11
    :start-after: exercise_8_2_3.txt
    :end-before: exercise_8_3_1.txt

|

:ref:`Query results for chapter 8 exercise 2`

Exercise 3: Nearest Vertex
-------------------------------------------------------------------------------

.. rubric:: Problem

* Calculate the OSM identifier of the nearest vertex to a point.

In particular use the following (lat,lon) value:  ``(@POINT1_LAT@, @POINT1_LON@)``.

* calculate the nearest OSM identifier of the vertex to:

  * ``vehicle_net_vertices_pgr``
  * ``taxi_net_vertices_pgr``
  * ``walk_net_vertices_pgr``

.. Note:: The ``ways`` and the ``ways_vertices_pgr`` tables are not used on the **final applications**

  The *net* views and *vertices* tables have been prepared in such a way that the ``AS`` statement is not needed any more
  on a pgRouting function.

.. rubric:: Solution

* For ``ways_vertices_pgr``:

  * Get the osm_id. (line **1**)
  * Using the distance operator `<-> <https://postgis.net/docs/geometry_distance_knn.html>`__ to order by distance. (line **3**)
  * Get only the first row, to obtain the nearest OSM identifier of the vertex. (line **4**)

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :emphasize-lines: 1,3,4
  :start-after: exercise_8_3_1.txt
  :end-before: exercise_8_3_2.txt

* For ``vehicle_net_vertices_pgr``:

  * Similar solution as in previous query but:

    * Extracting the ``id`` columns. (line **1**)
    * On ``vehicle_net_vertices_pgr``. (line **2**)

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :emphasize-lines: 1,2
  :start-after: exercise_8_3_2.txt
  :end-before: exercise_8_3_3.txt

* For ``taxi_net_vertices_pgr``:

  * Similar solution as in previous query but on ``taxi_net_vertices_pgr``. (line **2**)

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :emphasize-lines: 2
  :start-after: exercise_8_3_3.txt
  :end-before: exercise_8_3_4.txt

* For ``walk_net_vertices_pgr``:

  * Similar solution as in previous query but on ``walk_net_vertices_pgr``. (line **2**)

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :language: sql
  :linenos:
  :emphasize-lines: 2
  :start-after: exercise_8_3_4.txt
  :end-before: exercise_8_4.txt

|

:ref:`Query results for chapter 8 exercise 3`

Exercise 4: Nearest vertex function
-------------------------------------------------------------------------------

.. rubric:: Problem

When operations look similar for different tables, a function can be created.

* Create a function that calculates the OSM identifier of the nearest vertex to a point.
* Function name: ``wrk_NearestOSM``.
* Needs to work only for the **final application** views and table.


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
  :start-after: exercise_8_4.txt
  :end-before: exercise_8_5_1.txt

|

:ref:`Query results for chapter 8 exercise 4`


Exercise 5: Test nearest vertex function
-------------------------------------------------------------------------------

.. rubric:: Problem

* Test the ``wrk_NearestOSM`` function.

In particular use the following (lat,lon) values:  ``(@POINT1_LAT@, @POINT1_LON@)``.

* The point is the same as in :ref:`Exercise 3: Nearest Vertex` problem.

  * Verify the results are the same.

* calculate the nearest OSM identifier of the vertex to:

  * ``ways_vertices_pgr``
  * ``vehicle_net_vertices_pgr``
  * ``taxi_net_vertices_pgr``
  * ``walk_net_vertices_pgr``

.. rubric:: Solution

* For ``ways_vertices_pgr``:

  * Use the function with ``ways_vertices_pgr`` as the ``vertex_table`` parameter. (line **2**)
  * Pass the (lat,lon) values as second and third parameters. (line **3**)
  * Using the function on the original data does not return the OSM identifier.

    The value stored in ``id`` column is not the OSM identifier.

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 2, 3
    :start-after: exercise_8_5_1.txt
    :end-before: exercise_8_5_2.txt

* For ``vehicles_net_vertices_pgr``:

  * Similar solution as in previous query but on ``vehicles_net_vertices_pgr``. (lines **2**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 2
    :start-after: exercise_8_5_2.txt
    :end-before: exercise_8_5_3.txt

* For ``taxi_net_vertices_pgr``:

  * Similar solution as in previous query but on ``taxi_net_vertices_pgr``. (lines **2**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 2
    :start-after: exercise_8_5_3.txt
    :end-before: exercise_8_5_4.txt

* For ``walk_net_vertices_pgr``:

  * Similar solution as in previous query but on ``walk_net_vertices_pgr``. (lines **2**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 2
    :start-after: exercise_8_5_4.txt
    :end-before: exercise_8_6.txt

|

:ref:`Query results for chapter 8 exercise 5`


wrk_fromAtoB function
===============================================================================

In this section, creation and testing the requiered function will be tackled.


Exercise 6: Creating the main function
-------------------------------------------------------------------------------

.. rubric:: Problem

* Create the function ``wrk_fromAtoB``.
* Follow the description given at :ref:`Requirements for routing from A to B`.
* Use specialized functions already created ``wrk_dijkstra`` and ``wkt_NearestOSM``.

  * ``wkt_NearestOSM`` created on :ref:`Exercise 4: Nearest vertex function`.

    * It receives the point in natural language format.
    * Obtains the OSM identifier needed by ``wrk_dijkstra``.

  * ``wrk_dijkstra`` created on Chapter 7 :ref:`Exercise 10: Function for an application`.

.. rubric:: Solution

The function's signature:

* The input parameters highlited on lines **2** to **5**.
* The output columns are not higlighted on lines **7** to **13**.
* The function returns a set of values. (line **15**)

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
  :linenos:
  :emphasize-lines: 2-5
  :start-after: exercise_8_6.txt
  :end-before: signature ends

|

The function's body:

* Call to the function ``wrk_dijkstra`` (line **8**)

  * ``wrk_dijkstra`` obtains many of the result values
  * Parameters are passed on lines **9** to **13**.
  * The ``edges_subset``:

    * First parameters of the ``format`` function is the table name. (line **16**)
    * Is passed as ``%1$I``. (line **9**)

  * For the `departure` point:

    * ``wkt_NearestOSM`` is used to find the OSM identifier. (line **10**)

      * The vertices table name is formed with ``%1$I_vertices_pgr``. (line **11**)
      * Second and third parameters of the ``format`` function are ``%2$s``, ``%3$s``. (line **17**)
      * The latitude and longitude are given in natural language form. (line **12**)

  * For the `destination` point:

    * Similar query is constructed but with the destination information. (line **13**)
    * Fourth and fifth parameters of the ``format`` function. (line **18**)

* To get the constructed query in form of a warning:

  * The ``WARNING`` will be issued only when ``do_debug`` is true. (lines **20** to **22**)

.. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :linenos:
    :emphasize-lines: 9-13, 16-18, 20-22
    :start-after: signature ends
    :end-before: exercise_8_7_1.txt

|

:ref:`Query results for chapter 8 exercise 6`

Exercise 7: Using the main function
-------------------------------------------------------------------------------

.. rubric:: Problem

Use ``wrk_fromAtoB``

* Departure point is: (lat,lon) = ``(@POINT1_LAT@, @POINT1_LON@)``
* Destination point is: (lat,lon) = ``(@POINT2_LAT@, @POINT2_LON@)``
* For ``vehicle_net``:

  * Use with default value of ``do_debug``.

* For ``taxi_net``:

  * Use with ``do_debug`` set to ``true``.

* For ``walk_net``:

  * Use with default value of ``do_debug``.
  * Store results on a table.
  * Show the table contents.


.. Note:: The function is not ment to be used with ``ways``

.. rubric:: Solution

* For ``vehicle_net``:

  * The first parameter is the table name. (line **2**)
  * The next  two parameters are the latitude and longitude of the departure point. (line **3**)
  * The next  two parameters are the latitude and longitude of the destination point. (line **4**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 2-4
    :start-after: exercise_8_7_1.txt
    :end-before: exercise_8_7_2.txt

* For ``taxi_net``:

  * Similar to previous solution, but with ``taxi_net`` (line **2**)
  * Adding ``true`` to get the query that is executed. (line **5**)

  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 2, 5
    :start-after: exercise_8_7_2.txt
    :end-before: exercise_8_7_3.txt

* For ``walk_net``:

  * Similar to a previous solution, but with ``ways`` (line **4**)
  * Store results on a table. (line **2**)
  * Show the table contents using a ``SELECT`` clause (lines **8** and **9**).


  .. literalinclude:: ../scripts/chapter_8/all-sections-8.sql
    :language: sql
    :linenos:
    :emphasize-lines: 2, 3, 8-9
    :start-after: exercise_8_7_3.txt

:ref:`Query results for chapter 8 exercise 7`

