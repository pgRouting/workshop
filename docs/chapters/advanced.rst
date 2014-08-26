.. 
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _advanced:

Advanced Routing Queries
===============================================================================

.. note::

	This chapter may be skipped depending on available time, or you can come back here again later


As explained in the :ref:`chapter about routing algorithms <routing>` a shortest path query usualy looks like this:

.. code-block:: sql

	SELECT seq, id1 AS node, id2 AS edge, cost FROM pgr_dijkstra('
			SELECT gid AS id, 
				 source::integer, 
				 target::integer, 
				 length::double precision AS cost 
				FROM ways', 
			30, 60, false, false); 

	
This is usually called **shortest** path, which means that a length of an edge is its cost. But cost doesn't need to be length, cost can be almost anything, for example time, slope, surface, road type, etc.. Or it can be a combination of multiple parameters ("Weighted costs").

.. note::

	If you want to proceed with a routing database containing pgRouting functions, sample data and all required attributes, you can load the following database dump file. 

.. code-block:: bash

	# Optional: Drop database
	dropdb -U postgres pgrouting-workshop

	# Load database dump file
	psql -U postgres -f ~/Desktop/pgrouting-workshop/data/sampledata_routing.sql


Weighted costs
-------------------------------------------------------------------------------

In "real" networks there are different limitations or preferences for different road types for example. In other words, we don't want to get the *shortest* but the **cheapest** path - a path with a minimal cost. There is no limitation in what we take as costs.

When we convert data from OSM format using the osm2pgrouting tool, we get two additional tables for road ``types`` and road ``classes``:

.. note::

	We switch now to the database we previously generated with osm2pgrouting. From within PostgreSQL shell this is possible with the ``\c routing`` command.

.. rubric:: Run: ``SELECT * FROM types ORDER BY id;``

.. code-block:: sql

	 id |   name    
	----+-----------
	  2 | cycleway
	  1 | highway
	  4 | junction
	  3 | tracktype
	(4 rows)

   
.. rubric:: Run: ``SELECT * FROM classes ORDER BY id;``

.. code-block:: sql

	 id  | type_id |       name        | cost | priority | default_maxspeed 
	-----+---------+-------------------+------+----------+------------------
	 100 |       1 | road              |      |        1 |               50
	 101 |       1 | motorway          |      |        1 |               50
	 102 |       1 | motorway_link     |      |        1 |               50
	 103 |       1 | motorway_junction |      |        1 |               50
	 104 |       1 | trunk             |      |        1 |               50
	 105 |       1 | trunk_link        |      |        1 |               50
	 106 |       1 | primary           |      |        1 |               50
	 107 |       1 | primary_link      |      |        1 |               50
	 108 |       1 | secondary         |      |        1 |               50
	 109 |       1 | tertiary          |      |        1 |               50
	 110 |       1 | residential       |      |        1 |               50
	 111 |       1 | living_street     |      |        1 |               50
	 112 |       1 | service           |      |        1 |               50
	 113 |       1 | track             |      |        1 |               50
	 114 |       1 | pedestrian        |      |        1 |               50
	 115 |       1 | services          |      |        1 |               50
	 116 |       1 | bus_guideway      |      |        1 |               50
	 117 |       1 | path              |      |        1 |               50
	 118 |       1 | cycleway          |      |        1 |               50
	 119 |       1 | footway           |      |        1 |               50
	 120 |       1 | bridleway         |      |        1 |               50
	 121 |       1 | byway             |      |        1 |               50
	 122 |       1 | steps             |      |        1 |               50
	 123 |       1 | unclassified      |      |        1 |               50
	 124 |       1 | secondary_link    |      |        1 |               50
	 125 |       1 | tertiary_link     |      |        1 |               50
	 201 |       2 | lane              |      |        1 |               50
	 202 |       2 | track             |      |        1 |               50
	 203 |       2 | opposite_lane     |      |        1 |               50
	 204 |       2 | opposite          |      |        1 |               50
	 301 |       3 | grade1            |      |        1 |               50
	 302 |       3 | grade2            |      |        1 |               50
	 303 |       3 | grade3            |      |        1 |               50
	 304 |       3 | grade4            |      |        1 |               50
	 305 |       3 | grade5            |      |        1 |               50
	 401 |       4 | roundabout        |      |        1 |               50
	(36 rows)   

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

	SELECT seq, id1 AS node, id2 AS edge, cost FROM pgr_dijkstra('
			SELECT gid AS id, 
				 source::integer, 
				 target::integer, 
				 length * c.cost AS cost 
				FROM ways, classes c
				WHERE class_id = c.id', 
			30, 60, false, false); 


Restricted access
-------------------------------------------------------------------------------

Another possibility is to restrict access to roads of a certain type by either setting a very high cost for road links with a certain attribute or by not selecting certain road links at all:

.. code-block:: sql

	UPDATE classes SET cost=100000 WHERE name LIKE 'motorway%';

Through subqueries you can "mix" your costs as you like and this will change the results of your routing request immediately. Cost changes will affect the next shortest path search, and there is no need to rebuild your network.

Of course certain road classes can be excluded in the ``WHERE`` clause of the query as well, for example exclude "living_street" class:

.. code-block:: sql

	SELECT seq, id1 AS node, id2 AS edge, cost FROM pgr_dijkstra('
			SELECT gid AS id, 
				 source::integer, 
				 target::integer, 
				 length * c.cost AS cost 
				FROM ways, classes c
				WHERE class_id = c.id AND class_id != 111', 
			30, 60, false, false); 

Of course pgRouting allows you all kind of SQL that is possible with PostgreSQL/PostGIS.
 
