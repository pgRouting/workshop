..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

.. _fromAtoB:

Routing from A to B (function)
===============================================================================


Route between lat/lon points and return ordered geometry with heading
-------------------------------------------------------------------------------

The following function takes lat/lon points as input parameters and returns a
route that can be displayed in QGIS or WMS services such as Mapserver and
Geoserver:

.. rubric:: Input parameters

* Table name
* ``x1``, ``y1`` for start point and ``x2``, ``y2`` for end point

.. rubric::  Output columns

* Sequence (for example to order the results afterwards)
* Gid (for example to link the result back to the original table)
* Street name
* Heading in degree (simplified as it calculates the Azimuth between start and
  end node of a link)
* Costs as length in kilometer
* The road link geometry

What the function does internally:

1. Finds the nearest nodes to start and end point coordinates
2. Runs shortest path Dijkstra query
3. Flips the geometry if necessary, that target node of the previous road link
   is the source of the following road link
4. Calculates the azimuth from start to end node of each road link
5. Returns the result as a set of records

.. _exercise-19:

.. literalinclude:: solutions/fromAtoB.sql
  :language: sql
  :start-after: atob-2.txt
  :end-before: atob-3.txt


What the function does not do:

* It does not restrict the selected road network by BBOX (necessary for large
  networks)
* It does not return road classes and several other attributes
* It does not take into account one-way streets
* There is no error handling

.. rubric:: Example query

.. literalinclude:: solutions/fromAtoB.sql
  :language: sql
  :start-after: atob-3.txt
  :end-before: ROLLBACK


:ref:`sol-19`

To store the query result as a table run

.. code-block:: sql

	CREATE TABLE temp_route AS
		SELECT * FROM pgr_fromAtoB('ways',7.1192,50.7149,7.0979,50.7346);
	--DROP TABLE temp_route;

Save the function code above into a file ``~/Desktop/workshop/fromAtoB.sql``.
We can then install this function into the database with:

.. code-block:: bash

	psql -U user -d city_routing -f ~/Desktop/workshop/fromAtoB.sql
