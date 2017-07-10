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

pgRouting functions provide `low level` interface to applications, they return
ordered identifiers rather than routes with geometries.
Creating complex queries, using views or wrapper functions, can be used to connect to a high level
application.

.. contents:: Chapter Contents

Why a wrapper?
-------------------------------------------------------------------------------

Just considering the different ways `cost` can be calculated, makes it
almost impossible to create a general wrapper, that can work on all applications,
for example:

* The data may come from a source that is not OpenStreetMap.
* The column names may be in other language than English.

.. rubric:: Visualizing the result

Most of modern day applications display a map image instead of a sequence of rows, columns and numbers on the terminal screen.
In order to visualize the route on a map, can be done in different ways:

* **Storing the result as table** with ``CREATE TABLE <table name> AS SELECT ...``
* **Storing the result as view** with ``CREATE VIEW  <view name> AS SELECT ...``
* **Calculating the result using a fucntion** with ``CREATE FUNCTION AS <function name> (...) ...``

all of them returning a `geometry` column that can be used by the `high level` application for rendering the map.

OSGeo Live provides FOSS4G software for visualization, for example:

* QGIS (DB Manager, Layer Filter or `pgRouting Plugin <http://planet.qgis.org/planet/tag/pgrouting/>`_)
* WMS/WFS server with Geoserver/Mapserver.

The following exercises only cover shortest path queries with a single route
result.

* The examples will return a human readable geometry
  for analysis, except :ref:`Exercise 13 <exercise-13>`.
* The chapter uses som PostGIS functions. `PostGIS documentation
  <http://postgis.net/documentation>`_

.. _exercise-12:

Exercise 12 - Route geometry (human readable)
...............................................................................

.. rubric:: From the Venue, going to the Brewry by car, also get the geometry in human readable form.

.. image:: /images/wrapper1.png
  :width: 300pt
  :alt: From the Venue, going to the Brewry by car

* The vehicle is going from vertex ``13009`` to vertex ``3986``.
* The vehicle's cost in this case will be in seconds.
* Include the geometry of the path in human readable form.
* For simplicity all roads are considered usable by vehicles.

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


.. rubric:: From the Venue, going to the Brewry by car, also get the binary format geometry
    that can be used by a front end app.

.. TODO
.. image:: /images/wrapper2.png
  :width: 300pt
  :alt: From the Venue, going to the Brewry by car showing arrows.

.. note:: Not using ``ST_AsText`` gives the binary format.

* The vehicle is going from vertex ``13009`` to vertex ``3986``.
* The vehicle's cost in this case will be in seconds.
* Include the geometry of the path in default binary format.
* For simplicity all roads are considered usable by vehicles.

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-12.txt
  :end-before: w-13.txt

:ref:`Solution to Exercise 13`




.. _exercise-14:

Exercise 14 - Route geometry for arrows
...............................................................................

.. rubric:: From the Venue, going to the Brewry by car, get the geometry with
    correct arrow directionality.  (in human readable form).

.. TODO
.. image:: /images/wrapper3.png
  :width: 300pt
  :alt: From the Venue, going to the Brewry by car showing correct arrows.

* The vehicle is going from vertex ``13009`` to vertex ``3986``.
* The vehicle's cost in this case will be in seconds.
* Include the geometry of the path in human readable form.
* The first point of the segment must "match" with the last point of the
  previous segment.

.. tip::
  ``WITH`` provides a way to write auxiliary statements in larger queries.
  It can be thought of as defining temporary tables that exist just for one query.

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-13.txt
  :end-before: w-14.txt

:ref:`Solution to Exercise 14`


.. note::
  Comparing row 1 & 2 from :ref:`Solution to Exercise 12`

  .. code-block:: sql

    -- from Exercise 12
    LINESTRING(-71.0414012 42.3502602,-71.040802 42.351054)
    LINESTRING(-71.0412494 42.3502008,-71.0414012 42.3502602)

    -- from Excercise 14
    LINESTRING(-71.040802 42.351054,-71.0414012 42.3502602)
    LINESTRING(-71.0414012 42.3502602,-71.0412494 42.3502008)

  * In Exercise 12 the first point of the second segment **does not match** the
    last point of the first segment
  * In Exercise 14 the first point of the second segment **matches** the last
    point of the first segment




.. _exercise-15:

Exercise 15 - Route using "osm_id"
...............................................................................

.. rubric:: From the Venue, going to the Brewry by car when the osm_id is known.

.. TODO
.. image:: /images/wrapper4.png
  :width: 300pt
  :alt: From the Venue, going to the Brewry by car using osm_id.

* The vehicle is going from vertex ``61350413`` to vertex ``61479912``.
* Start and end vertex are given with their ``osm_id``.
* The result should contain:

  * ``seq`` for ordering and unique row identifier
  * the ``name`` of the road segments
  * the ``geometry`` of the road segments for arrows
  * the ``cost`` in seconds (travel time)

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-14.txt
  :end-before: w-15.txt

:ref:`Solution to Exercise 15`


Wrapping with views
-------------------------------------------------------------------------------

There can be different levels of wrapping with a view:

* Create a view of selected edges (that will be used for routing)
* Create a view of a pgRouting query

.. _exercise-16:

Exercise 16 - Limiting the Road Network within an Area
...............................................................................

(U) dijkstra: [3986] to [13009] BBOX(-71.07 42.34,-71.02 42.37)


.. rubric:: The vehicle is mini-taxi to transport people of FOSS4G Boston.
   The contract says that it can only circulate inside this Boundig Box:
   ``(-71.05 42.34, -71.03 42.35)``

* The vehicle can only circulate inside the bounding box:
  ``(-71.05 42.34, -71.03 42.35)``
* Create a view of the allowed road network for circulation.
* Routing `costs` will be based on seconds.
* Verify the reduced number of road segments

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: w-15.txt
  :end-before: w-16.txt

:ref:`Solution to Exercise 16`

.. _exercise-17:

Exercise 17 - Route using "osm_id" within an area
...............................................................................

.. TODO
.. image:: /images/wrapper4.png
  :width: 300pt
  :alt: From the Venue, going to the Brewry by car using osm_id.

* The vehicle is going from vertex ``61350413`` to vertex ``61479912``.
* Use **my_area** for the network selection.
* The vehicle is going from vertex ``61350413`` to vertex ``61479912``.
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
