.. 
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _installation:

Installation and Requirements
===============================================================================

For this workshop you need:

* Preferable a Linux operating system like Ubuntu
* An editor like Gedit, Medit or similar
* `Geoserver <http://geoserver.org>`_ for the routing application
* Internet connection

All required tools are available on the `OSGeo Live <http://live.osgeo.org>`_, so the following reference is a quick summary of how to install it on your own computer running Ubuntu 12.04 or later.


pgRouting
-------------------------------------------------------------------------------

pgRouting on Ubuntu can be installed using packages from a `Launchpad repository <https://launchpad.net/~georepublic/+archive/ubuntu/pgrouting>`_: 

All you need to do is to open a terminal window and run:

.. code-block:: bash
	
	# Add pgRouting launchpad repository
	sudo apt-add-repository -y ppa:ubuntugis/ppa
	sudo apt-add-repository -y ppa:georepublic/pgrouting
	sudo apt-get update

	# Install pgRouting package (for Ubuntu 14.04)
	sudo apt-get install postgresql-9.3-pgrouting 

	# Install osm2pgrouting package
	sudo apt-get install osm2pgrouting

	# Install workshop material (optional, but maybe slightly outdated)
	sudo apt-get install pgrouting-workshop

	# For workshops at conferences and events:
	# Download and install from http://trac.osgeo.org/osgeo/wiki/Live_GIS_Workshop_Install
	wget --no-check-certificate https://launchpad.net/~georepublic/+archive/pgrouting/+files/pgrouting-workshop_[version]_all.deb
	sudo dpkg -i pgrouting-workshop_[version]_all.deb

This will also install all required packages such as PostgreSQL and PostGIS if not installed yet.

.. note::

	* To be up-to-date with changes and improvements you might run ``sudo apt-get update & sudo apt-get upgrade`` from time to time, especially if you use an older version of the LiveDVD.
	* To avoid permission denied errors for local users you can set connection method to ``trust`` in ``/etc/postgresql/<version>/main/pg_hba.conf`` and restart PostgreSQL server with ``sudo service postgresql restart``.

	.. code-block:: bash

		local   all             postgres                                trust
		local   all             all                                     trust
		host    all             all             127.0.0.1/32            trust
		host    all             all             ::1/128                 trust

	``pg_hba.conf`` can be only edited with "superuser" rights, ie. from the terminal window with 

	.. code-block:: bash

		sudo nano /etc/postgresql/9.3/main/pg_hba.conf

	To close the editor again hit ``CTRL-X``.

	* The workshop runs commands as user ``user``, which is the default user for `OSGeo Live <http://live.osgeo.org>`_.


Workshop
-------------------------------------------------------------------------------

When you installed the workshop package you will find all documents in ``/usr/share/pgrouting/workshop/``.

We recommend to copy the files to your home directory and make a symbolic link to your webserver's root folder:

.. code-block:: bash
	
	cp -R /usr/share/pgrouting/workshop ~/Desktop/pgrouting-workshop
	sudo ln -s ~/Desktop/pgrouting-workshop /var/www/html/pgrouting-workshop

You can then find all workshop files in the ``pgrouting-workshop`` folder and access to

* Web directory: http://localhost/pgrouting-workshop/web/
* Online manual: http://localhost/pgrouting-workshop/docs/html/

.. note::

	Additional sample data is available in the workshop ``data`` directory. To extract the file run ``tar -xzf ~/Desktop/pgrouting-workshop/data.tar.gz``.


.. _installation_load_functions:

Add pgRouting Functions to database
-------------------------------------------------------------------------------

Since **version 2.0** pgRouting functions can be easily installed as extension. This requires:

* PostgreSQL 9.1 or higher
* PostGIS 2.x installed as extension

If these requirements are met, then open a terminal window and execute the following commands (or run these commands in pgAdmin 3:

.. code-block:: bash

	# login as user "user" 
	psql -U user

	-- create routing database
	CREATE DATABASE routing;
	\c routing

	-- add PostGIS functions 
	CREATE EXTENSION postgis;

	-- add pgRouting core functions
	CREATE EXTENSION pgrouting;
	

.. note::

	If you're looking for the SQL files containing pgRouting function, you can find them in ``/usr/share/postgresql/<version>/contrib/pgrouting-2.0/``:

	.. code-block:: bash

		-rw-r--r-- 1 root root  4126 Jun 18 22:30 pgrouting_dd_legacy.sql
		-rw-r--r-- 1 root root 43642 Jun 18 22:30 pgrouting_legacy.sql
		-rw-r--r-- 1 root root 40152 Jun 18 22:30 pgrouting.sql

Data
-------------------------------------------------------------------------------

The pgRouting workshop will make use of OpenStreetMap data, which is already available on `OSGeo Live <http://live.osgeo.org>`_. If you don't use the `OSGeo Live <http://live.osgeo.org>`_ or want to download the latest data or the data of your choice, you can make use of OpenStreetMap's API from your terminal window:

.. code-block:: bash
	
	# Download using Overpass XAPI (larger extracts possible than with default OSM API)
	BBOX="-122.8,45.4,-122.5,45.6"
	wget --progress=dot:mega -O "sampledata.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"

More information how to get OSM data:

	* OpenStreetMap download information in http://wiki.openstreetmap.org/wiki/Downloading_data
	* OpenStreetMap data is available at the `OSGeo Live <http://live.osgeo.org>`_ in ``/usr/local/share/osm/``

An alternative for very large areas is the download services of `Geofabrik <http://download.geofabrik.de>`_. 
Download a country extract and unpack the data like this:

.. code-block:: bash

	wget --progress=dot:mega http://download.geofabrik.de/[path/to/file].osm.bz2
	bunzip2 [file].osm.bz2
	
.. warning::

	Data of a whole country might be too big for the `OSGeo Live <http://live.osgeo.org>`_ installation as well as processing time might take very long.  
	






