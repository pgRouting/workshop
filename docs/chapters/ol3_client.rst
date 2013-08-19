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

 * FIXME: copy and paste this code into xxx ?
 * FIXME: center to Nottingham ?

.. literalinclude:: ../../web/ol3-routing-base.html
    :language: html
    :linenos:

This html code displays a map with an OpenStreetMap layer. At the moment there's not routing
related code.

Line by line we have:
  * line 6: include the default OpenLayers CSS file.
  * line 8 to 11: give the map a size: 400px height and the entire page width.
  * line 13: include the OpenLayers code. Add the function and javascript classes starting with ``ol`` comes from there.
  * line 16: create a div with a ``ol-map`` identifier. The map will be displayed inside this div.

The rest of the file (inside the ``script`` tag) will contain our javascript code to query the server
for a routing and display the result.

FIXME:
  * map init
  * what's a layer?
  * what's a source?
  * what's a 2d view?

-------------------------------------------------------------------------------------------------------------
Displaying the routing result
-------------------------------------------------------------------------------------------------------------

Add this code a the end of the ``script`` tag:

.. code-block:: js

  var params = {
    FORMAT: 'image/png',
    METHOD: 'SPD'
  };

  map.addLayer(new ol.layer.ImageLayer({
    source: new ol.source.SingleImageWMS({
      url: 'http://localhost',
      params: params
    })
  }));

The routing result is displayed as a single WMS image. We could have display it a as a GeoJSON but (FIXME)
The ``params`` object holds the WMS GET parameters.

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

Add this code a the end of the ``script`` tag:

.. code-block:: js

  var transform = ol.proj.getTransformFromProjections('EPSG:3857', 'EPSG:4326');

  map.on('click', function(event) {
    // start point overlay
    // final point overlay
    // params.STARTPOINT = transform(...).join(' ');
    // params.FINALPOINT = transform(...).join(' ');

    // FIXME: refresh layer
  });


Transform the coordinates between the map projection and the server projection (``EPSG:4326``).

FIXME: add clear button (removes points)
