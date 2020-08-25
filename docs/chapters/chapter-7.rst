..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************


###############################################################################
Writing a SQL Stored Procedures
###############################################################################

.. image:: /images/route.png
  :scale: 25%
  :align: center

pgRouting functions provide `low level` interface.
When developing for a `higher level` application,
the requirements need to be represented in the SQL queries.
As these SQL queries get more complex, it is desirable to store them in postgreSQL
stored procedures or functions.
Stored procedures are an effective way to wrap application logic, in this case,
related to routing logic.



.. contents:: Chapter Contents

The application requirements
===============================================================================

The stored procedure that is going to be developed has the following requirements:

#. Vehicles are routed.
    - Do not use pedestrian roads.
    - Once the `VIEW` is created, it is going to be used on the other requirements.
    - Costs are to be in minutes.

      - :ref:`exercise-d-4` Solves a pedestrian routing in minutes.

#. Starting and ending vertices are by selection using `osm_id`.
    - In past chapters it was done using the `id` of the vertices.

#. Name of the road on the path.

#. The geometry segments along the route path with the correct orientation.
    - Geometry is to be returned.
    - Azimuth in degrees of the geometry is to be returned.
    - Geometry handling is needed to get the correct orientation.



.. _exercise-ch7-e1:

Exercise 1 - Segments for Vehicle Routing
-------------------------------------------------------------------------------

.. image:: /images/chapter7/ch7-e1.png
  :scale: 25%
  :alt: View of roads for vehicles

.. rubric:: The vehicle can not circulate on non-pedestrian roads

* Create a view of the allowed road network for circulation.
* Routing `costs` will be based on minutes.
* Verify the reduced number of road segments.

.. literalinclude:: ../scripts/chapter_7/all_sections.sql
  :language: sql
  :linenos:
  :start-after: 7.1.1
  :end-before: 7.1.2

:ref:`Solution to Chapter 7 Exercise 1`



.. _exercise-ch7-e2:

Exercise 2 - Limiting the Road Network within an Area
-------------------------------------------------------------------------------

.. image:: /images/chapter7/ch7-e2.png
  :scale: 25%
  :alt: View of smaller set of roads for vehicles

.. rubric:: The vehicle can only circulate inside this Bounding Box:
   ``(26.08, 44.42, 26.11, 44.44)``

* The vehicle can only circulate inside the bounding box: ``(26.08, 44.42, 26.11, 44.44)``
* Create a view of the allowed road network for circulation.
* Use the ``vehicle_net`` `VIEW`.
* Verify the reduced number of road segments.

.. literalinclude:: ../scripts/chapter_7/all_sections.sql
  :language: sql
  :linenos:
  :start-after: 7.1.2
  :end-before: 7.1.3

:ref:`Solution to Chapter 7 Exercise 2`


.. _exercise-ch7-e3:

Exercise 3 - Route using "osm_id"
-------------------------------------------------------------------------------

.. image:: /images/chapter7/ch7-e3.png
  :scale: 25%
  :alt:   From the Venue to the hotel using the osm_id.

.. rubric:: From the Venue to the hotel using the osm_id.


* The vehicle is going from the Venue at ``6498351588``.
* The vehicle is going to the hotel at ``255093299``.
* Start and end vertex are given with their ``osm_id``.
* The result should contain:

  * ``seq`` for ordering and unique row identifier

.. literalinclude:: ../scripts/chapter_7/all_sections.sql
  :language: sql
  :linenos:
  :start-after: 7.1.3
  :end-before: 7.1.4

:ref:`Solution to Chapter 7 Exercise 3`

.. _exercise-ch7-e4:

Exercise 4 - Get additional information
-------------------------------------------------------------------------------


.. image:: /images/chapter7/ch7-e4.png
  :width: 300pt
  :alt:  Route showing names

.. rubric:: From the |place_3| to the |place_1|, additionally get the name of the roads.

* The vehicle is going from the |place_3| at ``6498351588``.
* The vehicle is going to the |place_1| at ``255093299``.
* The result should contain:

  * ``seq`` for ordering and unique row identifier
  * the ``name`` of the road segments

.. literalinclude:: ../scripts/chapter_7/all_sections.sql
  :language: sql
  :linenos:
  :start-after: 7.1.4
  :end-before: 7.2.1

:ref:`Solution to Chapter 7 Exercise 4`




Geometry handling
===============================================================================

.. _exercise-ch7-e5:

Exercise 5 - Route geometry (human readable)
-------------------------------------------------------------------------------

.. rubric:: From the |place_3| to the |place_1|, additionally get the geometry in human readable form.

.. image:: /images/chapter7/ch7-e5.png
  :width: 300pt
  :alt: From the Venue to the Brewry

* The vehicle is going from the |place_3| at ``6498351588``
* The vehicle is going to the |place_1| at ``255093299``.
* The result should contain:

  * ``seq`` for ordering and unique row identifier
  * the ``name`` of the road segments
  * the geometry of the path in human readable form.

.. literalinclude:: ../scripts/chapter_7/all_sections.sql
  :language: sql
  :linenos:
  :start-after: 7.2.1
  :end-before: 7.2.2

:ref:`Solution to Chapter 7 Exercise 5`

.. note::
  The last row of the result, does not contain a geometry value since the
  shortest path function returns ``-1`` for the last edge to indicate the end
  of the route.




.. _exercise-ch7-e6:

Exercise 6 - Route geometry (binary format)
-------------------------------------------------------------------------------

.. image:: /images/chapter7/ch7-e6.png
  :width: 300pt
  :alt: From |place_3| to the |place_1| showing arrows.

.. rubric:: From the |place_3| to the |place_1| by car, get the binary format geometry
    that can be used by a front end app.

.. note:: Not using ``ST_AsText`` gives the binary format.

.. tip::
  ``WITH`` provides a way to write auxiliary statements in larger queries.
  It can be thought of as defining temporary tables that exist just for one query.

* The vehicle is going from the |place_3| at ``6498351588``.
* The vehicle is going to the |place_1| at ``255093299``.
* The result should contain:

  * ``seq`` for ordering and unique row identifier.
  * the ``name`` of the road segments.
  * the geometry of the path in human readable form.
  * the geometry of the path in default binary format.

.. literalinclude:: ../scripts/chapter_7/all_sections.sql
  :language: sql
  :linenos:
  :start-after: 7.2.2
  :end-before: 7.2.3

:ref:`Solution to Chapter 7 Exercise 6`




.. _exercise-ch7-e7:

Exercise 7 - Using the geometry
-------------------------------------------------------------------------------

.. image:: /images/chapter7/ch7-e7.png
  :width: 300pt
  :alt: From |place_3| to the |place_1| show azimuth

.. rubric:: From the |place_3| to the |place_1|, calculate the azimuth in degrees.

* The vehicle is going from the |place_3| at ``6498351588``.
* The vehicle is going to the |place_1| at ``255093299``.
* Get the ``seq``, ``name``, ``cost``, ``azimuth`` in degrees and the ``geometry``.
* The geometry of the route path in human readable form & binary form.


.. literalinclude:: ../scripts/chapter_7/all_sections.sql
  :language: sql
  :linenos:
  :start-after: 7.2.3
  :end-before: 7.2.4

:ref:`Solution to Chapter 7 Exercise 7`






.. _exercise-ch7-e8:

Exercise 8 - Geometry directionality
-------------------------------------------------------------------------------

.. image:: /images/chapter7/ch7-e8.png
  :width: 300pt
  :alt: From |place_3| to the |place_1|
.. rubric:: From the |place_3|, going to the |place_1| by car, get the geometry with
    correct arrow directionality.

When we generate a route the segments are returned as the geometry in the database.
It means that the segments can be reversed relative to the direction of the `route path`.
Our goal is to have all segments oriented correctly along the route path.


* The vehicle is going from the |place_3| at ``6498351588``.
* The vehicle is going to the |place_1| at ``255093299``.
* The first point of the segment must "match" with the last point of the
  previous segment.
* Get the ``seq``, ``name``, ``cost``, ``azimuth`` and the ``geomtery``.
* The geometry of the route path in human readable form & binary form.


.. literalinclude:: ../scripts/chapter_7/all_sections.sql
  :language: sql
  :linenos:
  :start-after: 7.2.4
  :end-before: 7.3.1

:ref:`Solution to Chapter 7 Exercise 8`


.. note::
  Comparing row 10 & 11 from :ref:`Solution to Chapter 7 Exercise 5`

  ::

    -- from Exercise 5
    LINESTRING(26.1007594 44.4390039,26.1006676 44.4391489)
    LINESTRING(26.1004837 44.4391168,26.1006676 44.4391489)

    -- from Excercise 8
    LINESTRING(26.1007594 44.4390039,26.1006676 44.4391489)
    LINESTRING(26.1006676 44.4391489,26.1004837 44.4391168)

  * In Exercise 5 the first point of row 11 **does not match** the
    last point of row 10
  * In Exercise 8 the first point of row 11 **matches** the last
    point of row 10




Creating a Function
===============================================================================

The following function simplifies (and sets default values) when it calls the
shortest path Dijkstra function.

.. tip::
  pgRouting uses heavely function overloading:

  * Avoid the name of a function installed with pgRouting
  * Avoid the name of a function starting with `pgr_` & `ST_`

.. _exercise-ch7-e9:

Exercise 9 - Function for an application
-------------------------------------------------------------------------------


.. rubric:: Putting all together in a SQL function

* Should work for any given area.
* Data tables:

  * The edges are found in **ways**.
  * The vertices are found in **ways_vertices_pgr**.

* Allow a view as a parameter

  * A table can be used if the columns have the correct names.

* Start and end vertex are given with their ``osm_id``.
* The result should contain:

  * ``seq``, ``name``, ``cost``, ``azimuth`` and the ``geometry``.
  * The geometry of the route path in human readable form & binary form.


.. literalinclude:: ../scripts/chapter_7/all_sections.sql
  :linenos:
  :start-after: 7.3.1
  :end-before: 7.3.2

:ref:`Solution to Chapter 7 Exercise 9`

.. _exercise-ch7-e10:

Exercise 10 - Using the function
-------------------------------------------------------------------------------

* The ``osm_id`` must exist on the ``ways_vertices_pgr`` table.
* If an ``osm_id`` falls outside the view, No path will be returned.

.. literalinclude:: ../scripts/chapter_7/all_sections.sql
  :language: sql
  :linenos:
  :start-after: 7.3.2

:ref:`Solution to Chapter 7 Exercise 10`

.. note:: Try the function with ``little_net`` and a combination of the interesting places:

  * `255093299` |place_1|
  * `6159253045` |place_2|
  * `6498351588` |place_3|
  * `123392877`  |place_4|
  * `1886700005` |place_5|

Exercise 11 - Saving the function
-------------------------------------------------------------------------------

.. rubric:: Save the function code above into a file ``~/Desktop/workshop/wrk_dijkstra.sql``.

Saving functions in a file can be used to install the function in another database.
Install the function into the database with:

.. code-block:: bash

    psql -U user -d city_routing -f ~/Desktop/workshop/wrk_dijkstra.sql


