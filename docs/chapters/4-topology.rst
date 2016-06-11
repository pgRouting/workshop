.. 
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _topology:

Create a Network Topology
===============================================================================

.. image:: images/network.png
    :width: 250pt
    :align: center

In this chapter you will learn how to create a basic `Routing Network Topology` from a network data and
create the minimum attributes needed the `Routing Network Topology`.

* :ref:`4-load`
* :ref:`4-topology`
* :ref:`4-verify`
* :ref:`4-adjust`

.. _4-load:

Load network data
-------------------------------------------------------------------------------

At first we will load a database dump from the workshop ``data`` directory. This directory contains a compressed file with database dumps as well as a small size network data. If you haven't uncompressed the data yet, extract the file by 

.. code-block:: bash

    cd ~/Desktop/pgrouting-workshop/
    tar -xvzf data.tar.gz

The following command will import the database dump. It will add PostGIS and pgRouting functions to a database, in the same way as described in the previous chapter. It will also load the sample data with a minimum number of attributes, which you will usually find in any network data:

.. code-block:: bash

    # Optional: Drop database
    dropdb -U user pgrouting-workshop

    # Load database dump file
    psql -U user -d postgres -f ~/Desktop/pgrouting-workshop/data/sampledata_notopo.sql

Let's see which tables have been created:

.. rubric:: Run: ``psql -U user -d pgrouting-workshop -c "\d"``
    
.. code-block:: none

                   List of relations
     Schema |       Name        | Type  |  Owner   
    --------+-------------------+-------+----------
     public | geography_columns | view  | user
     public | geometry_columns  | view  | user
     public | raster_columns    | view  | user
     public | raster_overviews  | view  | user
     public | spatial_ref_sys   | table | user
     public | ways              | table | user
    (7 rows)


The table containing the road network data has the name ``ways``. It consists of the following attributes:
    
.. rubric:: Run: ``psql -U user -d pgrouting-workshop -c "\d ways"``
    
.. code-block:: none

                   Table "public.ways"
      Column  |           Type            | Modifiers 
    ----------+---------------------------+-----------
     gid      | bigint                    | 
     class_id | integer                   | not null
     length   | double precision          | 
     name     | character(200)            | 
     osm_id   | bigint                    | 
     the_geom | geometry(LineString,4326) | 
    Indexes:
        "ways_gid_idx" UNIQUE, btree (gid)
        "geom_idx" gist (the_geom)


It is common that road network data provides at least the following information:

* Road link ID (gid)
* Road class (class_id)
* Road link length (length)
* Road name (name)
* Road geometry (the_geom)

This allows to display the road network as a PostGIS layer in GIS software, for example in QGIS. Though it is not sufficient for routing, because it doesn't contain network topology information.

The next steps will use the PostgreSQL command line tool.

.. code-block:: bash

    psql -U user pgrouting-workshop
    
... or use PgAdmin III.


.. _4-topology:

Create a Routing Network Topology
-------------------------------------------------------------------------------

Having your data imported into a PostgreSQL database might require one more step for pgRouting.

Make sure that your data provides a correct `Routing Network Topology`, which consists of information about source and target identifiers for each road link.
The results above, show that the network topology does not have any source and target information.

Creation of the `Routing Network Topology` is necessary.

.. warning::

    PostGIS topology is not suitable for Routing.

pgRouting provides a general way for creating the `Routing Network Topology` with the ``pgr_createTopology`` function.

This function:

* Assigns a ``source`` and a ``target`` identifiers to each road link
* It can logically "snap" nearby vertices within a certain tolerance by assigning the same identifier.
* Creates a vertices table related to it.
* Creates the basic indices.

.. code-block:: sql

    pgr_createTopology('<table>', <tolerance>, '<geometry column>', '<gid>')

For additional information see `pgr_createTopology  <http://docs.pgrouting.org/latest/en/src/topology/doc/pgr_createTopology.html>`_ documentation.
    
First add source and target column, then run the ``pgr_createTopology`` function ... and wait.

* Depending on the network size this process may take from minutes to hours.
* Progress indicator can be read with postgreSQL NOTICE
* It will also require enough memory (RAM or SWAP partition) to store temporary data.

The dimension of the tolerance parameter depends on your data projection.
Usually it's either "degrees" or "meters".
In our example the geometry data projection to determine the tolerance:
 
.. code-block:: sql

    SELECT find_srid('public','ways','the_geom');
    find_srid 
    -----------
       4326
    (1 row)

Based on this result the tolerance will be 0.00001

.. code-block:: sql

    -- Add "source" and "target" column
    ALTER TABLE ways ADD COLUMN "source" integer;
    ALTER TABLE ways ADD COLUMN "target" integer;
    
    -- Run topology function
    SELECT pgr_createTopology('ways', 0.00001, 'the_geom', 'gid');


.. _4-verify:

Verify the Routing Network Topology
-------------------------------------------------------------------------------

To verify that there is a basic `Routing Network Topology`:

.. code-block:: sql

     \d ways

We get:

.. code-block:: none

                  Table "public.ways"
      Column  |           Type            | Modifiers 
    ----------+---------------------------+-----------
     gid      | integer                   | 
     class_id | integer                   | not null
     length   | double precision          | 
     name     | text                      | 
     osm_id   | bigint                    | 
     the_geom | geometry(LineString,4326) | 
     source   | integer                   | 
     target   | integer                   | 
    Indexes:
        "ways_gid_idx" UNIQUE, btree (gid)
        "geom_idx" gist (the_geom)
        "ways_source_idx" btree (source)
        "ways_target_idx" btree (target)

* ``source`` and ``target`` columns are now updated with the vertices identifiers.
* ``name`` may contain the street name or be empty.
* ``length`` is the road link length in degrees.

A new table containing the vertices information was created:

.. code-block:: sql

     \d ways_vertices_pgr

We get:

.. code-block:: none

                                 Table "public.ways_vertices_pgr"
    Column  |         Type         |                           Modifiers                            
    ----------+----------------------+----------------------------------------------------------------
    id       | bigint               | not null default nextval('ways_vertices_pgr_id_seq'::regclass)
    cnt      | integer              | 
    chk      | integer              | 
    ein      | integer              | 
    eout     | integer              | 
    the_geom | geometry(Point,4326) | 
    Indexes:
        "ways_vertices_pgr_pkey" PRIMARY KEY, btree (id)
        "ways_vertices_pgr_the_geom_idx" gist (the_geom)


* ``id`` is the vertex identifier
* ``the_geom`` is the geometry considered for that particular vertex identifier.
* ``source`` and ``target`` from the ``ways`` correspond to an ``id`` in ``ways_vertices_pgr`` table
* Additional columns are for analyzing the topology.

Now we are ready for our first routing query with :doc:`Dijkstra algorithm <5-shortest_path>`!

.. _4-Adjust:

Analize and Adjust the Routing Network Topology
-------------------------------------------------------------------------------

Analyzing the topology with `pgr_analyzeGraph <http://docs.pgrouting.org/latest/en/src/common/doc/functions/analyze_graph.html>`_:

.. code-block:: sql

    select pgr_analyzeGraph('ways', 0.000001, id := 'gid');

    NOTICE:  PROCESSING:
    NOTICE:  pgr_analyzeGraph('ways',1e-06,'the_geom','gid','source','target','true')
    NOTICE:  Performing checks, please wait ...
    NOTICE:  Analyzing for dead ends. Please wait...
    NOTICE:  Analyzing for gaps. Please wait...
    NOTICE:  Analyzing for isolated edges. Please wait...
    NOTICE:  Analyzing for ring geometries. Please wait...
    NOTICE:  Analyzing for intersections. Please wait...
    NOTICE:              ANALYSIS RESULTS FOR SELECTED EDGES:
    NOTICE:                    Isolated segments: 59
    NOTICE:                            Dead ends: 9445
    NOTICE:  Potential gaps found near dead ends: 2
    NOTICE:               Intersections detected: 1832
    NOTICE:                      Ring geometries: 1
    pgr_analyzegraph 
    ------------------
    OK
    (1 row)

Adjusting the topology is not an easy task:

* Is an isolated segment an error in the data?
* Is an isolated segment because its on the edge of the bounding box?
* Do the potential gaps found near dead ends because the tolerance was too small?
* Are the intersections real intersections and need to be nodded?
* Are the intersections bridges or tunnels and do not need to be nodded?

Depending on the application some adjustments need to be made.

Some `topology manipulation <http://docs.pgrouting.org/2.0/en/src/common/doc/functions/index.html>`_ functions help to detect and fix some of the topological errors in the data.

