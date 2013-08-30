.. 
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _topology:

Create a Network Topology
===============================================================================

:doc:`osm2pgrouting <osm2pgrouting>` is a convenient tool, but it's also a *black box*. There are several cases where :doc:`osm2pgrouting <osm2pgrouting>` can't be used. Obviously if the data isn't OpenStreetMap data. Some network data already comes with a network topology that can be used with pgRouting out-of-the-box. Often network data is stored in Shape file format (``.shp``) and we can use PostGIS' ``shape2postgresql`` converter to import the data into a PostgreSQL database. But what to do then?

.. image:: images/network.png
	:width: 250pt
	:align: center

In this chapter you will learn how to create a network topology from scratch. For that we will start with data that contains the minimum attributes needed for routing and show how to proceed step-by-step to build routable data for pgRouting. 


Load network data
-------------------------------------------------------------------------------

At first we will load a database dump from the workshop ``data`` directory. This directory contains a compressed file with database dumps as well as a small size network data. If you haven't uncompressed the data yet, extract the file by 

.. code-block:: bash

	cd ~/Desktop/pgrouting-workshop/
	tar -xvzf data.tar.gz

The following command will import the database dump. It will add PostGIS and pgRouting functions to a database, in the same way as decribed in the previous chapter. It will also load the sample data with a minimum number of attributes, which you will usually find in any network data:

.. code-block:: bash

	# Optional: Drop database
	dropdb -U postgres pgrouting-workshop

	# Load database dump file
	psql -U postgres -f ~/Desktop/pgrouting-workshop/data/sampledata_notopo.sql

Let's see wich tables have been created:

.. rubric:: Run: ``psql -U postgres -d pgrouting-workshop -c "\d"``
	
.. code-block:: sql

	               List of relations
	 Schema |       Name        | Type  |  Owner   
	--------+-------------------+-------+----------
	 public | geography_columns | view  | postgres
	 public | geometry_columns  | view  | postgres
	 public | raster_columns    | view  | postgres
	 public | raster_overviews  | view  | postgres
	 public | spatial_ref_sys   | table | postgres
	 public | ways              | table | postgres
	(7 rows)


The table containing the road network data has the name ``ways``. It consists of the following attributes:
	
.. rubric:: Run: ``psql -U postgres -d pgrouting-workshop -c "\d ways"``
	
.. code-block:: sql

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

For the next steps we need to start the PostgreSQL command line tool 

.. code-block:: bash

	psql -U postgres pgrouting-workshop
	
... or use PgAdmin III.


Calculate topology
-------------------------------------------------------------------------------

Having your data imported into a PostgreSQL database usually requires one more step for pgRouting. You have to make sure that your data provides a correct network topology, which consists of information about source and target ID of each road link.

If your network data doesn't have such network topology information already you need to run the ``pgr_createTopology`` function. This function assigns a ``source`` and a ``target`` ID to each link and it can "snap" nearby vertices within a certain tolerance.

.. code-block:: sql

	pgr_createTopology('<table>', float tolerance, '<geometry column', '<gid>')
	
First we have to add source and target column, then we run the assign_vertex_id function ... and wait.:

.. code-block:: sql

	-- Add "source" and "target" column
	ALTER TABLE ways ADD COLUMN "source" integer;
	ALTER TABLE ways ADD COLUMN "target" integer;
	
	-- Run topology function
	SELECT pgr_createTopology('ways', 0.00001, 'the_geom', 'gid');

.. note::

	Execute ``psql -U postgres -d pgrouting-workshop`` in your terminal to connect to the database and start the PostgreSQL shell. Leave the shell with ``\q`` command.   

.. warning::

	The dimension of the tolerance parameter depends on your data projection. Usually it's either "degrees" or "meters".


Add indices
-------------------------------------------------------------------------------

Fortunately we didn't need to wait too long because the data is small. But your network data might be very large, so it's a good idea to add an index to ``source`` and ``target`` column.

.. code-block:: sql

	CREATE INDEX source_idx ON ways("source");
	CREATE INDEX target_idx ON ways("target");

After these steps our routing database look like this:

.. rubric:: Run: ``\d``
	
.. code-block:: sql

	                 List of relations
	 Schema |        Name         |   Type   |  Owner   
	--------+---------------------+----------+----------
	 public | geography_columns   | view     | postgres
	 public | geometry_columns    | view     | postgres
	 public | raster_columns      | view     | postgres
	 public | raster_overviews    | view     | postgres
	 public | spatial_ref_sys     | table    | postgres
	 public | vertices_tmp        | table    | postgres
	 public | vertices_tmp_id_seq | sequence | postgres
	 public | ways                | table    | postgres
	(9 rows)


.. rubric:: Run: ``\d ways``
	
.. code-block:: sql
	
	               Table "public.ways"
	  Column  |           Type            | Modifiers 
	----------+---------------------------+-----------
	 gid      | bigint                    | 
	 class_id | integer                   | not null
	 length   | double precision          | 
	 name     | character(200)            | 
	 osm_id   | bigint                    | 
	 the_geom | geometry(LineString,4326) | 
	 source   | integer                   | 
	 target   | integer                   | 
	Indexes:
	    "ways_gid_idx" UNIQUE, btree (gid)
	    "geom_idx" gist (the_geom)
	    "source_idx" btree (source)
	    "target_idx" btree (target)

		
Now we are ready for our first routing query with :doc:`Dijkstra algorithm <shortest_path>`!
