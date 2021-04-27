..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: https://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

pgRouting Algorithms
===============================================================================

.. image:: /images/route.png
  :scale: 25%
  :align: center

**pgRouting** was first called *pgDijkstra*, because it implemented only shortest
path search with *Dijkstra* algorithm. Later other functions were added and the
library was renamed to pgRouting.


.. contents:: Chapter Contents

pgr_dijkstra
-------------------------------------------------------------------------------

Dijkstra algorithm was the first algorithm implemented in pgRouting. It doesn't
require other attributes than ``id``, ``source`` and ``target`` ID and ``cost``
and ``reverse_cost``.

You can specify when to consider the graph as `directed
<https://en.wikipedia.org/wiki/Directed_graph>`__ or undirected.

.. rubric:: Signature Summary

.. code-block:: sql

  pgr_dijkstra(Edges SQL, start_vid,  end_vid  [, directed])
  pgr_dijkstra(Edges SQL, start_vid,  end_vids [, directed])
  pgr_dijkstra(Edges SQL, start_vids, end_vid  [, directed])
  pgr_dijkstra(Edges SQL, start_vids, end_vids [, directed])
  pgr_dijkstra(Edges SQL, Combinations SQL [, directed])

  RETURNS SET OF (seq, path_seq [, start_vid] [, end_vid], node, edge, cost, agg_cost)
      OR EMPTY SET

Description of the parameters can be found in `pgr_dijkstra
<https://docs.pgrouting.org/latest/en/pgr_dijkstra.html#description-of-the-signatures>`__.

.. note::
  * Many pgRouting functions have ``sql::text`` as one of their arguments. While
    this may look confusing at first, it makes the functions very flexible as
    the user can pass a ``SELECT`` statement as function argument as long as
    the returned result contains the required number of attributes and the
    correct attribute names.
  * Most of pgRouting implemented algorithms do not require the **geometry**.
  * The pgRouting functions **do not** return a geometry, but only an ordered
    list of nodes or edges.

.. rubric:: Identifiers for the Queries

The assignment of the vertices identifiers on the source and target columns may
be different, the following exercises will use the results of this query.
For the workshop, some locations near of the FOSS4G Bucharest event are going to be used.
These locations are within this area https://www.openstreetmap.org/#map=14/44.4291/26.0854

* |osmid_1| |place_1|
* |osmid_2| |place_2|
* |osmid_3| |place_3|
* |osmid_4| |place_4|
* |osmid_5| |place_5|


Connect to the database, if not connected:

::

  psql city_routing

Get the vertex identifiers

.. literalinclude:: ../scripts/chapter_5/all_exercises_5.sql
  :language: sql
  :start-after: exercise_5_0.txt
  :end-before: exercise_5_1.txt
  :linenos:

|

.. literalinclude:: ../scripts/chapter_5/section-5.1-1.txt
  :linenos:

* |osmid_1| |place_1|  (|id_1|)
* |osmid_2| |place_2|  (|id_2|)
* |osmid_3| |place_3|  (|id_3|)
* |osmid_4| |place_4|  (|id_4|)
* |osmid_5| |place_5|  (|id_5|)


The corresponding :code:`id` are shown in the following image, and a sample route from
"|place_3|" to "|place_5|".


.. image:: /images/route.png
  :scale: 25%

Exercise 1: Single pedestrian routing
...............................................................................

.. rubric:: Problem:

* Walking from "|place_1|" to the "|place_3|".

.. image:: /images/pedestrian-route1.png
  :scale: 25%
  :alt: From the |place_1| to the |place_3|

.. rubric:: Solution:

* The pedestrian wants to go from vertex |id_1| to vertex |id_3| (lines **9** and **10**).
* The pedestrian's cost is in terms of length. In this case ``length`` (line **6**), which
  was calculated by osm2pgrouting, is in unit ``degrees``.
* From a pedestrian perspective the graph is ``undirected`` (line **11**), that is, the
  pedestrian can move in both directions on all segments.

.. literalinclude:: ../scripts/chapter_5/all_exercises_5.sql
  :language: sql
  :start-after: exercise_5_1.txt
  :end-before: exercise_5_2.txt
  :linenos:
  :emphasize-lines: 3-7

|

:ref:`Query results for chapter 5 exercise 1`

.. note::
  * The returned cost attribute represents the cost specified in the
    inner SQL query (``edges_sql::text`` argument). In this example cost is ``length`` in unit
    "degrees". Cost may be time, distance or any combination of both or any
    other attributes or a custom formula.
  * ``node`` and ``edge`` results may vary depending on the assignment of the
    identifiers to the vertices given by osm2pgrouting.

Exercise 2: Many Pedestrians going to the same destination
...............................................................................

.. rubric:: Problem:

* Walking from the "|place_1|" and "|place_2|" to the "|place_3|".

.. image:: /images/pedestrian-route2.png
  :scale: 25%
  :alt: From |place_1| and |place_2| to |place_3|

.. rubric:: Solution:

* The pedestrians are departing at vertices |id_1| and |id_2| (line **9**).
* All pedestrians want to go to vertex |id_3| (line **10**).
* The cost to be in meters using attribute ``length_m`` (line **6**).

.. literalinclude:: ../scripts/chapter_5/all_exercises_5.sql
  :language: sql
  :start-after: exercise_5_2.txt
  :end-before: exercise_5_3.txt
  :linenos:
  :emphasize-lines: 9

|

:ref:`Query results for chapter 5 exercise 2`


Exercise 3: Many Pedestrians departing from the same location
...............................................................................

.. rubric:: Problem:

* Walking from the "|place_3|" to the "|place_1|" and "|place_2|" (in seconds).

.. image:: /images/pedestrian-route2.png
  :scale: 25%
  :alt: From the hotels to/from the venue

.. rubric:: Solution:

* All pedestrians are departing from vertex |id_3| (line **9**).
* Pedestrians want to go to locations |id_1| and |id_2| (line **10**).
* The cost to be in seconds, with a walking speed ``s = 1.3 m/s`` and ``t = d/s`` (line **6**).

.. literalinclude:: ../scripts/chapter_5/all_exercises_5.sql
  :language: sql
  :start-after: exercise_5_3.txt
  :end-before: exercise_5_4.txt
  :linenos:
  :emphasize-lines: 10

:ref:`Query results for chapter 5 exercise 3`


Exercise 4: Many Pedestrians going to different destinations
...............................................................................

.. rubric:: Problem:

* Walking from the hotels to the "|place_4|" and "|place_5|" (in minutes).

.. image:: /images/pedestrian-route4.png
  :scale: 25%
  :alt: From the hotels to the |place_4| and |place_5|

.. rubric:: Solution:

* The pedestrians depart from |id_1| and |id_2| (line **9**).
* The pedestrians want to go to destinations |id_4| and |id_5| (line **10**).
* The cost to be in minutes, with a walking speed ``s = 1.3 m/s`` and ``t = d/s`` (line **6**).
* Result adds the costs per destination.

.. literalinclude:: ../scripts/chapter_5/all_exercises_5.sql
  :language: sql
  :start-after: exercise_5_4.txt
  :end-before: exercise_5_5.txt
  :linenos:
  :emphasize-lines: 9-10

|

:ref:`Query results for chapter 5 exercise 4`


.. note::
  Inspecting the results, looking for totals (`edge = -1`):

  * Going to vertex |id_4|:

    - from |id_1| takes 6.67.. minutes (seq = 72)
    - from |id_2| takes 6.92.. minutes (seq = 141)

  * Going to to vertex |id_5|:

    - from |id_1| takes 19.69.. minutes (seq = 43)
    - from |id_2| takes 17.26.. minutes (seq = 122)


pgr_dijkstraCost
-------------------------------------------------------------------------------

When the main goal is to calculate the total cost, without "inspecting" the `pgr_dijkstra` results,
using ``pgr_dijkstraCost`` returns a more compact result.

.. rubric:: Signature Summary

.. code-block:: none

  pgr_dijkstraCost(edges_sql, start_vid,  end_vid  [, directed])
  pgr_dijkstraCost(edges_sql, start_vid,  end_vids [, directed])
  pgr_dijkstraCost(edges_sql, start_vids, end_vid  [, directed])
  pgr_dijkstraCost(edges_sql, start_vids, end_vids [, directed])
  pgr_dijkstraCost(edges_sql, combinations_sql   [, directed])

  RETURNS SET OF (start_vid, end_vid, agg_cost)
      OR EMPTY SET

Description of the parameters can be found in `pgr_dijkstraCost
<https://docs.pgrouting.org/latest/en/pgr_dijkstraCost.html#description-of-the-signatures>`__


Exercise 5: Many Pedestrians going to different destinations returning aggregate costs
...................................................................................................

.. rubric:: Problem:

* Walking from the hotels to the "|place_4|" or "|place_5|" (get only the cost in minutes).

.. image:: /images/pedestrian-route5.png
  :scale: 25%
  :alt: From the hotels to the |place_4| and |place_5|

.. rubric:: Solution:

* The pedestrians depart from |id_1| and |id_2| (line **10**).
* The pedestrians want to go to destinations |id_4| and |id_5| (line **11**).
* The cost to be in minutes, with a walking speed ``s = 1.3 m/s`` and ``t = d/s`` (line **7**).
* Result as aggregated costs.

.. literalinclude:: ../scripts/chapter_5/all_exercises_5.sql
  :language: sql
  :start-after: exercise_5_5.txt
  :end-before: exercise_5_6.txt
  :linenos:
  :emphasize-lines: 2

|

:ref:`Query results for chapter 5 exercise 5`

Compare with :ref:`Exercise 4 <Exercise 4: Many Pedestrians going to different destinations>` 's note.


Exercise 6: Many Pedestrians going to different destinations summarizing the total costs per departure
...........................................................................................................

.. rubric:: Problem:

* Walking from the hotels to the "|place_4|" or "|place_5|" (summarize cost in minutes).

.. rubric:: Solution:

* The pedestrians depart from |id_1| and |id_2| (line **10**).
* The pedestrians want to go to destinations |id_4| and |id_5| (line **11**).
* The cost to be in minutes, with a walking speed s = 1.3 m/s and t = d/s (line **7**).
* Result adds the costs per destination.

.. literalinclude:: ../scripts/chapter_5/all_exercises_5.sql
  :language: sql
  :start-after: exercise_5_6.txt
  :linenos:
  :emphasize-lines: 13-14

|

:ref:`Query results for chapter 5 exercise 6`


.. note:: An interpretation of the result can be: In general, it is faster to depart from the "|place_2|" than from the "|place_1|".
