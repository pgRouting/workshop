==============================================================================================================
GeoExt Browser Client
==============================================================================================================

GeoExt is a "JavaScript Toolkit for Rich Web Mapping Applications". GeoExt
brings together the geospatial know how of `OpenLayers <http://www.openlayers.org>`_ with
the user interface savvy of `Ext JS <http://www.sencha.com>`_ to help you build powerful desktop
style GIS apps on the web with JavaScript.

Let's start with a simple GeoExt example and extend it with routing functionality then:

.. literalinclude:: ../../web/routing-0.html
	:language: html

In the header we include all the javascript and css needed for the application,
we also define a function to be run when the page is load.

This function creates a `GeoExt.MapPanel
<http://www.geoext.org/lib/GeoExt/widgets/MapPanel.html>`_ with an
OpenStreetMap layer centered to Barcelona. In this code, no OpenLayers.Map is
explicitly created; the GeoExt.MapPanel do this for you: it takes the map object, the
center and the zoom and create a map instance accordingly.

To allow our users to get directions, we need to provide:
 * a way to select the routing algorithm (Shortest path Dijkstra, A* or Shooting*),
 * a way to select the start and final destination.

-------------------------------------------------------------------------------------------------------------
Routing method selection
-------------------------------------------------------------------------------------------------------------

First, we create an html div to display our `Ext.form.ComboBox
<http://www.sencha.com/deploy/dev/docs/?class=Ext.form.ComboBox>`_.

Then we create the combo instance and set all the possible values. The format
is [key, value]: the key will be send to the server and the value displayed in
the combo.

This part only use ExtJS component. 

.. literalinclude:: ../../web/routing-1.html
	:language: html

-------------------------------------------------------------------------------------------------------------
Select the start and final destination
-------------------------------------------------------------------------------------------------------------

Of course, we want to allow the users to draw and move the start and final
destination points. To do that we will need a tool to draw points
(OpenLayers.Control.DrawPoints) and a tool to move points
(OpenLayers.Control.DragPoints). These two controls will a place to draw and
manipluate the points; we will also need a OpenLayers.Layer.Vector.


-------------------------------------------------------------------------------------------------------------
Call the web service
-------------------------------------------------------------------------------------------------------------

We need to call the webservice when:
 * the two points are drawn
 * one of the point is moved 
 * the routing method is changed

-------------------------------------------------------------------------------------------------------------
Draw the route
-------------------------------------------------------------------------------------------------------------



