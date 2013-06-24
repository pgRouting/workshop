.. 
   ****************************************************************************
    pgRouting Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _installation:

Installation and Requirements
===============================================================================

For this workshop you need:

* A webserver like Apache with PHP support (and PHP PostgreSQL module)
* Preferable a Linux operating system like Ubuntu
* An editor like Gedit
* Internet connection

All required tools are available on the `OSGeo LiveDVD <http://live.osgeo.org>`_, so the following reference is a quick summary of how to install it on your own computer running Ubuntu 12.04 or later.


pgRouting
-------------------------------------------------------------------------------

pgRouting on Ubuntu can be done using packages from a `Launchpad repository <https://launchpad.net/~georepublic/+archive/pgrouting-unstable>`_: 

All you need to do is to open a terminal window and run:

.. code-block:: bash
	
	# Add pgRouting launchpad repository
	sudo add-apt-repository ppa:georepublic/pgrouting-unstable
	sudo apt-get update

	# Install pgRouting package
	sudo apt-get install postgresql-9.1-pgrouting 

	# Install osm2pgrouting package
	sudo apt-get install osm2pgrouting

	# Install workshop material (optional)
	sudo apt-get install pgrouting-workshop

This will also install all required packages such as PostgreSQL and PostGIS if not installed yet.

.. note::

	* "Multiverse" packages must be available as software sources. 
	* To be up-to-date with changes and improvements you might run ``sudo apt-get update & sudo apt-get upgrade`` from time to time, especially if you use an older version of the LiveDVD.
	* To avoid permission denied errors for local users you can set connection method to ``trust`` in ``/etc/postgresql/9.1/main/pg_hba.conf`` and restart PostgreSQL server with ``sudo service postgresql restart``.
	

Workshop
-------------------------------------------------------------------------------

When you installed the workshop package you will find all documents in ``/usr/share/pgrouting/workshop/``.

We recommend to copy the files to your home directory and make a symbolic link to your webserver's root folder:

.. code-block:: bash
	
	cp -R /usr/share/pgrouting/workshop ~/Desktop/pgrouting-workshop
	sudo ln -s ~/Desktop/pgrouting-workshop /var/www/pgrouting-workshop

You can then find all workshop files in the ``pgrouting-workshop`` folder and access to

* Web directory: http://localhost/pgrouting-workshop/web/
* Online manual: http://localhost/pgrouting-workshop/docs/html/

.. note::

	Additional sample data is available in the workshop ``data`` directory. To extract the file run ``tar -xzf ~/Desktop/pgrouting-workshop/data.tar.gz``.


.. _installation_load_functions:

Add pgRouting Functions to database
-------------------------------------------------------------------------------

Since **version 2.0** pgRouting functions can be easily installed as extension. This requires additionally:

* PostgreSQL 9.1 or higher
* PostGIS installed as extension

If these requirements are met, then open a terminal window and execute the following commands (or run these commands in pgAdmin 3:

.. code-block:: bash

	# login as user "postgres" 
	psql -U postgres

	# create routing database
	CREATE DATABASE routing;
	\c routing

	# add PostGIS functions 
	CREATE EXTENSION postgis;

	# add pgRouting core functions
	CREATE EXTENSION pgrouting;
	

.. note::

	If you're looking for the SQL files containing pgRouting function, you can find them in ``/usr/share/postgresql/9.1/contrib/pgrouting-2.0/``:

	.. code-block:: bash

		-rw-r--r-- 1 root root  4126 Jun 18 22:30 pgrouting_dd_legacy.sql
		-rw-r--r-- 1 root root 43642 Jun 18 22:30 pgrouting_legacy.sql
		-rw-r--r-- 1 root root 40152 Jun 18 22:30 pgrouting.sql

Data
-------------------------------------------------------------------------------

The pgRouting workshop will make use of OpenStreetMap data, which is already available on the LiveDVD. If you don't use the LiveDVD or want to download the latest data or the data of your choice, you can make use of OpenStreetMap's API from your terminal window:

.. code-block:: bash
	
	# Dowload as file sampledata.osm
	wget --progress=dot:mega -O sampledata.osm "http://api.openstreetmap.org/api/0.6/map?bbox=11.54,48.14,11.543,48.145" 

The API has a download size limitation, which can make it a bit inconvenient to download large areas with many features. An alternative is `JOSM Editor <http://josm.openstreetmap.de>`_, which also makes API calls to dowload data, but it provides an user friendly interface. You can save the data as ``.osm`` file to use it in this workship. JOSM is also available on the LiveDVD.

.. note::

	* OpenStreetMap download information in http://wiki.openstreetmap.org/wiki/Downloading_data
	* OpenStreetMap data is available at the LiveDVD in ``/usr/local/share/osm/``

An alternative for very large areas is the download services of `CloudMade <http://www.cloudemade.com>`_ or `Geofabrik <http://www.geofabrik.de>`_. The companies offer extracts of maps from countries around the world. For data of Japan for example go to http://download.geofabrik.de/asia/japan-latest.osm.bz2 and download the compressed ``.osm.bz2`` file:

.. code-block:: bash

	wget --progress=dot:mega http://download.geofabrik.de/asia/japan-latest.osm.bz2
	
.. warning::

	Data of a whole country might be too big for the LiveDVD as well as processing time might take very long.  
	






