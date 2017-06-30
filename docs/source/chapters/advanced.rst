..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

.. _advanced:

Advanced Routing Queries
===============================================================================

.. thumbnail:: images/route.png
  :width: 300pt
  :align: center

Routing, is not limited to pedestrians. This chapter covers routing vehicles
and manipulation of the query costs:

.. contents:: Chapter Contents


Routing for Vehicles
-------------------------------------------------------------------------------

A query for vehicle routing generally differs from routing for pedestrians:

* the road segments are considered `directed`,
* the `reverse_cost` attribute must be taken into account.

This is due to the fact that there are roads that
are "one way".

Depending on the geometry, the valid way:

* (source, target) segment (``cost >= 0`` and ``reverse_cost < 0``)
* (target, source) segment (``cost < 0`` and ``reverse_cost >= 0``)

So a "wrong way" is indicated with a **negative value** and is not inserted in the
graph for processing.

For two way roads ``cost >= 0`` and ``reverse_cost >= 0`` and their values can
be different. For example, it is faster going down hill on a sloped road.
In general ``cost`` and ``reverse_cost`` do not need to be length; they can be
almost anything, for example time, slope, surface, road type, etc., or they can
be a combination of multiple parameters.

.. rubric:: The following queries indicate the number of road segments, where a "one way" rule applies:

#. Number of (source, target) segments with ``cost < 0``

   .. literalinclude:: solutions/manipulate_costs.sql
        :language: sql
        :start-after: cost_manipulation-1.txt
        :end-before: cost_manipulation-2.txt


   .. literalinclude:: solutions/cost_manipulation-1.txt

#. Number of (target, source) segments with ``reverse_cost < 0``

   .. literalinclude:: solutions/manipulate_costs.sql
        :language: sql
        :start-after: cost_manipulation-2.txt
        :end-before: cost_manipulation-3.txt

   .. literalinclude:: solutions/cost_manipulation-1.txt

.. _exercise-7:

Exercise 7 - Vehicle routing - Going
...............................................................................

.. rubric:: From the Westin, going to the Brewry by car.

.. thumbnail:: images/car-route1.png
  :width: 300pt
  :alt: From the Westin, going to the Brewry by car

* The vehicle is going from vertex ``9411`` to vertex ``13009``.
* Use ``cost`` and ``reverse_cost`` columns, which are in unit ``degrees``.

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: ad-7.txt
  :end-before: ad-8.txt

:ref:`sol-7`



.. _exercise-8:

Exercise 8 - Vehicle routing - Returning
...............................................................................

.. rubric:: From the Brewry, going to the Westin by car.

.. thumbnail:: images/car-route2.png
  :width: 300pt
  :alt: From the Brewry, going to the Westin by car

* The vehicle is going from vertex ``13009`` to vertex ``9411``.
* Use ``cost`` and ``reverse_cost`` columns, which are in unit ``degrees``.

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: ad-8.txt
  :end-before: ad-9.txt

:ref:`sol-8`

.. note:: On a directed graph, going and coming back routes, most of the time are different.

.. _exercise-9:

Exercise 9 - Vehicle routing where "time is money"
...............................................................................

* The vehicle is going from vertex ``13224`` to vertex ``9224``.
* The cost is ``€100 per 3600 seconds``.
* Use ``cost_s`` and ``reverse_cost_s`` columns, which are in unit ``seconds``.
* The duration in hours is ``cost / 3600``
* The cost in € is ``cost / 3600 * 100``

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: ad-9.txt
  :end-before: tmp.txt

:ref:`sol-9`

.. note::
  Comparing with :ref:`Exercise 7<exercise-7>`:

  * The total number of records are identical
  * The node sequence is identical
  * The edge sequence is identical
  * The cost and agg_cost results are directly proportional

.. _modify:

Cost Manipulations
-------------------------------------------------------------------------------

In "real" networks there are different limitations or preferences for different
road types for example. In other words, we don't want to get the *shortest* but
the **cheapest** path - a path with a minimal cost. There is no limitation in
what we take as costs.

When we convert data from OSM format using the osm2pgrouting tool, we get two
additional tables: ``osm_way_types`` and ``osm_way_classes``:

.. rubric:: Run ``SELECT * FROM osm_way_types ORDER BY type_id;``

.. code-block:: sql

    type_id |   name
   ---------+-----------
          1 | highway
          2 | cycleway
          3 | tracktype
          4 | junction
  (4 rows)

.. rubric:: Run ``SELECT * FROM osm_way_classes ORDER BY class_id;``

.. code-block:: sql

   class_id | type_id |       name        | priority | default_maxspeed
  ----------+---------+-------------------+----------+------------------
        100 |       1 | road              |        1 |               50
        101 |       1 | motorway          |        1 |               50
        102 |       1 | motorway_link     |        1 |               50
        103 |       1 | motorway_junction |        1 |               50
        104 |       1 | trunk             |        1 |               50
        105 |       1 | trunk_link        |        1 |               50
        106 |       1 | primary           |        1 |               50
        107 |       1 | primary_link      |        1 |               50
        108 |       1 | secondary         |        1 |               50
        109 |       1 | tertiary          |        1 |               50
        110 |       1 | residential       |        1 |               50
        111 |       1 | living_street     |        1 |               50
        112 |       1 | service           |        1 |               50
        113 |       1 | track             |        1 |               50
        114 |       1 | pedestrian        |        1 |               50
        115 |       1 | services          |        1 |               50
        116 |       1 | bus_guideway      |        1 |               50
        117 |       1 | path              |        1 |               50
        118 |       1 | cycleway          |        1 |               50
        119 |       1 | footway           |        1 |               50
        120 |       1 | bridleway         |        1 |               50
        121 |       1 | byway             |        1 |               50
        122 |       1 | steps             |        1 |               50
        123 |       1 | unclassified      |        1 |               50
        124 |       1 | secondary_link    |        1 |               50
        125 |       1 | tertiary_link     |        1 |               50
        201 |       2 | lane              |        1 |               50
        202 |       2 | track             |        1 |               50
        203 |       2 | opposite_lane     |        1 |               50
        204 |       2 | opposite          |        1 |               50
        301 |       3 | grade1            |        1 |               50
        302 |       3 | grade2            |        1 |               50
        303 |       3 | grade3            |        1 |               50
        304 |       3 | grade4            |        1 |               50
        305 |       3 | grade5            |        1 |               50
        401 |       4 | roundabout        |        1 |               50
  (36 rows)

.. rubric:: Manipulating cost values

* The :code:`osm_way_classes` table is linked with the :code:`ways` table by the
  :code:`class_id` field.
* Its values can be changed with an ``UPDATE`` query.

Let's change the cost values for the :code:`osm_way_classes` table, that the use
of "faster" roads is encouraged when the cost of each road segment is multiplied
with a certain factor:

.. code-block:: sql

  ALTER TABLE osm_way_classes ADD COLUMN penalty FLOAT;
  UPDATE osm_way_classes SET penalty=1;
  UPDATE osm_way_classes SET penalty=2.0 WHERE name IN ('pedestrian','steps','footway');
  UPDATE osm_way_classes SET penalty=1.5 WHERE name IN ('cicleway','living_street','path');
  UPDATE osm_way_classes SET penalty=0.8 WHERE name IN ('secondary','tertiary');
  UPDATE osm_way_classes SET penalty=0.6 WHERE name IN ('primary','primary_link');
  UPDATE osm_way_classes SET penalty=0.4 WHERE name IN ('trunk','trunk_link');
  UPDATE osm_way_classes SET penalty=0.3 WHERE name IN ('motorway','motorway_junction','motorway_link');

.. _exercise-10:

Exercise 9 - Vehicle routing preferring "fast" roads
...............................................................................

* The vehicle is going from vertex ``13224`` to vertex ``9224``.
* Use ``cost_s`` and ``reverse_cost_s`` columns, which are in unit ``seconds``.
* Costs are the original costs in seconds multiplied with :code:`penalty`

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: ad-10.txt
  :end-before: ad-11.txt

:ref:`sol-10`

.. note::
  Comparing with :ref:`Exercise 7<exercise-7>`:

  * The total number of records changed.
  * The node sequence changed.
  * The edge sequence changed.

.. _exercise-11:

Exercise 11 - Vehicle routing with access restrictions
...............................................................................

* The vehicle is going from vertex ``13224`` to vertex ``9224``.
* The vehicle's cost in this case will be in seconds.
* The regular cost is the original cost in seconds multiplied with €0.10.
* The cost for ``residential`` roads is the original cost in seconds multiplied with a €0.50 penalty.
* Any ``primary`` road cost is the original cost in seconds multiplied with a €100 fine.

Through ``CASE`` statements and sub queries costs can be mixed as you like, and
this will change the results of your routing request instantly. Cost changes
will affect the next shortest path search, and there is no need to rebuild your
network.

.. literalinclude:: solutions/advanced_problems.sql
  :start-after: ad-10.txt
  :end-before: tmp.txt

:ref:`sol-11`

.. note::
  Comparing with :ref:`Exercise 7<exercise-7>` and with :ref:`Exercise 9<exercise-9>`:

  * The total number of records changed.
  * The node and edge sequence changed.
  * The edge sequence changed.
