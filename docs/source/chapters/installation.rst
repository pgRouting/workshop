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

Using a terminal window:


.. code-block:: bash

    # Create /etc/apt/sources.list.d/pgdg.list. The distributions are called codename-pgdg.
    sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

    # Import the repository key, update the package lists
    sudo apt-get install wget ca-certificates
    wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
    sudo apt-get update

    # Install pgrouting based ont your postgres Installation: for this example is 9.3
    sudo apt-get install postgresql-9.3-pgrouting

This will also install all required packages such as postgreSQL and postGIS if not installed yet.

.. note::

    * To be up-to-date with changes and improvements

        .. code-block:: bash

            sudo apt-get update & sudo apt-get upgrade

    * To avoid permission denied errors for local users you can set connection method to ``trust`` in ``/etc/postgresql/<version>/main/pg_hba.conf`` and restart PostgreSQL server with ``sudo service postgresql restart``. Following the example with postgreSQL 9.3:


        .. code-block:: bash

            sudo nano /etc/postgresql/9.3/main/pg_hba.conf

            local   all             postgres                                trust
            local   all             all                                     trust
            host    all             all             127.0.0.1/32            trust
            host    all             all             ::1/128                 trust


pgRouting Workshop
-------------------------------------------------------------------------------

To download the workshops at conferences and events:

.. rubric:: Method 1

Download and install from http://trac.osgeo.org/osgeo/wiki/Live_GIS_Workshop_Install

.. rubric:: Method 2

.. code-block:: bash
    
    # Add pgRouting launchpad repository
    sudo apt-add-repository -y ppa:ubuntugis/ppa
    sudo apt-add-repository -y ppa:georepublic/pgrouting
    sudo apt-get update

    # or
    wget --no-check-certificate https://launchpad.net/~georepublic/+archive/pgrouting/+files/pgrouting-workshop_[version]_all.deb
    sudo dpkg -i pgrouting-workshop_[version]_all.deb



.. note::

    The workshop runs commands as user ``user``, which is the default user for `OSGeo Live <http://live.osgeo.org>`_.


When you installed the workshop package you will find all documents in ``/usr/share/pgrouting/workshop/``.

We recommend to copy the files to your home directory and make a symbolic link to your web server's root folder:

.. code-block:: bash

    cp -R /usr/share/pgrouting/workshop ~/Desktop/pgrouting-workshop
    sudo ln -s ~/Desktop/pgrouting-workshop /var/www/html/pgrouting-workshop

You can then find all workshop files in the ``pgrouting-workshop`` folder and access to

* Web directory: http://localhost/pgrouting-workshop/web/
* Online manual: http://localhost/pgrouting-workshop/docs/html/

.. note::

    Additional sample data is available in the workshop ``data`` directory. To extract the file run ``tar -xzf ~/Desktop/pgrouting-workshop/data.tar.gz``.


.. _installation_load_functions:

Installing pgRouting to the database
-------------------------------------------------------------------------------

Since **version 2.0** pgRouting functions are installed as extension. This requires:

* postgreSQL 9.1 or higher
* postGIS 2.x installed as extension

If these requirements are met, then open a terminal window and execute the following commands (or run these commands in pgAdmin 3:

.. code-block:: bash

    # login as user "user"
    psql -U user

    -- create routing database
    CREATE DATABASE routing;
    \c city-routing

    -- add PostGIS functions
    CREATE EXTENSION postgis;

    -- add pgRouting functions
    CREATE EXTENSION pgrouting;
    
    -- Inspect the pgRouting installation
    \dx+ pgRouting

.. _installation_workshop_data:

Install Workshop Data
-------------------------------------------------------------------------------

The pgRouting workshop will make use of OpenStreetMap data, which is already available on `OSGeo Live <http://live.osgeo.org>`_.
If you don't use the `OSGeo Live <http://live.osgeo.org>`_ or want to download the latest data or the data of your choice, you can make use of OpenStreetMap's API from your terminal window:

.. code-block:: bash
    
    # make a directory for pgRouting data manipulation
    mkdir ~/Desktop/pgRouting-workshop-data
    cd ~/Desktop/pgRouting-workshop-data

This workshop will use the following Bonn city data:

.. rubric:: If using OsgeLive

.. code-block:: bash
    
    CITY="BONN_DE"
    cp ../../data/osm/$CITY.osm.bz2 .
    bunzip2 $CITY.osm.bz2
 

.. rubric:: Download data form osgeolive

.. code-block:: bash
    
    CITY="BONN_DE"
    wget -N --progress=dot:mega \
        "http://download.osgeo.org/livedvd/data/osm/$CITY/$CITY.osm.bz2"
    bunzip2 $CITY.osm.bz2

.. rubric:: Download using Overpass XAPI (larger extracts possible than with default OSM API)

.. code-block:: bash
    
    BBOX="7.097,50.6999,7.1778,50.7721"
    wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"



More information how to download OpenStreetMap information can be found in http://wiki.openstreetmap.org/wiki/Downloading_data

An alternative for very large areas is to use the download services of `Geofabrik <http://download.geofabrik.de>`_.
