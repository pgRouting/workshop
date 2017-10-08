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
These locations are within this area http://www.openstreetmap.org/#map=14/42.3526/-71.0502

.. note:: Connect to the database with if not connected:
    ::

        psql city_routing

.. code-block:: sql

  SELECT osm_id, id FROM ways_vertices_pgr
      WHERE osm_id IN (61350413, 61441749, 61479912, 61493634, 1718017636, 2481136250)
      ORDER BY osm_id;
      
       osm_id   |  id   
    ------------+-------
       61350413 |  3986
       61441749 |  4793
       61479912 | 13009
       61493634 | 12235
     1718017636 |  9411
     2481136250 |  8401
    (6 rows)

* `61350413` is the entrance to the venue, at the Seaport Hotel & World Trade Center  with :code:`id = 3986`.
* `61441749` is the Central Parking at the Airport with :code:`id = 4793`
* `61479912` is the Harpoon Brewery  with :code:`id = 13009`
* `61493634` is the  Market Place with :code:`id = 12235`
* `1718017636` is the Westin Boston Waterfront  with :code:`id = 9411`
* `2481136250` is the New England Aquarium with :code:`id = 8401`

The corresponding :code:`id` are shown in the following image, and a sample route from the venue to the airport:

.. image:: /images/route.png
  :width: 300pt

.. _exercise-d-1:

Exercise 1 - Single pedestrian routing.
...............................................................................

.. rubric:: Walking from the Westin hotel to the Venue

.. image:: /images/pedestrian-route1.png
  :width: 300pt
  :alt: From the Westin, going to the Venue


* The pedestrian wants to go from vertex ``9411`` to vertex ``3986``.
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

.. rubric:: Walking from the Westin and Seaport hotels to the brewry (in meters). 

.. image:: /images/pedestrian-route2.png
  :width: 300pt
  :alt: From the hotels, going to/from the brewry

* The pedestrians are located at vertices ``3986``, ``9411``.
* All pedestrians want to go to vertex ``13009``.
* The cost to be in meters using attribute ``length_m``.

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-2.txt
  :end-before: d-3.txt

:ref:`Solution to Exercise 2`

.. _exercise-d-3:

Exercise 3 - Many Pedestrians departing from the same location.
...............................................................................

.. rubric:: Walking back to the hotels after having the beer (in seconds). 

.. image:: /images/pedestrian-route2.png
  :width: 300pt
  :alt: From the hotels, going to/from the brewry

* All pedestrians are starting from vertex ``13009``.
* Pedestrians want to go to locations ``3986``, ``9411``.
* The cost to be in seconds, with a walking speed ``s = 1.3 m/s`` and ``t = d/s``

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-3.txt
  :end-before: d-4.txt

:ref:`Solution to Exercise 3`

.. _exercise-d-4:

Exercise 4 - Many Pedestrians going to different destinations.
...............................................................................

.. rubric:: Walking from the hotels to the Market and to the Aquarium (in minutes). 

.. image:: /images/pedestrian-route4.png
  :width: 300pt
  :alt: From the hotels, to sighseen

* The hotels are located at vertices ``3986``, ``9411``.
* Pedestrians want to go to destinations ``8401``, ``12235``.
* The cost to be in minutes, with a walking speed ``s = 1.3 m/s`` and ``t = d/s``

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-4.txt
  :end-before: d-5.txt

:ref:`Solution to Exercise 4`


.. note::
  Inspecting the results, looking for totals (`edge = -1`):

  * Going to vertex 8401:

    - from 3986 takes 23.4190755088423 minutes (row 42)
    - from 9411 takes 26.7078952983972 minutes (row 125)

  * Going to to vertex 12235:

    - from 3986 takes 23.9778917105248 minutes (row 83)
    - from 9411 takes 26.7679707128945 minutes (row 167) 


pgr_dijkstraCost
-------------------------------------------------------------------------------

When the main goal is to calculate the total cost, without "inspecting" the `pgr_dijkstra` results,
using ``pgr_dijkstraCost`` returns a more compact result.

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
<http://docs.pgrouting.org/2.2/en/src/dijkstra/doc/pgr_dijkstraCost.html#description-of-the-signatures>`_

.. _exercise-d-5:

Exercise 5 - Many Pedestrians going to different destinations returning aggregate costs.
...................................................................................................

.. image:: /images/pedestrian-route5.png
  :width: 300pt
  :alt: From the hotels, to sighseen

.. rubric:: Walking from the hotels to the Market and to the Aquarium (get only the cost in minutes). 

* The hotels are located at vertices ``3986``, ``9411``.
* Pedestrians want to go to destinations ``8401``, ``12235``.
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

.. rubric:: Walking from the hotels to the Market and to the Aquarium (sumirize cost in minutes). 

* The hotels are located at vertices ``3986``, ``9411``.
* Pedestrians want to go to destinations ``8401``, ``12235``.
* The cost to be in minutes, with a walking speed ``s = 1.3 m/s`` and ``t = d/s``
* Result adds the costs per destination.

.. literalinclude:: solutions/shortest_problems.sql
  :language: sql
  :start-after: d-6.txt

:ref:`Solution to Exercise 6`

.. note:: An interpretation of the result can be: In general, it is slightly faster to go to the Aquarium from any of the hotels.
