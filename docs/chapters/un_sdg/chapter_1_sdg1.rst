UN SDG 1
===============================================================================

**The United Nations (UN) Sustainable Development Goals (SDGs)** involve many topics, including no hunger, clean water and sanitation, decent work and economic growth. All *17 goals* are worth mentioning, and all are equally important. **OSGeo**, as an organization of open source projects for geospatial, indirectly provides tools for people around the world to search for a decent work in a geospatial context. **pgRouting** is growing faster than the development of the official workshop material. pgRouting is not only useful for routing cars and other vehicles on roads, it can also be used to analyse river flows, the connectivity of an electricity network or to determine where to add a new street to connect two unconnected locations. The aim of this challenge is to expand the pgRouting workshop to cover at least three UN SDGs.


.. contents:: Chapter Contents

Setting Search Path
-------------------------------------------------------------------------------

Connect to the database, if not connected:

::

  psql mumbai

Get the vertex identifiers

.. literalinclude:: ../scripts/un_sdg/all_exercises_sdg1.sql
  :language: sql
  :start-after: setting_search_path.txt
  :end-before: count_roads_and_buildings.txt
  :linenos: