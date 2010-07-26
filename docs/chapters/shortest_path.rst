==============================================================================================================
Shortest Path Search
==============================================================================================================

pgRouting was first called *pgDijkstra*, because it implemented only shortest path search with *Dijkstra* algorithm. Later other functions were added and the library was renamed.

.. image:: images/route.png
	:width: 250pt
	:align: center
	
This chapter will explain the three different shortest path algorithms and which attributes are required. If you run osm2pgrouting tool to import *OpenStreetMap* data, the ``ways`` table contains all attributes already to run all shortest path function functions.


-------------------------------------------------------------------------------------------------------------
Dijkstra
-------------------------------------------------------------------------------------------------------------

Dijkstra algorithm was the first algorithm implemented in pgRouting. It doesn't require other attributes than ``source`` and ``target`` ID, ``id`` attribute and ``cost``. It can distinguish between directed and undirected graphs. You can specify if your network has ``reverse cost`` or not.

.. rubric:: Prerequisites

To be able to use ``reverse cost`` you need to add an additional cost column. We can set reverse cost as length.

.. code-block:: sql

	ALTER TABLE ways ADD COLUMN reverse_cost double precision;
	UPDATE ways SET reverse_cost = length;

.. rubric:: Function with parameters

.. code-block:: sql

	shortest_path( sql text, 
			   source_id integer, 
			   target_id integer, 
			   directed boolean, 
			   has_reverse_cost boolean ) 

.. note::

	* Source and target IDs are vertex IDs.
	* Undirected graphs ("directed false") ignore "has_reverse_cost" setting


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Core
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Each algorithm has its *core* function , which is the base for its wrapper functions.

.. code-block:: sql

	SELECT * FROM shortest_path('
			SELECT gid as id, 
				 source::integer, 
				 target::integer, 
				 length::double precision as cost 
				FROM ways', 
			605, 359, false, false); 

.. code-block:: sql

	 vertex_id | edge_id |        cost         
	-----------+---------+---------------------
		   605 |    5575 |  0.0717467247513547
		  1679 |    2095 |   0.148344716070272
		   588 |    2094 |  0.0611856933258344
	       ... |     ... |  ...
	       359 |      -1 |                   0
	(82 rows)


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Wrapper
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Wrapper WITHOUT bounding box

Wrapper functions extend the core functions with transformations, bounding box limitations, etc.. Wrappers can change the format and ordering of the result. They often set default function parameters and make the usage of pgRouting more simple.

.. code-block:: sql

	SELECT gid, AsText(the_geom) AS the_geom 
		FROM dijkstra_sp('ways', 605, 359);
		
.. code-block:: sql
		
	  gid   |                              the_geom      
	--------+---------------------------------------------------------------
	    168 | MULTILINESTRING((2.1633077 41.3802886,2.1637094 41.3803008))
	    169 | MULTILINESTRING((2.1637094 41.3803008,2.1638796 41.3803093))
	    170 | MULTILINESTRING((2.1638796 41.3803093,2.1640527 41.3803265))
	    ... | ...
	   5575 | MULTILINESTRING((2.1436976 41.3897581,2.143876 41.3903893))
	(81 rows)
	
.. rubric:: Wrapper WITH bounding box

You can limit your search area by adding a bounding box. This will improve performance especially for large networks.

.. code-block:: sql

	SELECT gid, AsText(the_geom) AS the_geom 
		FROM dijkstra_sp_delta('ways', 605, 359, 0.1);
		
.. code-block:: sql

	  gid   |                              the_geom      
	--------+---------------------------------------------------------------
	    168 | MULTILINESTRING((2.1633077 41.3802886,2.1637094 41.3803008))
	    169 | MULTILINESTRING((2.1637094 41.3803008,2.1638796 41.3803093))
	    170 | MULTILINESTRING((2.1638796 41.3803093,2.1640527 41.3803265))
	    ... | ...
	   5575 | MULTILINESTRING((2.1436976 41.3897581,2.143876 41.3903893))
	(81 rows)

.. note:: 

	The projection of OSM data is "degree", so we set a bounding box containing start and end vertex plus a ``0.1`` degree buffer for example.


-------------------------------------------------------------------------------------------------------------
A-Star
-------------------------------------------------------------------------------------------------------------

A-Star algorithm is another well-known routing algorithm. It adds geographical information to source and target of each network link. This enables the shortest path search to prefer links which are closer to the target of the search.

.. rubric:: Prerequisites

For A-Star you need to prepare your network table and add latitute/longitude columns (``x1``, ``y1`` and ``x2``, ``y2``) and calculate their values.

.. code-block:: sql

	ALTER TABLE ways ADD COLUMN x1 double precision;
	ALTER TABLE ways ADD COLUMN y1 double precision;
	ALTER TABLE ways ADD COLUMN x2 double precision;
	ALTER TABLE ways ADD COLUMN y2 double precision;
	
	UPDATE ways SET x1 = x(ST_startpoint(the_geom));
	UPDATE ways SET y1 = y(ST_startpoint(the_geom));
	
	UPDATE ways SET x2 = x(ST_endpoint(the_geom));
	UPDATE ways SET y2 = y(ST_endpoint(the_geom));
	
	UPDATE ways SET x1 = x(ST_PointN(the_geom, 1));
	UPDATE ways SET y1 = y(ST_PointN(the_geom, 1));
	
	UPDATE ways SET x2 = x(ST_PointN(the_geom, ST_NumPoints(the_geom)));
	UPDATE ways SET y2 = y(ST_PointN(the_geom, ST_NumPoints(the_geom)));

.. Note:: 

	``endpoint()`` function fails for some versions of PostgreSQL (ie. 8.2.5, 8.1.9). A workaround for that problem is using the ``PointN()`` function instead:


.. rubric:: Function with parameters

Shortest Path A-Star function is very similar to the Dijkstra function, though it prefers links that are close to the target of the search. The heuristics of this search are predefined, so you need to recompile pgRouting if you want to make changes to the heuristic function itself.

.. code-block:: sql

	shortest_path_astar( sql text, 
			   source_id integer, 
			   target_id integer, 
			   directed boolean, 
			   has_reverse_cost boolean ) 

.. note::
	* Source and target IDs are vertex IDs.
	* Undirected graphs ("directed false") ignore "has_reverse_cost" setting

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Core
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. code-block:: sql

	SELECT * FROM shortest_path_astar('
			SELECT gid as id, 
				 source::integer, 
				 target::integer, 
				 length::double precision as cost, 
				 x1, y1, x2, y2
				FROM ways', 
			605, 359, false, false); 
		
.. code-block:: sql
		
	 vertex_id | edge_id |        cost         
	-----------+---------+---------------------
		   605 |    5575 |  0.0717467247513547
		  1679 |    2095 |   0.148344716070272
		   588 |    2094 |  0.0611856933258344
	       ... |     ... |  ...
	       359 |      -1 |                   0
	(82 rows)


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Wrapper
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Wrapper function WITH bounding box

Wrapper functions extend the core functions with transformations, bounding box limitations, etc..

.. code-block:: sql

	SELECT gid, AsText(the_geom) AS the_geom 
		FROM astar_sp_delta('ways', 605, 359, 0.1);

.. code-block:: sql

	  gid   |                              the_geom      
	--------+---------------------------------------------------------------
	   2095 | MULTILINESTRING((2.1456208 41.3901317,2.143876 41.3903893))
	   1721 | MULTILINESTRING((2.1494579 41.3890058,2.1482992 41.3898429))
	   1719 | MULTILINESTRING((2.1517067 41.3873058,2.1505566 41.3881623))
	    ... | ...
	   3607 | MULTILINESTRING((2.1795052 41.3843643,2.1796184 41.3844328))
	(81 rows)
	
.. note::

	* There is currently no wrapper function for A-Star without bounding box, since bounding boxes are very useful to increase performance. If you don't need a bounding box Dijkstra will be enough anyway.
	* The projection of OSM data is "degree", so we set a bounding box containing start and end vertex plus a 0.1 degree buffer for example.


-------------------------------------------------------------------------------------------------------------
Shooting-Star
-------------------------------------------------------------------------------------------------------------

Shooting-Star algorithm is the latest of pgRouting shortest path algorithms. Its speciality is that it routes from link to link, not from vertex to vertex as Dijkstra and A-Star algorithms do. This makes it possible to define relations between links for example, and it solves some other vertex-based algorithm issues like "parallel links", which have same source and target but different costs.

.. rubric:: Prerequisites

For Shooting-Star you need to prepare your network table and add the ``rule`` and ``to_cost`` column. Like A-Star this algorithm also has a heuristic function, which prefers links closer to the target of the search.

.. code-block:: sql

	# Add rule and to_cost column
	ALTER TABLE ways ADD COLUMN to_cost double precision;	
	ALTER TABLE ways ADD COLUMN rule text;

.. rubric:: Shooting-Star algorithm introduces two new attributes

.. list-table::
   :widths: 10 90

   * - **Attribute**
     - **Description**
   * - rule
     - a string with a comma separated list of edge IDs, which describes a rule for turning restriction (if you came along these edges, you can pass through the current one only with the cost stated in to_cost column)
   * - to_cost
     - a cost of a restricted passage (can be very high in a case of turn restriction or comparable with an edge cost in a case of traffic light)

.. rubric:: Function with parameters

.. code-block:: sql

	shortest_path_shooting_star( sql text, 
			   source_id integer, 
			   target_id integer, 
			   directed boolean, 
			   has_reverse_cost boolean ) 

.. note::

	* Source and target IDs are link IDs.
	* Undirected graphs ("directed false") ignores "has_reverse_cost" setting

To describe turn restrictions:

.. code-block:: sql

	 gid | source | target | cost | x1 | y1 | x2 | y2 | to_cost | rule
	-----+--------+--------+------+----+----+----+----+---------+------
	  12 |      3 |     10 |    2 |  4 |  3 |  4 |  5 |    1000 | 14
  
... means that the cost of going from edge 14 to edge 12 is 1000, and

.. code-block:: sql

	 gid | source | target | cost | x1 | y1 | x2 | y2 | to_cost | rule
	-----+--------+--------+------+----+----+----+----+---------+------
	  12 |      3 |     10 |    2 |  4 |  3 |  4 |  5 |    1000 | 14, 4

... means that the cost of going from edge 14 to edge 12 through edge 4 is 1000.

If you need multiple restrictions for a given edge then you have to add multiple records for that edge each with a separate restriction.

.. code-block:: sql

	 gid | source | target | cost | x1 | y1 | x2 | y2 | to_cost | rule
	-----+--------+--------+------+----+----+----+----+---------+------
	  11 |      3 |     10 |    2 |  4 |  3 |  4 |  5 |    1000 | 4
	  11 |      3 |     10 |    2 |  4 |  3 |  4 |  5 |    1000 | 12

... means that the cost of going from either edge 4 or 12 to edge 11 is 1000. And then you always need to order your data by gid when you load it to a shortest path function..


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Core
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

An example of a Shooting Star query may look like this: 

.. code-block:: sql

	SELECT * FROM shortest_path_shooting_star('
			SELECT gid as id, 
				 source::integer,
				 target::integer, 
				 length::double precision as cost, 
				 x1, y1, x2, y2,
				 rule, to_cost 
				FROM ways', 
			609, 366, false, false); 

.. code-block:: sql

	 vertex_id | edge_id |        cost         
	-----------+---------+---------------------
		  2026 |     609 |   0.132151952643718
		  2461 |     273 |   0.132231995120746
		  2459 |     272 |  0.0344834036101095
	       ... |     ... |  ...
	      2571 |     366 |   0.120471497765379
	(81 rows)

.. warning::

	Shooting Star algorithm calculates a path from edge to edge (not from vertex to vertex). Column vertex_id contains start vertex of an edge from column edge_id.


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Wrapper
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wrapper functions extend the core functions with transformations, bounding box limitations, etc..

.. code-block:: sql

	SELECT gid, AsText(the_geom) AS the_geom
		FROM shootingstar_sp('ways', 609, 366, 0.1, 'length', true, true);

.. code-block:: sql

	  gid   |                              the_geom      
	--------+---------------------------------------------------------------
	    609 | MULTILINESTRING((2.1436976 41.3897581,2.1449097 41.3889929))
	    273 | MULTILINESTRING((2.1460685 41.3898043,2.1449097 41.3889929))
	    272 | MULTILINESTRING((2.1463431 41.3900361,2.1460685 41.3898043))
	    ... | ...
	   3607 | MULTILINESTRING((2.1795052 41.3843643,2.1796184 41.3844328))
	(81 rows)

.. note::

	There is currently no wrapper function for Shooting-Star without bounding box, since bounding boxes are very useful to increase performance. 

.. warning::

	The projection of OSM data is "degree", so we set a bounding box containing start and end vertex plus a 0.1 degree buffer for example.
