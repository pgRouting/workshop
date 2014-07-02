.. _ol3:

==============================================================================================================
OpenLayers 3 Browser Client
==============================================================================================================

The goal of this chapter is to create a simple web based user
interface to pgRouting based on OpenLayers 3. The user will be able to
choose the start and destination location of the routing by clicking
on the map.

The general workflow of this application is to wait until we have the
start and destination points, then we send these values to the WMS
server who will query the database for a routing result. The result is
represented as an image by the WMS server and returned to our
application and displayed.

-------------------------------------------------------------------------------------------------------------
OpenLayers 3 introduction
-------------------------------------------------------------------------------------------------------------

OpenLayers 3 is a complete rewrite of OpenLayers 2, it uses modern
javascript and HTML5 technologies such as Canvas and WebGL. 

The new code is based on the `Google Closure Tools
<https://developers.google.com/closure/>`_, this allows us to use a
comprehensive and well-tested library (the Closure Library, also used
to build Gmail, Google Maps and most of the Google web
applications). But the most powerful tool is the Closure Compiler; a
Java based compiler who can remove dead code, optimize and minimize
Javascript. These tools are completely optional for the OpenLayers
library users: they only need to download the compiled code and use
it, that's what we will do now.

Let's explore some key concepts of OpenLayers 3:

At the heart of the library we have the map (``ol.Map`` class),
responsible for managing the layers, the controls, the view and the
renderer.

Each map has a renderer who is responsible to draw the layers into the
HTML element. They are three different type of renderer:

* ``ol.renderer.dom`` a DOM based renderer who uses a grid of html
  img tag. This type of system is also used in OpenLayers 2 or
  Leaflet. This is the slowest and least tested of the renderer,
  don't use it ...
* ``ol.renderer.canvas`` a Canvas based renderer, uses a single
  canvas tag and combine all the tiles from the layers into it. This
  system is also used by the mobile version of HERE from Nokia
  (`http://m.here.com <http://m.here.com>`_).
* ``ol.renderer.webgl`` same as the canvas renderer but uses
  WebGL. WebGL is also used by the new version of Google Maps. At
  the moment only the 2d navigation is supported.

The view (``ol.View`` class) represents what's displayed in the map:
this geographic center of the map, the resolution but also the map
rotation. Unlike others library, these values are separated from the
map object; one advantage is to allows two maps to share the same view
(for example in `this example <http://ol3js.org/en/master/examples/preload.html>`_)

-------------------------------------------------------------------------------------------------------------
Creating a minimal map
-------------------------------------------------------------------------------------------------------------

Let's start our first OpenLayers 3 map: open a text editor and copy
this code into a file named ``ol3.html``. You can save this file into
the Desktop and open it with a web browser.

.. literalinclude:: ../../web/ol3-routing-base.html
    :language: html
    :linenos:


This code displays a map with an OpenStreetMap layer centered to a predefined location.

At the moment there's not routing related code; only standard navigation.

Line by line we have:
  * line 6: include the default OpenLayers CSS file.
  * line 8 to 11: give the map a size: 400px height and the entire page width.
  * line 13: include the OpenLayers code. All the functions and javascript classes starting with ``ol`` comes from there.
  * line 16: create a div with a ``ol-map`` identifier. The map will be displayed inside this div.

The rest of the file (inside the ``script`` tag) will contain our javascript code to query the server
for a routing and display the result.

Once the page is open in a web browser, try to open the javascript
console and interact with the ``map`` object:

.. code-block:: js

  map.getView().getCenter();
  map.getView().setCenter([-29686, 6700403]);

  map.getView().setRotation(Math.PI);


.. note:: If you inspect an OpenLayers object using the console, you can see that most of the properties and
 functions have a short (and cryptic) name; that's because the Google Closure Compiler renames the original
 names. The goal of this compilation is to product the smaller library as possible.

-------------------------------------------------------------------------------------------------------------
WMS GET parameters
-------------------------------------------------------------------------------------------------------------

Add this code a the end of the ``script`` tag:

.. code-block:: js

  var params = {
    LAYERS: 'pgrouting:pgrouting',
    FORMAT: 'image/png'
  };

The ``params`` object holds the WMS GET parameters that will be sent
to GeoServer. Here we set the values that will never change: the layer
name and the output format.

-------------------------------------------------------------------------------------------------------------
Select the start and final destination
-------------------------------------------------------------------------------------------------------------

We want to allow the users to set the start and destination position by clicking on the map.

Add this code a the end of the ``script`` tag:

.. code-block:: js

  var startPoint = new ol.Feature();
  var finalPoint = new ol.Feature();
  new ol.FeatureOverlay({features: [startPoint, finalPoint], map: map});

It's creates a feature overlay with two points, which get a reference to the map because they need to update their position according
to the view (in short: they move when the map moves).

Add this code a the end of the ``script`` tag:

.. code-block:: js

  var transform = ol.proj.getTransform('EPSG:3857', 'EPSG:4326');

  map.on('click', function(event) {

    if (startPoint.getGeometry() == null) {
      // first click
      startPoint.setGeometry(new ol.geom.Point(event.coordinate));
    } 
    
    else if (finalPoint.getGeometry() == null) {
      // second click
      finalPoint.setGeometry(new ol.geom.Point(event.coordinate));

      // transform the coordinates from the map projection (EPSG:3857)
      // into the server projection (EPSG:4326)
      var startCoord = transform(startPoint.getGeometry().getCoordinates());
      var finalCoord = transform(finalPoint.getGeometry().getCoordinates());
      var viewparams = [
        'x1:' + startCoord[0], 'y1:' + startCoord[1],
        'x2:' + finalCoord[0], 'y2:' + finalCoord[1]
      ];
      params.viewparams = viewparams.join(';');

      // we now have the two points, create the result layer and add it to the map
      result = new ol.layer.Image({
        source: new ol.source.ImageWMS({
          url: 'http://localhost:8082/geoserver/pgrouting/wms',
          params: params
        })
      });
      map.addLayer(result);
    }
  });

When the map is clicked, this function is executed. The geographical
position of the cursor is stored into the feature objects and shows them on the map

Once we have the start and destination points (after two clicks); the
two pairs of coordinates are transformed from the map projection
(``EPSG:3857``) into the server projection (``EPSG:4326``) using the
``transform`` function.

The ``viewparams`` property is set on WMS GET parameters object. The value
of this property has a special meaning: GeoServer will substitute the
value before executing the SQL query for the layer. For example, if we
have:

.. code-block:: sql

  SELECT * FROM ways WHERE maxspeed_forward BETWEEN %min% AND %max%

And ``viewparams`` is ``viewparams=min:20;max:120`` then the query
sent to PostGIS will be:

.. code-block:: sql

  SELECT * FROM ways WHERE maxspeed_forward BETWEEN 20 AND 120

Finally, a new OpenLayers WMS layer is created and added to the map,
the param object is passed to it.

-------------------------------------------------------------------------------------------------------------
Clear the results
-------------------------------------------------------------------------------------------------------------

Add this code between the map's html ``div`` and the ``script`` tag:

.. code-block:: html

  <button id="clear">clear</button>

This create a button to allow the user to clear the routing points and
start a new routing query.

Add this code a the end of the ``script`` tag:

.. code-block:: js

  document.getElementById('clear').addEventListener('click', function(event) {
    // hide the overlays
    startPoint.setGeometry(null);
    finalPoint.setGeometry(null);

    // remove the result layer
    map.removeLayer(result);
  });

When the button is clicked, this function is executed. The routing
points and the result layer are hidden.
