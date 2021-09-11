..
  ****************************************************************************
  pgRouting Workshop Manual Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

UN SDG7: Affordable and Clean Energy
###############################################################################

SDG 11 aspires to ensure access to `affordable, reliable, sustainable` and 
`modern` energy for all. Optimising the Electricity Distribution Network

.. image:: images/sdg7/un_sdg7.png 
  :align: center

.. contents:: Chapter Contents


Excercise: Optimising the Electricity Distribution Network
================================================================================

**Problem Statement**

To determine the least length of the path for laying the electricity 
distribution equipment such that every building is served

**Core Idea** 

Electricity lines may not be there on every road of the city. In a complex 
road network of a city, the network can be optised for less length such that
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
current search path. ``SET search_path`` is used to set the serach path to ``roads``. 
Finally, ``\dt`` is used to verify if the the Schema have bees changed correctly.

Enumerate all the schemas

.. code-block:: bash

        \dn

.. code-block:: bash

           List of schemas
           Name    |  Owner   
        -----------+----------
         public    | postgres
         roads     | <user-name>
        (2 rows)

Show the current search path

.. code-block:: bash

        SHOW search_path;

.. code-block:: bash

           search_path   
        -----------------
         "$user", public
        (1 row)

Set the search path

.. code-block:: bash

        SET search_path TO roads,public;
        SHOW search_path;

.. code-block:: bash

            search_path    
        -------------------
         roads, public
        (1 row)

Enumerate all the tables

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
of data. Also, some of the rows can be seen to  understand the sructure of the 
table and how the data is stored in it.


    

Extract connected components of roads
--------------------------------------------------------------------------------
why connected components. add a table.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Add a column for storing the component
    :end-before:  -- Update the vertices with the component number
    :language: sql 

Update the vertices with the component number

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Update the vertices with the component number
    :end-before:  -- These components are to be removed
    :language: sql 

These components are to be removed

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- These components are to be removed
    :end-before:  -- The edges that need to be removed
    :language: sql 

These edges are to be removed

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- The edges that need to be removed
    :end-before:  -- Removing the unwanted edges
    :language: sql 

Removing the unwanted edges

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Removing the unwanted edges
    :end-before:  -- Removing unused vertices
    :language: sql 

Removing unused vertices

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Removing unused vertices
    :end-before:  \o kruskal_minimum_spanning_tree.txt
    :language: sql 

Find the minimum spanning tree
--------------------------------------------------------------------------------


.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Adding id column
    :end-before:  -- Finding the minimum spanning tree
    :language: sql 

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: -- Finding the minimum spanning tree
    :end-before:  \o list_of_edges_with_costs
    :language: sql 

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: \o list_of_edges_with_costs
    :end-before:  \o comparison.txt
    :language: sql 

The final output can be seen in the following image.

.. image:: images/sdg7/sdg7_output.png 
  :align: center

Comparison
--------------------------------------------------------------------------------
111 as 1 degree = 111km approximately.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: \o comparison.txt
    :end-before:  \o
    :language: sql 

For this area we are getting following outputs:

* Total Road Length: ``57.12 km``
* Optimal Network Length: ``30.78 km``



Further possible extensions to the exercise
--------------------------------------------------------------------------------

* Finding the optimal network of roads such that it reaches every building
* Finding the optimal number and locations of Electricity Transformers