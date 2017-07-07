..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************


Writing a pl/pgsql Wrapper
===============================================================================

.. image:: /images/route.png
  :width: 250pt
  :align: center

.. contents:: Chapter Contents

Why a wrapper?
-------------------------------------------------------------------------------

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

In this chapter covers some simple example wrappers.



One Route geometry
-------------------------------------------------------------------------------

The following exercises only cover shortest path queries with a single route
result.

* For this chapter, all the examples will return a human readable geometry
  for analysis, except :ref:`Exercise 12 <exercise-12>`.
* The chapter uses som PostGIS functions. `PostGIS documentation
  <http://postgis.net/documentation>`_

.. _exercise-12:

Exercise 12 - Route geometry (human readable)
...............................................................................

* The vehicle is going from vertex ``13224`` to vertex ``6549``.
* The vehicle's cost in this case will be in seconds.
* Include the geometry of the path in human readable form.

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-11.txt
  :end-before: w-12.txt

:ref:`Solution to Exercise 12`

.. note::
  The last record of the query doesn't contain a geometry value since the
  shortest path function returns ``-1`` for the last record to indicate the end
  of the route.




.. _exercise-13:

Exercise 13 - Route geometry (binary format)
...............................................................................

* The vehicle is going from vertex ``13224`` to vertex ``6549``.
* The vehicle's cost in this case will be in seconds.
* Include the geometry of the path in default binary format.

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-12.txt
  :end-before: w-13.txt

:ref:`Solution to Exercise 13`




.. _exercise-14:

Exercise 14 - Route geometry for arrows
...............................................................................

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

:ref:`Solution to Exercise 14`

.. note::
  * Comparing row 1 & 2 from :ref:`Solution to Exercise 11`

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




.. _exercise-15:

Exercise 14 - Route using "osm_id"
...............................................................................

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

:ref:`Solution to Exercise 15`

.. _viewWrap:

Wrapping with views
-------------------------------------------------------------------------------

There can be different levels of wrapping with a view:

* Create a view of selected edges (that will be used for routing)
* Create a view of a pgRouting query

.. _exercise-16:

Exercise 15 - Road network within an area
...............................................................................

* The vehicle is not allowed to operate outside a bounding box:
  ``(7.11606541142, 50.7011037738), (7.14589528858, 50.7210993262)``
* Create a view of the network area (bounding box).
* Verify the reduced number of road segments

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-15.txt
  :end-before: w-16.txt

:ref:`Solution to Exercise 17`

.. _exercise-17:

Exercise 17 - Route using "osm_id" within an area
...............................................................................

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

:ref:`Solution to Exercise 17`


.. _functionWrap:

Wrapping with functions
-------------------------------------------------------------------------------

The following function simplifies (and sets default values) when it calls the
shortest path Dijkstra function.

.. tip::
  pgRouting uses heavely function overloading:

  * Avoid the name of a function installed with pgRouting
  * Avoid the name of a function starting with `pgr_` & `ST_`

.. _exercise-18:

Exercise 18 - Function for an application
...............................................................................

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

:ref:`Solution to Exercise 18`

.. _exercise-19:

Exercise 19 - Function for an application with heading
...............................................................................

* Same conditions as in the :ref:`previous exercise <exercise-17>` apply.
* Additionally provide information for orientation (heading).

.. literalinclude:: solutions/wrapper_problems.sql
  :start-after: w-18.txt
  :end-before: w-19.txt

:ref:`Solution to Exercise 19`
