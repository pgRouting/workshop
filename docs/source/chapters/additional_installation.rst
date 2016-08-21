..
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _more_installation:

Appendix: Installation
===============================================================================

For this workshop you need:

* Linux operating system like Ubuntu
* An editor like Gedit, Medit or similar
* `Geoserver <https://live.osgeo.org/en/quickstart/geoserver_quickstart.html>`_
  for the routing application
* Internet connection

`Install pgRouting on a Windows computer <http://postgis.net/windows_downloads/more_installation>`_.


The following reference is a quick summary of how to install it on your own
computer running Ubuntu 12.04 or later.


pgRouting
-------------------------------------------------------------------------------

pgRouting on Ubuntu can be installed using packages from a `PostgreSQL
repository <http://apt.postgresql.org/pub/repos/apt/>`_:

Using a terminal window:

.. code-block:: bash

  # Create /etc/apt/sources.list.d/pgdg.list. The distributions are called codename-pgdg.
  sudo sh -c 'echo "deb http://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

  # Import the repository key, update the package lists
  sudo apt-get install wget ca-certificates
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt-get update

  # Install pgrouting based on your postgres Installation: for this example is 9.3
  sudo apt-get install postgresql-9.3-pgrouting

This will also install all required packages such as PostgreSQL and PostGIS if not installed yet.

.. note::

  * To be up-to-date with changes and improvements

    .. code-block:: bash

      sudo apt-get update & sudo apt-get upgrade

  * To avoid permission denied errors for local users you can set connection
    method to ``trust`` in ``/etc/postgresql/<version>/main/pg_hba.conf`` and
    restart PostgreSQL server with ``sudo service postgresql restart``.
    Following the example with PostgreSQL 9.3:

    .. code-block:: bash

      sudo nano /etc/postgresql/9.3/main/pg_hba.conf

      local   all             postgres                                trust
      local   all             all                                     trust
      host    all             all             127.0.0.1/32            trust
      host    all             all             ::1/128                 trust

pgRouting Workshop
-------------------------------------------------------------------------------

.. TODO:: this section is outdated

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
  The workshop runs commands as user ``user``, which is the default user for
  `OSGeo Live <http://live.osgeo.org>`_.

When you installed the workshop package you will find all documents in
``/usr/share/pgrouting/workshop/``.

We recommend to copy the files to your home directory and make a symbolic link
to your web server's root folder:

.. code-block:: bash

    cp -R /usr/share/pgrouting/workshop ~/Desktop/pgrouting-workshop
    sudo ln -s ~/Desktop/pgrouting-workshop /var/www/html/pgrouting-workshop

You can then find all workshop files in the ``pgrouting-workshop`` folder and
access to

* Web directory: http://localhost/pgrouting-workshop/web/
* Online manual: http://localhost/pgrouting-workshop/docs/html/

.. note::
    Additional sample data is available in the workshop ``data`` directory. To
    extract the file run ``tar -xzf ~/Desktop/pgrouting-workshop/data.tar.gz``.

.. _installation_load_functions:
