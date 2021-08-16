..
  ****************************************************************************
  pgRouting Workshop Manual Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

UN SDG11: Sustainable Cities and Communities
###############################################################################

SDG 11 aspires to make cities inclusive, safe, resilient and sustainable.The
world is becoming increasingly urbanized. Since 2007, more than half the world’s
population has been living in cities. This causes the city's infrastructure to
get overloaded. During disasters like flash floods, city's drainage system may
crumble and lead to inundation of the many low-lying areas. In this exercise, we
will try to find safe spots for evacuation of flood affected areas.

.. image:: /images/un_sdg11.png :align: center

Excercise 4.1: Optimal locations of Safe Zones during floods
================================================================================

**Problem Statement**

* To determine the optimal locations of safe zones during floods

**Core Idea** 

* Tall buildings in an area could be used as safe zones where people can live
  until help comes.

**Approach**

* To prepare a dataset with:

  - Nodes: Locations of buildings - Edges: Roads and Rivers - Polygons:
    Buildings with height

* Estimate the area with high flood vulnerabilty * Find the tall buildings in
  that area * Find the shortest route to reach those buildings



.. contents:: Chapter Contents


 
Estimating the area with high flood vulnerabilty
...............................................................................
Flood vulnerable areas can be calculated using max flow function.





Finding the tall buildings in that area
...............................................................................
Filter the building that are taller than the threshold height.



Finding the shortest route to reach those buildings
...............................................................................
Use pgr_bdDijkstra(Many to One) or pgr_bdAstar(Many to One) to find the shortest
routres to these buldings
