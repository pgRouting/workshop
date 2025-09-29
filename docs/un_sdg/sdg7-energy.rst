..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Affordable and Clean Energy
###############################################################################

`Affordable and Clean Energy` is the 7th Sustainable Development Goal 11. It aspires
to ensure access to `affordable, reliable, sustainable` and `modern` energy for all.
Today renewable energy is making impressive gains in the electricity sector. As
more and more new settlements are built, there would be new electricity distribution
network developed. Electricity Distribution is very expensive infrastructure. Finding the
optimal path for laying this infrastructure is very crucial to maintain the
affordability of electricity for everyone. This exercise focusses on finding this
optimal path/network for laying the electricity distribution equipment.

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

.. image:: images/sdg7/sdg7_output.png
  :align: center
  :scale: 25%

**Core Idea**

Electricity lines may not be there on every road of the city. In a complex
road network of a city, the network can be optimised for less length such that
Electricity lines reach every locality of the city. Less length leads to
enhanced cost-effectiveness resulting in affordable electricity.

**Approach**

* Extract connected components of roads
* Use pgRouting to find the minimum spanning tree
* Compare the total length of roads and minimum spanning tree


Pre-processing roads data
================================================================================
First step is to pre-process the data obtained from :doc:`data`.
This section will work the graph that is going to be used for processing. While
building the graph, the data has to be inspected to determine if there is any
invalid data. This is a very important step to make sure that the data is of
required quality. pgRouting can also be used to do some Data Adjustments.
This will be discussed in further sections.

Setting the Search Path of Roads
--------------------------------------------------------------------------------
First step in pre processing is to set the search path for ``Roads`` data.
Search path is a list of schemas helps the system determine how a particular table
is to be imported.

Exercise 1: Set the seach path
...............................................................................

In this case, search path of roads table is search path to ``roads`` and
``buildings`` schemas. Following query is used to adjust the search path.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
   :start-after: set_path.txt
   :end-before: show_path2.txt

.. collapse:: Command output

  .. literalinclude:: ../scripts/un_sdg/sdg7/set_path.txt

Checking the search path again

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: show_path2.txt
    :end-before: revert_changes.txt

.. collapse:: Command output

  .. literalinclude:: ../scripts/un_sdg/sdg7/show_path2.txt


Exercise 2: Remove disconnected components
...............................................................................

To remove the disconnected components on the road network, the following
pgRouting functions, discussed on :doc:`../basic/graphs`, will be used:

* ``pgr_extractVertices``
* ``pgr_connectedComponents``

.. rubric:: Create a vertices table.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: only_connected1.txt
    :end-before: only_connected2.txt
    :language: sql

.. collapse:: Query Results

  .. literalinclude:: ../scripts/un_sdg/sdg7/only_connected1.txt

.. rubric:: Fill up the ``x``, ``y`` and ``geom`` columns.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: only_connected2.txt
    :end-before: only_connected3.txt
    :language: sql

.. collapse:: Query Results

  .. literalinclude:: ../scripts/un_sdg/sdg7/only_connected2.txt

.. rubric:: Add a ``component`` column on the edges and vertices tables.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: only_connected3.txt
    :end-before: only_connected4.txt
    :language: sql

.. collapse:: Query Results

  .. literalinclude:: ../scripts/un_sdg/sdg7/only_connected3.txt

.. rubric:: Fill up the ``component`` column on the vertices table.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: only_connected4.txt
    :end-before: only_connected5.txt
    :language: sql

.. collapse:: Query Results

  .. literalinclude:: ../scripts/un_sdg/sdg7/only_connected4.txt

.. rubric:: Fill up the ``component`` column on the edges table.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: only_connected5.txt
    :end-before: only_connected6.txt
    :language: sql

.. collapse:: Query Results

  .. literalinclude:: ../scripts/un_sdg/sdg7/only_connected5.txt

.. rubric:: Get the component number with the most number of edges.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: only_connected6.txt
    :end-before: only_connected7.txt
    :language: sql

.. collapse:: Query Results

  .. literalinclude:: ../scripts/un_sdg/sdg7/only_connected6.txt

.. rubric:: Delete edges not belonging to the most connected component.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: only_connected7.txt
    :end-before: only_connected8.txt
    :language: sql

.. collapse:: Query Results

  .. literalinclude:: ../scripts/un_sdg/sdg3/only_connected7.txt

.. rubric:: Delete vertices not belonging to the most connected component.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: only_connected8.txt
    :end-before: exercise_10-1.txt
    :language: sql

.. collapse:: Query Results

  .. literalinclude:: ../scripts/un_sdg/sdg3/only_connected8.txt


pgr_kruskalDFS
================================================================================

For the next step ``pgr_kruskalDFS`` will be used. Kruskal algorithm is used for
getting the Minimum Spanning Tree with Depth First Search ordering. A minimum spanning
tree (MST) is a subset of edges of a connected undirected graph that connects all
the vertices together, without any cycles such that sum of edge weights is as small
as possible.

.. rubric:: Signatures

.. code-block:: none

    pgr_kruskalDFS(Edges SQL, Root vid [, max_depth])
    pgr_kruskalDFS(Edges SQL, Root vids [, max_depth])

    RETURNS SET OF (seq, depth, start_vid, node, edge, cost, agg_cost)

`pgr_kruskalDFS Documentation <https://docs.pgrouting.org/3.1/en/pgr_kruskalDFS.html>`__
can be found at this link for more information.

Exercise 3: Find the minimum spanning tree
================================================================================

The road network has a minimum spanning forest which is a union of the minimum
spanning trees for its connected components. This minimum spanning forest is the
optimal network of electricity distribution components.

To complete this task, execute the query below.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: exercise_10-1.txt
    :end-before:  exercise_10-2.txt
    :language: sql

.. collapse:: Query Results

  .. literalinclude:: ../scripts/un_sdg/sdg7/exercise_10-1.txt

The following query will give the results with the source vertex, target vertex,
edge id, aggregate cost.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: exercise_10-2.txt
    :end-before:  exercise_11.txt
    :language: sql

.. collapse:: Query Results

  .. literalinclude:: ../scripts/un_sdg/sdg7/exercise_10-2.txt

Comparison between Total and Optimal lengths
================================================================================

Total lengths of the network and the minimum spanning tree can be compared to see
the difference between both. To do the same, follow the steps below:

Exercise 4: Compute total length of material required in km
--------------------------------------------------------------------------------

Compute the total length of the minimum spanning tree which is an estimate of the
total length of material required.

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: exercise_11.txt
    :end-before:  exercise_12.txt
    :language: sql
    :linenos:

.. collapse:: Query Results

  .. literalinclude:: ../scripts/un_sdg/sdg7/exercise_11.txt

Exercise 5: Compute total length of roads
--------------------------------------------------------------------------------

Compute the total length of the road network of the given area..

.. literalinclude:: ../scripts/un_sdg/sdg7/all_exercises_sdg7.sql
    :start-after: exercise_12.txt
    :end-before:  \o
    :language: sql

.. collapse:: Query Results

  .. literalinclude:: ../scripts/un_sdg/sdg7/exercise_12.txt

-For this area we are getting following outputs:
-
-* Total Road Length: ``55.68 km``
-* Optimal Network Length: ``29.89 km``

Length of minimum spanning tree is about half of the length of total road network.

Further possible extensions to the exercise
================================================================================

* Find the optimal network of roads such that it reaches every building
* Find the optimal number and locations of Electricity Transformers
