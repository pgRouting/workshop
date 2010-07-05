==============================================================================================================
Shortest Path Search
==============================================================================================================

.. todo::

	Add chapter introduction for Shortest Path Search

-------------------------------------------------------------------------------------------------------------
Dijkstra algorithm
-------------------------------------------------------------------------------------------------------------

Dijkstra algorithm was the first algorithm implemented in pgRouting. It doesn't require more attributes than source and target ID, and it can distinguish between directed and undirected graphs. You can specify if your network has "reverse cost" or not.

.. code-block:: sql

	shortest_path( sql text, 
			   source_id integer, 
			   target_id integer, 
			   directed boolean, 
			   has_reverse_cost boolean ) 

.. note::

	* Source and target IDs are vertex IDs.
	* Undirected graphs ("directed false") ignores "has_reverse_cost" setting
	* Shortest Path Dijkstra core function

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Core
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Each algorithm has its core function (implementation), which is the base for its wrapper functions.

.. code-block:: sql

	SELECT * FROM shortest_path('
			SELECT gid as id, 
				 source::integer, 
				 target::integer, 
				 length::double precision as cost 
				FROM ways', 
			10, 20, false, false); 

.. code-block:: sql

	 vertex_id | edge_id |        cost         
	-----------+---------+---------------------
	        10 |     293 |  0.0059596293824534
	         9 |    4632 |  0.0846731039249787
	      3974 |    4633 |  0.0765635090514303
	      2107 |    4634 |  0.0763951531894937
	       ... |     ... |  ...
	        20 |      -1 |                   0
	(63 rows)


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Wrapper
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Wrapper WITHOUT bounding box

Wrapper functions extend the core functions with transformations, bounding box limitations, etc.. Wrappers can change the format and ordering of the result. They often set default function parameters and make the usage of pgRouting more simple.

.. code-block:: sql

	SELECT gid, AsText(the_geom) AS the_geom 
		FROM dijkstra_sp('ways', 10, 20);
		
.. code-block:: sql
		
	  gid   |                              the_geom      
	--------+---------------------------------------------------------------
	    293 | MULTILINESTRING((18.4074149 -33.9443308,18.4074019 -33.9443833))
	   4632 | MULTILINESTRING((18.4074149 -33.9443308,18.4077388 -33.9436183))
	   4633 | MULTILINESTRING((18.4077388 -33.9436183,18.4080293 -33.9429733))
	    ... | ...
	    762 | MULTILINESTRING((18.4241422 -33.9179275,18.4237423 -33.9182966))
	    761 | MULTILINESTRING((18.4243523 -33.9177154,18.4241422 -33.9179275))
	(62 rows)
	
.. rubric:: Wrapper WITH bounding box

You can limit your search area by adding a bounding box. This will improve performance especially for large networks.

.. code-block:: sql

	SELECT gid, AsText(the_geom) AS the_geom 
		FROM dijkstra_sp_delta('ways', 10, 20, 0.1);
		
.. code-block:: sql

	   gid  | the_geom
	--------+---------------------------------------------------------------
	   293  | MULTILINESTRING((18.4074149 -33.9443308,18.4074019 -33.9443833))
	   4632 | MULTILINESTRING((18.4074149 -33.9443308,18.4077388 -33.9436183)) 
	   4633 | MULTILINESTRING((18.4077388 -33.9436183,18.4080293 -33.9429733))
	   ...  | ... 
	   762  | MULTILINESTRING((18.4241422 -33.9179275,18.4237423 -33.9182966)) 
	   761 | MULTILINESTRING((18.4243523 -33.9177154,18.4241422 -33.9179275))
	(62 rows)

.. warning:: 

	The projection of OSM data is "degree", so we set a bounding box containing start and end vertex plus a 0.1 degree buffer for example.


-------------------------------------------------------------------------------------------------------------
A-Star algorithm
-------------------------------------------------------------------------------------------------------------

A-Star algorithm is another well-known routing algorithm. It adds geographical information to source and target of each network link. This enables the shortest path search to prefer links which are closer to the target of the search.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Prerequisites
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For A-Star you need to prepare your network table and add latitute/longitude columns (x1, y1 and x2, y2) and calculate their values.

.. code-block:: sql

	ALTER TABLE ways ADD COLUMN x1 double precision;
	ALTER TABLE ways ADD COLUMN y1 double precision;
	ALTER TABLE ways ADD COLUMN x2 double precision;
	ALTER TABLE ways ADD COLUMN y2 double precision;
	
	UPDATE ways SET x1 = x(startpoint(the_geom));
	UPDATE ways SET y1 = y(startpoint(the_geom));
	
	UPDATE ways SET x2 = x(endpoint(the_geom));
	UPDATE ways SET y2 = y(endpoint(the_geom));
	
	UPDATE ways SET x1 = x(PointN(the_geom, 1));
	UPDATE ways SET y1 = y(PointN(the_geom, 1));
	
	UPDATE ways SET x2 = x(PointN(the_geom, NumPoints(the_geom)));
	UPDATE ways SET y2 = y(PointN(the_geom, NumPoints(the_geom)));

.. Note:: 

	"endpoint()" function fails for some versions of PostgreSQL (ie. 8.2.5, 8.1.9). A workaround for that problem is using the "PointN()" function instead:


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Core
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Shortest Path A-Star function is very similar to the Dijkstra function, though it prefers links that are close to the target of the search. The heuristics of this search are predefined, so you need to recompile pgRouting if you want to make changes to the heuristic function itself.

.. code-block:: sql

	shortest_path_astar( sql text, 
			   source_id integer, 
			   target_id integer, 
			   directed boolean, 
			   has_reverse_cost boolean ) 

.. note::
	* Source and target IDs are vertex IDs.
	* Undirected graphs ("directed false") ignores "has_reverse_cost" setting
	* Example of A-Star core function

.. code-block:: sql

	SELECT * FROM shortest_path_astar('
			SELECT gid as id, 
				 source::integer, 
				 target::integer, 
				 length::double precision as cost, 
				 x1, y1, x2, y2
				FROM ways', 
			10, 20, false, false); 
		
.. code-block:: sql
		
	vertex_id | edge_id |        cost         
	-----------+---------+---------------------
	       10 |     293 |  0.0059596293824534
	        9 |    4632 |  0.0846731039249787
	     3974 |    4633 |  0.0765635090514303
	      ... |     ... |  ...
	       20 |      -1 |                   0
	(63 rows)


^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Wrapper
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

.. rubric:: Wrapper function WITH bounding box

Wrapper functions extend the core functions with transformations, bounding box limitations, etc..

.. code-block:: sql

	SELECT gid, AsText(the_geom) AS the_geom 
		FROM astar_sp_delta('ways', 10, 20, 0.1);

.. code-block:: sql

	  gid   |                              the_geom      
	--------+---------------------------------------------------------------
	    293 | MULTILINESTRING((18.4074149 -33.9443308,18.4074019 -33.9443833))
	   4632 | MULTILINESTRING((18.4074149 -33.9443308,18.4077388 -33.9436183))
	   4633 | MULTILINESTRING((18.4077388 -33.9436183,18.4080293 -33.9429733))
	    ... | ...
	    762 | MULTILINESTRING((18.4241422 -33.9179275,18.4237423 -33.9182966))
	    761 | MULTILINESTRING((18.4243523 -33.9177154,18.4241422 -33.9179275))
	(62 rows)
	
.. note::
	There is currently no wrapper function for A-Star without bounding box, since bounding boxes are very useful to increase performance. If you don't need a bounding box Dijkstra will be enough anyway.

.. warning::
	The projection of OSM data is "degree", so we set a bounding box containing start and end vertex plus a 0.1 degree buffer for example.


-------------------------------------------------------------------------------------------------------------
Shooting-Star algorithm
-------------------------------------------------------------------------------------------------------------

Shooting-Star algorithm is the latest of pgRouting shortest path algorithms. Its speciality is that it routes from link to link, not from vertex to vertex as Dijkstra and A-Star algorithms do. This makes it possible to define relations between links for example, and it solves some other vertex-based algorithm issues like "parallel links", which have same source and target but different costs.

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Prerequisites
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

For Shooting-Star you need to prepare your network table and add the "reverse_cost" and "to_cost" column. Like A-Star this algorithm also has a heuristic function, which prefers links closer to the target of the search.

.. code-block:: sql

	ALTER TABLE ways ADD COLUMN reverse_cost double precision;
	UPDATE ways SET reverse_cost = length;
	
	ALTER TABLE ways ADD COLUMN to_cost double precision;
	
	ALTER TABLE ways ADD COLUMN rule text;

.. rubric:: Shooting-Star algorithm introduces two new attributes

* **rule**: a string with a comma separated list of edge IDs, which describes a rule for turning restriction (if you came along these edges, you can pass through the current one only with the cost stated in to_cost column)
* **to_cost**: a cost of a restricted passage (can be very high in a case of turn restriction or comparable with an edge cost in a case of traffic light)

.. code-block:: sql

	shortest_path_shooting_star( sql text, 
			   source_id integer, 
			   target_id integer, 
			   directed boolean, 
			   has_reverse_cost boolean ) 

.. note::

	* Source and target IDs are link IDs.
	* Undirected graphs ("directed false") ignores "has_reverse_cost" setting
	* Example for Shooting-Star "rule"

.. warning::

	Shooting* algorithm calculates a path from edge to edge (not from vertex to vertex). Column vertex_id contains start vertex of an edge from column edge_id.

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

.. code-block:: sql

	SELECT * FROM shortest_path_shooting_star('
			SELECT gid as id, 
				 source::integer,
				 target::integer, 
				 length::double precision as cost, 
				 x1, y1, x2, y2,
				 rule, to_cost 
				FROM ways', 
			293, 761, false, false); 

.. code-block:: sql

	 vertex_id | edge_id |        cost         
	-----------+---------+---------------------
	      4232 |     293 |  0.0059596293824534
	      3144 |     293 |  0.0059596293824534
	      4232 |    4632 |  0.0846731039249787
	       ... |     ... |  ...
	        51 |     761 |  0.0305298478239596
	(63 rows)

^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^
Wrapper
^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^

Wrapper functions extend the core functions with transformations, bounding box limitations, etc..

.. code-block:: sql

	SELECT gid, AsText(the_geom) AS the_geom
		FROM shootingstar_sp('ways', 293, 761, 0.1, 'length', true, true);

.. code-block:: sql

	  gid   |                              the_geom      
	--------+---------------------------------------------------------------
	    293 | MULTILINESTRING((18.4074149 -33.9443308,18.4074019 -33.9443833))
	    293 | MULTILINESTRING((18.4074149 -33.9443308,18.4074019 -33.9443833))
	   4632 | MULTILINESTRING((18.4074149 -33.9443308,18.4077388 -33.9436183))
	    ... | ...
	    762 | MULTILINESTRING((18.4241422 -33.9179275,18.4237423 -33.9182966))
	    761 | MULTILINESTRING((18.4243523 -33.9177154,18.4241422 -33.9179275))
	(62 rows)

.. note::

	There is currently no wrapper function for A-Star without bounding box, since bounding boxes are very useful to increase performance. If you don't need a bounding box Dijkstra will be enough anyway.

.. warning::

	The projection of OSM data is "degree", so we set a bounding box containing start and end vertex plus a 0.1 degree buffer for example.
