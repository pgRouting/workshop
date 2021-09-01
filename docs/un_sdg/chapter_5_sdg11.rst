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
Set the search path of the `Waterways` to its respective schemas.

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o setting_search_path.txt 
    :end-before:  \o count_waterways.txt
    :language: sql 
    :linenos:


Counting the number of Waterways
...............................................................................

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o count_waterways.txt
    :end-before:  \o connected_components.txt
    :language: sql 
    :linenos:
 
Removing the Rivers which are not on land
...............................................................................
This exercise focusses only the areas on land, where if it rains the city is 
affected. Hence the rivers which are there in the swamp area have to be removed.

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: -- remove rivers on the swamp area (we want the rivers which are only on land)
    :end-before:  -- Update the vertices with the component number
    :language: sql 
    :linenos:

Choose a city
...............................................................................
For this exercise. Munshigang city from Bangladesh is chosen. This city has 2 
rivers in its proximity. The exercise will try to find the areas, where if it rains
the city will be affected. Create a table to store thep oint of City's location using
its lattiude amd longitude values.

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: -- Create a city
    :end-before:  \o creating_buffers_city.txt
    :language: sql 
    :linenos:
    
Process to get Connected Components of Waterways
...............................................................................
As the rivers in the data are not having single edge, i.e, multiple edges make up 
a river, it is important to find out the connected edges and store the information
in the `waterways_ways` table. This will help us to identify which edges belong to
a river.First, the connected components are found and then stored in a new column 
named `component`.`pgr_connectedComponents` is used to complete this task.

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o connected_components.txt
    :end-before:  -- remove rivers on the swamp area (we want the rivers which are only on land)
    :language: sql 
    :linenos:
    
.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: -- Update the vertices with the component number
    :end-before:  -- Create a city
    :language: sql 
    :linenos:


Create a Buffer around city
...............................................................................
Create a buffer around the city to define an area, inside which the intersection 
of rivers would be found. `ST_Buffer` is used to create this buffer.

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o creating_buffers_city.txt
    :end-before:  \o Intersecting_components.txt
    :language: sql 
    :linenos:


Finding the components intersecting the buffer
...............................................................................
Find the components of waterways which lie in the buffer zone of the city using
`ST_Intersects`.

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o Intersecting_components.txt
    :end-before:  \o creating_rain_zones_buffers_waterways.txt
    :language: sql 
    :linenos:
    
Output shows the distinct component numbers which lie in the buffer zone of the city.
Next step is to get all the edges that have those components.

Create a Buffer function to get an intersection with the river components
...............................................................................
This is the final step of the exercise. In this, the area where if it rains, the 
city would be affected, also can be called as `rain zone` is being found. 
First, add column names `rain_zone` to store Buffer geometry of the required edges.
Then update this column in all the rows where the edges have the components found in 
previous step

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o creating_rain_zones_buffers_waterways.txt
    :end-before:  \o       
    :language: sql 
    :linenos:
