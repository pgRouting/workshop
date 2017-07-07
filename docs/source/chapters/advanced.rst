..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************


Advanced Routing Queries
===============================================================================

.. image:: /images/route.png
  :width: 300pt
  :align: center

Routing, is not limited to pedestrians and most of the time is used for routing vehicles.

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

.. image:: /images/car-route1.png
  :width: 300pt
  :alt: From the Westin, going to the Brewry by car

* The vehicle is going from vertex ``9411`` to vertex ``13009``.
* Use ``cost`` and ``reverse_cost`` columns, which are in unit ``degrees``.

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: ad-7.txt
  :end-before: ad-8.txt

:ref:`Solution to Exercise 7`



.. _exercise-8:

Exercise 8 - Vehicle routing - Returning
...............................................................................

.. rubric:: From the Brewry, going to the Westin by car.

.. image:: /images/car-route2.png
  :width: 300pt
  :alt: From the Brewry, going to the Westin by car

* The vehicle is going from vertex ``13009`` to vertex ``9411``.
* Use ``cost`` and ``reverse_cost`` columns, which are in unit ``degrees``.

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: ad-8.txt
  :end-before: ad-9.txt

:ref:`Solution to Exercise 8`

.. note:: On a directed graph, going and coming back routes, most of the time are different.



.. _exercise-9:

Exercise 9 - Vehicle routing when "time is money"
...............................................................................

.. rubric:: From the Brewry, going to the Westin by taxi. Fee: $100/hour

.. image:: /images/car-route2.png
  :width: 300pt
  :alt: From the Brewry, going to the Westin by car

* The vehicle is going from vertex ``13009`` to vertex ``9411``.
* The cost is ``$100 per hour``.
* Use ``cost_s`` and ``reverse_cost_s`` columns, which are in unit ``seconds``.
* The duration in hours is ``cost / 3600``
* The cost in ``$`` is ``cost / 3600 * 100``

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: ad-9.txt
  :end-before: info-1.txt

:ref:`Solution to Exercise 9`

.. note::
  Comparing with :ref:`Exercise 8<exercise-8>`:

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

.. rubric:: osm_way_types

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: info-1.txt
  :end-before: info-2.txt

.. literalinclude:: solutions/info-1.txt

.. rubric:: osm_way_classes

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: info-2.txt
  :end-before: tmp.txt

.. literalinclude:: solutions/info-2.txt

In this workshop, costs are going to be manipulated using the ``osm_way_types`` and ``osm_way_classes`` tables.


Manipulating cost values
...............................................................................

* The :code:`osm_way_classes` table is linked with the :code:`ways` table by the
  :code:`class_id` field.
* Its values can be changed with an ``UPDATE`` query.

Let's change the cost values for the :code:`osm_way_classes` table, that the use
of "faster" roads is encouraged when the cost of each road segment is multiplied
with a certain factor:

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: tmp.txt
  :end-before: ad-10.txt



.. _exercise-10:

Exercise 10 - Vehicle routing with penalization
...............................................................................

.. rubric:: From the Brewry, going to the Westin with penalization.

.. image:: /images/car-route3.png
  :width: 300pt
  :alt: From the Brewry, going to the Westin by car

* The vehicle is going from vertex ``13009`` to vertex ``9411``.
* Use ``cost_s`` and ``reverse_cost_s`` columns, which are in unit ``seconds``.
* Costs are the original costs in seconds multiplied by :code:`penalty`

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: ad-10.txt
  :end-before: ad-11.txt

:ref:`Solution to Exercise 10`

.. note::
  Comparing with :ref:`Exercise 8<exercise-8>`:

  * The total number of records changed.
  * The node sequence changed.
  * The edge sequence changed.

.. _exercise-11:

Exercise 11 - Vehicle routing with access restrictions
...............................................................................


* The vehicle is going from vertex ``13009`` to vertex ``9411``.
* The vehicle's cost in this case will be in seconds.
* The regular cost is the original cost in seconds multiplied by $0.10.
* The cost for ``residential`` roads is the original cost in seconds multiplied with a $0.50 penalty.
* Any ``primary`` road cost is the original cost in seconds multiplied with a $100 fine.

Through ``CASE`` statements and sub queries costs can be mixed as you like, and
this will change the results of your routing request instantly. Cost changes
will affect the next shortest path search, and there is no need to rebuild the
network.

.. literalinclude:: solutions/advanced_problems.sql
  :start-after: ad-11.txt
  :end-before: tmp.txt

:ref:`Solution to Exercise 11`

.. note::
  Comparing with :ref:`Exercise 7<exercise-7>` and with :ref:`Exercise 9<exercise-9>`:

  * The total number of records changed.
  * The node and edge sequence changed.
  * The edge sequence changed.
