..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************


Advanced Routing Queries
===============================================================================

.. image:: /images/ad7.png
  :scale: 25%
  :align: center

Routing, is not limited to pedestrians and most of the time is used for routing vehicles.

.. contents:: Chapter Contents


Routing for Vehicles
-------------------------------------------------------------------------------

A query for vehicle routing generally differs from routing for pedestrians:

* The road segments are considered `directed`,
* Costs can be:

  * Distance
  * Time
  * Euros
  * Pesos
  * Dollars
  * CO2 emissions
  * Wear and tear on the vehicle, etc.

* The ``reverse_cost`` attribute must be taken into account on two way streets.

  * The costs should have the same units as the ``cost`` attribute
  * ``cost`` and ``reverse_cost`` values can be different

Due to the fact that there are roads that are **one way**:

Depending on the geometry, the valid way:

* (``source, target``) segment ``IF cost >= 0 AND reverse_cost < 0``
* (``target, source``) segment ``IF cost < 0 AND reverse_cost >= 0``

A **wrong way** is indicated with a **negative value** and is not inserted in the
graph for processing.

**Two way** roads - ``IF cost >= 0 AND reverse_cost >= 0`` and their values can
be different. For example, it is faster going down hill on a sloped road.
In general, ``cost`` and ``reverse_cost`` do not need to be length; they can be
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

   .. literalinclude:: solutions/cost_manipulation-2.txt

.. _exercise-7:

Exercise 7 - Vehicle routing - Going
...............................................................................

.. rubric:: From the |place_3| to the |place_1| by car.

.. image:: /images/ad7.png
  :scale: 25%
  :alt: From |place_3| to the |place_1| by car.


* The vehicle is going from vertex |id_3| to |id_1|.
* Use ``cost`` and ``reverse_cost`` columns, which are in unit ``degrees``.

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: ad-7.txt
  :end-before: ad-8.txt
  :linenos:
  :emphasize-lines: 3-8


:ref:`Solution to Exercise 7`



.. _exercise-8:

Exercise 8 - Vehicle routing - Returning
...............................................................................

.. rubric:: From |place_1| to the |place_3| by car.

.. image:: /images/ad8.png
  :scale: 25%
  :alt: From |place_1| to the |place_3| by car.


* The vehicle is going from vertex |id_1| to |id_3|
* Use ``cost`` and ``reverse_cost`` columns, which are in unit ``degrees``.

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: ad-8.txt
  :end-before: ad-9.txt
  :linenos:
  :emphasize-lines: 10-11

:ref:`Solution to Exercise 8`

.. note:: On a directed graph, going and coming back routes, most of the time are different.



.. _exercise-9:

Exercise 9 - Vehicle routing when "time is money"
...............................................................................

.. rubric:: From |place_1| to the |place_3| by taxi.

.. image:: /images/ad8.png
  :width: 300pt
  :alt: From |place_1| to |place_3| by taxi.


* The vehicle is going from vertex |id_1| to |id_3|
* The cost is ``$100 per hour``.
* Use ``cost_s`` and ``reverse_cost_s`` columns, which are in unit ``seconds``.
* The duration in hours is ``cost / 3600``
* The cost in ``$`` is ``cost / 3600 * 100``

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: ad-9.txt
  :end-before: info-1.txt
  :linenos:
  :emphasize-lines: 6-7

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

When dealing with data, being aware of what kind of data is being used can improve results.

* Vehicles can not circulate on pedestrian ways

.. image:: /images/pedestrian-only-roads.png
  :scale: 25%
  :alt:

Penalizing or removal of pedestrian ways will make the results closer to reality.

When converting data from OSM format using the osm2pgrouting tool, there is an
additional table: ``configuration``

.. rubric:: The ``configuration`` table structure can be obtained with the following command.

::

  city_routing=# \dS+ configuration


This is part of the results.

::

  Table public.configuration
  Column            |       Type       | Nullable  | Default | Storage  |
  ------------------+------------------+-----------+---------+----------+
  id                | integer          | not null  | nextval | plain    |
  tag_id            | integer          |           |         | plain    |
  tag_key           | text             |           |         | extended |
  tag_value         | text             |           |         | extended |
  priority          | double precision |           |         | plain    |
  maxspeed          | double precision |           |         | plain    |
  maxspeed_forward  | double precision |           |         | plain    |
  maxspeed_backward | double precision |           |         | plain    |
  force             | character(1)     |           |         | extended |
  
  Indexes:
    configuration_pkey PRIMARY KEY, btree (id)
    configuration_tag_id_key UNIQUE CONSTRAINT, btree (tag_id)
  
  Referenced by:
    TABLE ways CONSTRAINT ways_tag_id_fkey FOREIGN KEY (tag_id) REFERENCES configuration(tag_id)
  
  Options: autovacuum_enabled=false


.. image:: /images/detailofroute9.png
  :scale: 25%
  :alt: tag_id values

In the image above there is a detail of the ``tag_id`` of the roads.

.. rubric:: OSM way types

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: info-1.txt
  :end-before: info-2.txt

.. literalinclude:: solutions/info-1.txt

Also, on the ``ways`` table there is a column that can be used to ``JOIN`` with the ``configuration`` table.

.. rubric:: The ``ways`` types

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: info-2.txt
  :end-before: ad-10.txt

.. literalinclude:: solutions/info-2.txt

In this workshop, costs are going to be manipulated using the ``configuration`` table.



.. _exercise-10:

Exercise 10 - Vehicle routing without penalization
...............................................................................

.. rubric:: From the |place_3| to |place_1|

.. image:: /images/ad7.png
  :scale: 25%
  :alt: From |place_3| to |place_1|

* The vehicle is going from vertex |id_3| to vertex |id_1|.
* The vehicle's cost in this case will be in seconds.
* All roads have a ``penalty`` of ``1``.
* Costs (in seconds) are to be multiplied by :code:`penalty`.
* Costs wont change (times 1 leaves the value unchanged).
* The :code:`configuration` table is linked with the :code:`ways` table by the
  :code:`tag_id` field using a ``JOIN``.

.. literalinclude:: solutions/advanced_problems.sql
  :start-after: ad-10.txt
  :end-before: tmp.txt

:ref:`Solution to Exercise 10`

.. _exercise-11:

Exercise 11 - Vehicle routing with penalization
...............................................................................

Change the cost values for the :code:`configuration` table, in such a way, that the

* Pedestrian roads are not used.
* Using residential roads is not encouraged.
* Using "faster" roads is highly encouraged.
* The ``penalty`` values can be changed with ``UPDATE`` queries.

.. note:: These values are an exaggeration.

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: tmp.txt
  :end-before: ad-11.txt

.. rubric:: From the |place_3| to |place_1| with penalization.

* The vehicle is going from vertex |id_3| to vertex |id_1|.
* Use ``cost_s`` and ``reverse_cost_s`` columns, which are in unit ``seconds``.
* Costs are to be multiplied by :code:`penalty`.
* The :code:`configuration` table is linked with the :code:`ways` table by the
  :code:`tag_id` field using a ``JOIN``.

.. literalinclude:: solutions/advanced_problems.sql
  :language: sql
  :start-after: ad-11.txt
  :end-before: tmp.txt

.. image:: /images/ad11.png
  :scale: 25%
  :alt: From |place_5| to |place_3|

:ref:`Solution to Exercise 11`

.. note::
  Comparing with :ref:`Exercise 9<exercise-9>`:

  * The total number of records changed.
  * The node sequence changed.
  * The edge sequence changed.
  * The route is avoiding the residential roads that have ``tag_id = 110``.

