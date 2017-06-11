..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

.. _routing:

pgRouting Algorithms
===============================================================================

.. thumbnail:: images/route.png
  :width: 300pt
  :align: center

pgRouting was first called *pgDijkstra*, because it implemented only shortest
path search with *Dijkstra* algorithm. Later other functions were added and the
library was renamed to pgRouting. This chapter will cover selected pgRouting
algorithms and some of the attributes required.

* :ref:`dijkstra`

  * :ref:`Exercise 1 <exercise-1>` - Single Pedestrian Routing.
  * :ref:`Exercise 2 <exercise-2>` - Many Pedestrians going to the same destination.
  * :ref:`Exercise 3 <exercise-3>` - Many Pedestrians departing from the same location.
  * :ref:`Exercise 4 <exercise-4>` - Many Pedestrians going to different destinations.

* :ref:`dijkstraCost`

  * :ref:`Exercise 5 <exercise-5>` - Many Pedestrians going to different
    destinations, interested only on the aggregate cost.

.. _dijkstra:

pgr_dijkstra
-------------------------------------------------------------------------------

Dijkstra algorithm was the first algorithm implemented in pgRouting. It doesn't
require other attributes than ``id``, ``source`` and ``target`` ID and ``cost``.
You can specify when to consider the graph as `directed
<http://en.wikipedia.org/wiki/Directed_graph>`_ or undirected.

.. rubric:: Signature Summary

.. code-block:: sql

  pgr_dijkstra(edges_sql, start_vid,  end_vid)
  pgr_dijkstra(edges_sql, start_vid,  end_vid  [, directed])
  pgr_dijkstra(edges_sql, start_vid,  end_vids [, directed])
  pgr_dijkstra(edges_sql, start_vids, end_vid  [, directed])
  pgr_dijkstra(edges_sql, start_vids, end_vids [, directed])

  RETURNS SET OF (seq, path_seq [, start_vid] [, end_vid], node, edge, cost, agg_cost)
      OR EMPTY SET

Description of the parameters can be found in `pgr_dijkstra
<http://docs.pgrouting.org/2.4/en/pgr_dijkstra.html#description-of-the-signatures>`_.

.. note::
  * Many pgRouting functions have ``sql::text`` as one of their arguments. While
    this may look confusing at first, it makes the functions very flexible as
    the user can pass any ``SELECT`` statement as function argument as long as
    the returned result contains the required number of attributes and the
    correct attribute names.
  * Most of pgRouting implemeted algorithms do not require the network geometry.
  * Most of pgRouting functions do not return a geometry, but only an ordered
    list of nodes or edges.

.. rubric:: Identifiers for the Queries

The assignment of the vertices identifiers on the source and target columns may
be different, the following exercises will use the results of this query.
For the workshop, some locations of the FOSS4G Boston event are going to be used.
These locations are within this area http://www.openstreetmap.org/#map=14/42.3577/-71.1164


.. code-block:: sql

  SELECT osm_id, id FROM ways_vertices_pgr
      WHERE osm_id IN (61324740, 61350413, 61479912, 1718017636, 2481136250)
      ORDER BY osm_id;
      osm_id   |  id   
   ------------+-------
      61324740 | 16061
      61350413 |  3991
      61479912 | 12800
    1718017636 | 25322
    2481136250 | 17794
   (5 rows)

* `61324740` is the CGIS-knafel with :code:`id = 16061`
* `61350413` is the entrance of the Seaport Hotel & World Trade Center  with :code:`id = 3991`.
* `61479912` is the Harpoon Brewery  with :code:`id = 12800`
* `1718017636` is the Westin Boston Waterfront  with :code:`id = 25322`
* `2481136250` is the New England Aquarium with :code:`id = 17794`

The corresponding :code:`id`, is used in the workshop, here is a sample route:

.. thumbnail:: images/route.png
  :width: 300pt

.. _exercise-1:
.. rubric:: Exercise 1 - "Single pedestrian routing"

* The pedestrian wants to go from vertex ``13224`` to vertex ``6549``.
* The pedestrian's cost is in terms of length. In this case ``length``, which
  was calculated by osm2pgrouting, is in unit ``degrees``.
* From a pedestrian perspective the graph is ``undirected``, that is, the
  pedestrian can move in both directions on all segments.

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-1.txt
  :end-before: d-2.txt

:ref:`sol-1`

.. note::
  * With more complex SQL statements, using JOINs for example, the result may be
    in a wrong order. In that case ``ORDER BY seq`` will ensure that the path is
    in the right order again.
  * The returned cost attribute represents the cost specified in the
    ``edges_sql::text`` argument. In this example cost is ``length`` in unit
    "degrees". Cost may be time, distance or any combination of both or any
    other attributes or a custom formula.
  * ``node`` and ``edge`` results may vary depending on the assignment of the
    identifiers to the vertices given by osm2pgrouting.

.. _exercise-2:
.. rubric:: Exercise 2 - "Many Pedestrians going to the same destination."

* The pedestrians are located at vertices ``6549``, ``1458`` and ``9224``.
* All pedestrians want to go to vertex ``13224``.
* The cost to be in meters using attribute ``length_m``.

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-2.txt
  :end-before: d-3.txt

:ref:`sol-2`

.. _exercise-3:
.. rubric:: Exercise 3 - "Many Pedestrians departing from the same location"

* All pedestrians are starting from vertex ``13224``.
* The pedestrians want to go to locations ``6549``, ``1458`` and ``9224``.
* The cost to be in seconds, with a walking speed ``s = 1.3 m/s`` and ``t = d/s``

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-3.txt
  :end-before: d-4.txt

:ref:`sol-3`

.. _exercise-4:
.. rubric:: Exercise 4 - "Many Pedestrians going to different destinations."

* The pedestrians are located at vertices ``6549``, ``1458`` and ``9224``.
* The pedestrians want to go to destinations ``13224`` or ``6963``.
* The cost to be in minutes, with a walking speed ``s = 1.3 m/s`` and ``t = d/s``

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-4.txt
  :end-before: d-5.txt

:ref:`sol-4`




.. note::
  Inspecting the results, looking for totals (when `edge = -1`):

  * If they go to vertex 3991: the total time would be approximately:
    ``42.2043207264202 = 11.0653331908227 + 23.4190755088423 + 7.71991202675522``

  * If they go to vertex 16061: the total time would be approximately:
    ``263.322345688827 = 97.6387559904243 + 74.6873580103822 + 90.9962316880208``

.. _dijkstraCost:

pgr_dijkstraCost
-------------------------------------------------------------------------------

When the main goal is to calculate the total cost, for example to calculate
multiple routes for a cost matrix, then ``pgr_dijkstraCost`` returns a more
compact result.

.. rubric:: Signature Summary

.. code-block:: none

  pgr_dijkstraCost(edges_sql, start_vid,  end_vid)
  pgr_dijkstraCost(edges_sql, start_vid,  end_vid,  directed)
  pgr_dijkstraCost(edges_sql, start_vid,  end_vids, directed)
  pgr_dijkstraCost(edges_sql, start_vids, end_vid,  directed)
  pgr_dijkstraCost(edges_sql, start_vids, end_vids, directed)

  RETURNS SET OF (start_vid, end_vid, agg_cost)
      OR EMPTY SET

Description of the parameters can be found in `pgr_dijkstraCost
<http://docs.pgrouting.org/latest/en/src/dijkstra/doc/pgr_dijkstraCost.html#description-of-the-signatures>`_

.. _exercise-5:
.. rubric:: Exercise 5 - "Many Pedestrians going to different destinations returning aggregate costs."

* The pedestrians are located at vertices ``6549``, ``1458`` and ``9224``.
* The pedestrians want to go to destinations ``13224`` or ``6963``.
* The cost to be in minutes, with a walking speed ``s = 1.3 m/s`` and ``t = d/s``
* Result as aggregated costs.

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-5.txt
  :end-before: d-6.txt

:ref:`sol-5`

.. _exercise-6:
.. rubric:: Exercise 6 - "Many Pedestrians going to different destinations sumirizes the total costs per destination."

* The pedestrians are located at vertices ``6549``, ``1458`` and ``9224``.
* The pedestrians want to go to destinations ``13224`` or ``6963``.
* The cost to be in minutes, with a walking speed ``s = 1.3 m/s`` and ``t = d/s``
* Result adds the costs per destination.

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-6.txt

:ref:`sol-6`
