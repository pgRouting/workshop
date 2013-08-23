==============================================================================================================
OpenLayers 3 Browser Client
==============================================================================================================

What's the goal of this chapter and what will be the final result?

OpenLayers 3 quick introduction:
  * ol2 / ol3 differences
  * Google Closure Compiler
  * WebGL
  * website / google groups
  * current and planned features (vector)

-------------------------------------------------------------------------------------------------------------
Creating a minimal map
-------------------------------------------------------------------------------------------------------------

FIXME: copy and paste this code into xxx ?

.. literalinclude:: ../../web/ol3-routing-base.html
    :language: html
    :linenos:

FIXME: open a web browser at `yyy <http://localhost/>`_

This code displays a map with an OpenStreetMap layer centered to FIXME.
At the moment there's not routing related code; only standard navigation.

Line by line we have:
  * line 6: include the default OpenLayers CSS file.
  * line 8 to 11: give the map a size: 400px height and the entire page width.
  * line 13: include the OpenLayers code. Add the function and javascript classes starting with ``ol`` comes from there.
  * line 16: create a div with a ``ol-map`` identifier. The map will be displayed inside this div.

The rest of the file (inside the ``script`` tag) will contain our javascript code to query the server
for a routing and display the result.

FIXME:
  * what's a layer?
  * what's a source?
  * what's a 2d view?


FIXME: open up the browser's console and play the map object:

.. code-block:: js

  map.getView().getCenter();
  map.getView().setCenter([-29686, 6700403]);

  map.getView().setRotation(Math.PI);


Note: If you inspect an OpenLayers object using the console, you can see that most of the properties and
functions have a short (and cryptic) name; that's because the Google Closure Compiler renames the original
names. The goal of this compilation is to product the smaller library as possible.

-------------------------------------------------------------------------------------------------------------
Displaying the routing result
-------------------------------------------------------------------------------------------------------------

Add this code a the end of the ``script`` tag:

.. code-block:: js

  var params = {
    FORMAT: 'image/png',
    METHOD: 'SPD'
  };

  var result = new ol.layer.ImageLayer({
    visible: false,
    source: new ol.source.SingleImageWMS({
      url: 'http://localhost',
      params: params
    })
  });
  map.addLayer(result);

The routing result is displayed as a single WMS image. We could have display it a as a GeoJSON but (FIXME)
The ``params`` object holds the WMS GET parameters.

The layer starts initially hidden; it will be shown when we have the start and final positions.

-------------------------------------------------------------------------------------------------------------
Routing method selection
-------------------------------------------------------------------------------------------------------------

Add this code between the map ``div`` and the ``script`` tag:

.. code-block:: html

  <select id="algorithm">
    <option value="SPD" selected>Shortest Path Dijkstra</option>
    <option value="SPA">Shortest Path A*</option>
    <option value="SPS">Shortest Path Shooting*</option>
  </select>

This adds an html select to the page to be able to select between the routing algorithm.

Add this code a the end of the ``script`` tag:

.. code-block:: js

  document.getElementById('algorithm').addEventListener('change', function(event) {
    params.METHOD = event.target.value;
    // FIXME: refresh layer
  });

Adds and event handler to catch the select change events. When the routing algorithm changes,
we update the ``METHOD`` value from the ``params`` object.

-------------------------------------------------------------------------------------------------------------
Select the start and final destination
-------------------------------------------------------------------------------------------------------------

Add two divs inside the map element

.. code-block:: html

  <div id="ol-map">
    <div id="start-point">start</div>
    <div id="final-point">final</div>
  </div>


Add this code a the end of the ``script`` tag:

.. code-block:: js

  var startPoint = new ol.Overlay({
    map: map,
    element: document.getElementById('start-point')
  });
  var finalPoint = new ol.Overlay({
    map: map,
    element: document.getElementById('final-point')
  });

Creates two overlays, they get a reference to the map because they need to update their position according
to the view (in short: move when the map moves).

Invisible because the position is not set.


Add this code a the end of the ``script`` tag:

.. code-block:: js

  var transform = ol.proj.getTransformFromProjections('EPSG:3857', 'EPSG:4326');

  map.on('click', function(event) {
    // ...
  });


Transform the coordinates between the map projection and the server projection (``EPSG:4326``).

Clear button:



Add this code a the end of the ``script`` tag:

Add this code between the algorithm html ``select`` and the ``script`` tag:

.. code-block:: html

  <button id="clear">clear</button>

.. code-block:: js

  document.getElementById('clear').addEventListener('click', function(event) {
    // ...
  });


-------------------------------------------------------------------------------------------------------------
Bonus tasks
-------------------------------------------------------------------------------------------------------------
