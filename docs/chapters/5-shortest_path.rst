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

.. image:: images/route.png
    :width: 250pt
    :align: center

pgRouting was first called *pgDijkstra*, because it implemented only shortest path search with *Dijkstra* algorithm.
Later other functions were added and the library was renamed.

This chapter will explain selected pgRouting algorithms and which attributes are required and do some excersices.

* :ref:`dijkstra`

  * :ref:`d-1` Single Pedestrian Routing.
  * :ref:`d-2` Many Pedestrians going to the same destination.
  * :ref:`d-3`  Many Pedestrians going departing from the same location.
  * :ref:`d-4`  Many Pedestrians going to different destinations.


* :ref:`dijkstraCost`

  * :ref:`d-5`  Many Pedestrians going to different destinations interested only on the aggregate cost.

* :ref:`astar`

  * :ref:`d-6` Single Pedestrian Routing.

.. _dijkstra:

Shortest Path Dijkstra
-------------------------------------------------------------------------------

Dijkstra algorithm was the first algorithm implemented in pgRouting. It doesn't require other attributes than ``id``, ``source`` and ``target`` ID and ``cost``.
Opionally a ``reverse_cost`` attribute can be added.
You can specify when to consider the graph as `directed <http://en.wikipedia.org/wiki/Directed_graph>`_ or undirected.

.. rubric:: Signature Summary


.. code-block:: none

    pgr_dijkstra(edges_sql, start_vid,  end_vid)
    pgr_dijkstra(edges_sql, start_vid,  end_vid,  directed:=true)
    pgr_dijkstra(edges_sql, start_vid,  end_vids, directed:=true)
    pgr_dijkstra(edges_sql, start_vids, end_vid,  directed:=true)
    pgr_dijkstra(edges_sql, start_vids, end_vids, directed:=true)

    RETURNS SET OF (seq, path_seq [, start_vid] [, end_vid], node, edge, cost, agg_cost)
        OR EMPTY SET

Description of the parameters can be found in `pgr_dijkstra <http://docs.pgrouting.org/latest/en/src/dijkstra/doc/pgr_dijkstra.html#description-of-the-signatures>`_

.. note::

    * Many pgRouting functions have ``sql::text`` as one of their arguments. While this may look confusing at first, it makes the functions very flexible as the user can pass any ``SELECT`` statement as function argument as long as the returned result contains the required number of attributes and the correct attribute names.
    * Most of pgRouting implemeted algorithms do not require the network geometry.
    * Most of pgRouting functions do not return a geometry, but only an ordered list of nodes.


.. note::

    * With more complex SQL statements, using JOINs for example, the result may be in a wrong order. In that case ``ORDER BY seq`` and ``ORDER BY path_seq`` will ensure that the path(s) is/are in the correct order.
    * The returned ``cost`` and ``agg_cost`` attributes are in the units of the ``cost`` variable.

In the current data, table ``ways`` does not have any information of one way or two way segments.
In this case, we are going to consider the information for routing a pedestrian.

* A pedestrian can go both ways on any segment, therefore the graph is `undirected`

The assignment of the vertices identifiers on the source and target columns may be different, the following exercises will use the results of this query.

.. rubric:: Query

.. code-block:: sql

    SELECT source FROM ways WHERE gid in(39450, 53981,74908, 76516, 68362);

.. rubric:: Query result

.. code-block:: sql

     source 
    --------
         30
         34
         49
         60
         62
    (5 rows)   

.. _d-1:

Exercise 1
..............................................

.. rubric:: Single Pedestrian Routing.

* Pedestrian: "I am in vertex 30 and want to walk to vertex 60."

.. rubric:: Problem description 

* The pedestrian wants to go from vertex 30 to vertex 60.
* The pedestrian`s cost is in terms of length. In this case ``length`` is in degrees.

.. rubric:: Query

.. code-block:: sql

    SELECT * FROM pgr_dijkstra('
            SELECT gid AS id,
                 source,
                 target,
                 length AS cost
                FROM ways',
            30, 60, directed := false);


.. rubric:: Query result

.. code-block:: sql

     seq | path_seq | node  |  edge  |        cost         |      agg_cost      
    -----+----------+-------+--------+---------------------+--------------------
       1 |        1 |    30 |  75158 |  0.0162495088597164 |                  0
       2 |        2 | 31812 |  39448 |  0.0555108926515049 | 0.0162495088597164
       3 |        3 | 31811 |  39446 |   0.121874578369716 | 0.0717604015112213
       ...
      91 |       91 |    61 |  74908 | 0.00461841654598986 |   8.01273264755227
      92 |       92 |    60 |     -1 |                   0 |   8.01735106409826
    (92 rows)

.. note:: ``node`` results may vary depending on the assignment of the identifiers to the vertices


.. _d-2:

Exercise 2
..............................................................

.. rubric:: Many Pedestrians going to the same destination.

* Pedestrian A: "I am in vertex 30 and I am meeting my friends at vertex 60."
* Pedestrian B: "I am in vertex 34 and I am meeting my friends at vertex 60."
* Pedestrian C: "I am in vertex 62 and I am meeting my friends at vertex 60."

.. rubric:: Problem description 

* The pedestrians are located at vertices 30, 34, and 62
* Want to go to vertex 60.
* The cost to be in meters.

.. rubric:: Query 

.. code-block:: sql

    SELECT * FROM pgr_dijkstra('
            SELECT gid AS id,
                 source,
                 target,
                 ST_LENGTH(the_geom::geography) AS cost
                FROM ways',
            ARRAY[30,34,62], 60, directed := false);


.. rubric:: Query result

.. code-block:: sql

     seq | path_seq | start_vid | node  |  edge  |       cost       |     agg_cost     
    -----+----------+-----------+-------+--------+------------------+------------------
       1 |        1 |        30 |    30 |  75158 | 16.2593740656048 |                0
       2 |        2 |        30 | 31812 |  39448 | 55.5379720917542 | 16.2593740656048
    ...
      92 |       92 |        30 |    61 |  74908 | 4.61641747437376 | 8054.09022666041
      93 |       93 |        30 |    60 |     -1 |                0 | 8058.70664413478
      94 |        1 |        34 |    34 |  54683 | 4.14215286469835 |                0
      95 |        2 |        34 |  2957 |  54682 | 4.15471166138733 | 4.14215286469835
      96 |        3 |        34 | 40209 |  53970 | 10.2302680444079 | 8.29686452608568
    ...
     166 |       73 |        34 |    61 |  74908 | 4.61641747437376 | 4929.46923832009
     167 |       74 |        34 |    60 |     -1 |                0 | 4934.08565579447
     168 |        1 |        62 |    62 |  76516 | 6.50923598154284 |                0
     169 |        2 |        62 |    63 |  91449 | 97.2269409644129 | 6.50923598154284
     170 |        3 |        62 | 56015 |  91440 |   22.82401884475 | 103.736176945956
    ...
     265 |       98 |        62 | 16806 |  96334 | 11.1738950889419 | 5694.66843205915
     266 |       99 |        62 | 57393 | 103535 | 12.2131542893613 | 5705.84232714809
     267 |      100 |        62 |    60 |     -1 |                0 | 5718.05548143746
    (267 rows)

.. _d-3:

Exercise 3
.......................................................................

.. rubric:: Many Pedestrians going departing from the same location.

* Pedestrian A: "Me and my friends are at vertex 60 and I want to go to vertex 30."
* Pedestrian B: "Me and my friends are at vertex 60 and I want to go to vertex 34."
* Pedestrian C: "Me and my friends are at vertex 60 and I want to go to vertex 62."

.. rubric:: Problem description 

* The pedestrians are located at vertex 60
* The pedestrians want to go to locations 30, 34, and 62
* The cost to be in seconds.
* Use as walking speed: s = 1.3 m/s
* t = d/s

.. rubric:: Query 

.. code-block:: sql

    SELECT * FROM pgr_dijkstra('
            SELECT gid AS id,
                 source,
                 target,
                 ST_LENGTH(the_geom::geography)/1.3 AS cost
                FROM ways',
            60, ARRAY[30,34,62], directed := false);


.. rubric:: Query result

.. code-block:: sql

     seq | path_seq | end_vid | node  |  edge  |       cost       |     agg_cost     
    -----+----------+---------+-------+--------+------------------+------------------
       1 |        1 |      30 |    60 |  74908 | 3.55109036490289 |                0
       2 |        2 |      30 |    61 | 117754 | 18.5820589058328 | 3.55109036490289
       3 |        3 |      30 | 57394 | 117709 | 9.89145618541221 | 22.1331492707357
    ...
      92 |       92 |      30 | 31812 |  75158 |  12.507210819696 | 6186.49790005321
      93 |       93 |      30 |    30 |     -1 |                0 | 6199.00511087291
      94 |        1 |      34 |    60 |  74908 | 3.55109036490289 |                0
      95 |        2 |      34 |    61 | 117754 | 18.5820589058328 | 3.55109036490289
    ...
     165 |       72 |      34 | 40209 |  54682 | 3.19593204722102 | 3789.06830097568
     166 |       73 |      34 |  2957 |  54683 | 3.18627143438335 |  3792.2642330229
     167 |       74 |      34 |    34 |     -1 |                0 | 3795.45050445728
     168 |        1 |      62 |    60 | 103535 | 9.39473406873945 |                0
     169 |        2 |      62 | 57393 |  96334 | 8.59530391457066 | 9.39473406873945
    ...
     266 |       99 |      62 |    63 |  76516 |  5.0071046011868 | 4393.49711188917
     267 |      100 |      62 |    62 |     -1 |                0 | 4398.50421649035
    (267 rows)

.. _d-4:

Exercise 4
.......................................................................

.. rubric:: Many Pedestrians going to different destinations.

* Pedestrian A: "I am in vertex 30 and I am meeting my friends at vertex 60 or at vertex 49."
* Pedestrian B: "I am in vertex 34 and I am meeting my friends at vertex 60 or at vertex 49."
* Pedestrian C: "I am in vertex 62 and I am meeting my friends at vertex 60 or at vertex 49."


.. rubric:: Problem description 

* The pedestrians are located at vertex 30, 34, and 62
* The pedestrians want to go to this destinations: 60, 49
* The cost to be in minutes.
* Use as walking speed: s = 1.3 m/s
* t = d/s
* 1 minute = 60 seconds

.. rubric:: Query 

.. code-block:: sql

    SELECT * FROM pgr_dijkstra('
            SELECT gid AS id,
                 source,
                 target,
                 ST_LENGTH(the_geom::geography)/1.3/60 AS cost
                FROM ways',
            ARRAY[30,34,62], ARRAY[60,49], directed := false);


.. rubric:: Query result

.. code-block:: sql

     seq | path_seq | start_vid | end_vid | node  |  edge  |        cost        |      agg_cost      
    -----+----------+-----------+---------+-------+--------+--------------------+--------------------
       1 |        1 |        30 |      49 |    30 |  75158 |    0.2084535136616 |                  0
       2 |        2 |        30 |      49 | 31812 |  39448 |  0.712025283227618 |    0.2084535136616
    ...
      59 |       59 |        30 |      49 | 44906 |  68361 |  0.508797878862462 |    61.767866703127
      60 |       60 |        30 |      49 |    49 |     -1 |                  0 |   62.2766645819894
      61 |        1 |        30 |      60 |    30 |  75158 |    0.2084535136616 |                  0
      62 |        2 |        30 |      60 | 31812 |  39448 |  0.712025283227618 |    0.2084535136616
    ...
     152 |       92 |        30 |      60 |    61 |  74908 | 0.0591848394150482 |   103.257567008467
     153 |       93 |        30 |      60 |    60 |     -1 |                  0 |   103.316751847882
     154 |        1 |        34 |      49 |    34 |  54683 | 0.0531045239063891 |                  0
     155 |        2 |        34 |      49 |  2957 |   2861 |  0.331807978470314 | 0.0531045239063891
    ...
     293 |      140 |        34 |      49 |    48 |  68352 |  0.421714447874515 |   122.911687792398
     294 |      141 |        34 |      49 |    49 |     -1 |                  0 |   123.333402240272
     295 |        1 |        34 |      60 |    34 |  54683 | 0.0531045239063891 |                  0
     296 |        2 |        34 |      60 |  2957 |  54682 | 0.0532655341203504 | 0.0531045239063891
    ...
     366 |       72 |        34 |      60 | 57394 | 117754 |   0.30970098176388 |   62.8886225864424
     367 |       73 |        34 |      60 |    61 |  74908 | 0.0591848394150482 |   63.1983235682063
     368 |       74 |        34 |      60 |    60 |     -1 |                  0 |   63.2575084076214
     369 |        1 |        62 |      49 |    62 |  91434 |  0.408395885009055 |                  0
     370 |        2 |        62 |      49 | 56011 | 116836 | 0.0552156104580778 |  0.408395885009055
    ...
     478 |      110 |        62 |      49 | 44907 |  63276 |   0.27477550652324 |   99.0536446108382
     479 |      111 |        62 |      49 |    48 |  68352 |  0.421714447874515 |   99.3284201173615
     480 |      112 |        62 |      49 |    49 |     -1 |                  0 |    99.750134565236
     481 |        1 |        62 |      60 |    62 |  76516 | 0.0834517433531133 |                  0
     482 |        2 |        62 |      60 |    63 |  91449 |    1.2464992431335 | 0.0834517433531132
    ...
     579 |       99 |        62 |      60 | 57393 | 103535 |  0.156578901145658 |   73.1518247070269
     580 |      100 |        62 |      60 |    60 |     -1 |                  0 |   73.3084036081725
    (580 rows)


If they go to vertex 49, the total time would be aproximately: 62 + 123 + 99 = 284 minutes

If they go to vertex 60, the total time would be aproximately: 103 + 62 + 73 = 238 minutes

.. _dijkstraCost:

pgr_dijkstraCost
-------------------------------------------------------------------------------


.. rubric:: Signature Summary


.. code-block:: none

    pgr_dijkstraCost(edges_sql, start_vid,  end_vid)
    pgr_dijkstraCost(edges_sql, start_vid,  end_vid,  directed:=true)
    pgr_dijkstraCost(edges_sql, start_vid,  end_vids, directed:=true)
    pgr_dijkstraCost(edges_sql, start_vids, end_vid,  directed:=true)
    pgr_dijkstraCost(edges_sql, start_vids, end_vids, directed:=true)

    RETURNS SET OF (start_vid, end_vid], agg_cost)
        OR EMPTY SET

Description of the parameters can be found in `pgr_dijkstraCost <http://docs.pgrouting.org/latest/en/src/dijkstra/doc/pgr_dijkstraCost.html#description-of-the-signatures>`_




.. _d-5:

Exercise 5
....................................................................................................

.. rubric:: Many Pedestrians going to different destinations interested only on the aggregate cost.

* Pedestrian A: "I am in vertex 30 and I am meeting my friends at vertex 60 or at vertex 49."
* Pedestrian B: "I am in vertex 34 and I am meeting my friends at vertex 60 or at vertex 49."
* Pedestrian C: "I am in vertex 62 and I am meeting my friends at vertex 60 or at vertex 49."
* all: "we only want to know the Cost in hours"

.. rubric:: Problem description 

* The pedestrians are located at vertex 30, 34, and 62
* The pedestrians want to go to this destinations: 60, 49
* The cost to be in hours.
* Use as walking speed: s = 5 km /hr
* t = d/s
* 1m = 0.001m

.. rubric:: Query 

.. code-block:: sql

    SELECT * FROM pgr_dijkstraCost('
            SELECT gid AS id,
                 source,
                 target,
                 ST_LENGTH(the_geom::geography)*0.001/5 AS cost
                FROM ways',
            ARRAY[30,34,62], ARRAY[60,49], directed := false);


.. rubric:: Query result

.. code-block:: sql

     start_vid | end_vid |     agg_cost      
    -----------+---------+-------------------
            30 |      49 | 0.971515967479036
            30 |      60 |  1.61174132882696
            34 |      49 |  1.92400107494825
            34 |      60 | 0.986817131158894
            62 |      49 |  1.55610209921768
            62 |      60 |  1.14361109628749
    (6 rows)



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


Description of the parameters can be found in `pgr_astar <http://docs.pgrouting.org/latest/en/src/dijkstra/doc/pgr_astar.html#description>`_

.. _d-6:

Exercise 6
....................................................................................................

.. rubric:: Single Pedestrian Routing.

* Pedestrian A: "I am in vertex 30 and I am meeting my friends at vertex 60 or at vertex 49."

.. code-block:: sql

    SELECT seq, id1 AS node, id2 AS edge, cost FROM pgr_astar('
            SELECT gid AS id,
                 source::integer,
                 target::integer,
                 length::double precision AS cost,
                 x1, y1, x2, y2
                FROM ways',
            30, 60, false, false);


.. rubric:: Query result

.. code-block:: sql

     seq | node | edge |        cost
    -----+------+------+---------------------
       0 |   30 |   53 |  0.0591267653820616
       1 |   44 |   52 |  0.0665408320949312
       2 |   14 |   15 |  0.0809556879332114
       ...
       6 |   10 | 6869 |  0.0164274192597773
       7 |   59 |   72 |  0.0109385169537801
       8 |   60 |   -1 |                   0
    (9 rows)

.. note::

    * The result of Dijkstra and A-Star might not be the same, because of the heuritic.
    * A-Star is theoretically faster than Dijkstra algorithm as the network size is getting larger.

There are many other functions available with the latest pgRouting release, most of them work in a similar way, and it would take too much time to mention them all in this workshop. For the complete list of pgRouting functions see the API documentation: http://docs.pgrouting.org/

