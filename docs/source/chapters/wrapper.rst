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

.. image:: /images/route.png
  :width: 250pt
  :align: center

.. rubric::
  It is the user responiblility to write their own wrapper functions for their
  own use cases.

pgRouting functions provide a "low-level" interface to algorithms and return
ordered identifiers rather than routes with geometries. Creating a complex
queries, views or wrapper functions, can be used to connect to a high level
application.

Just considering the different ways that the `cost` can be calculated, makes it
almost impossible to create a general wrapper, that can work on all applications,
for example:

* The data may come from a source that is not OpenStreetMap.
* The column names may be in other language than English.

.. rubric:: Visualizing the result

Instead of looking at rows, columns and numbers on the terminal screen, it's
more interesting to visualize the route on a map. Here a few ways to do so:

* **Store the result as table** with ``CREATE TABLE <table name> AS SELECT ...``
* **Store the result as view** with ``CREATE VIEW  <view name> AS SELECT ...``

OSGeo Live provides FOSS4G software for visualization, for example:

* QGIS (DB Manager, Layer Filter or `pgRouting Plugin <http://planet.qgis.org/planet/tag/pgrouting/>`_)
* WMS/WFS server with Geoserver/Mapserver.

In this chapter we will look at some common wrappers examples.

* :ref:`oneRouteGeo`

  * :ref:`Exercise 11 <exercise-11>` - Route geometry (human readable)
  * :ref:`Exercise 12 <exercise-12>` - Route geometry
  * :ref:`Exercise 13 <exercise-13>` - Route geometry for arrows
  * :ref:`Exercise 14 <exercise-14>` - Route using "osm_id"

* :ref:`viewWrap`

  * :ref:`Exercise 15 <exercise-15>` - Road network within an area
  * :ref:`Exercise 16 <exercise-16>` - Route using "osm_id" within an area

* :ref:`functionWrap`

  * :ref:`Exercise 17 <exercise-17>` - Function for an application
  * :ref:`Exercise 18 <exercise-18>` - Function for an application with heading

.. _oneRouteGeo:

One Route geometry
-------------------------------------------------------------------------------

The following exercises only cover shortest path queries with a single route
result.

* For this chapter, all the examples will return a human readable geometry
  for analysis, except :ref:`Exercise 12 <exercise-12>`.
* The chapter uses som PostGIS functions. `PostGIS documentation
  <http://postgis.net/documentation>`_

.. _exercise-11:
.. rubric:: Exercise 11 - Route geometry (human readable)

* The vehicle is going from vertex ``13224`` to vertex ``6549``.
* The vehicle's cost in this case will be in seconds.
* Include the geometry of the path in human readable form.

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-11.txt
  :end-before: w-12.txt

:ref:`sol-11`

.. note::
  The last record of the query doesn't contain a geometry value since the
  shortest path function returns ``-1`` for the last record to indicate the end
  of the route.

.. _exercise-12:
.. rubric:: Exercise 12 - Route geometry (binary format)

* The vehicle is going from vertex ``13224`` to vertex ``6549``.
* The vehicle's cost in this case will be in seconds.
* Include the geometry of the path in default binary format.

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-12.txt
  :end-before: w-13.txt

:ref:`sol-12`

.. _exercise-13:
.. rubric:: Exercise 13 - Route geometry for arrows

* The vehicle is going from vertex ``13224`` to vertex ``6549``.
* The vehicle's cost in this case will be in seconds.
* Include the geometry of the path in human readable form.
* The first point of the segment must "match" with the last point of the
  previous segment.

.. tip::
  ``WITH`` provides a way to write auxiliary statements for use in larger queries.
  It can be thought of as defining temporary tables that exist just for one query.

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-13.txt
  :end-before: w-14.txt

:ref:`sol-13`

.. note::
  * Comparing row 1 & 2 from :ref:`sol-11`

  .. code-block:: sql

    -- from Exercise 11
    LINESTRING(7.1234212 50.7172365,7.1220583 50.7183785)
    LINESTRING(7.1250564 50.7179702,7.1244554 50.7176698,7.1235463 50.7172858,7.1234212 50.7172365)

    -- from Excercise 13
    LINESTRING(7.1220583 50.7183785,7.1234212 50.7172365)
    LINESTRING(7.1234212 50.7172365,7.1235463 50.7172858,7.1244554 50.7176698,7.1250564 50.7179702)

  * In Exercise 11 The first point of the second segment **does not match** the
    last point of the first segment
  * In Exercise 13 The first point of the second segment **matches** the last
    point of the first segment

.. _exercise-14:
.. rubric:: Exercise 14 - Route using "osm_id"

* The vehicle is going from vertex ``33180347`` to vertex ``253908904``.
* Start and end vertex are given with their ``osm_id``.
* The result should contain:

  * ``seq`` for ordering and unique row identifier
  * the name of the road segments
  * the geometry of the road segments
  * the cost in seconds (travel time)

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-14.txt
  :end-before: w-15.txt

:ref:`sol-14`

.. _viewWrap:

Wrapping with views
-------------------------------------------------------------------------------

There can be different levels of wrapping with a view:

* Create a view of selected edges (that will be used for routing)
* Create a view of a pgRouting query

.. _exercise-15:
.. rubric:: Exercise 15 - Road network within an area

* The vehicle is not allowed to operate outside a bounding box:
  ``(7.11606541142, 50.7011037738), (7.14589528858, 50.7210993262)``
* Create a view of the network area (bounding box).
* Verify the reduced number of road segments

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-15.txt
  :end-before: w-16.txt

:ref:`sol-15`

.. _exercise-16:
.. rubric:: Exercise 16 - Route using "osm_id" within an area

* Use **my_area** for the network selection.
* The vehicle wants to go from vertex ``33180347`` to vertex ``253908904``.
* Start and end vertex are given with their ``osm_id``.
* The result should contain:

  * ``seq`` for ordering and unique row identifier
  * the name of the road segments
  * the geometry of the road segments
  * the cost in seconds (travel time)

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-16.txt
  :end-before: w-17.txt

:ref:`sol-16`


.. _functionWrap:

Wrapping with functions
-------------------------------------------------------------------------------

The following function simplifies (and sets default values) when it calls the
shortest path Dijkstra function.

.. tip::
  pgRouting uses heavely function overloading:

  * Avoid the name of a function installed with pgRouting
  * Avoid the name of a function starting with `pgr_` & `ST_`

.. _exercise-17:
.. rubric:: Exercise 17 - Function for an application

* Need to make many similar queries.
* Should work for any given area.
* Data tables:

  * the edges are found in **ways**
  * the vertices are found in **ways_vertices_pgr**

* Allow the table/view as a parameter
* Start and end vertex are given with their ``osm_id``.
* The result should contain:

  * ``seq`` for ordering and unique row identifier
  * the name of the road segments
  * the geometry of the road segments
  * the cost in seconds (travel time)

.. literalinclude:: solutions/wrapper_problems.sql
  :start-after: w-17.txt
  :end-before: w-18.txt

:ref:`sol-17`

.. _exercise-18:
.. rubric:: Exercise 18 - Function for an application with heading

* Same conditions as in the :ref:`previous exercise <exercise-17>` apply.
* Additionally provide information for orientation (heading).

.. literalinclude:: solutions/wrapper_problems.sql
  :start-after: w-18.txt
  :end-before: w-19.txt

:ref:`sol-18`
