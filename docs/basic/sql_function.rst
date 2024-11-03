..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************


SQL function
###############################################################################

.. image:: images/chapter5/route.png
  :scale: 25%
  :align: center

.. contents:: Chapter Contents

pgRouting functions provide `low level` interface.

When developing for a `higher level` application,
the requirements need to be represented in the SQL queries.
As these SQL queries get more complex, it is desirable to store them in postgreSQL
stored procedures or functions.
Stored procedures or functions are an effective way to wrap application logic, in this case,
related to routing logic and requirements.

The application requirements
===============================================================================

A front end needs the following routing information:
  - seq - A unique identifier of the rows
  - id - The segment's identifier
  - name - The segment's name
  - length - The segment's length
  - seconds - Number of seconds to traverse the segment
  - azimuth - The azimuth of the segment
  - route_geom - The routing geometry
  - route_readable - The geometry in human readable form.

.. rubric:: Design of the function

The function to be created ``wrk_dijkstra`` with the following input parameters and
output columns:

.. rubric:: Input parameters

============= ========= =================
Name          Type      Description
============= ========= =================
edges_subset  REGCLASS  The table/view that is going to be used for processing
source_osm    BIGINT    The OSM identifier of the `departure` location.
target_osm    BIGINT    The OSM identifier of the `destination` location.
============= ========= =================

.. rubric:: output columns

=============== ========= =================
Name            Type      Description
=============== ========= =================
seq             INTEGER   A unique number for each result row.
id              BIGINT    The edge identifier.
name            TEXT      The name of the segment.
seconds         FLOAT     The number of seconds it takes to traverse the segment.
azimuth         FLOAT     The azimuth of the segment.
length          FLOAT     The leng in meters of the segment.
route_readable  TEXT      The geometry in human readable form.
route_geom      geometry  The geometry of the segment in the correct direction.
=============== ========= =================

Preparing processing graphs
===============================================================================


.. note:: For the following exercises only ``vehicle_net`` will be used, but
  you can test the queries with the other views.


Exercise 1: Get additional information
-------------------------------------------------------------------------------


.. image:: images/chapter7/ch7-e4.png
  :width: 300pt
  :alt:  Route showing names

.. rubric:: Problem

* From |ch7_place_1| to |ch7_place_2|, using OSM identifiers.
* Additionally get the following information:

  * ``name``
  * ``length``

.. rubric:: Solution

* The query from used as a subquery named ``results`` (not highlighted lines **5** to **9**)
* The ``SELECT`` clause contains

  * All the columns of ``results``. (line **2**)
  * The ``name`` and the ``length`` values. (line **3**)

* A ``LEFT JOIN`` with ``vehicle_net`` is needed to get the additional information. (line **10**)

  * Has to be ``LEFT`` to include the row with ``id = -1`` because it does not
    exist on ``vehicle_net``

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :emphasize-lines: 2, 3,10
  :start-after: 7_5
  :end-before: 7_6

|

:ref:`basic/appendix:**Exercise**: 1 (**Chapter:** SQL)`




Geometry handling
===============================================================================

Exercise 2: Route geometry (human readable)
-------------------------------------------------------------------------------


.. image:: images/chapter7/ch7-e4.png
  :width: 300pt
  :alt: From |ch7_place_1| to |ch7_place_2|

.. rubric:: Problem

From the |ch7_place_1| to the |ch7_place_2|, additionally get the geometry in
human readable form.

* Additionally to the results of the previous exercise, also get

  * ``geom`` in human readable form named as ``route_readable``

.. tip::
  ``WITH`` provides a way to write auxiliary statements in larger queries.
  It can be thought of as defining temporary tables that exist just for one query.

.. rubric:: Solution

* The routing query named ``results`` in a WITH clause. (not highlighted lines
  **2** to **6**)
* The ``SELECT`` clause contains:

  * All the columns of ``results``. (line **8**)
  * The ``the_geom`` processed with ``ST_AsText`` to get the human readable form. (line **9**)

    * Renames the result to  ``route_readable``

* Like before ``LEFT JOIN`` with ``vehicle_net``. (line **11**)


.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :emphasize-lines: 8,9,11
  :start-after: 7_6
  :end-before: 7_7

|

:ref:`basic/appendix:**Exercise**: 2 (**Chapter:** SQL)`



Exercise 3: Route geometry (binary format)
-------------------------------------------------------------------------------

.. image:: images/chapter7/ch7-e6.png
  :width: 300pt
  :alt: From |ch7_place_1| to |ch7_place_2| showing arrows.

.. rubric:: Problem

* From the |ch7_place_1| to |ch7_place_2|, the geometry in binary format.

  * Additionally to the previous exercise get the

    * ``geom`` in binary format with the name ``route_geom``

.. rubric:: Solution

* The query from the pregious exercise is used
* The ``SELECT`` clause also contains:

  * The ``geom`` including the renaming (line **9**)


.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :emphasize-lines: 10
  :start-after: 7_7
  :end-before: wrong_directionality.txt

|

:ref:`basic/appendix:**Exercise**: 3 (**Chapter:** SQL)`


Exercise 4: Route geometry directionality
-------------------------------------------------------------------------------

.. image:: images/chapter7/ch7-e8.png
  :width: 300pt
  :alt: From |ch7_place_1| to |ch7_place_2|

|

Inspecting the detail image of `Exercise 3: Route geometry (binary format)`_ there are
arrows that do not match the directionality of the route.

Inspecting the a detail of the results of :ref:`basic/appendix:**Exercise**: 2 (**Chapter:** SQL)`

* To have correct directionality, the ending point of a geometry must match the
  starting point of the next geometry
* Rows **59** to **61** do not match that criteria

.. collapse:: Query

  .. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
    :language: sql
    :start-after: wrong_directionality.txt
    :end-before: exercise_7_8.txt

.. literalinclude:: ../scripts/basic/chapter_7/wrong_directionality.txt
  :language: sql

.. rubric:: Problem

* From |ch7_place_1| to |ch7_place_2|,

  * Fix the directionality of the geometries of the previouse exercise

    * ``geom`` in human readable form named as  ``route_readable``
    * ``geom`` in binary format  with the name ``route_geom``
    * Both columns must have the geometry fixed for directionality.

.. rubric:: Solution

* To get the correct direction some geometries need to be reversed:

  * Reversing a geometry will depend on the ``node`` column of the query to dijkstra (line **3**)

    * That ``node`` is not needed on the ouput of the query, so explicitly naming required columns at line **9**.
  * A conditional ``CASE`` statement that returns the geometry in human readable form:

    * Of the geometry when ``node`` is the ``source`` column. (line **11**)
    * Of the reversed geometry when ``node`` is not the ``source`` column. (line **12**)

  * A conditional ``CASE`` statement that returns:

    * The reversed geometry when ``node`` is not the ``source`` column. (line **16**)
    * The geometry when ``node`` is the ``source`` column. (line **17**)

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :emphasize-lines: 3,9,11,12,16,17
  :start-after: exercise_7_8.txt
  :end-before: good_directionality.txt

.. collapse:: results

  .. literalinclude:: ../scripts/basic/chapter_7/exercise_7_8.txt

Inspecting some of the problematic rows, the directionality has been fixed.

.. literalinclude:: ../scripts/basic/chapter_7/good_directionality.txt

|

:ref:`basic/appendix:**Exercise**: 4 (**Chapter:** SQL)`



Exercise 5: Using the geometry
-------------------------------------------------------------------------------

.. image:: images/chapter7/ch7-e7.png
  :width: 300pt
  :alt: From |ch7_place_1| to the |ch7_place_2| show azimuth


There are many geometry functions in PostGIS, the workshop already covered some of them like
``ST_AsText``, ``ST_Reverse``, ``ST_EndPoint``, etc.
This exercise will make use an additional function ``ST_Azimuth``.


.. rubric:: Problem

Modify the query from the previous exercise

* Aditionally obtain the azimuth of the correct geometry.
* keep the output small:

  * Even that other columns are calculated only output:

    * ``seq``, ``id``, ``seconds`` and the ``azimuth``

* Because ``vehicle_net`` is a subgraph of ``ways``, do the ``JOIN`` with ``ways``.

.. rubric:: Solution

* Moving the query that gets the additional information into the ``WITH`` statement.

  * Naming it ``additional``. (line **9**)

* Final ``SELECT`` statements gets:

  * The requested information. (line **25**)
  * Calculates the azimuth of ``route_geom``. (line **26**)

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :emphasize-lines: 9,25,26
  :start-after: exercise_7_9.txt
  :end-before: exercise_7_10.txt

|

:ref:`basic/appendix:**Exercise**: 5 (**Chapter:** SQL)`



Creating the Function
===============================================================================

The following function simplifies (and sets default values) when it calls the
shortest path Dijkstra function.

.. warning::
  pgRouting uses heavely function overloading:

  * Avoid creating functions with a name of a pgRouting routing function
  * Avoid the name of a function to start with `pgr_`, `_pgr` or `ST_`

Exercise 6: Function for an application
-------------------------------------------------------------------------------

.. rubric:: Problem

Putting all together in a SQL function

* function name ``wrk_dijkstra``
* Should work for any given view.

  * Allow a view as a parameter

    * A table can be used if the columns have the correct names.

* ``source`` and ``target`` are in terms of ``osm_id``.
* The result should meet the requirements indicated at the begining of the chapter


.. rubric:: Solution

* The signature of the function:

  * The input parameters are from line **4** to **6**.
  * The output columns are from line **7** to **14** (not highlited).
  * The function returns a set. (line **16**)

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :emphasize-lines: 4-6,16
  :start-after: exercise_7_10.txt
  :end-before: BODY

* The body of the function:

  * Appending the view name on line **7** in the ``SELECT`` query to ``pgr_dijkstra``.
  * Using the data to get the route from ``source`` to ``target``. (line **8**)
  * The ``JOIN`` with ``ways`` is necessary, as the views are subset of ``ways`` (line **25**)


.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :emphasize-lines: 7,8,25
  :start-after: RETURNS SETOF
  :end-before: exercise_7_11.txt

|

:ref:`basic/appendix:**Exercise**: 6 (**Chapter:** SQL)`

.. _exercise-ch7-e10:

Exercise 7: Using the function
-------------------------------------------------------------------------------

.. rubric:: Problem

* Test the function with the three views
* From the "|ch7_place_1|" to the |ch7_place_2| using the OSM identifier

.. rubric:: Solution

* Use the function on the ``SELECT`` statement
* The first parameter changes based on the view to be tested

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :start-after: exercise_7_11.txt

.. collapse:: Solutions

  .. literalinclude:: ../scripts/basic/chapter_7/exercise_7_11.txt

:ref:`basic/appendix:**Exercise**: 7 (**Chapter:** SQL)`

.. rubric:: Use the function

* Try the function with a combination of the interesting places:

  * |osmid_1| |place_1|
  * |osmid_2| |place_2|
  * |osmid_3| |place_3|
  * |osmid_4| |place_4|
  * |osmid_5| |place_5|
