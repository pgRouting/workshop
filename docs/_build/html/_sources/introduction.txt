Introduction
==============================================================================================================

pgRouting adds routing functionality to PostGIS. This introductory workshop will show you how. It gives a practical example of how to use pgRouting with OpenStreetMap road network data. It explains the steps to prepare the data, make routing queries, assign costs and use GeoExt to show your route in a web-mapping application.

Navigation for road networks requires complex routing algorithms that support turn restrictions and even time-dependent attributes. pgRouting is an extendible open-source library that provides a variety of tools for shortest path search as extension of PostgreSQL and PostGIS. The workshop will explain about shortest path search with pgRouting in real road networks and how the data structure is important to get faster results. Also you will learn about difficulties and limitations of pgRouting in GIS applications.

To give a practical example the workshop makes use of OpenStreetMap data of Barcelona. You will learn how to convert the data into the required format and how to calibrate the data with "cost" attributes. Furthermore we will explain the difference of the main routing algorithms "Dijkstra", "A-Star" and "Shooting-Star". By the end of the workshop you will have a good understanding of how to use pgRouting and how to get your network data prepared.

To learn how to get the output from rows and columns to be drawn on a map, we will build a basic map GUI with GeoExt. We listened to the students feedback of the last year's and want to guide you through the basic steps to build a simple browser application. Our goal is to make this as easy as possible, and to show that it's not difficult to integrate with other FOSS4G tools. For that reason we selected GeoExt, which is a JavaScript library providing the groundwork for creating web-mapping applications based on OpenLayers and Ext.

presenter
-------------------------------------------------------------------------------------------------------------

D. Kastl (Georepublic), F. Junod (Camptocamp).

Daniel Kastl is founder and CEO of Georepublic UG and works in Germany and Japan. He is moderating and promoting the pgRouting community and development since 4 years, and he's an active OSM contributor in Japan.
Frédéric Junod works at the Swiss office of Camptocamp for about five years. He's an active developer of many open source GIS projects from the browser (GeoExt, OpenLayers) to the server world (MapFish, Shapely, TileCache).
Daniel and Frédéric are the auhtors of the previous pgRouting workshops, that have been held at FOSS4G events in Canada and South Africa and at local conferences in Japan.

workshop level
-------------------------------------------------------------------------------------------------------------

intermediate


attendee's previous knowledge
-------------------------------------------------------------------------------------------------------------

SQL (PostgreSQL, PostGIS), Javascript, HTML


equipments
-------------------------------------------------------------------------------------------------------------

This workshops will make use of the GIS LiveDVD if possible. Otherwise it will require VirtualBox installed to load a virtual machine image.
