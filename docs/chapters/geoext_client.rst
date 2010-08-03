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
we also define a function to be run when the page is loaded (Ext.onReady).

This function creates a `GeoExt.MapPanel
<http://www.geoext.org/lib/GeoExt/widgets/MapPanel.html>`_ with an
OpenStreetMap layer centered to Barcelona. In this code, no OpenLayers.Map is
explicitly created; the GeoExt.MapPanel do this under the hood: it takes the map options, the
center and the zoom and create a map instance accordingly.

To allow our users to get directions, we need to provide:
 * a way to select the routing algorithm (Shortest path Dijkstra, A* or Shooting*),
 * a way to select the start and final destination.

-------------------------------------------------------------------------------------------------------------
Routing method selection
-------------------------------------------------------------------------------------------------------------

To select the routing method, we will use an `Ext.form.ComboBox
<http://www.sencha.com/deploy/dev/docs/?class=Ext.form.ComboBox>`_: it's
behaves just like an html select but we can more easily control it.

Just like the GeoExt.MapPanel, we need an html element to place our control,
let's create a new div in the body with 'method' as id:

 .. code-block:: html

   <body>
     <div id="gxmap"></div>
     <div id="method"></div>
   </body>

Then we create the combo and bind the html element via the renderTo option:
 .. code-block:: js

   var method = new Ext.form.ComboBox({
       renderTo: "method",
       triggerAction: "all",
       editable: false,
       forceSelection: true,
       store: [
           ["SPD", "Shortest Path Dijkstra"],
           ["SPA", "Shortest Path A*"],
           ["SPS", "Shortest Path Shooting*"]
       ]
   });

In the ``store`` option, we set all the possible values for the routing method;
the format is an array of options where an option is in the form ``[key, name]``.
The ``key`` will be send to the server (the php script in our case) and the
``value`` displayed in the combo.

The ``renderTo`` specify where the combo must be rendered, we use our new div here.

And finally, a default value is selected:
 .. code-block:: js

    method.setValue("SPD")

This part only use ExtJS component: no OpenLayers or GeoExt code here.

-------------------------------------------------------------------------------------------------------------
Select the start and final destination
-------------------------------------------------------------------------------------------------------------

We want to allow the users to draw and move the start and final destination
points. This is more or less the behavior of google maps and others: the user
selects the points via a search box (address search) or by clicking the map,
then it's possible to update the points positions by dragging markers.

In this workshop, we will only implement the input via the map (draw points and
drag-and-drop) but it's possible to implement the search box feature by using a
web service like `GeoNames <http://www.geonames.org/>`_ or any other `geocoding
<http://en.wikipedia.org/wiki/Geocoding>`_ service.

To do this we will need a tool to draw points (we will use the
`OpenLayers.Control.DrawFeatures
<http://openlayers.org/dev/examples/draw-feature.html>`_ control) and a tool to
move points (`OpenLayers.Control.DragFeatures
<http://openlayers.org/dev/examples/drag-feature.html>`_ will be perfect for
this job). (As their name suggests these controls comes from OpenLayers)

But these two controls will need a place to draw and manipluate the points; we
will also need an `OpenLayers.Layer.Vector
<http://dev.openlayers.org/releases/OpenLayers-2.9/doc/apidocs/files/OpenLayers/Layer/Vector-js.html>`_
layer. In OpenLayers, a vector layer in a place where features (geometry +
attributes) can be drawn programmatically: in our case, the points are
features. Because vector layers are cheap, we will use a second one to draw the
route returned by the web service.

Let's look at the control to draw the points: because this component has
special behavior it's more easy to create a new class based on the standard
OpenLayers.Control.DrawFeatures control. This new control (named DrawPoints) is
saved in a separated javascript file (``web/DrawPoints.js``):

.. literalinclude:: ../../web/DrawPoints.js
	:language: js

In the ``initialize`` function (that's the class constructor) we set that
this control can only draw points (handler variable).

The special behavior is implemented in the ``drawFeature`` function: because we
only need the start and final points the control deactivates itself when two
points are drawn (``this.deactivate()``).

-------------------------------------------------------------------------------------------------------------
Call and receive data from web service
-------------------------------------------------------------------------------------------------------------

The basic workflow to get a route from the web server is:

#. transform our points coordinates from EPSG:900913 to EPSG:4326
#. call the webservice with the correct arguments (method and two points)
#. parse the web service response: transform GeoJSON to OpenLayers.Feature.Vector
#. transform the result from EPSG:4326 to EPSG:900913
#. add this result to a vector layer

The first item is something new: our map uses the EPSG:900913 projection
(because we use an OSM layer) but the web service expects coordinates in
EPSG:4326: we have to re-project the data before sending. This is not a
big deal: we simple use the `Proj4js <http://trac.osgeo.org/proj4js/>`_
javascript library.

(The second item is covered in the next chapter.)

The routing web service in pgrouting.php returns a `GeoJSON
<http://geojson.org/>`_ FeatureCollection: this is very convenient because
OpenLayers and GeoExt have all what we need to handle this format. To make our
live even easier, we are going to use the GeoExt.data.FeatureStore:

 .. code-block:: js

    var store = new GeoExt.data.FeatureStore({
        layer: route_layer,
        proxy: new GeoExt.data.ProtocolProxy({
            protocol: new OpenLayers.Protocol.HTTP({
                url: '/pgrouting-workshop/php/pgrouting.php',
                format: new OpenLayers.Format.GeoJSON({
                    internalProjection: epsg_900913,
                    externalProjection: epsg_4326
                })
            })
        })
    });

Let's explain the options:

``layer``: the argument is a vector layer: by specifying a layer, the
FeatureStore will automatically draw the data received into this this
layer. This is exactly what we need for the last item ("add this result to a
vector layer") in the list above.

``proxy``: the proxy item specify where the data should be taken: in our case
from a HTTP server. The proxy type is GeoExt.data.ProtocolProxy: this class
connects the ExtJS world (the store) and the OpenLayers world (the protocol
object).

``protocol``: this OpenLayers component is able to make HTTP requests to an ``url``
(our php script) and to parse the response (``format`` option). By adding the
``internalProjection`` and ``externalProjection`` option, the coordinates
re-projection in made by the format.

We now have all what we need to handle the route from the web service: the next
chapter will explain how and when to call the service.

-------------------------------------------------------------------------------------------------------------
Trigger the web service call
-------------------------------------------------------------------------------------------------------------

We need to call the webservice when:
 * the two points are drawn
 * one of the point is moved
 * the routing method has changed

Our vector layer (draw_layer) generates an event (called featureadded) when a
new feature is added, we can listen to this event and call to pgrouting function:

 .. code-block:: js

    draw_layer.events.on({
        featureadded: function() {
            pgrouting(store, draw_layer, method);
        }
    });

No event is generated when a point is moved but hopefully we can give a
function to the DragFeature control to be called we the point is moved:

 .. code-block:: js

    drag_points.onComplete = function() {
        pgrouting(store, draw_layer, method);
    };

For the 'method' combo, we can add a listeners options to the constructor with
a 'select' argument (that's the event name):

 .. code-block:: js

    var method = new Ext.form.ComboBox({
        renderTo: "method",
        triggerAction: "all",
        editable: false,
        forceSelection: true,
        store: [
            ["SPD", "Shortest Path Dijkstra"],
            ["SPA", "Shortest Path A*"],
            ["SPS", "Shortest Path Shooting*"]
        ],
        listeners: {
            select: function() {
                pgrouting(store, draw_layer, method);
            }
    });

#FIXME
The pgrouting function handle the call to the web service through the
store. The function check if we have the two points and call store.removeAll();
this will erase the a previous result from the map.
Then the function format the arguments and call store.load will all the parameters.



-------------------------------------------------------------------------------------------------------------
Draw the route
-------------------------------------------------------------------------------------------------------------

