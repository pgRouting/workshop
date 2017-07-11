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

pgRouting functions provide `low level` interface to applications, they return
When developing for a `higher level` application,
the requirements need to be represented in the SQL queries.
As these SQl queries get more complex it is desirable to store them in stored procedures.
Stored procedures are an effective way wrap application logic related to routing into a simple to use procedure.



.. contents:: Chapter Contents

The application requierments
===============================================================================

The stored procedure that is going to be developed has the following requirements:

#. Vehicles are routed.
    - Do not use pedestrian roads.
    - Once the `VIEW` is created, it is going to be used on the other requirements.
    - :ref:`exercise-10` solves using a `CASE` statement.
    - Costs are to be in minutes.

      - :ref:`exercise-d-4` solves a pedestrian routing in minutes.

#. Starting and ending vertices are by selection using `osm_id`.
    - In past chapters was done using the `id` of the vertices.

#. Name of the road on the path.
#. The geometry segments along the route path with the corrent orientation.
    - Geometry is to be returned. 
    - Geometry handling to get the correct orientation.

.. note:: Each requirement will be treated independenly to understand the concepts behind them.

Vehicles are routed.
-------------------------------------------------------------------------------

.. _exercise-ch7-e1:

Exercise 1 - Segments for Vehicle Routing
...............................................................................

.. image:: /images/ch7-e1.png
  :width: 300pt
  :alt: View of roads for vehicles

.. rubric:: The vehicle is can not circulate on non pedestrian roads

* Create a view of the allowed road network for circulation.
* Routing `costs` will be based on minutes.
* Verify the reduced number of road segments

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: ch7-e1.txt
  :end-before: ch7-e2.txt

:ref:`Solution to Chapter 7 Exercise 1`


  
.. _exercise-ch7-e2:

Exercise 2 - Limiting the Road Network within an Area
...............................................................................

.. image:: /images/ch7-e2.png
  :width: 300pt
  :alt: View of smaller set of roads for vehicles

.. rubric:: The vehicle can only circulate inside this Boundig Box:
   ``(-71.05 42.34, -71.03 42.35)``

* The vehicle can only circulate inside the bounding box:
  ``(-71.05 42.34, -71.03 42.35)``
* Create a view of the allowed road network for circulation.
* Use the ``vehicle_net`` `VIEW`.
* Verify the reduced number of road segments

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: ch7-e2.txt
  :end-before: ch7-e3.txt

:ref:`Solution to Chapter 7 Exercise 2`

  
.. _exercise-ch7-e3:

Exercise 3 - Route using "osm_id"
...............................................................................

.. image:: /images/ch7-e3.png
  :width: 300pt
  :alt:  From the Venue to the Brewry using the osm_id.

.. rubric:: From the Venue to the Brewry using the osm_id.

.. image:: /images/wrapper4.png
  :width: 300pt
  :alt: From the Venue, going to the Brewry by car using osm_id.

* The vehicle is going from vertex ``61350413`` to vertex ``61479912``.
* Start and end vertex are given with their ``osm_id``.
* The result should contain:

  * ``seq`` for ordering and unique row identifier
  * the ``name`` of the road segments

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: ch7-e3.txt
  :end-before: ch7-e4.txt

:ref:`Solution to Chapter 7 Exercise 3`

.. _exercise-ch7-e4:

Exercise 4 - Get additional information
...............................................................................


.. image:: /images/ch7-e4.png
  :width: 300pt
  :alt:  Route showing names

.. rubric:: From the Venue to the Brewry, additionally get the name of the roads.

* The vehicle is going from vertex ``61350413`` to vertex ``61479912``.
* The result should also contain:

  * the ``name`` of the road segments

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: ch7-e4.txt
  :end-before: ch7-e5.txt

:ref:`Solution to Chapter 7 Exercise 4`




Geometry handling
-------------------------------------------------------------------------------

.. _exercise-ch7-e5:

Exercise 5 - Route geometry (human readable)
...............................................................................

.. rubric:: From the Venue to the Brewry, additionally get the geometry in human readable form.

.. image:: /images/ch7-e5.png
  :width: 300pt
  :alt: From the Venue to the Brewry

* The vehicle is going from vertex ``61350413`` to vertex ``61479912``.
* Include the geometry of the path in human readable form.

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: ch7-e5.txt
  :end-before: ch7-e6.txt

:ref:`Solution to Chapter 7 Exercise 5`

.. note::
  The last record of the result, does not contain a geometry value since the
  shortest path function returns ``-1`` for the last record to indicate the end
  of the route.




.. _exercise-ch7-e6:

Exercise 6 - Route geometry (binary format)
...............................................................................

.. image:: /images/ch7-e6.png
  :width: 300pt
  :alt: From Venue to Brewry showing arrows.

.. rubric:: From the Venue, going to the Brewry by car, also get the binary format geometry
    that can be used by a front end app.

.. note:: Not using ``ST_AsText`` gives the binary format.

* The vehicle is going from vertex ``61350413`` to vertex ``61479912``.
* Include the geometry of the path in default binary format.

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: ch7-e6.txt
  :end-before: ch7-e7.txt

:ref:`Solution to Chapter 7 Exercise 6`




.. _exercise-ch7-e7:

Exercise 7 - Route geometry for arrows
...............................................................................

.. image:: /images/ch7-e7.png
  :width: 300pt
  :alt: From Venue to Brewry showing arrows.

.. rubric:: From the Venue, going to the Brewry by car, get the geometry with
    correct arrow directionality.  (in human readable form).

When we generate a route the segements are returned as the geometry in the database.
that means the segments can be reverserd relative to the direction of the `route path`.
Goal is to have all segments oriented correctly along the route path.


* The vehicle is going from vertex ``61350413`` to vertex ``61479912``.
* Include the geometry of the path in human readable form.
* The first point of the segment must "match" with the last point of the
  previous segment.

.. tip::
  ``WITH`` provides a way to write auxiliary statements in larger queries.
  It can be thought of as defining temporary tables that exist just for one query.

.. literalinclude:: solutions/wrapper_problems.sql
  :language: sql
  :start-after: ch7-e7.txt
  :end-before: ch7-e8.txt

:ref:`Solution to Chapter 7 Exercise 7`


.. note::
  Comparing row 1 & 2 from :ref:`Solution to Chapter 7 Exercise 5`

  ::

    -- from Exercise 5
    LINESTRING(-71.0414012 42.3502602,-71.040802 42.351054)
    LINESTRING(-71.0415194 42.3501037,-71.0414012 42.3502602)

    -- from Excercise 7
    LINESTRING(-71.040802 42.351054,-71.0414012 42.3502602)
    LINESTRING(-71.0414012 42.3502602,-71.0415194 42.3501037)

  * In Exercise 5 the first point of the second segment **does not match** the
    last point of the first segment
  * In Exercise 7 the first point of the second segment **matches** the last
    point of the first segment







Creating a Function
-------------------------------------------------------------------------------

The following function simplifies (and sets default values) when it calls the
shortest path Dijkstra function.

.. tip::
  pgRouting uses heavely function overloading:

  * Avoid the name of a function installed with pgRouting
  * Avoid the name of a function starting with `pgr_` & `ST_`

.. _exercise-ch7-e8:

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
  :start-after: ch7-e8.txt
  :end-before: tmp.txt

:ref:`Solution to Exercise 18`

.. _exercise-19:

Exercise 19 - Function for an application with heading
...............................................................................

* Same conditions as in the :ref:`previous exercise <exercise-17>` apply.
* Additionally provide information for orientation (heading).

.. literalinclude:: solutions/wrapper_problems.sql
  :start-after: w-18.txt
  :end-before: tmp.txt

:ref:`Solution to Exercise 19`




Keeping this info just for reference while re-writing the chapter
===============================================================================

Segments orientation

so the applications only see simple calls to stored procedures.
pgRouting functions provide `low level` interface to applications, they return
ordered identifiers rather than routes with geometries.
Creating complex queries, using views or wrapper functions, can be used to connect to a high level
application.

For applications the queries get more complex.
Stored procedures are an effective way wrap application logic related to routing into a simple to use procedure.
This section will look at ways to do this and discuss why you might want to write and use them.


orient the segments along the direction of the route

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
