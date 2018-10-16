..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

.. _openlayers:

OpenLayers Based Routing Interface
===============================================================================

The goal of this chapter is to create a simple web-based user interface to
pgRouting based on OpenLayers. The user will be able to choose start and
destination locations, and get the route from the start point to the destination
point.

The start and destination points are created by the user, with simple clicks on
the map. The start and destination coordinates are then sent to the WMS server
(GeoServer), as parameters to a WMS ``GetMap`` request. The resulting image is
added as an *image* layer to the map.

OpenLayers introduction
-------------------------------------------------------------------------------

OpenLayers uses modern JavaScript, and HTML5 technologies such as Canvas and
WebGL for the rendering of images/tiles and vectors.

Creating an OpenLayers map in a web page involves creating a *map* object,
which is an instance of the ``ol.Map`` class. Then, data layers and controls can
be added to that map object.

The center and resolution (zoom level) of the map are controlled through the
*view* object. Unless other mapping libraries, the view is separated from the
map; one advantage is to allow multiple maps to share the same view. See `this
example <http://openlayers.org/en/master/examples/preload.html>`_.

OpenLayers features three renderers: the *Canvas* renderer, the *WebGL*
renderer, and the *DOM* renderer. Currently, the most capable renderer is
Canvas. In particular the Canvas renderer supports vector layers, while the
other two don't. Canvas is the default renderer, and the renderer used in this
workshop.

Creating a minimal map
-------------------------------------------------------------------------------

Let's create our first OpenLayers map: open a text editor and copy this code
into a file named ``ol3.html``. You can save this file on the ``Desktop`` and
open it with a web browser.

.. literalinclude:: code/ol3-routing-base.html
  :language: html

.. note::
  This workshop assumes, that you use OSGeo Live, which includes the OpenLayers
  Javascript library accessible under the following URL: http://localhost/ol3/dist/
  If you don't use OSGeo Live for this workshop, you need to adjust the URL to
  OpenLayers Javascript and CSS file.

This web page includes a simple map with an OpenStreetMap layer and center to a
predifined location. There is no routing-related code for now; just a simple map
with stantard navigation tools.

Line by line we have:

* Line 6: include the default OpenLayers CSS file.
* Line 7 to Line 12: CSS rules to give dimensions to the map DOM element.
* Line 15: add a div element for the map. The element's identifier is ``map``.
* Line 16: load the OpenLayers library code. Functions and classes in the
  ``ol`` namespace come from there.
* Line 18 to Line 29: the JavaScript code specific to that example.

Let's have a closer look at the code that create the OpenLayers code:

.. code-block:: javascript

  var map = new ol.Map({
    target: 'map',
    layers: [
      new ol.layer.Tile({
        source: new ol.source.OSM()
      })
    ],
    view: new ol.View({
      center: ol.proj.transform([7.1192, 50.7149], 'EPSG:4326', 'EPSG:3857'),
      zoom: 13
    }),
    controls: ol.control.defaults({
      attributionOptions: {
        collapsible: false
      }
    })
  });

This code creates an ``ol.Map`` instance whose ``target`` is the ``map`` DOM
element in the HTML page. The map is configured with a *tile layer*, itself
configured with an OpenStreetMap *source*. The map is also configured with a
*view* instance (of the ``ol.View`` class) with predefined values for the
*center* and the *zoom* level.

WMS GET parameters
-------------------------------------------------------------------------------

Add this code after the creation of the map:

.. code-block:: javascript

  var params = {
    LAYERS: 'pgrouting:pgrouting',
    FORMAT: 'image/png'
  };

The ``params`` object holds the WMS GET parameters that will be sent to
GeoServer. Here we set the values that will never change: the layer name and the
output format.


Select "start" and "destination"
-------------------------------------------------------------------------------

We now want to allow the user to add the start and destination positions by
clicking on the map. Add the following code for that:

.. code-block:: javascript

  // The "start" and "destination" features.
  var startPoint = new ol.Feature();
  var destPoint = new ol.Feature();

  // The vector layer used to display the "start" and "destination" features.
  var vectorLayer = new ol.layer.Vector({
    source: new ol.source.Vector({
      features: [startPoint, destPoint]
    })
  });
  map.addLayer(vectorLayer);

That code creates two vector features, one for the "start" position and one for
the "destination" position. These features are empty for now – they do not
include a geometry.

The code also creates a vector layer, with the "start" and "destination"
features added to it. It also adds the vector layer to the map, using the map's
``addLayer`` method.

Now add the following code:

.. code-block:: js

  // A transform function to convert coordinates from EPSG:3857
  // to EPSG:4326.
  var transform = ol.proj.getTransform('EPSG:3857', 'EPSG:4326');

  // Register a map click listener.
  map.on('click', function(event) {
    if (startPoint.getGeometry() == null) {
      // First click.
      startPoint.setGeometry(new ol.geom.Point(event.coordinate));
    } else if (destPoint.getGeometry() == null) {
      // Second click.
      destPoint.setGeometry(new ol.geom.Point(event.coordinate));
      // Transform the coordinates from the map projection (EPSG:3857)
      // to the server projection (EPSG:4326).
      var startCoord = transform(startPoint.getGeometry().getCoordinates());
      var destCoord = transform(destPoint.getGeometry().getCoordinates());
      var viewparams = [
        'x1:' + startCoord[0], 'y1:' + startCoord[1],
        'x2:' + destCoord[0], 'y2:' + destCoord[1]
      ];
      params.viewparams = viewparams.join(';');
      result = new ol.layer.Image({
        source: new ol.source.ImageWMS({
          url: 'http://localhost:8082/geoserver/pgrouting/wms',
          params: params
        })
      });
      map.addLayer(result);
    }
  });

This code registers a listener function for the map ``click`` event. This means
that OpenLayers will call that function each time a click is detected on the
map.

The event object passed to the listener function includes a ``coordinate``
property that indicates the geographical location of the click. That coordinate
is used to create a *point* geometry for the "start" and "destination" features.

Once we have the start and destination points (after two clicks); the two pairs
of coordinates are transformed from the map projection (``EPSG:3857``) into the
server projection (``EPSG:4326``) using the ``transform`` function.

The ``viewparams`` property is then set on WMS GET parameters object. The value
of this property has a special meaning: GeoServer will substitute the value
before executing the SQL query for the layer. For example, if we have:

.. code-block:: sql

  SELECT * FROM ways WHERE maxspeed_forward BETWEEN %min% AND %max%

And ``viewparams`` is ``viewparams=min:20;max:120`` then the SQL query sent to
PostGIS will be:

.. code-block:: sql

  SELECT * FROM ways WHERE maxspeed_forward BETWEEN 20 AND 120

Finally, a new OpenLayers WMS layer is created and added to the map, the param
object is passed to it.

Clear the results
-------------------------------------------------------------------------------

Add this after the map ``div`` in the HTML page:

.. code-block:: html

  <button id="clear">clear</button>

This creates a button to we will use to allow the user to clear the routing
points and start a new routing query.

Now add the following to the JavaScript code:

.. code-block:: js

  var clearButton = document.getElementById('clear');
  clearButton.addEventListener('click', function(event) {
    // Reset the "start" and "destination" features.
    startPoint.setGeometry(null);
    destPoint.setGeometry(null);
    // Remove the result layer.
    map.removeLayer(result);
  });

When the button is clicked, this function passed to ``addEventListener`` is
executed. That function resets the "start" and "destination" features and remove
the routing result layer from the map.

Summary (full example)
-------------------------------------------------------------------------------

Now copy the following final application code into a file, accessible by a
webserver, such as Apache or Nginx for example:

.. literalinclude:: code/ol3-routing-final.html
  :language: html
