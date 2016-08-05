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

* :ref:`intro`

  * :ref:`Exercise 7 <exercise-7>` Single Driver Routing.
  * :ref:`Exercise 8 <exercise-8>` Single Driver Routing: time is money.

* :ref:`modify` 

  * :ref:`Exercise 9 <exercise-9>` Single Driver Routing encourage on fast road.
  * :ref:`Exercise 10 <exercise-10>` Restricted Access.

.. _intro:

Introduction
------------------

A query for routing vehicles differs from routing pedestrians, 

* Now the segments are considered `directed`,
* There is a `reverse_cost` involved
* This is due to the fact that there are roads that are `one way`, and depending on the geometry, the valid way is the

  * (source, target) segment (`cost` >= 0 and `reverse_cost` < 0)
  * (target, source) segment (`cost` < 0 and `reverse_cost` >= 0)
  * So a `wrong way` is indicated with a negative value and is not inserted in the graph for processing.

For two way roads `cost` >= 0 and `reverse_cost` >= 0 and their values can be different.
For example its faster going down hill on a sloped road.

In general `cost` and `reverse_cost` do not need to be length; they can be almost anything, for example time, slope, surface, road type, etc..
or can be a combination of multiple parameters.


Using the psql client, before proceeding with the exercises, verify some imformation:

.. rubric:: Number of (source, target) that are `wrong way`

Run: :code:`SELECT count(*) FROM ways WHERE cost < 0;`

.. code-block:: sql

    count 
    -------
        10
    (1 row)


.. rubric:: Number of (target, source) that are `wrong way`

Run: :code:`SELECT count(*) FROM ways WHERE reverse_cost < 0;`

.. code-block:: sql

    count 
    -------
      2238
    (1 row)

    
.. _exercise-7:

.. topic:: Exercise 7

    Single Driver Routing

* Driver “I am in vertex 13224 and want to Drive to vertex 9224. Time based results”

.. rubric:: Problem description

* The driver wants to go from vertex 13224 to vertex 9224.
* Use ``cost_s`` and ``reverse_cost_s`` columns, which are in terms of **seconds**.

.. rubric:: Query

.. literalinclude:: solutions/advanced_problems.sql
    :language: sql
    :start-after: ad-7.txt
    :end-before: ad-8.txt

.. rubric:: Query Result

:ref:`sol-7`

.. _exercise-8:

.. topic:: Exercise 8

    Single Driver Routing: time is money.

* Driver “I am in vertex 13224 and want to Drive to vertex 9224. I charge $100 per hour”

.. rubric:: Problem description

* The driver wants to go from vertex 13224 to vertex 9224.
* The cost is $100 per 3600 seconds
* Use ``cost_s`` and ``reverse_cost_s`` columns, which are in terms of **seconds**.
* The duration in hours is cost / 3600
* The cost in $ is cost / 3600 * 100

.. rubric:: Query

.. literalinclude:: solutions/advanced_problems.sql
    :language: sql
    :start-after: ad-8.txt
    :end-before: tmp.txt

.. rubric:: Query Result

:ref:`sol-8`

.. note:: Comparing with Exercise 7:

    * the total number of records are the same
    * the node sequence is the same
    * the edge sequence is the same
    * the cost and agg_cost reuslts are the directly proportional to the result of Exercise 7
    

.. _modify:

Modifying Costs
-------------------------------------------------------------------------------

In "real" networks there are different limitations or preferences for different road types for example. In other words, we don't want to get the *shortest* but the **cheapest** path - a path with a minimal cost. There is no limitation in what we take as costs.

When we convert data from OSM format using the osm2pgrouting tool, we get two additional tables for road ``osm_way_types`` and road ``osm_way_classes``:

Run: ``SELECT * FROM osm_way_types ORDER BY type_id;``

.. code-block:: sql

     type_id |   name    
    ---------+-----------
           1 | highway
           2 | cycleway
           3 | tracktype
           4 | junction
    (4 rows)


Run: ``SELECT * FROM osm_way_classes ORDER BY class_id;``

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


* The :code:`osm_way_classes`  linked with the :code:`ways` table by the :code:`class_id` field.

* Its values can be changed with an ``UPDATE`` query.

.. rubric:: Change cost values for the :code:`osm_way_classes` table so that a circulating on faster roads is encouraged:

.. code-block:: sql

    ALTER TABLE osm_way_classes ADD COLUMN penalty FLOAT;
    UPDATE osm_way_classes SET penalty=1;
    UPDATE osm_way_classes SET penalty=2.0 WHERE name IN ('pedestrian','steps','footway');
    UPDATE osm_way_classes SET penalty=1.5 WHERE name IN ('cicleway','living_street','path');
    UPDATE osm_way_classes SET penalty=0.8 WHERE name IN ('secondary','tertiary');
    UPDATE osm_way_classes SET penalty=0.6 WHERE name IN ('primary','primary_link');
    UPDATE osm_way_classes SET penalty=0.4 WHERE name IN ('trunk','trunk_link');
    UPDATE osm_way_classes SET penalty=0.3 WHERE name IN ('motorway','motorway_junction','motorway_link');

The idea behind these two tables is to specify a factor to be multiplied with the cost of each link.

.. note::

    For performance, especially if the network data is large, an index on the ``class_id`` field of the `ways` table and `osm_way_classes` table can be created. 

    .. code-block:: sql

        CREATE INDEX  ON ways (class_id);
        CREATE INDEX  ON osm_way_classes (class_id);
        ALTER TABLE ways ADD CONSTRAINT class FOREIGN KEY (class_id) REFERENCES osm_way_classes (class_id);

.. _exercise-9:

.. topic:: Exercise 9

    Single Driver Routing encouraged to use faster roads.

* Driver “I am in vertex 13224 and want to Drive to vertex 9224 preferably on faster roads.”

.. rubric:: Problem description

* The driver wants to go from vertex 13224 to vertex 9224.
* Use ``cost_s`` and ``reverse_cost_s`` columns, which are in terms of **seconds**.
* costs = cost in seconds * :code:`penalty`

.. rubric:: Query

.. literalinclude:: solutions/advanced_problems.sql
    :language: sql
    :start-after: ad-9.txt
    :end-before: ad-10.txt

.. rubric:: Query Result

:ref:`sol-9`


.. note:: Comparing with :ref:`Exercise 7<exercise-7>`:

    * The total number of records changed.
    * The node sequence changed.
    * The edge sequence changed.
    * In othe words a completlty different route was found.

.. _exercise-10:

.. topic:: Exercise 10

    Restricted Access

* Driver “I am in vertex 13224 and want to drive my bus to vertex 9224

  * The drivers salary is fixed so it will not affect the decision.
  * Using the bus is $0.10 per second normally.
  * The cost of a bus traveling on `residential` roads is $.50 per second, because of permit.
  * The cost of a bus traveling on any `primary` is $100 per second because of fines.

.. rubric:: Problem description

* The driver wants to go from vertex 13224 to vertex 9224.
* The driver's cost in this case will be in seconds.
* Normal Cost = Cost in seconds * $0.10
* `residential` road cost = Cost in seconds * $0.50
* Any `primary` road cost = Cost in seconds * $100


Through CASE statements sub queries you can "mix" your costs as you like and this will change the results of your routing request immediately.
Cost changes will affect the next shortest path search, and there is no need to rebuild your network.

.. rubric:: Query

.. literalinclude:: solutions/advanced_problems.sql
    :language: sql
    :start-after: ad-10.txt
    :end-before: tmp.txt

.. rubric:: Query Result

:ref:`sol-10`

.. note:: Comparing with :ref:`Exercise 7<exercise-7>` and with :ref:`Exercise 9<exercise-9>`:

    * The total number of records changed.
    * The node sequence changed.
    * The edge sequence changed.
    * In othe words another completlty different route was found.
