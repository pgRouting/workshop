..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************


Graph views
###############################################################################

.. image:: images/chapter5/route.png
  :scale: 25%
  :align: center

.. contents:: Chapter Contents

Different application require different graphs. This chapter covers how to
discard unconected segments and different approaches to create graphs.

pgr_extractVertices
================================================================================

``pgr_extractVertices`` compute the connected components of an undirected
graph using a Depth First Search approach. A connected component of an
undirected graph is a set of vertices that are all reachable from each other.

.. rubric:: Signature summary

.. code-block:: sql

   pgr_extractVertices(Edges SQL, [dryrun])

   RETURNS SETOF (id, in_edges, out_edges, x, y, geom)
   OR EMTPY SET

Description of the function can be found in `pgr_extractVertices
<https://docs.pgrouting.org/latest/en/pgr_connectedComponents.html>`__

pgr_connectedComponents
================================================================================

``pgr_connectedComponents`` compute the connected components of an undirected
graph using a Depth First Search approach. A connected component of an
undirected graph is a set of vertices that are all reachable from each other.

.. rubric:: Signature summary

.. code-block:: sql

    pgr_connectedComponents(edges_sql)

    RETURNS SET OF (seq, component, node)
    OR EMPTY SET

Description of the function can be found in `pgr_connectedComponents
<https://docs.pgrouting.org/latest/en/pgr_connectedComponents.html>`__

The graph requirements
===============================================================================

In this chapter there are three graph requirements. It consists on three **fully
connected** graphs: two for different types of vehicles and one for pedestrian,
the source and the target in all of them are based on the ``source_osm`` and
``target_osm``.

The description of the graphs:

- Particular vehicle:

  - Circulate on the whole @PGR_WORKSHOP_CITY@ area.

    - Do not use `steps`, `footway`, `path`, `cycleway`.

  - Speed is the default speed from OSM information.

- Taxi vehicle:

  - Circulate on a smaller area:

    - Bounding box: ``(@PGR_WORKSHOP_LITTLE_NET_BBOX@)``
    - Do not use `steps`, `footway`, `path`, `cycleway`.

  - Speed is 10% slower than that of the particular vehicles.

- Pedestrians:

  - Walk on the whole @PGR_WORKSHOP_CITY@ area.
  - Can not walk on exclusive vehicle ways

    - `motorways` and on `primary` segments.

  - The speed is ``2 mts/sec``.

Preparing the graphs
===============================================================================

Exercise 1: Create a vertices table
-------------------------------------------------------------------------------

.. rubric:: Problem

Create the vertices table corresponding to the edges in ``ways``.

.. rubric:: Solution

- A graph consists of a set of vertices and a set of edges.
- In this case, the ``ways`` table is a set of edgesr.
- In order to make use of all the graph functions from pgRouting, it is required
  have the set of vertices defined.
- From the requirements, the graph is going to be based on OSM identifiers.


.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :emphasize-lines: 3
  :start-after: create_vertices.txt
  :end-before: vertices_description.txt

.. collapse:: Query results

  .. literalinclude:: ../scripts/basic/chapter_7/create_vertices.txt

Reviewing the description of the vertices table

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :start-after: vertices_description.txt
  :end-before: selected_rows.txt

.. collapse:: Description

  .. literalinclude:: ../scripts/basic/chapter_7/vertices_description.txt

Inspecting the information on the vertices table

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :emphasize-lines: 3
  :start-after: selected_rows.txt
  :end-before: fill_columns_1.txt

.. collapse:: Data on table

  .. literalinclude:: ../scripts/basic/chapter_7/selected_rows.txt


Exercise 2: Fill up other columns in the vertices table
-------------------------------------------------------------------------------

.. rubric:: Problem

Fill up geometry information on the vertices table.

.. rubric:: Solution

Count the number of rows that need to be filled up.

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :emphasize-lines: 3
  :start-after: fill_columns_1.txt
  :end-before: fill_columns_2.txt

.. collapse:: Number of rows with empty geometry

  .. literalinclude:: ../scripts/basic/chapter_7/fill_columns_1.txt

* Update the ``geom`` columns based on the ``sourse_osm`` column
  from ``ways`` table.
* Use the start point of the geometry.

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :start-after: fill_columns_2.txt
  :end-before: fill_columns_3.txt

.. collapse:: Number of updated records

  .. literalinclude:: ../scripts/basic/chapter_7/fill_columns_2.txt

Not expecting to be done due to the fact that some vertices are only dead ends.

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :start-after: fill_columns_3.txt
  :end-before: fill_columns_4.txt

.. collapse:: Numbers of records that need update

  .. literalinclude:: ../scripts/basic/chapter_7/fill_columns_3.txt

* Update the ``geom`` columns based on the ``target_osm`` column
  from ``ways`` table.
* Use the end point of the geometry.

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :start-after: fill_columns_4.txt
  :end-before: fill_columns_5.txt

.. collapse:: Number of updated records

  .. literalinclude:: ../scripts/basic/chapter_7/fill_columns_4.txt

Expecting to be done, that is the geometry column should not have a ``NULL``
value.

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :start-after: fill_columns_5.txt
  :end-before: fill_columns_6.txt

.. collapse:: Count should be 0

  .. literalinclude:: ../scripts/basic/chapter_7/fill_columns_5.txt

Update the ``x`` and ``y`` columns based on the ``geom`` column.

.. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
  :language: sql
  :start-after: fill_columns_6.txt
  :end-before: exercise_7_1.txt

.. collapse:: Number of updated records

  .. literalinclude:: ../scripts/basic/chapter_7/fill_columns_6.txt



Exercise 1: Creating a view for routing
-------------------------------------------------------------------------------

.. image:: images/chapter7/vehicle_net.png
  :scale: 25%
  :alt: View of roads for vehicles

.. rubric:: Problem

- Create a view with minimal amount of information for processing the particular vehicles.
- Use the osm identifiers on the vertices.
- Routing `cost` and `reverse_cost` in terms of seconds for routing calculations.
- Exclude `steps`, `footway`, `path`, `cycleway` segments.
- Data needed in the view for further prossesing.

  - `name` The name of the segment.
  - `length_m` The length in meters rename to ``length``.
  - `the_geom` The geometry rename to ``geom``.

- Verify the number of edges was reduced.

.. rubric:: Solution

- Creating the view:

  - The `source` and `target` requirements for the function are to be with OSM
    identifiers. (line **6**)

  - The ``cost`` and ``reverse_cost`` are in terms of seconds. (line **7**)
  - The additional parameters `name`, `length_m` and `the_geom`. (line **8**)
  - ``JOIN`` with the `configuration`:

    - Exclude `steps`, `footway`, `path`, `cycleway`. (line **11**)

  - If you need to reconstruct the view, first drop it using the command on line **1**.

  .. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
    :language: sql
    :emphasize-lines: 6-8,11
    :start-after: exercise_7_1.txt
    :end-before: Verification1

- Verification:

  - Count the rows on the original ``ways`` (line **1**)
  - Count the rows on the view ``vehicle_net`` (line **2**)

  .. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
    :start-after: Verification1
    :end-before: exercise_7_2.txt

|

:ref:`basic/appendix:**Exercise**: 1 (**Chapter:** views)`


Exercise 2: Limiting the road network within an area
-------------------------------------------------------------------------------

.. image:: images/chapter7/taxi_net.png
  :scale: 25%
  :alt: View of smaller set of roads for vehicles

.. rubric:: Problem

* Create a view ``taxi_net`` for the `taxi`:

  * The taxi can only circulate inside this Bounding Box: ``(@PGR_WORKSHOP_LITTLE_NET_BBOX@)``
  * The taxi speed is 10% faster than the particular vehicle.

* Verify the reduced number of road segments.

.. rubric:: Solution

* Creating the view:

  * The graph for the taxi is a subset of the ``vehicle_net`` graph. (line **9**)
  * Can only circulate inside the bounding box: ``(@PGR_WORKSHOP_LITTLE_NET_BBOX@)``. (line **10**)
  * Adjust the taxi's ``cost`` and ``reverse_cost`` to be 90% of the particular vehicle. (line **7**)

  .. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
    :language: sql
    :emphasize-lines: 7,9,10
    :start-after: 7_2
    :end-before: Verification2

- Verification:

  - Count the rows on the original ``taxi_net``

  .. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
    :language: sql
    :start-after: Verification2
    :end-before: 7_3

|

:ref:`basic/appendix:**Exercise**: 2 (**Chapter:** views)`

Exercise 3: Creating a materialized view for routing pedestrians
-------------------------------------------------------------------------------

.. image:: images/chapter7/walk_net.png
  :scale: 25%
  :alt: View of roads for pedestrians

.. rubric:: Problem

- Create a materialized view with minimal amount of information for processing pedestrians.
- Routing `cost` and `reverse_cost` will be on seconds for routing calculations.

  - The speed is ``2 mts/sec``.

- Exclude `motorway` , `primary` and `secondary` segments.
- Data needed in the view for further prossesing.

  - `length_m` The length in meters.
  - `the_geom` The geometry.

- Verify the number of edges was reduced.

.. rubric:: Solution

- Creating the view:

  - Similar to `Exercise 1: Creating a view for routing`_:

    - The ``cost`` and ``reverse_cost`` are in terms of seconds with speed of ``2 mts/sec``. (line **7**)
    - Exclude `motorway`, `primary` and `secondary` . (line **11**)

  .. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
    :language: sql
    :emphasize-lines: 7, 11
    :start-after: 7_3
    :end-before: Verification3

- Verification:

  - Count the rows on the view ``walk_net`` (line **1**)

  .. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
    :language: sql
    :start-after: Verification3
    :end-before: 7_4

|

:ref:`basic/appendix:**Exercise**: 3 (**Chapter:** views)`


Exercise 4: Testing the views for routing
-------------------------------------------------------------------------------

.. image:: images/chapter7/ch7-e3.png
  :scale: 25%
  :alt:   From the Venue to the hotel using the osm_id.

.. rubric:: Problem

* Test the created views

In particular:

* From the "|ch7_place_1|" to the "|ch7_place_2|" using the OSM identifier
* the views to be tested are:

  * ``vehicle_net``
  * ``taxi_net``
  * ``walk_net``

* Only show the following results, as the other columns are to be ignored on the function.

  * ``seq``
  * ``edge`` with the name ``id``
  * ``cost`` with the name: ``seconds``

.. rubric:: Solution

* In general

  * The departure is |ch7_place_1| with OSM identifier |ch7_osmid_1|.
  * The destination is |ch7_place_2| with OSM identifier |ch7_osmid_2|.

* For ``vehicle_net``:

  * ``vehicle_net`` is used.
  * Selection of the columns with the corresponding names are on line **1**.
  * The view is prepared with the column names that pgRouting use.

    * There is no need to rename columns. (line **3**)

  * The OSM identifiers of the departure and destination are used. (line **4**)

  .. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
    :language: sql
    :emphasize-lines: 1,3,4
    :start-after: exercise_7_4.txt
    :end-before: For taxi_net

* For ``taxi_net``:

  * Similar as the previous one but with ``taxi_net``. (line **3**)
  * The results give the same route as with ``vehicle_net`` but ``cost`` is lower

  .. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
    :language: sql
    :emphasize-lines: 3
    :start-after: For taxi_net
    :end-before: For walk_net

* For ``walk_net``:

  * Similar as the previous one but with ``walk_net``. (line **3**)
  * The results give a different route than of the vehicles.

  .. literalinclude:: ../scripts/basic/chapter_7/all_sections.sql
    :language: sql
    :emphasize-lines: 3
    :start-after: For walk_net
    :end-before: exercise_7_5.txt


.. note:: From these queries, it can be deduced that what we design for one view will work
  for the other views. On the following exercises only ``vehicle_net`` will be used, but
  you can test the queries with the other views.

|

:ref:`basic/appendix:**Exercise**: 4 (**Chapter:** views)`
