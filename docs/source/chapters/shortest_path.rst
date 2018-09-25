..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

pgRouting Algorithms
===============================================================================

.. image:: /images/route.png
  :width: 300pt
  :align: center

pgRouting was first called *pgDijkstra*, because it implemented only shortest
path search with *Dijkstra* algorithm. Later other functions were added and the
library was renamed to pgRouting.


.. contents:: Chapter Contents

pgr_dijkstra
-------------------------------------------------------------------------------

Dijkstra algorithm was the first algorithm implemented in pgRouting. It doesn't
require other attributes than ``id``, ``source`` and ``target`` ID and ``cost``.
You can specify when to consider the graph as `directed
<http://en.wikipedia.org/wiki/Directed_graph>`__ or undirected.

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
<http://docs.pgrouting.org/latest/en/pgr_dijkstra.html#description-of-the-signatures>`__.

.. note::
  * Many pgRouting functions have ``sql::text`` as one of their arguments. While
    this may look confusing at first, it makes the functions very flexible as
    the user can pass any ``SELECT`` statement as function argument as long as
    the returned result contains the required number of attributes and the
    correct attribute names.
  * Most of pgRouting implemeted algorithms do not require the network geometry.
  * Most of pgRouting functions **do not** return a geometry, but only an ordered
    list of nodes or edges.

.. rubric:: Identifiers for the Queries

The assignment of the vertices identifiers on the source and target columns may
be different, the following exercises will use the results of this query.
For the workshop, some locations of the FOSS4G Boston event are going to be used.
These locations are within this area http://www.openstreetmap.org/#map=14/42.3526/-71.0502

.. note:: Connect to the database with if not connected:
    ::

        psql city_routing

.. code-block:: sql

  SELECT osm_id, id FROM ways_vertices_pgr
        WHERE osm_id IN (252643343, 1645787956, 302056515, 252963461, 302057309)
        ORDER BY osm_id;
     osm_id   |  id
  ------------+------
    252643343 | 1195
    252963461 | 1461
    302056515 | 1256
    302057309 | 1639
   1645787956 |  856
  (5 rows)

* `252643343,` is the intersection near the entrance to the venue, at the Shaaban Robert Street & Ghana street :code:`id = 1195`.
* `252963461` is the  National Museum and House of Culture with :code:`id = 1461`
* `302056515` is the Fish market and the beach :code:`id = 1256`
* `302057309` is the Serena Hotel with :code:`id = 1639`
* `1645787956` is the entrance of the botanical garden :code:`id = 856`

The corresponding :code:`id` are shown in the following image, and a sample route from the venue to the fish market:

.. image:: /images/route.png
  :width: 300pt

.. _exercise-d-1:

Exercise 1 - Single pedestrian routing.
...............................................................................

.. rubric:: Walking from the Serena hotel to the Venue

.. image:: /images/pedestrian-route1.png
  :width: 300pt
  :alt: From the Serena Hotel, going to the Venue


* The pedestrian wants to go from vertex ``1639`` to vertex ``1195``.
* The pedestrian's cost is in terms of length. In this case ``length``, which
  was calculated by osm2pgrouting, is in unit ``degrees``.
* From a pedestrian perspective the graph is ``undirected``, that is, the
  pedestrian can move in both directions on all segments.

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-1.txt
  :end-before: d-2.txt

:ref:`Solution to Exercise 1`

.. note::
  * The returned cost attribute represents the cost specified in the
    inner SQL query (``edges_sql::text`` argument). In this example cost is ``length`` in unit
    "degrees". Cost may be time, distance or any combination of both or any
    other attributes or a custom formula.
  * ``node`` and ``edge`` results may vary depending on the assignment of the
    identifiers to the vertices given by osm2pgrouting.

.. _exercise-d-2:

Exercise 2 - Many Pedestrians going to the same destination.
...............................................................................

.. rubric:: Walking from the Serena hotel and from the venue to the botanical garden (in meters).

.. image:: /images/pedestrian-route2.png
  :width: 300pt
  :alt: From the hotel & venue, to/from the botanical garden

* The pedestrians are departing at vertices ``1639``, ``1195``.
* All pedestrians want to go to vertex ``856``.
* The cost to be in meters using attribute ``length_m``.

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-2.txt
  :end-before: d-3.txt

:ref:`Solution to Exercise 2`

.. _exercise-d-3:

Exercise 3 - Many Pedestrians departing from the same location.
...............................................................................

.. rubric:: Walking back to the hotel and venue after visiting the botanical garden (in seconds).

.. image:: /images/pedestrian-route2.png
  :width: 300pt
  :alt: From the hotel & venue, to/from the botanical garden

* All pedestrians are departing from vertex ``856``.
* Pedestrians want to go to locations ``1639``, ``1195``.
* The cost to be in seconds, with a walking speed ``s = 1.3 m/s`` and ``t = d/s``

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-3.txt
  :end-before: d-4.txt

:ref:`Solution to Exercise 3`

.. _exercise-d-4:

Exercise 4 - Many Pedestrians going to different destinations.
...............................................................................

.. rubric:: Walking from the hotel or venue to the Botanical garden or the museum (in minutes).

.. image:: /images/pedestrian-route4.png
  :width: 300pt
  :alt: From the hotels & venue, to sighseen

* The pedestrians depart from ``1639``, ``1195``.
* The pedestrians want to go to destinations ``856``, ``1256``.
* The cost to be in minutes, with a walking speed ``s = 1.3 m/s`` and ``t = d/s``
* Result adds the costs per destination.

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-6.txt

:ref:`Solution to Exercise 4`



.. note::
  Inspecting the results, looking for totals (`edge = -1`):

  * Going to vertex 856:

    - from 1195 takes 7.58936281639964 minutes (row 4)
    - from 1639 takes 14.1217680758304  minutes (row 23)

  * Going to to vertex 1256:

    - from 1195 takes 20.5968484435532 minutes (row 16)
    - from 1639 takes 26.7767911805329  minutes (row 39)


pgr_dijkstraCost
-------------------------------------------------------------------------------

When the main goal is to calculate the total cost, without "inspecting" the `pgr_dijkstra` results,
using ``pgr_dijkstraCost`` returns a more compact result.

.. rubric:: Signature Summary

.. code-block:: none

  pgr_dijkstraCost(edges_sql, start_vid,  end_vid)
  pgr_dijkstraCost(edges_sql, start_vid,  end_vid  [, directed])
  pgr_dijkstraCost(edges_sql, start_vid,  end_vids [, directed])
  pgr_dijkstraCost(edges_sql, start_vids, end_vid  [, directed])
  pgr_dijkstraCost(edges_sql, start_vids, end_vids [, directed])

  RETURNS SET OF (start_vid, end_vid, agg_cost)
      OR EMPTY SET

Description of the parameters can be found in `pgr_dijkstraCost
<http://docs.pgrouting.org/2.2/en/src/dijkstra/doc/pgr_dijkstraCost.html#description-of-the-signatures>`_

.. _exercise-d-5:

Exercise 5 - Many Pedestrians going to different destinations returning aggregate costs.
...................................................................................................

.. image:: /images/pedestrian-route5.png
  :width: 300pt
  :alt: From the hotels & venue, to sighseen

.. rubric:: Walking from the hotel or venue to the Botanical garden or the museum (get only the cost in minutes).

* The pedestrians depart from ``1639``, ``1195``.
* The pedestrians want to go to destinations ``856``, ``1256``.
* The cost to be in minutes, with a walking speed ``s = 1.3 m/s`` and ``t = d/s``
* Result as aggregated costs.

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-5.txt
  :end-before: d-6.txt


:ref:`Solution to Exercise 5`

Compare with :ref:`Exercise 4 <exercise-d-4>` 's note.

.. _exercise-d-6:

Exercise 6 - Many Pedestrians going to different destinations sumirizes the total costs per destination.
...........................................................................................................

.. rubric:: Walking from the hotel or venue to the Botanical garden or the museum (sumirize cost in minutes).

* The pedestrians depart from ``1639``, ``1195``.
* The pedestrians want to go to destinations ``856``, ``1256``.
* The cost to be in minutes, with a walking speed s = 1.3 m/s and t = d/s
* Result adds the costs per destination.

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-6.txt


:ref:`Solution to Exercise 6`

.. note:: An interpretation of the result can be: In general, it is slightly faster to depart from the Venue.
