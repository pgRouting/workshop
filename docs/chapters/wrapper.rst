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

.. image:: images/route.png
    :width: 250pt
    :align: center

pgRouting functions provide a "low-level" interface to algorithms and return ordered indentifiers rather than routes with geometries.
Creating a complex queries, views or wrapper functions, can be used to connect to a high level application.

.. note::

    pgRouting only supports low-level functions and it is the user responiblility to write their own wrapper functions for their own use cases.

Just considering the different ways that the `cost` can be calculated makes almost imposible to create a general wrapper that can work on all applications.

* The data might come from a source that is not osm.
* The column names might be in other language than english.

The following wrappers are examples for common transformations:

* :ref:`w-11` Route geometry (human reading).
* :ref:`w-12` Route geometry.
* :ref:`w-13` Route geometry for arrows.

.. note::
    * For this chapter, all the examples will return a human readable geometry for analysis, except :ref:`w-12`.
    * `PostGIS documentation <http://postgis.net/documentation>`_


.. _w-11:

Exercise 11
..............................................

.. rubric:: Route geometry (human reading)

Driver A: '“I am in vertex 13224 and want to drive to vertex 6549. Include the geometry of the segments."

.. rubric:: Problem description

* The driver wants to go from vertex 13224 to vertex 6549.
* The driver’s cost is in terms of seconds.
* Include the geometry of the path in human readable form.

.. rubric:: literal include querty Path Dijkstra

.. literalinclude:: solutions/wrapper_problems.sql
    :language: sql
    :start-after: w-11.txt
    :end-before: w-12.txt

.. rubric:: Shortest Path Dijkstra

:ref:`sol-w-11` Route with network geometry.

.. note::
    * The last record of the query doesn't contain a geometry value since the shortest path function returns ``-1`` for the last record to indicate the end of the route.

.. _w-12:

Exercise 12
..............................................

.. rubric:: Route geometry

Driver A: '“I am in vertex 13224 and want to drive to vertex 6549. Include the geometry of the segments."

.. rubric:: Problem description

* The driver wants to go from vertex 13224 to vertex 6549.
* The driver’s cost is in terms of seconds.
* Include the geometry of the path in non human readable form.

.. rubric:: Query

.. literalinclude:: solutions/wrapper_problems.sql
    :language: sql
    :start-after: w-12.txt
    :end-before: w-13.txt


.. rubric:: Query Results

:ref:`sol-w-12`

.. note::
    * Just removing `ST_AsText` from the **human readable form**


.. _w-13:

Exercise 13
..............................................

.. rubric:: Route geometry for arrows

Driver A: '“I am in vertex 13224 and want to drive to vertex 6549. Include the geometry of the segments."

.. rubric:: Problem description

* The driver wants to go from vertex 13224 to vertex 6549.
* The driver’s cost is in terms of seconds.
* Include the geometry of the path in human readable form.
* The first point of the segment must "match" with the last point of the previous segment"

.. rubric:: Query

.. literalinclude:: solutions/wrapper_problems.sql
    :language: sql
    :start-after: w-13.txt
    :end-before: w-14.txt

.. rubric:: Query Results

:ref:`sol-w-13`

* Comparing row 1 & 2 from :ref:`sol-w-11`

.. code-block:: sql

      -- from Exercise 11
      LINESTRING(7.1234212 50.7172365,7.1220583 50.7183785)
      LINESTRING(7.1250564 50.7179702,7.1244554 50.7176698,7.1235463 50.7172858,7.1234212 50.7172365)

      -- from Excercise 13
      LINESTRING(7.1220583 50.7183785,7.1234212 50.7172365)
      LINESTRING(7.1234212 50.7172365,7.1235463 50.7172858,7.1244554 50.7176698,7.1250564 50.7179702)

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
        sql text;
        rec     record;
    BEGIN
        seq     := 0;
        sql     := 'SELECT gid,the_geom FROM ' ||
                'pgr_dijkstra(''SELECT gid as id, source::int, target::int, '  
                        || 'length::float AS cost FROM ' 
                        || quote_ident(tbl) || ''', ' 
                        || quote_literal(source) || ', '  
                        || quote_literal(target) || ' , false, false), '  
                    || quote_ident(tbl) || ' WHERE id2 = gid ORDER BY seq';

        FOR rec IN EXECUTE sql
        LOOP
            seq := seq + 1;
            gid     := rec.gid;
            geom    := rec.the_geom;
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

    SELECT * FROM pgr_fromAtoB('ways',-122.662,45.528,-122.684,45.514);

To store the query result as a table run

.. code-block:: sql

    CREATE TABLE temp_route AS 
        SELECT * FROM pgr_fromAtoB('ways',-122.662,45.528,-122.684,45.514);
    --DROP TABLE temp_route;

We can now install this function into the database:

.. code-block:: bash

    psql -U user -d pgrouting-workshop -f ~/Desktop/pgrouting-workshop/data/fromAtoB.sql
