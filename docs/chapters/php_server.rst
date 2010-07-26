==============================================================================================================
Server side script with PHP
==============================================================================================================

We will use a PHP script to make the routing query and send the result back to the web client.

The following steps are necessary:

* Retrieve the start and end point coordinates.
* Find the closest edge to start/end point.
* Take either the start or end vertex of this edge (for Dijkstra/ A-Star) or the complete edge (Shooting-Star) as start of the route and end respectively.
* Make the Shortest Path database query.
* Transform the query result to XML or better GeoJSON and send it back to the web client.

Let's start with some PHP template and then place this file in a directory, which is accessible by Apache:

.. literalinclude:: ../../web/php/pgrouting.php
	:language: php
	:lines: 1-18

	  
-------------------------------------------------------------------------------------------------------------
Closest edge
-------------------------------------------------------------------------------------------------------------

Usually the start and end point, which we retrieved from the client, is not the start or end vertex of an edge. It is more convenient to look for the closest edge than for the closest vertex, because Shooting Star algorithm is “edge-based”. For “vertex-based” algorithms (Dijkstra, A-Star) we can choose arbitrary start or end of the selected edge.

.. literalinclude:: ../../web/php/pgrouting.php
	:language: php
	:lines: 20-56
	  
	  
-------------------------------------------------------------------------------------------------------------
Routing query
-------------------------------------------------------------------------------------------------------------

.. literalinclude:: ../../web/php/pgrouting.php
	:language: php
	:lines: 58-116


-------------------------------------------------------------------------------------------------------------
GeoJSON output
-------------------------------------------------------------------------------------------------------------

OpenLayers allows to draw lines directly using GeoJSON format, so our script returns a GeoJSON linestring object:

.. literalinclude:: ../../web/php/pgrouting.php
	:language: php
	:lines: 118-

