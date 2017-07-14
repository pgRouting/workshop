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
  :start-after: ch8-e2.txt
  :end-before: ch8-e3.txt

:ref:`Solution to Chapter 8 Exercise 2`


Ch. 8 Exercise 3
-------------------------------------------------------------------------------

.. literalinclude:: solutions/fromAtoB.sql
  :language: sql
  :start-after: ch8-e3.txt
  :end-before: ch8-e4.txt

:ref:`Solution to Chapter 8 Exercise 3`


Ch. 8 Exercise 4
-------------------------------------------------------------------------------

.. literalinclude:: solutions/fromAtoB.sql
  :language: sql
  :start-after: ch8-e4.txt
  :end-before: ch8-e5.txt

:ref:`Solution to Chapter 8 Exercise 4`

Past
-----------------------------
To store the query result as a table run

.. code-block:: sql

	CREATE TABLE temp_route AS
		SELECT * FROM pgr_fromAtoB('ways',7.1192,50.7149,7.0979,50.7346);
	--DROP TABLE temp_route;

Save the function code above into a file ``~/Desktop/workshop/fromAtoB.sql``.
We can then install this function into the database with:

.. code-block:: bash

	psql -U user -d city_routing -f ~/Desktop/workshop/fromAtoB.sql
