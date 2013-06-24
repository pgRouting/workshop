.. 
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _wrapper:

Writing a pl/pgsql Wrapper
===============================================================================

Many pgRouting functions provide a "low-level" interface to algorithms and for example return ordered ID's rather than routes with geometries. "Wrapper functions" therefor offer different input parameters as well as transform the returned result into a format, that can be easier read or consumed by applications.

The downside of wrapper functions is, that they often make assumptions that make them only useful for specific use cases or network data. Tgerefor pgRouting has decided to only support low-level functions and let the user write their own wrapper functions for their own use cases.

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
			10, 60, false, false); 


.. rubric:: Result with Geometries

.. code-block:: sql

	SELECT seq, id1 AS node, id2 AS edge, cost, b.the_geom FROM pgr_dijkstra('
			SELECT gid AS id, 
				 source::integer, 
				 target::integer, 
				 length::double precision AS cost 
				FROM ways', 
			10, 60, false, false) a LEFT JOIN ways b ON (a.id2 = b.gid); 

.. note::

	The last record of this JOIN doesn't contain a geometry value since the shortest path function returns ``-1`` for the last record to indicate the end of the route. 


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
					|| quote_ident(tbl) || ' WHERE id2 = gid ';

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

	SELECT * FROM pgr_dijkstra('ways',10,60);

..
	Limit selected network by Bounding Box
	-------------------------------------------------------------------------------

	[TBD]

