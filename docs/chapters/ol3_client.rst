==============================================================================================================
OpenLayers 3 Browser Client
==============================================================================================================

FIXME: ol3 introduction, community, documentation, current and planned features,  ...

-------------------------------------------------------------------------------------------------------------
Creating a minimal map
-------------------------------------------------------------------------------------------------------------

.. literalinclude:: ../../web/ol3-routing-base.html
	:language: html

FIXME: layers, source, view

-------------------------------------------------------------------------------------------------------------
Displaying the routing result
-------------------------------------------------------------------------------------------------------------

.. code-block:: js

  var params = {
    FORMAT: 'image/png'
  };

  map.addLayer(new ol.layer.ImageLayer({
    source: new ol.source.SingleImageWMS({
      url: 'http://localhost',
      params: params
    })
  }));

-------------------------------------------------------------------------------------------------------------
Routing method selection
-------------------------------------------------------------------------------------------------------------

.. code-block:: html

  <select id="algorithm">
    <option value="SPD">Shortest Path Dijkstra</option>
    <option value="SPA">Shortest Path A*</option>
    <option value="SPS">Shortest Path Shooting*</option>
  </select>


.. code-block:: js

  document.getElementById('algorithm').addEventListener('change', function(event) {
    params.METHOD = event.target.value;
    // FIXME: refresh layer
  });

-------------------------------------------------------------------------------------------------------------
Select the start and final destination
-------------------------------------------------------------------------------------------------------------

.. code-block:: js

  map.on('click', function(event) {

    // FIXME: refresh layer
  });
