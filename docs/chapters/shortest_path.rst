.. 
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _routing:

pgRouting Algorithms
===============================================================================

pgRouting was first called *pgDijkstra*, because it implemented only shortest path search with *Dijkstra* algorithm. Later other functions were added and the library was renamed.

.. image:: images/route.png
    :width: 250pt
    :align: center
    
This chapter will explain selected pgRouting algorithms and which attributes are required. 


.. note::

    If you run :doc:`osm2pgrouting <osm2pgrouting>` tool to import *OpenStreetMap* data, the ``ways`` table contains all attributes already to run all shortest path functions. The ``ways`` table of the ``pgrouting-workshop`` database of the :doc:`previous chapter <topology>` is missing several attributes instead, which are listed as **Prerequisites** in this chapter.


.. _dijkstra:

Shortest Path Dijkstra
-------------------------------------------------------------------------------

Dijkstra algorithm was the first algorithm implemented in pgRouting. It doesn't require other attributes than ``source`` and ``target`` ID, ``id`` attribute and ``cost``. It can distinguish between `directed <http://en.wikipedia.org/wiki/Directed_graph>`_ and undirected graphs. You can specify if your network has ``reverse cost`` or not.

.. rubric:: Prerequisites

To be able to use ``reverse cost`` you need to add an additional cost column. We can set reverse cost as length.

.. code-block:: sql

    ALTER TABLE ways ADD COLUMN reverse_cost double precision;
    UPDATE ways SET reverse_cost = length;

.. rubric:: Descritpion

Returns a set of (seq, path_seq, node, edge, cost, agg_cost) that make up the path
or EMPTY SET when no path was found

.. code-block:: sql

    pgr_dijkstra(edges_sql, start_vid, end_vid, directed);


.. rubric:: Parameters

:edges_sql: a SQL query, which should return a set of rows with the following columns:

    .. code-block:: sql

        SELECT id, source, target, cost [,reverse_cost] FROM edge_table


    :id: ``ANY-INTEGER`` Identifier of the edge
    :source: ``ANY-INTEGER`` Identifier of the source vertex
    :target: ``ANY-INTEGER`` Identifier of the target vertex
    :cost: ``ANY-NUMERICAL`` Cost value of traversing from ``source`` to ``target``. A negative cost will prevent the edge ``(source, target)`` from being inserted in the graph.
    :reverse_cost: ``ANY-NUMERICAL`` (optional) Cost value of traversing from ``target`` to ``source``. A negative cost will prevent the edge ``(target, source)`` from being inserted in the graph.

:start_vid: ``ANY-INTEGER`` Identifier of the start vertex.
:end_vid: ``ANY-INTEGER`` Identifier of the end vertex.
:directed: ``BOOLEAN`` When ``true`` the graph is directed and is the *default*, when ``false`` is undirected.

Returns set of ``(seq, path_seq, node, edge, cost, agg_cost)``:

============== ========== =================================================
Column         Type       Description
============== ========== =================================================
**seq**        ``INT``    Sequential value starting from **1**.
**path_seq**   ``INT``    Relative position in the path. Has value **1** for the begining of a path.
**node**       ``BIGINT`` Identifier of the node in the path.
**edge**       ``BIGINT`` Identifier of the edge used to go from ``node`` to the next node in the path sequence. ``-1`` for the last node of the path.
**cost**       ``FLOAT8`` Cost to traverse from ``node`` using ``edge`` to the next node in the path sequence.
**agg_cost**   ``FLOAT8`` Aggregate cost from ``source`` to ``node``.
============== ========== =================================================


Where:

:ANY-INTEGER: SMALLINT, INTEGER, BIGINT
:ANY-NUMERICAL: SMALLINT, INTEGER, BIGINT, REAL, FLOAT


.. note::

    * Many pgRouting functions have ``sql::text`` as one of their arguments. While this may look confusing at first, it makes the functions very flexible as the user can pass any ``SELECT`` statement as function argument as long as the returned result contains the required number of attributes and the correct attribute names. 
    * Dijkstra algorithm does not require the network geometry.
    * The function does not return a geometry, but only an ordered list of nodes.

.. rubric:: Example query

.. code-block:: sql

   SELECT * from pgr_dijkstra('
        SELECT gid as id,
               source, target,
               length as cost from ways',
        29450, 20712, false);


.. rubric:: Query result

.. code-block:: sql

     seq | path_seq | node  | edge  |         cost         |      agg_cost       
    -----+----------+-------+-------+----------------------+---------------------
       1 |        1 | 29450 | 33792 |  0.00177810584893137 |                   0
       2 |        2 | 38472 | 57954 |  0.00179225967147818 | 0.00177810584893137
       3 |        3 | 15637 | 42749 | 0.000102092605022171 | 0.00357036552040955
       4 |        4 | 56395 | 33059 | 8.66225143958747e-05 | 0.00367245812543172
       5 |        5 | 21827 |  9206 |  0.00047705096163826 |  0.0037590806398276
       6 |        6 | 42745 | 40394 | 0.000513853140499986 | 0.00423613160146586
       7 |        7 | 17028 | 11512 | 9.12382595170489e-05 | 0.00474998474196585
       8 |        8 | 27124 | 40395 | 9.71560600269149e-05 | 0.00484122300148289
       9 |        9 | 51983 | 11513 | 0.000120258430056735 | 0.00493837906150981
      10 |       10 | 53769 | 59629 |  0.00102611053011065 | 0.00505863749156655
      11 |       11 | 20712 |    -1 |                    0 | 0.00608474802167719
    (11 rows)

.. note::
    
    * With more complex SQL statements, using JOINs for example, the result may be in a wrong order. In that case ``ORDER BY seq`` will ensure that the path is in the right order again.
    * The returned cost attribute represents the cost specified in the ``edges_sql::text`` argument. In this example cost is ``length`` in unit "degrees". Cost may be time, distance or any combination of both or any other attributes or a custom formula.

.. _astar:

Shortest Path A*
-------------------------------------------------------------------------------

A-Star algorithm is another well-known routing algorithm. It adds geographical information to source and target of each network link. This enables the routing query to prefer links which are closer to the target of the shortest path search.

.. rubric:: Prerequisites

For A-Star you need to prepare your network table and add latitute/longitude columns (``x1``, ``y1`` and ``x2``, ``y2``) and calculate their values.

.. code-block:: sql

    ALTER TABLE ways ADD COLUMN x1 double precision;
    ALTER TABLE ways ADD COLUMN y1 double precision;
    ALTER TABLE ways ADD COLUMN x2 double precision;
    ALTER TABLE ways ADD COLUMN y2 double precision;

    UPDATE ways SET x1 = ST_x(ST_PointN(the_geom, 1));
    UPDATE ways SET y1 = ST_y(ST_PointN(the_geom, 1));
    
    UPDATE ways SET x2 = ST_x(ST_PointN(the_geom, ST_NumPoints(the_geom)));
    UPDATE ways SET y2 = ST_y(ST_PointN(the_geom, ST_NumPoints(the_geom)));

.. Note::

    * A bug in a previous version of PostGIS didn't allow the use of ``ST_startpoint`` or ``ST_endpoint``.
    * From PostGIS 2.x ``ST_startpoint`` and ``ST_endpoint`` are only valid for ``LINESTRING`` geometry type and will fail with ``MULTILINESTING``.

    Therefor a slightly more difficult looking query is used.
    If the network data really contains multi-geomtery linestrings the query might give the wrong start and end point. But in general data has been imported as ``MULTILINESTING`` even if it only contains ``LINESTRING`` geometries.


.. rubric:: Description

Shortest Path A-Star function is very similar to the Dijkstra function, though it prefers links that are close to the target of the search. The heuristics of this search are predefined, so you need to recompile pgRouting if you want to make changes to the heuristic function itself.

Returns a set of ``pgr_costResult`` (seq, id1, id2, cost) rows, that make up a path.

.. code-block:: sql

    pgr_costResult[] pgr_astar(sql text, source integer, target integer, directed boolean, has_rcost boolean);


.. rubric:: Parameters

:sql: a SQL query, which should return a set of rows with the following columns:

    .. code-block:: sql

        SELECT id, source, target, cost, x1, y1, x2, y2 [,reverse_cost] FROM edge_table


    :id: ``int4`` identifier of the edge
    :source: ``int4`` identifier of the source vertex
    :target: ``int4`` identifier of the target vertex
    :cost: ``float8`` value, of the edge traversal cost. A negative cost will prevent the edge from being inserted in the graph.
    :x1: ``x`` coordinate of the start point of the edge
    :y1: ``y`` coordinate of the start point of the edge
    :x2: ``x`` coordinate of the end point of the edge
    :y2: ``y`` coordinate of the end point of the edge
    :reverse_cost: (optional) the cost for the reverse traversal of the edge. This is only used when the ``directed`` and ``has_rcost`` parameters are ``true`` (see the above remark about negative costs).

:source: ``int4`` id of the start point
:target: ``int4`` id of the end point
:directed: ``true`` if the graph is directed
:has_rcost: if ``true``, the ``reverse_cost`` column of the SQL generated set of rows will be used for the cost of the traversal of the edge in the opposite direction.

Returns set of ``pgr_costResult``:

:seq:   row sequence
:id1:   node ID
:id2:   edge ID (``-1`` for the last row)
:cost:  cost to traverse from ``id1`` using ``id2``




.. rubric:: Example query

.. code-block:: sql

    SELECT seq, id1 AS node, id2 AS edge, cost FROM pgr_astar('
            SELECT gid AS id, 
                 source::integer, 
                 target::integer, 
                 length::double precision AS cost, 
                 x1, y1, x2, y2
                FROM ways', 
             29450, 20712, false, false); 
        

.. rubric:: Query result

.. code-block:: sql
        
     seq | node  | edge  |         cost
    -----+-------+-------+----------------------
       0 | 29450 | 33792 |  0.00177810584893137
       1 | 38472 | 57954 |  0.00179225967147818
       2 | 15637 | 42749 | 0.000102092605022171
       3 | 56395 | 33059 | 8.66225143958747e-05
       4 | 21827 |  9206 |  0.00047705096163826
       5 | 42745 | 40394 | 0.000513853140499986
       6 | 17028 | 11512 | 9.12382595170489e-05
       7 | 27124 | 40395 | 9.71560600269149e-05
       8 | 51983 | 11513 | 0.000120258430056735
       9 | 53769 | 59629 |  0.00102611053011065
      10 | 20712 |    -1 |                    0
    (11 rows)

.. note::

    * The result of Dijkstra and A-Star are the same, which should be the case.
    * A-Star is supposed to be faster than Dijkstra algorithm as the network size is getting larger. But in case of pgRouting the algorithm speed advantage does not matter really compared the time required to select the network data and build the graph. 


.. _kdijkstra:

Multiple Shortest Paths with Dijkstra
-------------------------------------------------------------------------------

The Dijkstra has a family of functions are very similar to the Dijkstra function from a single starting vertex to a single target vertex, but they allow to set multiple departures ``start_vids`` and/or multiple destinations ``end_vids`` with a single function call.

.. rubric:: Prerequisites

Dijkstra doesn't require additional attributes to Dijkstra algorithm.


.. rubric:: Description

If the main goal is to calculate the total cost, for example to calculate multiple routes for a distance matrix, then ``pgr_dijkstraCost`` returns a more compact result. 
In case the paths are important ``pgr_dijkstra`` function returns a result similar to Dijkstra for each ``start_vid``,  ``end_vid`` pair.

.. rubric:: pgr_dijkstra

.. code-block:: sql

    pgr_dijkstra(edges_sql, start_vid,  end_vid,  directed)
    pgr_dijkstra(edges_sql, start_vid,  end_vids, directed)
    pgr_dijkstra(edges_sql, start_vids, end_vid,  directed)
    pgr_dijkstra(edges_sql, start_vids, end_vids, directed)

    RETURNS SET OF (seq, path_seq [, start_vid] [, end_vid], node, edge, cost, agg_cost)
        OR EMPTY SET

.. rubric:: pgr_dijkstraCost
    
.. code-block:: sql

    pgr_dijkstraCost(edges_sql, start_vid, end_vid, directed);
    pgr_dijkstraCost(edges_sql, start_vids, end_vid, directed);
    pgr_dijkstraCost(edges_sql, start_vid, end_vids, directed);
    pgr_dijkstraCost(edges_sql, start_vids, end_vids, directed);

    RETURNS SET OF (start_vid, end_vid, agg_cost) or EMPTY SET



.. rubric:: Parameters

:edges_sql: a SQL query, which should return a set of rows with the following columns:

    .. code-block:: sql

        SELECT id, source, target, cost [,reverse_cost] FROM edge_table


    :id: ``ANY-INTEGER`` Identifier of the edge
    :source: ``ANY-INTEGER`` Identifier of the source vertex
    :target: ``ANY-INTEGER`` Identifier of the target vertex
    :cost: ``ANY-NUMERICAL`` Cost value of traversing from ``source`` to ``target``. A negative cost will prevent the edge ``(source, target)`` from being inserted in the graph.
    :reverse_cost: ``ANY-NUMERICAL`` (optional) Cost value of traversing from ``target`` to ``source``. A negative cost will prevent the edge ``(target, source)`` from being inserted in the graph.

:start_vid:     ``ANY-INTEGER``             Identifier of the starting vertex of the path.
:end_vid:       ``ANY-INTEGER``             Identifier of the ending vertex of the path.
:start_vids:    ``array[ANY-INTEGER]`` Array of identifiers of starting vertices.
:end_vids:      ``array[ANY-INTEGER]`` Array of identifiers of ending vertices.
:directed: ``BOOLEAN`` When ``true`` the graph is directed and is the *default*, when ``false`` is undirected.


``pgr_dijkstraCost`` returns set of ``(start_vid, end_vid, agg_cost)``

============= ============= =================================================
Column        Type          Description
============= ============= =================================================
**start_vid** ``BIGINT``    Identifier of the starting vertex.
**end_vid**   ``BIGINT``    Identifier of the ending vertex.
**agg_cost**  ``FLOAT``     Aggregate cost of the shortest path from ``start_vid`` to ``end_vid``.
============= ============= =================================================

.. note:: Row ``(u,v)`` will not exist when there is no path from ``u`` to ``v``.



``pgr_dijkstra`` returns set of ``(seq, path_seq [, start_vid] [, end_vid], node, edge, cost, agg_cost)``

============== ========== =================================================
Column         Type       Description
============== ========== =================================================
**seq**        ``INT``    Sequential value starting from **1**.
**path_seq**   ``INT``    Relative position in the path. Has value **1** for the begining of a path.
**start_vid**  ``BIGINT`` Identifier of the starting vertex. Used when multiple starting vetrices are in the query.
**end_vid**    ``BIGINT`` Identifier of the ending vertex. Used when multiple ending vertices are in the query.
**node**       ``BIGINT`` Identifier of the node in the path from ``start_vid`` to ``end_vid``.
**edge**       ``BIGINT`` Identifier of the edge used to go from ``node`` to the next node in the path sequence. ``-1`` for the last node of the path.
**cost**       ``FLOAT8``  Cost to traverse from ``node`` using ``edge`` to the next node in the path sequence.
**agg_cost**   ``FLOAT8``  Aggregate cost from ``start_v`` to ``node``.
============== ========== =================================================

.. note:: depending on the function call columns ``start_vid`` and ``end_vid`` will be returned or not.

.. note::  Rows belonging to ``(u,v)`` combination will not exist when there is no path from ``u`` to ``v``.

For the following example the cost is length in meters.

.. rubric:: Example query ``pgr_kdijkstraCost``

.. code-block:: sql

    SELECT * from pgr_dijkstraCost('
        SELECT gid as id,
               source, target,
               length_m as cost from ways',
        29450, ARRAY[20712, 8418, 1293], false);


.. rubric:: Query result

.. code-block:: sql
        
     start_vid | end_vid |      agg_cost       
    -----------+---------+---------------------
         29450 |    1293 | 1556.54686142379
         29450 |    8418 | 2491.75714906812
         29450 |   20712 | 517.909080191137
    (2 rows)


.. rubric:: Example query ``pgr_kdijkstra``

.. code-block:: sql

    SELECT * from pgr_dijkstra('
        SELECT gid as id,
               source, target,
               length_m as cost from ways',
        29450, ARRAY[20712, 8418, 1293], false);

.. rubric:: Query result

.. code-block:: sql
        
     seq | path_seq | end_vid | node  | edge  |       cost       |     agg_cost     
    -----+----------+---------+-------+-------+------------------+------------------
       1 |        1 |    1293 | 29450 | 23464 | 44.5745770966455 |                0
       2 |        2 |    1293 | 15299 | 18667 | 53.3042387365226 | 44.5745770966455
    ...
      33 |       33 |    1293 | 14270 | 60149 |  122.73055200169 |  1433.8163094221
      34 |       34 |    1293 |  1293 |    -1 |                0 | 1556.54686142379
      35 |        1 |    8418 | 29450 | 23464 | 44.5745770966455 |                0
      36 |        2 |    8418 | 15299 | 18667 | 53.3042387365226 | 44.5745770966455
    ...
     103 |       69 |    8418 | 18887 | 69419 | 60.3483603978306 | 2431.40878867029
     104 |       70 |    8418 |  8418 |    -1 |                0 | 2491.75714906812
     105 |        1 |   20712 | 29450 | 33792 | 159.384330206319 |                0
     106 |        2 |   20712 | 38472 | 57954 | 141.535232985847 | 159.384330206319
    ...
     114 |       10 |   20712 | 53769 | 59629 | 87.8579034765522 | 430.051176714584
     115 |       11 |   20712 | 20712 |    -1 |                0 | 517.909080191137
    (115 rows)



There are many other functions available with the new pgRouting 2.0 release, but most of them work in a similar way, and it would take too much time to mention them all in this workshop. For the complete list of pgRouting functions see the API documentation: http://docs.pgrouting.org/

