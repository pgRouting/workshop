.. 
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _wrapper:

Writing a pl/pgsql Wrapper
===============================================================================

Many pgRouting functions provide a "low-level" interface to algorithms and for example return ordered ID's rather than routes with geometries. "Wrapper functions" therefor offer different input parameters as well as transform the returned result into a format, that can be easier read or consumed by applications.

The downside of wrapper functions is, that they often make assumptions that make them only useful for specific use cases or network data. Therefor pgRouting has decided to only support low-level functions and let the user write their own wrapper functions for their own use cases.

The following wrappers are examples for common transformations:


Return route with network geometry
-------------------------------------------------------------------------------

To return a route with the line geometry of it's path segments it's not necessary to write a wrapper function. It's sufficient to link the result pack to the original road network table:

.. rubric:: Shortest Path Dijkstra

.. code-block:: sql

	SELECT seq, id1 AS node, id2 AS edge, cost FROM pgr_dijkstra('
			SELECT gid AS id, 
				 source::integer, 
				 target::integer, 
				 length::double precision AS cost 
				FROM ways', 
			30, 60, false, false); 


.. rubric:: Result with Geometries

.. code-block:: sql

	SELECT seq, id1 AS node, id2 AS edge, cost, b.the_geom FROM pgr_dijkstra('
			SELECT gid AS id, 
				 source::integer, 
				 target::integer, 
				 length::double precision AS cost 
				FROM ways', 
			30, 60, false, false) a LEFT JOIN ways b ON (a.id2 = b.gid); 

.. note::

	The last record of this JOIN doesn't contain a geometry value since the shortest path function returns ``-1`` for the last record to indicate the end of the route. 


Visualize the result
-------------------------------------------------------------------------------

Instead of looking at rows, columns and numbers on the terminal screen it's more interesting to visualize the route on a map. Here a few ways to do so:

* **Store the result as table** with ``CREATE TABLE <table name> AS SELECT ...`` and show the result in QGIS, for example:

.. code-block:: sql

	CREATE TABLE route AS SELECT seq, id1 AS node, id2 AS edge, cost, b.the_geom FROM pgr_dijkstra('
			SELECT gid AS id, 
				 source::integer, 
				 target::integer, 
				 length::double precision AS cost 
				FROM ways', 
			30, 60, false, false) a LEFT JOIN ways b ON (a.id2 = b.gid); 

* Use **QGIS SQL where clause** when adding a PostGIS layer:
	* Create a database connection and add the “ways” table as a background layer.
	* Add another layer of the “ways” table but select ``Build query`` before adding it.
	* Then type the following into the  **SQL where clause** field:

	.. code-block:: sql

		"gid" IN ( SELECT id2 AS gid FROM pgr_dijkstra('
				SELECT gid AS id, 
					 source::integer, 
					 target::integer, 
					 length::double precision AS cost 
					FROM ways', 
				30, 60, false, false) a LEFT JOIN ways b ON (a.id2 = b.gid)
		)

* See the next chapter how to configure a WMS server with Geoserver.


Simplified input parameters and geometry output
-------------------------------------------------------------------------------

The following function simplifies (and sets default values) when it calls the shortest path Dijkstra function.

.. note::

	The name of the new function must not match any existing function with the same input argument types in the same schema. However, functions of different argument types can share a name (this is called overloading). 

.. rubric:: Dijkstra Wrapper

.. code-block:: sql

	--DROP FUNCTION pgr_dijkstra(varchar,int,int);

	CREATE OR REPLACE FUNCTION pgr_dijkstra(
			IN tbl varchar,
			IN source integer,
			IN target integer,
			OUT seq integer,
			OUT gid integer,
			OUT geom geometry
		)
		RETURNS SETOF record AS
	$BODY$
	DECLARE 
		sql	text;
		rec 	record;
	BEGIN
		seq 	:= 0;
		sql 	:= 'SELECT gid,the_geom FROM ' ||
				'pgr_dijkstra(''SELECT gid as id, source::int, target::int, '  
						|| 'length::float AS cost FROM ' 
						|| quote_ident(tbl) || ''', ' 
						|| quote_literal(source) || ', '  
						|| quote_literal(target) || ' , false, false), '  
					|| quote_ident(tbl) || ' WHERE id2 = gid ORDER BY seq';

		FOR rec IN EXECUTE sql
		LOOP
			seq	:= seq + 1;
			gid     := rec.gid;
			geom	:= rec.the_geom;
			RETURN NEXT;
		END LOOP;
		RETURN;
	END;
	$BODY$
	LANGUAGE 'plpgsql' VOLATILE STRICT; 

.. rubric:: Example query

.. code-block:: sql

	SELECT * FROM pgr_dijkstra('ways',30,60);


Route between lat/lon points and return ordered geometry with heading
-------------------------------------------------------------------------------

The following function takes lat/lon points as input parameters and returns a route that can be displayed in QGIS or WMS services such as Mapserver and Geoserver:

.. rubric:: Input parameters

* Table name
* ``x1``, ``y1`` for start point and ``x2``, ``y2`` for end point

.. rubric::  Output columns

* Sequence (for example to order the results afterwards)
* Gid (for example to link the result back to the original table) 
* Street name
* Heading in degree (simplified as it calculates the Azimuth between start and end node of a link)
* Costs as length in kilometer 
* The road link geometry

What the function does internally:

1. Finds the nearest nodes to start and end point coordinates
2. Runs shortest path Dijkstra query
3. Flips the geometry if necessary, that target node of the previous road link is the source of the following road link
4. Calculates the azimuth from start to end node of each road link
5. Returns the result as a set of records

.. literalinclude:: code/fromAtoB.sql
	:language: sql

What the function does not do:

* It does not restrict the selected road network by BBOX (necessary for large networks)
* It does not return road classes and several other attributes
* It does not take into account one-way streets
* There is no error handling

.. rubric:: Example query

.. code-block:: sql

	SELECT * FROM pgr_fromAtoB('ways',-1.18600,52.96701,-1.11762,52.93691);

To store the query result as a table run

.. code-block:: sql

	CREATE TABLE temp_route AS 
		SELECT * FROM pgr_fromAtoB('ways',-1.18600,52.96701,-1.11762,52.93691);
	--DROP TABLE temp_route;

We can now install this function into the database:

.. code-block:: bash

	psql -U postgres -d pgrouting-workshop ~/Desktop/pgrouting-workshop/data/fromAtoB.sql
