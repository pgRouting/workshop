..
  ****************************************************************************
  pgRouting Workshop Manual Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Affordable and Clean Energy
###############################################################################

`Affordable and Clean Energy` is the 7th Sustainable Development Goal 11 aspires
to ensure access to `affordable, reliable, sustainable` and 
`modern` energy for all. Today renewable energy is making impressive gains in the
electricity sector. As more and more new settlements are built, there would be 
new electricity distribution network developed. Electricity Distribution is very
infrastructure. Finding the optimal path for laying this infrastructure is very
crucial to maintain the affordability of electricity. This exercise focusses on 
finding this optimal path/network for laying the electricity distribution equipment.

.. image:: images/sdg7/un_sdg7.png 
  :align: center
  :alt: Sustainable Development Goal 7: Affordable and Clean Energy

`Image Source <https://sdgs.un.org/goals/goal7>`__

.. contents:: Chapter Contents

Problem: Optimising the Electricity Distribution Network
================================================================================

**Problem Statement**

To determine the least length of the path for laying the electricity 
distribution equipment such that every building is served

**Core Idea** 

Electricity lines may not be there on every road of the city. In a complex 
road network of a city, the network can be optimised for less length such that
Electricity lines reach every locality of the city. Less length leads to 
enhanced cost-effectiveness resulting in affordable electricity distribution 
equipment.

**Approach**

* Extract connected components of roads
* Use pgRouting to find the minimum spanning tree
* Compare the total length of roads and minimum spanning tree


Pre-processing roads data
--------------------------------------------------------------------------------
First step is to pre-process the data obtained from Chapter-2. The sub heads from
``Setting the Search Path of Roads`` to ``Counting the number of Roads`` 
explain the pre-processing steps.

Setting the Search Path of Roads
...............................................................................
First step in pre processing is to set the search path for our downloaded data.
Search path is a list of schemas helps the system determine how a particular table 
is to be imported. In this case, search path of roads table is set to ``roads`` 
schema and ``roads.xml`` configuration file as we say in Chapter 2.3. ``\dn`` is 
used to list down all the present schemas. ``SHOW search_path`` command shows the 
current search path. ``SET search_path`` is used to set the search path to ``roads``. 
Finally, ``\dt`` is used to verify if the Schema have bees changed correctly.

** Execrcise 1: Enumerating the schemas is done with:**

.. code-block:: bash

        \dn

.. code-block:: bash

           List of schemas
           Name    |  Owner   
        -----------+----------
         public    | postgres
         roads     | <user-name>
        (2 rows)


**Execrcise 2: Show the current** ``search path``

.. code-block:: bash

        SHOW search_path;

.. code-block:: bash

           search_path   
        -----------------
         "$user", public
        (1 row)

**Execrcise 3: Fixing the** ``search path``

.. code-block:: bash

        SET search_path TO roads,public;
        SHOW search_path;

.. code-block:: bash

            search_path    
        -------------------
         roads, public
        (1 row)

**Execrcise 4: Enumerate all the tables**

.. code-block:: bash

        \dt

.. code-block:: bash

                             List of relations
          Schema   |            Name             | Type  |  Owner  
        -----------+-----------------------------+-------+---------
         public    | spatial_ref_sys             | table | <user-name>
         roads     | configuration               | table | user
         roads     | roads_pointsofinterest      | table | user
         roads     | roads_ways                  | table | user
         roads     | roads_ways_vertices_pgr     | table | user
        (5 rows)

**Execrcise 5: Counting the number of Roads**

Counting the number of edges present in the gives the information if the amount 
of data. Also, some of the rows can be seen to  understand the structure of the 
table and how the data is stored in it.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: \o Exercise_5.txt
    :end-before:  \o Exercise_6.txt
    :language: postgresql 
    :linenos:

:ref:`Query results for Chapter_5 Exercise 5`

pgr_connectedComponents function 2
...............................................................................

for the next step    

Extract connected components of roads
--------------------------------------------------------------------------------
Similar to ``Chapter 3``, the disconnected 
roads have to be removed from their network to get appropriate results.

Follow the steps given below to complete this task.

**Execrcise 6: Find the Component number for Road vertices**

1. Add a column named** ``component`` to store component number.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Add a column for storing the component
    :end-before:  -- Update the vertices with the component number
    :language: postgresql 
    :linenos:

2. Update the ``component`` column in ``roads_ways_vertices_pgr`` ith the component number

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Update the vertices with the component number
    :end-before:  \o Exercise_7.txt
    :language: postgresql 
    :linenos:

This will store the component number of each edge in the table. Now, the completely 
connected network of roads should have the maximum count in the ``componenet`` table.


:ref:`Query results for Chapter_5 Exercise 6`

**Exercise 7: Finding the components which are to be removed**

This query selects all the components which are not equal to the component number
with maximum count using a subquery which groups the rows in ``roads_ways_vertices_pgr`` 
by the component.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: \o Exercise_7.txt
    :end-before:  \o Exercise_8.txt
    :language: postgresql 
    :linenos:


:ref:`Query results for Chapter_5 Exercise 7`

**Exercise 8: Finding the road vertices which belong to those components which are to be removed**

This query selects all the road vertices which have the component number from step 3.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: \o Exercise_8.txt
    :end-before:  \o Exercise_9.txt
    :language: postgresql 
    :linenos:


:ref:`Query results for Chapter_5 Exercise 8`

**Exercise 9: Removing the unwanted edges and vertices**

1. Removing the unwanted edges

In ``roads_ways`` table (edge table) ``source`` and ``target`` have the ``id`` of
the vertices from whre the edge starts and ends. To delete all the disconnected 
edges the following query takes the output from the query of Step 4 and deletes
all the edges having the same ``source`` as the ``id``.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: \o Exercise_9.txt
    :end-before:  -- Removing unused vertices
    :language: postgresql 
    :linenos:

2. Removing unused vertices

The following query uses the output of Step 4 to remove the vertices of the disconnected
edges.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Removing unused vertices
    :end-before:  \o Exercise_10.txt
    :language: postgresql 
    :linenos:


:ref:`Query results for Chapter_5 Exercise 9`

pgr_kruskal
--------------------------------------------------------------------------------

Find the minimum spanning tree
--------------------------------------------------------------------------------
A minimum spanning tree (MST) is a subset of edges of a connected undirected graph
that connects all the vertices together, without any cycles such that sum of edge 
weights is as small as possible. The road network also has a minimum spanning forest
which is a union of the minimum spanning trees for its connected components. This 
minimum spanning forest is the optimal network of electricity distribution components.
To complete this task, execute the query below.

**Exercise 10: Find the minimum spanning tree**

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: \o Exercise_10.txt
    :end-before:  \o list_of_edges_with_costs
    :language: postgresql 
    :linenos:

The following query will give the results with the source vertex ,target vertex
, edge id, aggregate cost,

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: \o list_of_edges_with_costs
    :end-before:  \o Exercise_11.txt
    :language: postgresql 
    :linenos:

:ref:`Query results for Chapter_5 Exercise 10`

The final output can be seen in the following image.

.. image:: images/sdg7/sdg7_output.png 
  :align: center
  :scale: 50%

Comparison
--------------------------------------------------------------------------------
Total lengths of the network and the minimum spanning tree can be compared to see
the difference between both. To do the same, follow the steps below:

**Exercise 11: Compute total length of material required in km**

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: \o Exercise_11.txt
    :end-before:  \o Exercise_12.txt
    :language: postgresql 
    :linenos:

:ref:`Query results for Chapter_5 Exercise 11`

**Exercise 12: Compute total length of roads in km**

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Compute total length of roads in km
    :end-before:  \o
    :language: postgresql 
    :linenos:

For this area we are getting following outputs:

* Total Road Length: ``55.68 km``
* Optimal Network Length: ``29.89 km``

Length of minimum spanning tree is about half of the length of total road network.

:ref:`Query results for Chapter_5 Exercise 12`

Further possible extensions to the exercise
--------------------------------------------------------------------------------

* Finding the optimal network of roads such that it reaches every building
* Finding the optimal number and locations of Electricity Transformers
