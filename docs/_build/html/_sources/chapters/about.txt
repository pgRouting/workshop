About
==============================================================================================================

.. todo:: 

   introduction paragraph for about


pgRouting
-------------------------------------------------------------------------------------------------------------

pgRouting is an extension of PostGIS and adds routing functionality to PostGIS/PostgreSQL. pgRouting is a further development of pgDijkstra (by Camptocamp). It is currently developed and maintained by Orkney, JAPAN.

pgRouting provides functions for:

* Shortest Path Dikstra: routing algorithm without heuristics
* Shortest Path A-Star: routing for large datasets (with heuristics)
* Shortest Path Shooting-Star: routing with turn restrictions (with heuristics)
* Traveling Salesperson Problem (TSP)
* Driving Distance calculation (Isolines)

Advantages of the database routing approach are:

* Accessible by multiple clients through JDBC, ODBC, or directly using Pl/pgSQL. The clients can either be PCs or mobile devices.
* Uses PostGIS for its geographic data format, which in turn uses OGC's data format Well Konwn Text (WKT) and Well Known Binary (WKB). This allows usage of existing open * data converters.
* Open Source software like qGIS and uDig can modify the data/attributes,
* Data changes can be reflected instantaneously through the routing engine. There is no need for precalculation.
* The "cost" parameter can be dynamically calculated through SQL and its value can come from multiple fields or tables.

pgRouting project website: http://www.pgrouting.org


OpenStreetMap
-------------------------------------------------------------------------------------------------------------

"OpenStreetMap is a project aimed squarely at creating and providing free geographic data such as street maps to anyone who wants them." "The project was started because most maps you think of as free actually have legal or technical restrictions on their use, holding back people from using them in creative, productive or unexpected ways." [Source: http://wiki.openstreetmap.org/index.php/Press]

OpenStreetMap uses a topological data structure:

* Nodes are points with a geographic position.
* Ways are lists of nodes, representing a polyline or polygon.
* Relations are groups of nodes, ways and other relations which can be assigned certain properties.
* Tags can be applied to nodes, ways or relations and consist of name=value pairs.
* This is how nodes, ways and relations are described in the OpenStreetMap XML file:


.. literalinclude:: code/about_osm_sample.osm


The OSM data can be downloaded from OpenStreetMap website using an API (see  http://wiki.openstreetmap.org/index.php/OSM_Protocol_Version_0.5), or with some other OSM tools, for example JOSM editor.

Update: CloudMade offers extracts of maps from different places around the world. For South Africa go to  http://download.cloudmade.com/africa/south_africa

Note: The API has a download size limitation, which can make it a bit inconvenient to download extensive areas with many features.


osm2pgrouting
-------------------------------------------------------------------------------------------------------------

When using the osm2pgrouting converter (see later), we take only nodes and ways of types and classes specified in "mapconfig.xml" file to be converted to pgRouting table format:


.. literalinclude:: code/mapconfig_sample.xml


Detailed description of all possible types and classes can be found here:  http://wiki.openstreetmap.org/index.php/Map_features.

For Cape Town the OpenStreetMap data is very comprehensive with many details. A compilation of the greater Cape Town area created with JOSM is available as capetown_20080829.osm.

GeoExt
-------------------------------------------------------------------------------------------------------------

< TODO: GeoExt paragraph >

