..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Appendix: Basic workshop solutions
===============================================================================

Solutions to :doc:`pedestrian`
-------------------------------------------------------------------------------

**Exercise**: 1 (**Chapter:** Pedestrian)
...............................................................................

:ref:`basic/pedestrian:Exercise 1: Single pedestrian routing`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_1.txt


**Exercise**: 2 (**Chapter:** Pedestrian)
...............................................................................

:ref:`basic/pedestrian:Exercise 2: Many Pedestrians going to the same destination`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_2.txt


**Exercise**: 3 (**Chapter:** Pedestrian)
...............................................................................

:ref:`basic/pedestrian:Exercise 3: Many Pedestrians departing from the same location`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_3.txt


**Exercise**: 4 (**Chapter:** Pedestrian)
...............................................................................

:ref:`basic/pedestrian:Exercise 4: Many Pedestrians going to different destinations`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_4.txt


**Exercise**: 5 (**Chapter:** Pedestrian)
...............................................................................

:ref:`basic/pedestrian:Exercise 5: Combination of routes`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_5.txt


**Exercise**: 6 (**Chapter:** Pedestrian)
...............................................................................

:ref:`basic/pedestrian:Exercise 6: Time for many Pedestrians going to different destinations`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_6.txt


**Exercise**: 7 (**Chapter:** Pedestrian)
...............................................................................

:ref:`basic/pedestrian:Exercise 7: Many Pedestrians going to different destinations summarizing the total costs per departure`

.. literalinclude:: ../scripts/basic/chapter_5/exercise_5_7.txt


Solutions to :doc:`vehicle`
-------------------------------------------------------------------------------

**Exercise**: 1 (**Chapter:** Vehicle)
...............................................................................

:ref:`basic/vehicle:Exercise 1: Vehicle routing - going`

.. literalinclude:: ../scripts/basic/chapter_6/section-6.1.1.txt


**Exercise**: 2 (**Chapter:** Vehicle)
...............................................................................

:ref:`basic/vehicle:Exercise 2: Vehicle routing - returning`

.. literalinclude:: ../scripts/basic/chapter_6/section-6.1.2.txt


**Exercise**: 3 (**Chapter:** Vehicle)
...............................................................................

:ref:`basic/vehicle:Exercise 3: Vehicle routing when time is money`

.. literalinclude:: ../scripts/basic/chapter_6/section-6.1.3.txt


**Exercise**: 4 (**Chapter:** Vehicle)
...............................................................................

:ref:`basic/vehicle:Exercise 4: Vehicle routing without penalization`

.. literalinclude:: ../scripts/basic/chapter_6/section-6.2.1.txt


**Exercise**: 5 (**Chapter:** Vehicle)
...............................................................................

:ref:`basic/vehicle:Exercise 5: Vehicle routing with penalization`

.. literalinclude:: ../scripts/basic/chapter_6/section-6.2.2-2.txt


**Exercise**: 6 (**Chapter:** Vehicle)
...............................................................................

:ref:`basic/vehicle:Exercise 6: Time in seconds of penalized route`

.. literalinclude:: ../scripts/basic/chapter_6/section-6.6.txt


Solutions to :doc:`sql_function`
-------------------------------------------------------------------------------

**Exercise**: 1 (**Chapter:** SQL)
...............................................................................

:ref:`basic/sql_function:Exercise 1: Get additional information`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_5.txt


**Exercise**: 2 (**Chapter:** SQL)
...............................................................................

:ref:`basic/sql_function:Exercise 2: Route geometry (human readable)`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_6.txt


**Exercise**: 3 (**Chapter:** SQL)
...............................................................................

:ref:`basic/sql_function:Exercise 3: Route geometry (binary format)`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_7.txt


**Exercise**: 4 (**Chapter:** SQL)
...............................................................................

:ref:`basic/sql_function:Exercise 4: Route geometry directionality`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_8.txt


**Exercise**: 5 (**Chapter:** SQL)
...............................................................................

:ref:`basic/sql_function:Exercise 5: Using the geometry`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_9.txt


**Exercise**: 6 (**Chapter:** SQL)
...............................................................................

:ref:`basic/sql_function:Exercise 6: Function for an application`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_10.txt

**Exercise**: 7 (**Chapter:** SQL)
...............................................................................

:ref:`basic/sql_function:Exercise 7: Using the function`

.. literalinclude:: ../scripts/basic/chapter_7/exercise_7_11.txt


Solutions to :doc:`plpgsql_function`
-------------------------------------------------------------------------------

**Exercise**: 1 (**Chapter:** pl/pgsql)
...............................................................................

:ref:`basic/plpgsql_function:Exercise 1: Number of Vertices`

For ``ways_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_1_1.txt

For ``vehicle_net``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_1_2.txt

For ``taxi_net``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_1_3.txt

For ``walk_net``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_1_4.txt

**Exercise**: 2 (**Chapter:** pl/pgsql)
...............................................................................

:ref:`basic/plpgsql_function:Exercise 2: Vertices on a table`

For ``vehicle_net``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_2_1.txt

For ``taxi_net``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_2_2.txt

For ``walk_net``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_2_3.txt


**Exercise**: 3 (**Chapter:** pl/pgsql)
...............................................................................

:ref:`basic/plpgsql_function:Exercise 3: Nearest Vertex`

For ``ways_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_3_1.txt

For ``vehicle_net_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_3_2.txt

For ``taxi_net_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_3_3.txt

For ``walk_net_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_3_4.txt


**Exercise**: 4 (**Chapter:** pl/pgsql)
...............................................................................

:ref:`basic/plpgsql_function:Exercise 4: Nearest vertex function`

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_4.txt

**Exercise**: 5 (**Chapter:** pl/pgsql)
...............................................................................

:ref:`basic/plpgsql_function:Exercise 5: Test nearest vertex function`

For ``ways_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_5_1.txt

For ``vehicle_net_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_5_2.txt

For ``taxi_net_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_5_3.txt

For ``walk_net_vertices_pgr``:

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_5_4.txt


**Exercise**: 6 (**Chapter:** pl/pgsql)
...............................................................................

:ref:`basic/plpgsql_function:Exercise 6: Creating the main function`

.. literalinclude:: ../scripts/basic/chapter_8/exercise_8_6.txt

**Exercise**: 7 (**Chapter:** pl/pgsql)
...............................................................................

:ref:`basic/plpgsql_function:Exercise 7: Using the main function`

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
