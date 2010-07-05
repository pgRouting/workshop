==============================================================================================================
Server side scripts with PHP
==============================================================================================================

We will use a PHP script to make the routing query and send the result back to the web client.

The following steps are necessary:

Retrieve the start and end point coordinates.
Find the closest edge to start/end point.
Take either the start or end vertex of this edge (for Dijkstra/ A-Star) or the complete edge (Shooting-Star) as start of the route and end respectively.
Make the Shortest Path database query.
Transform the query result to XML and send it back to the web client.


