..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Internet Examples
===============================================================================

.. rubric:: Hanoslav Example

pgRouting can solve the example problem like the one shown down below (`picture from hanoslav.net <http://hansolav.net/sql/graphs.html>`_)

.. image:: /images/hanosiav_example.png
  :width: 300pt
  :align: center
  

.. code-block:: sql

   SET client_min_messages TO WARNING;
   
   DROP TABLE IF EXISTS table1_vertices;
   CREATE TABLE table1_vertices (
       vid SERIAL PRIMARY KEY,
       name TEXT
   );
   
   DROP TABLE IF EXISTS table1;
   CREATE TABLE table1 (
       id SERIAL,
       source INTEGER REFERENCES table1_vertices(vid),
       target INTEGER REFERENCES table1_vertices(vid),
       cost FLOAT
   );
   
   INSERT INTO table1_vertices (name) VALUES ('Seatle');
   INSERT INTO table1_vertices (name) VALUES ('San Francisco');
   INSERT INTO table1_vertices (name) VALUES ('Las Vegas');
   INSERT INTO table1_vertices (name) VALUES ('Los Angeles');
   INSERT INTO table1_vertices (name) VALUES ('Denver');
   INSERT INTO table1_vertices (name) VALUES ('Minneapolis');
   INSERT INTO table1_vertices (name) VALUES ('Dallas');
   INSERT INTO table1_vertices (name) VALUES ('Chicago');
   INSERT INTO table1_vertices (name) VALUES ('Washington D.C.');
   INSERT INTO table1_vertices (name) VALUES ('Boston');
   INSERT INTO table1_vertices (name) VALUES ('Nueva York');
   INSERT INTO table1_vertices (name) VALUES ('Miami');
   
   INSERT INTO table1 (source, target, cost) VALUES ( 1,  2, 1306);
   INSERT INTO table1 (source, target, cost) VALUES ( 1,  5, 2161);
   INSERT INTO table1 (source, target, cost) VALUES ( 1,  6, 2661);
   INSERT INTO table1 (source, target, cost) VALUES ( 2,  3,  919);
   INSERT INTO table1 (source, target, cost) VALUES ( 2,  4,  629);
   INSERT INTO table1 (source, target, cost) VALUES ( 3,  4,  435);
   INSERT INTO table1 (source, target, cost) VALUES ( 3,  5, 1225);
   INSERT INTO table1 (source, target, cost) VALUES ( 3,  7, 1983);
   INSERT INTO table1 (source, target, cost) VALUES ( 5,  6, 1483);
   INSERT INTO table1 (source, target, cost) VALUES ( 5,  7, 1258);
   INSERT INTO table1 (source, target, cost) VALUES ( 6,  7, 1532);
   INSERT INTO table1 (source, target, cost) VALUES ( 6,  8,  661);
   INSERT INTO table1 (source, target, cost) VALUES ( 7,  9, 2113);
   INSERT INTO table1 (source, target, cost) VALUES ( 7, 12, 2161);
   INSERT INTO table1 (source, target, cost) VALUES ( 8,  9, 1145);
   INSERT INTO table1 (source, target, cost) VALUES ( 8, 10, 1613);
   INSERT INTO table1 (source, target, cost) VALUES ( 9, 10,  725);
   INSERT INTO table1 (source, target, cost) VALUES ( 9, 11,  383);
   INSERT INTO table1 (source, target, cost) VALUES ( 9, 12, 1709);
   INSERT INTO table1 (source, target, cost) VALUES (10, 11,  338);
   INSERT INTO table1 (source, target, cost) VALUES (11, 12, 2145);
   
   SET client_min_messages TO NOTICE;
   
   -- Their output starts with 0 so we subtract 1 to the vid
   -- pgrouting: no paths or 0 length (aka I am there, so no path) are not included
   SELECT  name, cost, agg_cost  FROM pgr_dijkstra(
       'SELECT id, source, target, cost FROM table1',
       1,  6, true)
       JOIN table1_vertices ON (node = vid) ORDER BY seq;
   
   SELECT  name, cost, agg_cost  FROM pgr_dijkstra(
       'SELECT id, source, target, cost FROM table1',
       1,  11, true)
       JOIN table1_vertices ON (node = vid) ORDER BY seq;
   
   select end_vid, array_to_string( array_agg(name ORDER BY seq),','), array_agg(node ORDER BY seq) 
   FROM pgr_dijkstra(
       'SELECT id, source, target, cost FROM table1',
       1,  ARRAY[1, 2, 3, 4, 5, 6, 7, 8, 9, 10, 11, 12], true)
   JOIN table1_vertices ON (node = vid) GROUP BY end_vid; 

The following code outputs the table down below.

::

   end_vid  |                    array_to_string                    |  array_agg   
   ---------+-------------------------------------------------------+--------------
          2 | Seatle,San Francisco                                  | {1,2}
          3 | Seatle,San Francisco,Las Vegas                        | {1,2,3}
          4 | Seatle,San Francisco,Los Angeles                      | {1,2,4}
          5 | Seatle,Denver                                         | {1,5}
          6 | Seatle,Minneapolis                                    | {1,6}
          7 | Seatle,Denver,Dallas                                  | {1,5,7}
          8 | Seatle,Minneapolis,Chicago                            | {1,6,8}
          9 | Seatle,Minneapolis,Chicago,Washington D.C.            | {1,6,8,9}
         10 | Seatle,Minneapolis,Chicago,Boston                     | {1,6,8,10}
         11 | Seatle,Minneapolis,Chicago,Washington D.C.,Nueva York | {1,6,8,9,11}
         12 | Seatle,Denver,Dallas,Miami                            | {1,5,7,12}
   (11 rows)
   
.. rubric:: Boost Dijkstra Example

Using, pgRouting you can translate `C++ dijkstra code <http://www.boost.org/doc/libs/1_59_0/libs/graph/example/dijkstra-example.cpp>`_ into SQL commands.

.. rubric:: Boost Code

.. code-block:: cpp

  const int num_nodes = 5;
  enum nodes { A, B, C, D, E }; = 1
  char name[] = "ABCDE";
  Edge edge_array[] = { Edge(A, C), Edge(B, B), Edge(B, D), Edge(B, E),
    Edge(C, B), Edge(C, D), Edge(D, E), Edge(E, A), Edge(E, B)
  };
  int weights[] = { 1, 2, 1, 2, 7, 3, 1, 1, 1 };

Here is the tranlasted SQL commands.

.. rubric:: Translated Code

.. code-block:: sql
   
   DROP TABLE IF EXISTS table1;
   CREATE TABLE table1 (
       id SERIAL,
       source INTEGER,
       target INTEGER,
       source_name TEXT,
       target_name TEXT,
       cost FLOAT
   );
   DROP TABLE IF EXISTS table1_vertices;
   CREATE TABLE table1_vertices (
       vid SERIAL,
       name TEXT
   );
   
   INSERT INTO table1_vertices (name) VALUES ('A');
   INSERT INTO table1_vertices (name) VALUES ('B');
   INSERT INTO table1_vertices (name) VALUES ('C');
   INSERT INTO table1_vertices (name) VALUES ('D');
   INSERT INTO table1_vertices (name) VALUES ('E');
   
   INSERT INTO table1 (source_name, target_name, cost) VALUES ('A', 'C', 1);
   INSERT INTO table1 (source_name, target_name, cost) VALUES ('B', 'B', 2);
   INSERT INTO table1 (source_name, target_name, cost) VALUES ('B', 'D', 1);
   INSERT INTO table1 (source_name, target_name, cost) VALUES ('B', 'E', 2);
   INSERT INTO table1 (source_name, target_name, cost) VALUES ('C', 'B', 7);
   INSERT INTO table1 (source_name, target_name, cost) VALUES ('C', 'D', 3);
   INSERT INTO table1 (source_name, target_name, cost) VALUES ('D', 'E', 1);
   INSERT INTO table1 (source_name, target_name, cost) VALUES ('E', 'A', 1);
   INSERT INTO table1 (source_name, target_name, cost) VALUES ('E', 'B', 1);
   
   UPDATE table1 
     SET source = table1_vertices.vid
   FROM table1_vertices
   WHERE source_name = name;
   
   UPDATE table1 SET target = table1_vertices.vid
   FROM table1_vertices
   WHERE target_name = name;
   
   -- Their output starts with 0 so we subtract 1 to the vid
   -- pgrouting: no paths or 0 length (aka I am there, so no path) are not included
   SELECT end_vid-1, agg_cost FROM pgr_dijkstra(
       'SELECT id, source, target, cost FROM table1',
   1, ARRAY[1, 2, 3, 4, 5], true) where edge < 0 order by end_vid;

Output from running the following SQL command:

.. rubric:: Output

.. code-block:: sql

   ?column?  | agg_cost 
   ----------+----------
           1 |        6
           2 |        1
           3 |        4
           4 |        5
   (4 rows)