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
As applications requirements become more complex, using previusly defined functions
becomes necessary.

.. contents:: Chapter Contents

Routing from A to B
===============================================================================

The following function takes latituted longitude points as input parameters and returns a
route that can be displayed in QGIS or WMS services such as Mapserver and
Geoserver:

.. rubric:: Input parameters

* Table name
* ``x1``, ``y1`` for start point and ``x2``, ``y2`` for end point

.. rubric::  Output columns

:seq: to order the results afterwards
:gid: The edge identifier that can be used to Join the results to the ``ways`` table
:name: the street name
:azimuth: between start and end node of a and edge
:length: in kilometers
:costs: Costs in minutes
:route_geom: The road geometry with corrected directionality.

What the function does internally:

#. Finds the nearest nodes to start and end point coordinates
#. Executes the function defined in :ref:`Chapter 7, Exercise 9 <Exercise 9 - Function for an application>`
#. Calculates the length in Kilometers
#. Returns the result as a set of records

Ch. 8 Exercise 1
-------------------------------------------------------------------------------


.. literalinclude:: solutions/fromAtoB.sql
  :language: sql
  :start-after: ch8-e1.txt
  :end-before: ch8-e2.txt

:ref:`Solution to Chapter 8 Exercise 1`


Ch. 8 Exercise 2
-------------------------------------------------------------------------------

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
