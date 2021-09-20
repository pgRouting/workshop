..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Good Health and Well Being
###############################################################################

`Good Health and Well Being` is the 3rd Sustainable Development Goal which aspires
to ensure health and well-being for all, including a bold commitment to end the 
epidemics like AIDS, tuberculosis, malaria and other communicable diseases by 2030.
It also aims to achieve universal health coverage, and provide access to safe and
effective medicines and vaccines for all. Supporting research and development for
vaccines is an essential part of this process as well as expanding access to 
affordable medicines. Hospitals are a very important part of a well functioning 
health infrastructure. An appropriate planning is required for optimal distribution
of the population of an area to its hospitals. Hence, it is very important to estimate
the number of dependant people living near the hospital for better planning which
would ultimately help in achieving universal coverage of health services. This chapter
will focus on solving one such problem.

.. image:: images/sdg3/un_sdg3.png
  :align: center
  :alt: Sustainable Development Goal 3: Good Health and Well Being

`Image Source <https://sdgs.un.org/goals/goal3>`__

.. contents:: Chapter Contents

Problem: Estimation of Population Served by Hospitals
================================================================================

**Problem Statement**

To determine the population served by a hospital based on travel time

**Core Idea** 

Population residing along the roads which reach to a hospital within a particular
time is dependant on that hospital.

**Approach**

* To prepare a dataset with:

  - Edges: Roads
  - Polygons: Buildings with population

* Find the travel-time based the roads served
* Estimate the population of the buildings
* Find the nearest road to the buildings
* Store the sum of population of nearest buildings in roads table
* Find the sum of population on all the roads in the roads served

Pre-processing roads and buildings data
--------------------------------------------------------------------------------
First step is to pre-process the data obtained from Chapter-2. This section will 
work the graph that is going to be used for processing. While building the graph,
the data has to be inspected to determine if there is any invalid data. This is 
a very important step . . . .

Inspecting the database structure
...............................................................................
First step in pre processing is to set the search path for ``Roads`` and ``Buildings``
data. `Search path` is a list of schemas helps the system determine how a particular
table is to be imported. In this case, search path of roads table is set to roads
and buildings schema. ``\dn`` is used to list down all the present schemas. 
``SHOW search_path`` command shows the current search path. ``SET search_path`` 
is used to set the search path to ``roads`` and ``buildings``. Finally, ``\dt``
is used to verify if the Schema have bees changed correctly. Following code snippets
show the steps as well as the outputs.

** Execrcise 1: Enumerating the schemas is done with:**

.. code-block:: bash

        \dn

The output of the postgresql command is:

.. code-block:: bash

           List of schemas
           Name    |  Owner   
        -----------+----------
         buildings | swapnil
         public    | postgres
         roads     | swapnil
        (3 rows)

The schema names are ``buildings`` , ``roads``  and ``public``. The owner depends
on who has the rights to the database.

**Execrcise 2: Show the current** ``search path``

.. code-block:: bash

        SHOW search_path;

The output of the postgresql command is:

.. code-block:: bash

           search_path   
        -----------------
         "$user", public
        (1 row)

This is the current search path. Tables cannot be accessed using this

**Execrcise 3: Fixing the** ``search path``

.. code-block:: bash

        SET search_path TO roads,buildings,public;
        SHOW search_path;

.. code-block:: bash

            search_path    
        -------------------
        roads, buildings, public
        (1 row)

**Execrcise 4: Enumerate all the tables**

.. code-block:: bash

        \dt

.. code-block:: bash

                             List of relations
          Schema   |            Name             | Type  |  Owner  
        -----------+-----------------------------+-------+---------
         buildings | buildings_pointsofinterest  | table | user
         buildings | buildings_ways              | table | user
         buildings | buildings_ways_vertices_pgr | table | user
         public    | spatial_ref_sys             | table | swapnil
         roads     | configuration               | table | user
         roads     | roads_pointsofinterest      | table | user
         roads     | roads_ways                  | table | user
         roads     | roads_ways_vertices_pgr     | table | user
        (8 rows)

**Execrcise 5: Counting the number of Roads and Buildings**

The importance of counting the information on this workshop is important to make 
sure that the same data is used and the results will be the same in the exercises.
Also, some of the rows can be seen to  understand the structure of the table and 
how the data is stored in it.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: \o Exercise_5.txt
    :end-before:  \o Exercise_6.txt
    :language: postgresql 
    :linenos:  

:ref:`Query results for Chapter 3 Exercise 5`

Following image shows the roads and buildings visualised.

.. image:: images/sdg3/roads_and_buildings.png
  :align: center
  :scale: 75%

Preprocessing Buildings
...............................................................................
The table ``buildings_ways`` contains the buildings in edge form. They have to be
converted into polygons.  To get the area


**Exercise 6: Add a spatial column to the table to store the Polygon Geometry**

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: --Add a spatial column to the table
    :end-before:  \o Exercise_7.txt
    :language: postgresql 
    :linenos:     

:ref:`Query results for Chapter 3 Exercise 6`

**Exercise 7: Removing the polygons with less than 4 points**

``ST_NumPoints`` is used to find the number of points on a geometry. Also, polygons
with less than 3 points/vertices are not considered valid polygons in PostgreSQL.
Hence, the buildings having less than 3 vertices need to be cleaned up. Follow 
the steps given below to complete this task.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: \o Exercise_7.txt 
    :end-before: \o Exercise_8.txt 
    :language: postgresql 
    :linenos: 

:ref:`Query results for Chapter 3 Exercise 7`

**Exercise 8: Creating the polygons**

``ST_MakePolygons`` is used to make the polygons. This step stores the geom of 
polygons in the ``poly_geom`` column which was created earlier.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: \o Exercise_8.txt 
    :end-before:  \o Exercise_9.txt 
    :language: postgresql 
    :linenos: 

:ref:`Query results for Chapter 3 Exercise 8`

**Exercise 9: Calculating the area**

1. Adding a column for storing the area

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Adding a column for storing the area
    :end-before:  -- Storing the area
    :language: postgresql 
    :linenos: 

2. Storing the area in the
new column

``ST_Area`` is used to calculate area of polygons. Area is stored in the
new column

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Storing the area
    :end-before:  \o Exercise_10.txt
    :language: postgresql 
    :linenos: 

:ref:`Query results for Chapter 3 Exercise 9`

pgr_connectedComponents
...............................................................................
for the next step 

Preprocessing Roads
...............................................................................
pgRouting algorithms are only useful when the road network belongs to a single 
graph (or all the roads are connected to each other). Hence, the disconnected 
roads have to be removed from their network to get appropriate results.
This image gives an example of the disconnected edges.

.. image:: images/sdg3/remove_disconnected_roads.png
  :align: center
  :scale: 60%

Follow the steps given below to complete this task.

**Exercise 10: Find the Component number for Road vertices**

1. Add a column named** ``component`` to store component number.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Add a column for storing the component
    :end-before:  -- Update the vertices with the component number
    :language: postgresql 
    :linenos: 

2. Update the ``component`` column in ``roads_ways_vertices_pgr`` with the component number

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Update the vertices with the component number
    :end-before:  \o Exercise_11.txt
    :language: postgresql 
    :linenos: 

This will store the component number of each edge in the table. Now, the completely 
connected network of roads should have the maximum count in the ``component`` table.

.. code-block:: sql

        SELECT component, count(*) FROM road_ways_vertices_pgr GROUP BY  component;

Connected this 
For example,there are 100 roads in a network and 3 are disconnected. 97 connected
roads will have the same component number, say 1. If there are 3 disconnected roads
have the connected component number, say 2, write a query to remove all the edges
with the component number 2.

:ref:`Query results for Chapter 3 Exercise 10`

**Exercise 11: Finding the components which are to be removed**

This query selects all the components which are not equal to the component number
with maximum count using a subquery which groups the rows in ``roads_ways_vertices_pgr`` 
by the component.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- These components are to be removed
    :end-before:  \o Exercise_12.txt
    :language: postgresql 
    :linenos: 

:ref:`Query results for Chapter 3 Exercise 11`

**Exercise 12: Finding the road vertices which belong to those components which are to be removed**

This query selects all the road vertices which have the component number from step 3.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- The edges that need to be removed
    :end-before:  \o Exercise_13.txt
    :language: postgresql 
    :linenos: 

:ref:`Query results for Chapter 3 Exercise 12`

**Exercise 13: Removing the unwanted edges and vertices**

1. Removing the unwanted edges

In ``roads_ways`` table (edge table) ``source`` and ``target`` have the ``id`` of
the vertices from where the edge starts and ends. To delete all the disconnected 
edges the following query takes the output from the query of Step 4 and deletes
all the edges having the same ``source`` as the ``id``.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Removing the unwanted edges
    :end-before:  -- Removing unused vertices
    :language: postgresql 
    :linenos: 

2. Removing unused vertices

The following query uses the output of Step 4 to remove the vertices of the disconnected
edges.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Removing unused vertices
    :end-before:  -- finding the service area
    :language: postgresql 
    :linenos: 


:ref:`Query results for Chapter 3 Exercise 13`

Finding the roads served by the hospitals
--------------------------------------------------------------------------------
After pre-processing the data, next step is to find the area served by the
hospital. This area can be computed from the entrance of the hospital or from any
point on road near the hospital. In this exercise it is computed from closest 
road vertex. ``pgr_drivingDistance`` will be used to find the roads served. The
steps to be followed are:

* Finding the closest road vertex
* Finding the roads served
* Generalising the roads served

Finding the closest road vertex
...............................................................................
There are multiple road vertices near the hospital. Create a function to find 
the geographically closest road vertex. 

.. image:: images/sdg3/finding_closest_vertex.png
  :align: center
  :scale: 75% 

**Exercise 14: Create a function to find the closest road vertex**

``closest_vertex`` function takes geometry of other table as input and gives
the gid of the closest vertex as output by comparing ``geom`` of both the tables.


.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- finding the closest road vertex
    :end-before:  -- service area
    :language: postgresql 
    :linenos: 
    

pgr_drivingDistance
...............................................................................
for the next step 


Finding the served roads
...............................................................................


**Exercise 15: Finding the served roads using pgr_drivingDistance**

In this exercise, the roads served based on travel-time is calculated. This can be 
calculated using ``pgrdrivingDistance`` function of pgRouting. Time in minutes is 
considered as ``cost``. The ``agg_cost`` column would show the time required to 
reach the hospital.

For the following query,

* In line 3, Pedestrian speed is assumed to be as ``1 m/s``. As ``time`` = ``distance/speed``, 
  ``length_m`` / ``1 m/s`` / ``60`` gives the time in minutes. 
* In line 7, ``tag_id = '318'``  as 318 is the tag_id of hospital in the configuration
  file of buildings.
* In line 8, ``10`` is written for 10 minutes which is a threshold for ``agg_cost``. 
* In line 8, ``FALSE`` is written as the query is for undirected graph.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: \o Exercise_15.txt
    :end-before:  \o Exercise_16.txt
    :language: postgresql 
    :linenos: 

:ref:`Query results for Chapter 3 Exercise 15`

Following figure shows the visualised output of the above query. The lines
highlighted by ``red`` colour show the area from where the hospital can be reached
within 10 minutes of walking at ``1 m/s``. It is evident from the output figure 
that some of the roads which are near to the hospital are not highlighted. For 
example, to roads in the north of the hospital. This is because the only one edge
per road vertex was selected by the query. Next session will solve this issue by
doing a little modification in the query.

.. image:: images/sdg3/service_area.png
  :align: center  
  :scale: 75%

Generalising the served roads
...............................................................................
The edges which are near to to hospital should also be selected in the roads served
as the hospital also serves those buildings. The following query takes the query
from previous section as a ``subquery`` and selects all the edges from ``roads_ways``
that have the same ``source`` and ``target`` to that of ``subquery`` (Line 14).


**Exercise 16: Generalising the served roads**

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: \o Exercise_16.txt
    :end-before:  -- Calculating the population residing along the road
    :language: postgresql 
    :linenos: 

:ref:`Query results for Chapter 3 Exercise 16`

Following figure shows the visualised output of the above query. Lines 
highlighted in ``yellow`` show the `generalised the roads served`. This gives a better
estimate of the areas from where the hospital can be reached by a particular speed.

.. image:: images/sdg3/generalised_service_area.png
  :align: center
  :scale: 75%

Calculating the population residing along the road
--------------------------------------------------------------------------------
Now the next step is to estimate the dependant population. Official source of 
population is Census conducted by the government. But for this exercise, population
will be estimated from the ``area`` as well as the ``category`` of the building.
This area will be stored in the nearest roads. Following steps explain the
process in detail.

Estimating the population of buildings
...............................................................................
Population of an building can be estimated by its area and its category.
Buildings of OpenStreetMap data are classified into various categories. For
this exercise, the buildings are classified into the following classes:

- Negligible: People do not live in these places. But the default is 1 because of 
  homeless people.
- Very Sparse: People do not live in these places. But the default is 2 because 
  there may be people guarding the place.
- Sparse: Considering the universities and college because the students live there.
- Moderate: A family unit housing kind of location.
- Dense: A medium sized residential building.
- Very Dense: A large sized residential building.

The class-specific factor is multiplied with the area of each building to get
the population

**Exercise 17: Estimating the population of buildings**

1. Create a function to find population usung class-specific factor and area.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- population_function_from_here
    :end-before:  -- Adding a column for storing the population
    :language: postgresql 
    :linenos:     

.. note:: All these are estimations based on this particular area. More complicated 
          functions can be done that consider height of the apartments but the 
          design of a function is going to depend on the availability of the data.
          For example, using census data can achieve more accurate estimation.

2. Add a column for storing the population in the ``buildings_ways``

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Adding a column for storing the population
    :end-before:  -- Storing the population
    :language: postgresql 
    :linenos: 

3. Use the ``population`` function to store the population in the new column created
in the ``building_ways``.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Storing the population
    :end-before:  -- population_function_to_here
    :language: postgresql 
    :linenos: 

:ref:`Query results for Chapter 3 Exercise 17`

Finding the nearest roads to store the population
...............................................................................
To store the population of buildings in the roads, nearest road to a building 
is to be found.

**Exercise 18: Finding the nearest roads to store the population**

1. Create Function for finding the closest edge.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Create Function for finding the closest edge
    :end-before:  -- Add a column for storing the closest edge
    :language: postgresql 
    :linenos: 

2. Add a column in ``buildings_ways`` for storing the id of closest edge

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Add a column for storing the closest edge
    :end-before:  -- Store the edge_id of the closest edge in the column
    :language: postgresql 
    :linenos: 

3. Store the edge id of the closest edge in the new column

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Store the edge_id of the closest edge in the column
    :end-before:  -- nearest_road_to_here
    :language: postgresql 
    :linenos: 

:ref:`Query results for Chapter 3 Exercise 18`

Storing the population in the roads
...............................................................................

After finding the nearest road, the sum of population of all the nearest
buildings is stored in the population column of the roads table.

**Exercise 19: Storing the population in the roads**

1. Add a column in ``roads_ways`` for storing population

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Add population column to roads table
    :end-before:  -- Update the roads with the SUM of population of buildings closest to it
    :language: postgresql 
    :linenos: 

2. Update the roads with the sum of population of buildings closest to it

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- Update the roads with the SUM of population of buildings closest to it
    :end-before:  -- testing
    :language: postgresql 
    :linenos: 

3. Verify is the population is stored using the folowing query.

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- testing
    :end-before:  -- road_population_to_here   
    :language: postgresql 
    :linenos: 

.. image:: images/sdg3/road_population.png
  :align: center
  :scale: 75%

:ref:`Query results for Chapter 3 Exercise 19`

Finding total population served by the hospital based on travel-time
----------------------------------------------------------------------------------
Use the query from 3.1.2.3 as a subquery to get all the edges in the roads served.
Note that ``s.population`` is added in line 14 which gves the population.
After getting the population for each edge/road, use ``sum()`` to get the total 
population which is dependant on the hospital.

**Exercise 20: Finding total population served by the hospital based on travel-time**

.. literalinclude:: ../scripts/un_sdg/sdg3/all_exercises_sdg3.sql
    :start-after: -- finding total population
    :end-before:  \o
    :language: postgresql 
    :linenos: 

:ref:`Query results for Chapter 3 Exercise 20`