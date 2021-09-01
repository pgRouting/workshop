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
population has been living in cities. This makes it very important for the cities
to remain alert when there is a chance of disaster like floods. Local 
administration should know if their city is going to get affected by the rains
which happen in their proximity. This excercise will solve one of such problems.

.. image:: /images/un_sdg11.png 
  :align: center

.. contents:: Chapter Contents

Excercise 4.1: City getting affected by rain or not
================================================================================

**Problem Statement**

* To determine the areas where if it rains will affect a city/town

**Core Idea** 

* If it rains in vicinity of a river connecting the city, the city will get 
  affected by the rains.

**Approach**

* Choose a city
* Get the Rivers (Edges) and Cities(Points) 
* Create river components
* Create a Buffer function to get an intersection with the river components




First step is to pre-process the data obtained from Chapter-4. The sub heads from
`Setting the Search Path` to `Process to get Connected Components of Waterways` 
explain the pre-processing steps.

Setting the Search Path
...............................................................................
Set the search path of the `Roads` and `Buildings` to their respective schemas.

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o setting_search_path.txt 
    :end-before:  \o count_waterways_and_cities.txt
    :language: sql 
    :linenos:


Counting the number of Waterways and Cities/Towns
...............................................................................

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o count_waterways_and_cities.txt
    :end-before:  \o connected_components.txt
    :language: sql 
    :linenos:


Process to get Connected Components of Waterways
...............................................................................
pgRouting algorithms are only useful when the road network belongs to a single 
graph (or all the roads are connected to each other). Hence, the disconnected 
rivers have to be removed from ther network to get accurate results.

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: -- Process to discard disconnected waterways
    :end-before:  \o creating_buffers.txt
    :language: sql 
    :linenos:

Choose a city
...............................................................................


Get the Rivers (Edges) and Cities(Points)
...............................................................................


Create river components
...............................................................................


Create a Buffer function to get an intersection with the river components
...............................................................................