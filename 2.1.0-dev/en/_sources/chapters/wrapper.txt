.. 
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _wrapper:

Writing a pl/pgsql Wrapper
===============================================================================

.. image:: images/route.png
    :width: 250pt
    :align: center

pgRouting functions provide a "low-level" interface to algorithms and return ordered identifiers rather than routes with geometries.
Creating a complex queries, views or wrapper functions, can be used to connect to a high level application.

.. note::

    pgRouting only supports low-level functions and it is the user responiblility to write their own wrapper functions for their own use cases.

Just considering the different ways that the `cost` can be calculated makes almost impossible to create a general wrapper that can work on all applications.

* The data might come from a source that is not OSM.
* The column names might be in other language than English.


Instead of looking at rows, columns and numbers on the terminal screen it's more interesting to visualize the route on a map. Here a few ways to do so:

* **Store the result as table** with ``CREATE TABLE <table name> AS SELECT ...`` and visualize the result in QGIS
* **Store the result as viewi** with ``CREATE VIEW  <view name> AS SELECT ...`` and visualize the result in QGIS

Visualize on:

* on QGIS
* on a WMS server with Geoserver.
* on mapserver

In this chapter we will see some common wrappers examples.

* :ref:`oneRouteGeo`

  * :ref:`Exercise 11 <w-11>` Route geometry (human reading).
  * :ref:`Exercise 12 <w-12>` Route geometry.
  * :ref:`Exercise 13 <w-13>` Route geometry for arrows.
  * :ref:`Exercise 14 <w-14>` Route using osm_id

* :ref:`viewWrap`

  * :ref:`Exercise 15 <w-15>` Edges on a bounding box
  * :ref:`Exercise 16 <w-16>` Route using osm_id with edges on bounding box

* :ref:`functionWrap`

  * :ref:`Exercise 17 <w-17>` Function for an application.
  * :ref:`Exercise 18 <w-18>` Function for an application with heading.

.. note::
    * For this chapter, all the examples will return a human readable geometry for analysis, except :ref:`Exercise 12 <w-12>`.
    * The chapter uses som postGIS functions. `postGIS documentation <http://postgis.net/documentation>`_

.. _oneRouteGeo:

One Route geometry
-------------------------------------------------------------------------------

The following exercises are for results that are for one route


.. _w-11:

.. topic:: Exercise 11

    Route geometry (human reading)

Driver A: '“I am in vertex 13224 and want to drive to vertex 6549. Include the geometry of the segments."

.. rubric:: Problem description

* The driver wants to go from vertex 13224 to vertex 6549.
* The driver's cost is in terms of seconds.
* Include the geometry of the path in human readable form.

.. rubric:: Query

.. literalinclude:: solutions/wrapper_problems.sql
    :language: sql
    :start-after: w-11.txt
    :end-before: w-12.txt

.. rubric:: Query results

:ref:`sol-w-11`

.. note::
    * The last record of the query doesn't contain a geometry value since the shortest path function returns ``-1`` for the last record to indicate the end of the route.

.. _w-12:

.. topic:: Exercise 12

    Route geometry

Driver: '“I am in vertex 13224 and want to drive to vertex 6549. Include the geometry of the segments."

.. rubric:: Problem description

* The driver wants to go from vertex 13224 to vertex 6549.
* The driver's cost is in terms of seconds.
* Include the geometry of the path in **non** human readable form.

.. rubric:: Query

.. literalinclude:: solutions/wrapper_problems.sql
    :language: sql
    :start-after: w-12.txt
    :end-before: w-13.txt


.. rubric:: Query Results

:ref:`sol-w-12`

.. note::
    * Just removing `ST_AsText` from the **human readable form**


.. _w-13:

.. topic:: Exercise 13

    Route geometry for arrows

Driver A: '“I am in vertex 13224 and want to drive to vertex 6549. Include the geometry of the segments."

.. rubric:: Problem description

* The driver wants to go from vertex 13224 to vertex 6549.
* The driver's cost is in terms of seconds.
* Include the geometry of the path in human readable form.
* The first point of the segment must "match" with the last point of the previous segment

.. rubric:: Query

.. literalinclude:: solutions/wrapper_problems.sql
    :language: sql
    :start-after: w-13.txt
    :end-before: w-14.txt

.. note::
    * WITH provides a way to write auxiliary statements for use in a larger query.
    * and can be thought of as: defining temporary tables that exist just for one query.

.. rubric:: Query Results

:ref:`sol-w-13`

.. note::
    * Comparing row 1 & 2 from :ref:`sol-w-11`

    .. code-block:: sql

          -- from Exercise 11
          LINESTRING(7.1234212 50.7172365,7.1220583 50.7183785)
          LINESTRING(7.1250564 50.7179702,7.1244554 50.7176698,7.1235463 50.7172858,7.1234212 50.7172365)

          -- from Excercise 13
          LINESTRING(7.1220583 50.7183785,7.1234212 50.7172365)
          LINESTRING(7.1234212 50.7172365,7.1235463 50.7172858,7.1244554 50.7176698,7.1250564 50.7179702)

    * In Exercise 11 The first point of the second segment **does not match** the last point of the first segment
    * In Exercise 13 The first point of the second segment **matches** the last point of the first segment


.. _w-14:

.. topic:: Exercise 14

    Route using osm_id

Driver: “I am in vertex 33180347 and want to drive to vertex 253908904.

* Include the geometry of the road 
* and include the name of the road.
* I don't care about the vertex identifiers
* I don't care about the edge identifiers
* I care about the time to traverse the road

.. rubric:: Problem description

* The driver wants to go from vertex 33180347 to vertex 253908904.
* The driver is asking using osm_id
* The output must have:

  * seq for ordering and unique row identifier,
  * the name of the segments,
  * the geometry,
  * the cost in seconds
 
.. rubric:: Query

.. literalinclude:: solutions/wrapper_problems.sql
    :language: sql
    :start-after: w-14.txt
    :end-before: w-15.txt


.. rubric:: Query Results

:ref:`sol-w-14`

.. _viewWrap:

Wrapping with views
-------------------------------------------------------------------------------

There can be different levels of wrapping with a view:

* Creating a view of the selected edges used to do the routing
* Create a view of the pg_routing query

  * Use the view of the selected edges

.. _w-15:

.. topic:: Exercise 15

    Edges on a bounding box

Chief: “From now on the driver(s) can not go out of this area:

* (7.11606541142, 50.7011037738), (7.14589528858, 50.7210993262)

.. rubric:: Problem description

* The chief will not allow routes outside of the bounding box
* Make a view of the area.
* Verify the number of edges decreased

.. rubric:: Query

.. literalinclude:: solutions/wrapper_problems.sql
    :language: sql
    :start-after: w-15.txt
    :end-before: w-16.txt


.. rubric:: Query Results

:ref:`sol-w-15`

.. _w-16:

.. topic:: Exercise 16

     Route using osm_id with edges on bounding box

Driver: “I am in vertex 33180347 and want to drive to vertex 253908904."

Chief: “Use same characteristics as exercise 14 and the view from 15"

.. rubric:: Problem description

* use **my_area** for the edges selection
* The driver wants to go from vertex 33180347 to vertex 253908904.
* The driver is asking using osm_id
* The output must have:

  * seq for ordering and unique id,
  * the name of the segments,
  * the geometry,
  * the cost in seconds
 
.. rubric:: Query

.. literalinclude:: solutions/wrapper_problems.sql
    :language: sql
    :start-after: w-16.txt
    :end-before: w-17.txt


.. rubric:: Query Results

:ref:`sol-w-16`


.. _functionWrap:

Wrapping with functions
-------------------------------------------------------------------------------

The following function simplifies (and sets default values) when it calls the shortest path Dijkstra function.

.. note::

    pgRouting uses heavely overloaded functions

    * try to avoid the name of a function installed with pgRouting
    * try to avoid the name of a function starting with `pgr_` & `ST_`


.. _w-17:

.. topic:: Exercise 17

    Function for an application.

Chief: "I need to make many queries that of the type in Exercise 16"

* Can be used for any area I need.

.. rubric:: Problem description

* Original data in:

  * the edges are in **ways** 
  * the vertices are in **ways_vertices_pgr**

* A table/view as a parameter
* The chief/driver is asking using osm_id
* The output must have:

  * seq for ordering and unique id,
  * the cost in seconds,
  * the name of the segments,
  * the geometry
 
.. rubric:: Query

.. literalinclude:: solutions/wrapper_problems.sql
    :language: sql
    :start-after: w-17.txt
    :end-before: w-18.txt

.. rubric:: Query Results

:ref:`sol-w-17`


.. _w-18:

.. topic:: Exercise 18

    Function for an application with heading


Chief: "Extend previous function for another API that also needs the heading"

* Can be used for any area I need.

.. rubric:: Problem description

* Original data in:

  * the edges are in **ways** 
  * the vertices are in **ways_vertices_pgr**

* A table/view as a parameter
* The chief/driver is asking uisng osm_id
* The output must have:

  * seq for ordering and unique id,
  * the cost in seconds,
  * the name of the segments,
  * the geometry
 
.. rubric:: Function

.. literalinclude:: solutions/wrapper_problems.sql
    :language: sql
    :start-after: w-18.txt
    :end-before: w-19.txt

.. rubric:: Query Results

:ref:`sol-w-18`

