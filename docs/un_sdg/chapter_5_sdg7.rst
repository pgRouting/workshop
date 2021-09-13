..
  ****************************************************************************
  pgRouting Workshop Manual Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

UN SDG7: Affordable and Clean Energy
###############################################################################

SDG 11 aspires to ensure access to `affordable, reliable, sustainable` and 
`modern` energy for all. Today renewable energy is making impressive gains in the
electricity sector. As more and more new settlements are built, there would be 
new electricity distribution network developed. Electricity Distribution is very
infrastructure. Finding the optimal path for laying this infrastructure is very
crucial to maintain the affordability of electricity. This exercise focusses on 
finding this optimal path/network for laying the electricity distribution equipment.

.. image:: images/sdg7/un_sdg7.png 
  :align: center

.. contents:: Chapter Contents


Exercise: Optimising the Electricity Distribution Network
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

**1. Enumerate all the schemas**

.. code-block:: bash

        \dn

.. code-block:: bash

           List of schemas
           Name    |  Owner   
        -----------+----------
         public    | postgres
         roads     | <user-name>
        (2 rows)


**2. Show the current search path**

.. code-block:: bash

        SHOW search_path;

.. code-block:: bash

           search_path   
        -----------------
         "$user", public
        (1 row)

**3. Set the search path**

.. code-block:: bash

        SET search_path TO roads,public;
        SHOW search_path;

.. code-block:: bash

            search_path    
        -------------------
         roads, public
        (1 row)

**4. Enumerate all the tables**

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

Counting the number of Roads
...............................................................................
Counting the number of edges present in the gives the information if the amount 
of data. Also, some of the rows can be seen to  understand the structure of the 
table and how the data is stored in it.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: \o count_roads.txt
    :end-before:  \o discard_disconnected_roads.txt
    :language: postgresql 
    :linenos:

    

Extract connected components of roads
--------------------------------------------------------------------------------
Similar to ``Chapter 3``, the disconnected 
roads have to be removed from their network to get appropriate results.

Follow the steps given below to complete this task.

**1. Add a column named** ``component`` **to store component number.**

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Add a column for storing the component
    :end-before:  -- Update the vertices with the component number
    :language: postgresql 
    :linenos:

**2. Update the** ``component`` **column in** ``roads_ways_vertices_pgr`` **with the component number**


.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Update the vertices with the component number
    :end-before:  -- These components are to be removed
    :language: postgresql 
    :linenos:

This will store the component number of each edge in the table. Now, the completely 
connected network of roads should have the maximum count in the ``componenet`` table.

**3. Finding the components which are to be removed**

This query selects all the components which are not equal to the component number
with maximum count using a subquery which groups the rows in ``roads_ways_vertices_pgr`` 
by the component.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- These components are to be removed
    :end-before:  -- The edges that need to be removed
    :language: postgresql 
    :linenos:

**4. Finding the road vertices which belong to those components which are to be removed**

This query selects all the road vertices which have the component number from step 3.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- The edges that need to be removed
    :end-before:  -- Removing the unwanted edges
    :language: postgresql 
    :linenos:

**5. Removing the unwanted edges**

In ``roads_ways`` table (edge table) ``source`` and ``target`` have the ``id`` of
the vertices from whre the edge starts and ends. To delete all the disconnected 
edges the following query takes the output from the query of Step 4 and deletes
all the edges having the same ``source`` as the ``id``.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Removing the unwanted edges
    :end-before:  -- Removing unused vertices
    :language: postgresql 
    :linenos:

**6. Removing unused vertices**

The following query uses the output of Step 4 to remove the vertices of the disconnected
edges.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Removing unused vertices
    :end-before:  \o kruskal_minimum_spanning_tree.txt
    :language: postgresql 
    :linenos:

Find the minimum spanning tree
--------------------------------------------------------------------------------
A minimum spanning tree (MST) is a subset of edges of a connected undirected graph
that connects all the vertices together, without any cyclessuch that sum of edge 
weights is as small as possible. The road network also has a minimum spanning forest
which is a union of the minimum spanning trees for its connected components. This 
minimum spanning forest is the optimal network of roexecute the the query below.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Finding the minimum spanning tree
    :end-before:  \o list_of_edges_with_costs
    :language: postgresql 
    :linenos:

The following query will give the reults with the source vertex , target vertex , edge id, aggregate cost,

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: \o list_of_edges_with_costs
    :end-before:  \o comparison.txt
    :language: postgresql 
    :linenos:

The final output can be seen in the following image.

.. image:: images/sdg7/sdg7_output.png 
  :align: center
  :scale: 50%

Comparison
--------------------------------------------------------------------------------
Total lengths of the network and the minimumspanning tree can be compared to see
the difference between both. To do the same, follow th steps below:

**1. Compute total length of material required in km**

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Compute total length of material required in km
    :end-before:  -- Compute total length of roads in km
    :language: postgresql 
    :linenos:

**2. Compute total length of roads in km**

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Compute total length of roads in km
    :end-before:  \o
    :language: postgresql 
    :linenos:


For this area we are getting following outputs:

* Total Road Length: ``55.68 km``
* Optimal Network Length: ``29.89 km``

Length of minimum spanning tree is about half of the legth of total road network.

Further possible extensions to the exercise
--------------------------------------------------------------------------------

* Finding the optimal network of roads such that it reaches every building
* Finding the optimal number and locations of Electricity Transformers
