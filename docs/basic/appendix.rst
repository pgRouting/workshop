..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Appendix: Basic workshop solutions
===============================================================================


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
