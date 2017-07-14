..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

###############################################################################
Writing a pl/pgsql Stored Procedures
###############################################################################

.. image:: /images/route.png
  :width: 250pt
  :align: center

Other kind of functions are `pl/pgsql`.
As applications requirements become more complex, using previously defined functions
becomes necessary.

.. contents:: Chapter Contents

Requierments for Routing from A to B
===============================================================================

The following function takes latitude/longitude points as input parameters and returns a
route that can be displayed in QGIS or WMS services such as Mapserver and
Geoserver:

.. rubric:: Input parameters

* Table name
* ``x1``, ``y1`` for start point and ``x2``, ``y2`` for end point

.. rubric::  Output columns

============= =================================================
column          Description
============= =================================================
*seq*           For ordering purposes
*gid*           The edge identifier that can be used to JOIN the results to the ``ways`` table
*name*          The street name
*azimuth*       between start and end node of a and edge
*length*        In kilometers
*costs*         Costs in minutes
*route_geom*    The road geometry with corrected directionality.
============= =================================================


The Vertex Table
-------------------------------------------------------------------------------

Graphs have a `set of edges` and `set of vertices` associated to it.
`osm2pgrouting` provides the `ways_vertices_pgr` table which is associated with
the `ways` table.
When a subset of `edges` is used like in ``vehicle_net`` or in ``small_net``,
the set of vertices associated to each one must be used in order to, for example,
locate the nearest vertex to a lat/lon location.

Exercise 1: Number of Vertices
...............................................................................


.. rubric:: Calculate the number of vertices in a graph 

* Get the set of vertices of:

  * ways
  * vehicle_net
  * little_net

* Use them to calculate the number of vertices


.. literalinclude:: solutions/fromAtoB.sql
  :language: sql
  :linenos:
  :start-after: ch8-e1.txt
  :end-before: ch8-e2.txt

:ref:`Solution to Chapter 8 Exercise 1`


Exercise 2: Nearest Vertex
...............................................................................

.. rubric:: Calculate the osm_id of the nearest vertex to ``-71.04143, 42.35126``.

* Get the set of vertices of:

  * ways
  * vehicle_net
  * little_net

* Use them to calculate the nearest vertex to ``-71.04143, 42.35126``.

.. literalinclude:: solutions/fromAtoB.sql
  :language: sql
  :linenos:
  :start-after: ch8-e2.txt
  :end-before: ch8-e3.txt

:ref:`Solution to Chapter 8 Exercise 2`

wrk_fromAtoB function
-------------------------------------------------------------------------------

Incorporating all the requirements into the function``wrk_fromAtoB``.
Additionally, it will show the query that is being executed, with the ``NOTICE`` statement.

Exercise 3: Creating the function
...............................................................................

.. rubric:: Create the function ``wrk_fromAtoB``.

.. literalinclude:: solutions/fromAtoB.sql
  :language: sql
  :linenos:
  :start-after: ch8-e3.txt
  :end-before: ch8-e4.txt

:ref:`Solution to Chapter 8 Exercise 3`

.. rubric:: Save the function in the file ``ẁrk_fromAtoB``

Exercise 4: Using the function
...............................................................................

.. literalinclude:: solutions/fromAtoB.sql
  :language: sql
  :linenos:
  :start-after: ch8-e4.txt
  :end-before: ch8-e5.txt

:ref:`Solution to Chapter 8 Exercise 4`

.. note:: A Notice will show while executing the function, for example:
    ::

        NOTICE:
        WITH
        vertices AS (
            SELECT * FROM ways_vertices_pgr
            WHERE id IN (
                SELECT source FROM vehicle_net 
                UNION
                SELECT target FROM vehicle_net)
        ),
        dijkstra AS (
            SELECT *
            FROM wrk_dijkstra(
                'vehicle_net',
                -- source
                (SELECT osm_id FROM vertices 
                    ORDER BY the_geom <-> ST_SetSRID(ST_Point(-71.04136, 42.35089), 4326) LIMIT 1),
                -- target
                (SELECT osm_id FROM vertices
                    ORDER BY the_geom <-> ST_SetSRID(ST_Point(-71.03483, 42.34595), 4326) LIMIT 1))
        )
        SELECT
            seq,
            dijkstra.gid,
            dijkstra.name,
            ways.length_m/1000.0 AS length,
            dijkstra.cost AS the_time,
            azimuth,
            route_geom AS geom
        FROM dijkstra JOIN ways USING (gid);





