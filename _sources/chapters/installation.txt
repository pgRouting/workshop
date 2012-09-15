==============================================================================================================
Installation and Requirements
==============================================================================================================

For this workshop you need:

* A webserver like Apache with PHP support (and PHP PostgreSQL module)
* Preferable a Linux operating system like Ubuntu
* An editor like Gedit
* Internet connection

All required tools are available on the OSGeo LiveDVD, so the following reference is a quick summary of how to install it on your own computer running Ubuntu 10.04 or later.

--------------------------------------------------------------------------------------------------------------
pgRouting
--------------------------------------------------------------------------------------------------------------

Installation of pgRouting on Ubuntu became very easy now because packages are available in a `Launchpad repository <https://launchpad.net/~georepublic/+archive/pgrouting>`_: 

All you need to do now is to open a terminal window and run:

.. code-block:: bash
	
	# Add pgRouting launchpad repository
	sudo add-apt-repository ppa:georepublic/pgrouting
	sudo apt-get update

	# Install pgRouting packages
	sudo apt-get install gaul-devel \
		postgresql-9.1-pgrouting \
		postgresql-9.1-pgrouting-dd \
		postgresql-9.1-pgrouting-tsp

	# Install osm2pgrouting package
	sudo apt-get install osm2pgrouting

	# Install workshop material (optional)
	sudo apt-get install pgrouting-workshop

This will also install all required packages such as PostgreSQL and PostGIS if not installed yet.

.. note::

	* "Multiverse" packages must be available as software sources. Currently packages for Ubuntu 10.04 to 12.04 are available.
	* To be up-to-date with changes and improvements you might run ``sudo apt-get update & sudo apt-get upgrade`` from time to time, especially if you use an older version of the LiveDVD.
	* To avoid permission denied errors for local users you can set connection method to ``trust`` in ``/etc/postgresql/9.1/main/pg_hba.conf`` and restart PostgreSQL server with ``sudo service postgresql-8.4 restart``.
	
--------------------------------------------------------------------------------------------------------------
Workshop
--------------------------------------------------------------------------------------------------------------

When you installed the workshop package you will find all documents in ``/usr/share/pgrouting/workshop/``.

We recommend to copy the files to your home directory and make a symbolic link to your webserver's root folder:

.. code-block:: bash
	
	cp -R /usr/share/pgrouting/workshop ~/Desktop/pgrouting-workshop
	sudo ln -s ~/Desktop/pgrouting-workshop /var/www/pgrouting-workshop

You can then find all workshop files in the ``pgrouting-workshop`` folder and access to

* Web directory: http://localhost/pgrouting-workshop/web/
* Online manual: http://localhost/pgrouting-workshop/docs/html/

.. note::

	Additional sample data is available in the workshop ``data`` directory. It contains a compressed file with database dumps as well as a smaller network data of Denver downtown. To extract the file run ``tar -xzf ~/Desktop/pgrouting-workshop/data.tar.gz``.


--------------------------------------------------------------------------------------------------------------
Database from Template
--------------------------------------------------------------------------------------------------------------

It's a good idea to create template databases for PostGIS and pgRouting. This makes it later very easy to create a routing database and have all functions available right away, without having to load additional SQL functions file by file into every new database.

A script is available in the workshop ``bin`` directory to add PostGIS and pgRouting template databases to your PostgreSQL server.
To create the template database execute the following command in a terminal window: 

.. code-block:: bash
	
	cd ~/Desktop/pgrouting-workshop
	bash bin/create_templates.sh

Now you can create a new "pgRouting enabled" database with ``template_routing`` as a template. Run the following command in the terminal window:

.. code-block:: bash
	
	# Create database "routing"
	createdb -U postgres -T template_routing routing

Alternativly you can use **PgAdmin III** and SQL commands. Start PgAdmin III (available on the LiveDVD), connect to any database and open the SQL Editor and then run the following SQL command:

.. code-block:: sql

	-- create routing database
	CREATE DATABASE "routing" TEMPLATE "template_routing";


.. _installation_load_functions:

--------------------------------------------------------------------------------------------------------------
Load Functions
--------------------------------------------------------------------------------------------------------------

Without a routing template database several files containing pgRouting functions must be loaded to the database. Therefore open a terminal window and execute the following commands:

.. code-block:: bash

	# become user "postgres" (or run as user "postgres")
	sudo su postgres

	# create routing database
	createdb routing
	createlang plpgsql routing

	# add PostGIS functions (version 1.x)
	psql -d routing -f /usr/share/postgresql/9.1/contrib/postgis-1.5/postgis.sql
	psql -d routing -f /usr/share/postgresql/9.1/contrib/postgis-1.5/spatial_ref_sys.sql
	
	# add PostGIS functions (version 2.x)
	psql -d routing -c "CREATE EXTENSION postgis;"	

	# add pgRouting core functions
	psql -d routing -f /usr/share/postlbs/routing_core.sql
	psql -d routing -f /usr/share/postlbs/routing_core_wrappers.sql
	psql -d routing -f /usr/share/postlbs/routing_topology.sql
	
Alternativly you can use **PgAdmin III** and SQL commands. Start PgAdmin III (available on the LiveDVD), connect to any database and open the SQL Editor and then run the following SQL command:

.. code-block:: sql

	-- create routing database
	CREATE DATABASE "routing";
	
Then connect to the ``routing`` database and open a new SQL Editor window:
	
.. code-block:: sql

	-- add plpgsql and PostGIS/pgRouting functions
	CREATE PROCEDURAL LANGUAGE plpgsql;

Next open ``.sql`` files with PostGIS/pgRouting functions as listed above and load them to the ``routing`` database.
	
.. note::

	PostGIS ``.sql`` files can be stored in different directories. The exact location depends on your version of PostGIS and PostgreSQL. The example above is valid for PostgeSQL/PostGIS version 1.5 installed on OSGeo LiveDVD.
	

--------------------------------------------------------------------------------------------------------------
Data
--------------------------------------------------------------------------------------------------------------

The pgRouting workshop will make use of OpenStreetMap data of Denver, which is already available on the LiveDVD. If you don't use the LiveDVD or want to download the latest data or the data of your choice, you can make use of OpenStreetMap's API from your terminal window:

.. code-block:: bash
	
	# Dowload as file sampledata.osm
	wget --progress=dot:mega -O "sampledata.osm"  
		"http://jxapi.openstreetmap.org/xapi/api/0.6/*
						[bbox=-105.2147,39.5506,-104.594,39.9139]"

The API has a download size limitation, which can make it a bit inconvenient to download large areas with many features. An alternative is `JOSM Editor <http://josm.openstreetmap.de>`_, which also makes API calls to dowload data, but it provides an user friendly interface. You can save the data as ``.osm`` file to use it in this workship. JOSM is also available on the LiveDVD.

.. note::

	* OpenStreetMap API v0.6, see for more information http://wiki.openstreetmap.org/index.php/OSM_Protocol_Version_0.6
	* Denver data is available at the LiveDVD in ``/usr/local/share/osm/``

An alternative for very large areas is the download service of `CloudMade <http://www.cloudemade.com>`_. The company offers extracts of maps from countries around the world. For data of Colorado for example go to http://download.cloudmade.com/americas/northern_america/united_states/colorado and download the compressed ``.osm.bz2`` file:

.. code-block:: bash

	wget --progress=dot:mega http://download.cloudmade.com/americas/northern_america/united_states/colorado/colorado.osm.bz2
	
.. warning::

	Data of a whole country might be too big for the LiveDVD as well as processing time might take very long.  
	






