..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: https://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Create a Network Topology
===============================================================================

.. image:: /images/network.png
  :width: 250pt
  :align: center

:doc:`osm2pgrouting <../appendix/appendix-3>` is a convenient tool, and its focus to work
on OpenStreetMap data. There are several cases where :doc:`osm2pgrouting
<../appendix/appendix-3>` can't be used. Some network data already comes with a network
topology that can be used with pgRouting out-of-the-box. Often network data is
stored in Shape file format (``.shp``) and we can use PostGIS'
``shp2pgsql`` converter to import the data into a PostgreSQL database.

But what to do then?

In this chapter you will learn how to create a basic `Routing Network Topology`
from a network data that does not have a routing Topology create the minimum
attributes needed the `Routing Network Topology`.

.. contents:: Chapter contents


Load network data
-------------------------------------------------------------------------------

At first we will load OpenStreetMap sample data with osm2pgsql.

.. code-block:: bash

  CITY="DS_TZ"
  cd ~/Desktop/workshop
  cp ~/data/osm/$CITY.osm.bz2 .

  createdb -U user osm_data
  psql -U user -d osm_data -c "CREATE EXTENSION postgis;"
  psql -U user -d osm_data -c "CREATE EXTENSION pgrouting;"
  osm2pgsql -U user -c -d osm_data --latlong --cache 5 --cache-strategy sparse $CITY.osm.bz2

Let's see which tables have been created:

.. rubric:: Run: ``psql -U user -d osm_data -c "\d"``

The table containing the road network data has the name ``planet_osm_roads``.
It consists of large amount of attributes.

.. rubric:: Run: ``psql -U user -d osm_data -c "\d planet_osm_roads"``

It is common that road network data provides at least the following information:

* Road link ID (gid)
* Road class (class_id)
* Road link length (length)
* Road name (name)
* Road geometry (the_geom)

This allows to display the road network as a PostGIS layer in GIS software, for
example in QGIS. Though it is not sufficient for routing, because it doesn't
contain network topology information.

The next steps will use the PostgreSQL command line tool.

.. code-block:: bash

  psql -U user osm_data



Create a Routing Network Topology
-------------------------------------------------------------------------------

Having your data imported into a PostgreSQL database might require one more step
for pgRouting.

Make sure that your data provides a correct `Routing Network Topology`, which
consists of information about source and target identifiers for each road link.
The results above, show that the network topology does not have any source and
target information.

Creation of the `Routing Network Topology` is necessary.

.. warning::
  PostGIS topology is not suitable for Routing.

pgRouting provides a general way for creating the `Routing Network Topology`
with the ``pgr_createTopology`` function.

This function:

* Assigns a ``source`` and a ``target`` identifiers to each road link
* It can logically "snap" nearby vertices within a certain tolerance by
  assigning the same identifier.
* Creates a vertices table related to it.
* Creates the basic indices.

.. code-block:: sql

  pgr_createTopology('<table>', <tolerance>, '<geometry column>', '<gid>')

For additional information see `pgr_createTopology
<https://docs.pgrouting.org/latest/en/pgr_createTopology.html>`_.

First add source and target column, then run the ``pgr_createTopology`` function
... and wait.

* Depending on the network size this process may take from minutes to hours.
* Progress indicator can be read with PostgreSQL NOTICE
* It will also require enough memory (RAM or SWAP partition) to store temporary
  data.

The dimension of the tolerance parameter depends on your data projection.
Usually it's either "degrees" or "meters". In our example the geometry data
projection to determine the tolerance:

.. code-block:: sql

  SELECT find_srid('public','planet_osm_roads','way');
  find_srid
  -----------
      4326
  (1 row)

Based on this result the tolerance will be 0.00001

.. code-block:: sql

  -- Add "source" and "target" column
  ALTER TABLE planet_osm_roads ADD COLUMN "source" integer;
  ALTER TABLE planet_osm_roads ADD COLUMN "target" integer;

  -- Run topology function
  SELECT pgr_createTopology('planet_osm_roads', 0.00001, 'way', 'osm_id');


Verify the Routing Network Topology
-------------------------------------------------------------------------------

To verify that there is a basic `Routing Network Topology`:

::

  \d planet_osm_roads

Also a new table containing the vertices information was created:

::

  \d planet_osm_roads_vertices_pgr

* ``id`` is the vertex identifier
* ``the_geom`` is the geometry considered for that particular vertex identifier.
* ``source`` and ``target`` from the ``planet_osm_roads`` correspond to an
  ``id`` in ``planet_osm_roads_vertices_pgr`` table
* Additional columns are for analyzing the topology.

Now we are ready for our first routing query with
`pgr_dijkstra <https://docs.pgrouting.org/latest/en/pgr_dijkstra.html>`__ 
or any other pgRouting query.



Analyze and Adjust the Routing Network Topology
-------------------------------------------------------------------------------

Analyzing the topology with `pgr_analyzeGraph
<https://docs.pgrouting.org/latest/en/pgr_analyzeGraph.html>`_:

.. code-block:: sql

  SELECT pgr_analyzeGraph('planet_osm_roads', 0.000001, the_geom := 'way', id := 'osm_id');

Adjusting the topology is not an easy task:

* Is an isolated segment an error in the data?
* Is an isolated segment because its on the edge of the bounding box?
* Do the potential gaps found near dead ends because the tolerance was too
  small?
* Are the intersections real intersections and need to be nodded?
* Are the intersections bridges or tunnels and do not need to be nodded?

Depending on the application some adjustments need to be made.

Some `topology manipulation <https://docs.pgrouting.org/latest/en/topology-functions.html>`_
functions help to detect and fix some of the topological errors in the data.

