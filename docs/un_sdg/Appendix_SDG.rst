..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************


Appendix: OSGeo UN Challenge Workshop Solutions
===============================================================================

Solutions to :doc:`chapter_3_sdg3`
-------------------------------------------------------------------------------

Query results for Chapter 3.1.2 
................................................................................
Chapter 3.1.2 :ref:`Finding the travel-time based the roads served of hospital`

:ref:`Finding the closest road vertex`

.. literalinclude:: ../scripts/un_sdg/sdg3/count_roads_and_buildings.txt

:ref:`Finding the roads served`

.. literalinclude:: ../scripts/un_sdg/sdg3/service_area.txt


:ref:`Generalising the roads served`

.. literalinclude:: ../scripts/un_sdg/sdg3/correct_service_area.txt


Query results for Chapter 3.1.3
...............................................................................

Chapter 3.1.3 :ref:`Calculating the population residing along the road`

:ref:`Estimating the population of buildings`

.. literalinclude:: ../scripts/un_sdg/sdg3/buildings_population_calculation.txt

:ref:`Storing the population in the roads`

.. literalinclude:: ../scripts/un_sdg/sdg3/total_population.txt

Query results for Chapter 3.1.4
...............................................................................

:ref:`Finding total population served by the hospital based on travel-time`

.. literalinclude:: ../scripts/un_sdg/sdg3/count_roads_and_buildings.txt


Solutions to :doc:`chapter_4_sdg11`
-------------------------------------------------------------------------------

Query results for Chapter 4.1.2 
................................................................................

Chapter 4.1.2 :ref:`Pre-processing waterways data`


:ref:`Counting the number of Waterways`

.. literalinclude:: ../scripts/un_sdg/sdg11/count_waterways.txt

Query results for Chapter 4.1.3
................................................................................

:ref:`Process to get Connected Components of Waterways`

Query results for Chapter 4.1.4
................................................................................

:ref:`Create a Buffer around city`

.. literalinclude:: ../scripts/un_sdg/sdg11/creating_buffers_city.txt

Query results for Chapter 4.1.5
................................................................................

:ref:`Finding the components intersecting the buffer`

.. literalinclude:: ../scripts/un_sdg/sdg11/Intersecting_components.txt

Query results for Chapter 4.1.6
................................................................................

:ref:`Create a Buffer around the river components to get the rain zones`

.. literalinclude:: ../scripts/un_sdg/sdg11/creating_rain_zones_buffers_waterways.txt


Solutions to :doc:`chapter_5_sdg7`
-------------------------------------------------------------------------------

Query results for Chapter 5.1.1
................................................................................

:ref:`Counting the number of Roads`

.. literalinclude:: ../scripts/un_sdg/sdg7/count_roads.txt


Query results for Chapter 5.1.2
................................................................................

:ref: `Extract connected components of roads`

.. literalinclude:: ../scripts/un_sdg/sdg7/discard_disconnected_roads.txt

Query results for Chapter 5.1.3
................................................................................

:ref: `Find the minimum spanning tree`

.. literalinclude:: ../scripts/un_sdg/sdg7/kruskal_minimum_spanning_tree.txt

Query results for Chapter 5.1.4
................................................................................

:ref: `Comparison`

.. literalinclude:: ../scripts/un_sdg/sdg7/comparison.txt

