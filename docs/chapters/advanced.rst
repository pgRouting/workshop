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

.. rubric:: Run: ``psql -U postgres -d routing -c "SELECT * FROM types;"``

.. code-block:: sql

	  id |   name    
	-----+------------
	   2 | cycleway
	   1 | highway
	   4 | junction
	   3 | tracktype
   
.. rubric:: Run: ``psql -U postgres -d routing -c "SELECT * FROM classes"``

.. code-block:: sql

	 id  | type_id |        name        |  cost 
	-----+---------+--------------------+--------
	 201 |       2 | lane               |   1  
	 204 |       2 | opposite           |   1  
	 203 |       2 | opposite_lane      |   1  
	 202 |       2 | track              |   1  
	 117 |       1 | bridleway          |   1  
	 113 |       1 | bus_guideway       |   1  
	 118 |       1 | byway              |   1  
	 115 |       1 | cicleway           |   1  
	 116 |       1 | footway            |   1  
	 108 |       1 | living_street      |   1  
	 101 |       1 | motorway           |   0.2  
	 103 |       1 | motorway_junction  |   0.2  
	 102 |       1 | motorway_link      |   0.2  
	 114 |       1 | path               |   100  
	 111 |       1 | pedestrian         |   100  
	 106 |       1 | primary            |   100  
	 107 |       1 | primary_link       |   100  
	 107 |       1 | residential        |   100  
	 100 |       1 | road               |   0.7  
	 100 |       1 | unclassified       |   0.7  
	 106 |       1 | secondary          |   10  
	 109 |       1 | service            |   10  
	 112 |       1 | services           |   10  
	 119 |       1 | steps              |   10  
	 107 |       1 | tertiary           |   10  
	 110 |       1 | track              |   10  
	 104 |       1 | trunk              |   10  
	 105 |       1 | trunk_link         |   10  
	 401 |       4 | roundabout         |   10  
	 301 |       3 | grade1             |   15  
	 302 |       3 | grade2             |   15  
	 303 |       3 | grade3             |   15  
	 304 |       3 | grade4             |   15  
	 305 |       3 | grade5             |   15  

The road class is linked with the ways table by ``class_id`` field. After importing data the ``cost`` attribute is not set yet. Its values can be changed with an ``UPDATE`` query. In this example cost values for the classes table are assigned arbitrary, so we execute:

.. code-block:: sql

	UPDATE classes SET cost=1 ;
	UPDATE classes SET cost=1 WHERE type_id = 1;
	UPDATE classes SET cost=0.1 WHERE id > 300;
	UPDATE classes SET cost=0.5 WHERE type_id = 2;
	UPDATE classes SET cost=0.2 WHERE name IN ('pedestrian','steps','footway');
	UPDATE classes SET cost=0.4 WHERE name IN ('cicleway','living_street','path');

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
