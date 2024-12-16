..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: https://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Appendix: Installation
===============================================================================

For this workshop you need:

* Linux operating system like Ubuntu
* An editor like Gedit, Medit or similar
* `Geoserver <https://live.osgeo.org/en/quickstart/geoserver_quickstart.html>`__
  for the routing application
* Internet connection

`Install pgRouting on a Windows computer <https://postgis.net/windows_downloads/>`__.

The following reference is a quick summary of how to install it on your own
computer running Ubuntu 14.04 or later.

.. rubric:: Ubuntu

pgRouting on Ubuntu can be installed using packages from a `PostgreSQL
repository <https://apt.postgresql.org/pub/repos/apt/>`__:

Using a terminal window:

.. code-block:: bash

  # Create /etc/apt/sources.list.d/pgdg.list. The distributions are called codename-pgdg.
  sudo sh -c 'echo "deb https://apt.postgresql.org/pub/repos/apt/ $(lsb_release -cs)-pgdg main" > /etc/apt/sources.list.d/pgdg.list'

  # Import the repository key, update the package lists
  sudo apt install wget ca-certificates
  wget --quiet -O - https://www.postgresql.org/media/keys/ACCC4CF8.asc | sudo apt-key add -
  sudo apt update

  # Install pgrouting based on your postgres Installation: for this example is 10
  sudo apt install postgresql-10-pgrouting

This will also install all required packages such as PostgreSQL and PostGIS if not installed yet.

To be up-to-date with changes and improvements

.. code-block:: bash

  sudo apt-get update & sudo apt-get upgrade

To avoid permission denied errors for local users you can set connection method
to ``trust`` in ``/etc/postgresql/<version>/main/pg_hba.conf`` and restart
PostgreSQL server with ``sudo service postgresql restart``.

Following the example with PostgreSQL 10:

.. code-block:: bash

  sudo nano /etc/postgresql/10/main/pg_hba.conf

  local   all             postgres                                trust
  local   all             all                                     trust
  host    all             all             127.0.0.1/32            trust
  host    all             all             ::1/128                 trust
