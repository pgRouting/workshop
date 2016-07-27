==============================================================================================================
Advanced Routing Queries
==============================================================================================================

As explained in the previous chapter a shortest path query usualy looks like this:

.. code-block:: sql

	SELECT * FROM shortest_path_shooting_star(
		'SELECT gid as id, source, target, length as cost, x1, y1, x2, y2, rule, 
		to_cost, reverse_cost FROM ways', 609, 366, true, true);
	
This is usually called **shortest** path, which means that a length of an edge is its cost. But cost doesn't need to be length, cost can be almost anything, for example time, slope, surface, road type, etc.. Or it can be a combination of multiple parameters ("Weighted costs").


-------------------------------------------------------------------------------------------------------------
Weighted costs
-------------------------------------------------------------------------------------------------------------

In real networks there are different limitations or preferences for different road types for example. In other words, we don't want to get the *shortest* but the **cheapest** path - a path with a minimal cost. There is no limitation in what we take as costs.

When we convert data from OSM format using the osm2pgrouting tool, we get two additional tables for road ``types`` and road ``classes``:

.. note::

	We switch now to the database we previously generated with osm2pgrouting. From within PostgreSQL shell this is possible with the ``\c routing`` command.

.. rubric:: Run: ``SELECT * FROM types;``

.. code-block:: sql

	  id |   name    
	-----+------------
	   2 | cycleway
	   1 | highway
	   4 | junction
	   3 | tracktype
   
.. rubric:: Run: ``SELECT * FROM classes;``

.. code-block:: sql

	 id  | type_id |        name        |  cost 
	-----+---------+--------------------+--------
	 201 |       2 | lane               |     
	 204 |       2 | opposite           |     
	 203 |       2 | opposite_lane      |    
	 202 |       2 | track              |     
	 117 |       1 | bridleway          |     
	 113 |       1 | bus_guideway       |     
	 118 |       1 | byway              |     
	 115 |       1 | cicleway           |     
	 116 |       1 | footway            |     
	 108 |       1 | living_street      |     
	 101 |       1 | motorway           |    
	 103 |       1 | motorway_junction  |     
	 102 |       1 | motorway_link      |     
	 114 |       1 | path               |     
	 111 |       1 | pedestrian         |     
	 106 |       1 | primary            |     
	 107 |       1 | primary_link       |     
	 107 |       1 | residential        |     
	 100 |       1 | road               |     
	 100 |       1 | unclassified       |     
	 106 |       1 | secondary          |    
	 109 |       1 | service            |     
	 112 |       1 | services           |     
	 119 |       1 | steps              |     
	 107 |       1 | tertiary           |     
	 110 |       1 | track              |     
	 104 |       1 | trunk              |     
	 105 |       1 | trunk_link         |     
	 401 |       4 | roundabout         |     
	 301 |       3 | grade1             |     
	 302 |       3 | grade2             |     
	 303 |       3 | grade3             |     
	 304 |       3 | grade4             |     
	 305 |       3 | grade5             |     

The road class is linked with the ways table by ``class_id`` field. After importing data the ``cost`` attribute is not set yet. Its values can be changed with an ``UPDATE`` query. In this example cost values for the classes table are assigned arbitrary, so we execute:

.. code-block:: sql

	UPDATE classes SET cost=1 ;
	UPDATE classes SET cost=2.0 WHERE name IN ('pedestrian','steps','footway');
	UPDATE classes SET cost=1.5 WHERE name IN ('cicleway','living_street','path');
	UPDATE classes SET cost=0.8 WHERE name IN ('secondary','tertiary');
	UPDATE classes SET cost=0.6 WHERE name IN ('primary','primary_link');
	UPDATE classes SET cost=0.4 WHERE name IN ('trunk','trunk_link');
	UPDATE classes SET cost=0.3 WHERE name IN ('motorway','motorway_junction','motorway_link');

For better performance, especially if the network data is large, it is better to create an index on the ``class_id`` field of the ways table and eventually on the ``id`` field of the ``types`` table.

.. code-block:: sql

	CREATE INDEX ways_class_idx ON ways (class_id);
	CREATE INDEX classes_idx ON classes (id);

The idea behind these two tables is to specify a factor to be multiplied with the cost of each link (usually length):

.. code-block:: sql

	SELECT * FROM shortest_path_shooting_star(
		'SELECT gid as id, class_id, source, target, length*c.cost as cost, 
			x1, y1, x2, y2, rule, to_cost, reverse_cost*c.cost as reverse_cost 
		FROM ways w, classes c 
		WHERE class_id=c.id', 609, 366, true, true);

-------------------------------------------------------------------------------------------------------------
Restricted access
-------------------------------------------------------------------------------------------------------------

Another possibility is to restrict access to roads of a certain type by either setting a very high cost for road links with a certain attribute or by not selecting certain road links at all:

.. code-block:: sql

	UPDATE classes SET cost=100000 WHERE name LIKE 'motorway%';

Through subqueries you can "mix" your costs as you like and this will change the results of your routing request immediately. Cost changes will affect the next shortest path search, and there is no need to rebuild your network.

Of course certain road classes can be excluded in the ``WHERE`` clause of the query as well, for example exclude "living_street" class:

.. code-block:: sql

	SELECT * FROM shortest_path_shooting_star(
		'SELECT gid as id, class_id, source, target, length*c.cost as cost, 
			x1, y1, x2, y2, rule, to_cost, reverse_cost*c.cost as reverse_cost 
		FROM ways w, classes c 
		WHERE class_id=c.id AND class_id != 111', 609, 366, true, true);

Of course pgRouting allows you all kind of SQL that is possible with PostgreSQL/PostGIS.
 
