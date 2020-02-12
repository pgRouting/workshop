..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Wikipedia Dijkstra Example
===============================================================================

pgRouting can solve easy dijkstra problems such as the example problem on wikipedia (`see top right graph
<https://en.wikipedia.org/wiki/Dijkstra%27s_algorithm>`_).

.. rubric:: Example code

.. code-block:: sql

   DROP TABLE IF EXISTS table1;
   CREATE TABLE table1 (
       id SERIAL,
       source INTEGER,
       target INTEGER,
       cost FLOAT
   );
   
   INSERT INTO table1 (source, target, cost) VALUES (1, 2, 7);
   INSERT INTO table1 (source, target, cost) VALUES (1, 3, 9);
   INSERT INTO table1 (source, target, cost) VALUES (1, 6, 14);
   INSERT INTO table1 (source, target, cost) VALUES (2, 3, 10);
   INSERT INTO table1 (source, target, cost) VALUES (2, 4, 15);
   INSERT INTO table1 (source, target, cost) VALUES (3, 6, 2);
   INSERT INTO table1 (source, target, cost) VALUES (3, 4, 11);
   INSERT INTO table1 (source, target, cost) VALUES (4, 5, 6);
   INSERT INTO table1 (source, target, cost) VALUES (5, 6, 9);
   
   SELECT * FROM pgr_dijkstra(
       'SELECT id, source, target, cost FROM table1',
       1, 5, false);

Running this code gives the following output, which is the shortest weighted path from point 1 to 5.

.. code-block:: sql

    seq | path_seq | node | edge | cost | agg_cost 
   -----+----------+------+------+------+----------
      1 |        1 |    1 |    2 |    9 |        0
      2 |        2 |    3 |    6 |    2 |        9
      3 |        3 |    6 |    9 |    9 |       11
      4 |        4 |    5 |   -1 |    0 |       20
   (4 rows)