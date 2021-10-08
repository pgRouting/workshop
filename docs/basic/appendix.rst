..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Appendix: Basic workshop solutions 
===============================================================================

Solutions to :ref:`Pedestrian routing`
-------------------------------------------------------------------------------


Query results for chapter 5 exercise 1
.......................................

:ref:`Exercise 1: Single pedestrian routing`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_1.txt


Query results for chapter 5 exercise 2
.......................................

:ref:`Exercise 2: Many Pedestrians going to the same destination`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_2.txt


Query results for chapter 5 exercise 3
.......................................

:ref:`Exercise 3: Many Pedestrians departing from the same location`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_3.txt


Query results for chapter 5 exercise 4
.......................................

:ref:`Exercise 4: Many Pedestrians going to different destinations`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_4.txt


Query results for chapter 5 exercise 5
.......................................

:ref:`Exercise 5: Many Pedestrians going to different destinations returning aggregate costs`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_5.txt


Query results for chapter 5 exercise 6
.......................................

:ref:`Exercise 6: Many Pedestrians going to different destinations summarizing the total costs per departure`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_6.txt

Solutions to :ref:`Vehicle routing`
-------------------------------------------------------------------------------


Query results for chapter 6 exercise 1
.......................................

:ref:`Exercise 1: Vehicle routing - going`

.. literalinclude:: ../scripts/basic/chapter_6/section-6.1.1.txt


Query results for chapter 6 exercise 2
.......................................

:ref:`Exercise 2: Vehicle routing - returning`

.. literalinclude:: ../scripts/basic/chapter_6/section-6.1.2.txt


Query results for chapter 6 exercise 3
.......................................

:ref:`Exercise 3: Vehicle routing when time is money`

.. literalinclude:: ../scripts/basic/chapter_6/section-6.1.3.txt


Query results for chapter 6 exercise 4
.......................................

:ref:`Exercise 4: Vehicle routing without penalization`

.. literalinclude:: ../scripts/basic/chapter_6/section-6.2.1.txt


Query results for chapter 6 exercise 5
.......................................

:ref:`Exercise 5: Vehicle routing with penalization`

.. literalinclude:: ../scripts/basic/chapter_6/section-6.2.2-2.txt



Solutions to :ref:`SQL function`
-------------------------------------------------------------------------------


Query results for chapter 7 exercise 1
...............................................................................

:ref:`Exercise 1: Creating a view for routing`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_1.txt


Query results for chapter 7 exercise 2
...............................................................................

:ref:`Exercise 2: Limiting the road network within an area`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_2.txt

Query results for chapter 7 exercise 3
...............................................................................

:ref:`Exercise 3: Creating a materialized view for routing`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_3.txt


Query results for chapter 7 exercise 4
...............................................................................

:ref:`Exercise 4: Testing the views for routing`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_4.txt



Query results for chapter 7 exercise 5
...............................................................................

:ref:`Exercise 5: Get additional information`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_5.txt


Query results for chapter 7 exercise 6
...............................................................................

:ref:`Exercise 6: Route geometry (human readable)`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_6.txt


Query results for chapter 7 exercise 7
...............................................................................

:ref:`Exercise 7: Route geometry (binary format)`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_7.txt


Query results for chapter 7 exercise 8
...............................................................................

:ref:`Exercise 8: Route geometry directionality`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_8.txt


Query results for chapter 7 exercise 9
...............................................................................

:ref:`Exercise 9: Using the geometry`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_9.txt


Query results for chapter 7 exercise 10
...............................................................................

:ref:`Exercise 10: Function for an application`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_10.txt

Query results for chapter 7 exercise 11
...............................................................................

:ref:`Exercise 11: Using the function`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_11.txt


Solutions to :ref:`pl/pgsql function`
-------------------------------------------------------------------------------

Query results for chapter 8 exercise 1
...............................................................................

:ref:`Exercise 1: Number of Vertices`

For ``ways_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_1_1.txt

For ``vehicle_net``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_1_2.txt

For ``taxi_net``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_1_3.txt

For ``walk_net``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_1_4.txt

Query results for chapter 8 exercise 2
...............................................................................

:ref:`Exercise 2: Vertices on a table`

For ``vehicle_net``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_2_1.txt

For ``taxi_net``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_2_2.txt

For ``walk_net``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_2_3.txt


Query results for chapter 8 exercise 3
...............................................................................

:ref:`Exercise 3: Nearest Vertex`

For ``ways_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_3_1.txt

For ``vehicle_net_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_3_2.txt

For ``taxi_net_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_3_3.txt

For ``walk_net_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_3_4.txt


Query results for chapter 8 exercise 4
...............................................................................

:ref:`Exercise 4: Nearest vertex function`

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_4.txt

Query results for chapter 8 exercise 5
...............................................................................

:ref:`Exercise 5: Test nearest vertex function`

For ``ways_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_5_1.txt

For ``vehicle_net_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_5_2.txt

For ``taxi_net_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_5_3.txt

For ``walk_net_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_5_4.txt


Query results for chapter 8 exercise 6
...............................................................................

:ref:`Exercise 6: Creating the main function`

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_6.txt

Query results for chapter 8 exercise 7
...............................................................................

:ref:`Exercise 7: Using the main function`

For ``vehicle_net``

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_7_1.txt

For ``taxi_net``

* The ``WARNING`` message:

.. literalinclude:: ../scripts/basic/chapter_8/warnings.txt
  :start-after: WARNING

* The query results:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_7_2.txt

For ``walk_net``

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_7_3.txt

