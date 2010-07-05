==============================================================================================================
Installation and Requirements
==============================================================================================================

For this workshop you need:

* A webserver like Apache with PHP support
* An editor like Gedit
* Internet connection
* Preferrable a Linux operating system like Ubuntu

Most of this is available on the OSGeo LiveDVD, so the following reference is a quick summary of how to install it on your own computer running latest Ubuntu 10.04.

--------------------------------------------------------------------------------------------------------------
Software
--------------------------------------------------------------------------------------------------------------

Installation of pgRouting on Ubuntu became very easy now because packages are available in a `Launchpad repository <https://launchpad.net/~georepublic/+archive/pgrouting>`_: 

All you need to do now is to open a terminal window and run:

.. code-block:: bash
	
	# Add pgRouting launchpad repository
	sudo add-apt-repository ppa:georepublic/pgrouting
	sudo apt-get update

	# Install pgRouting packages
	sudo apt-get install gaul-devel \
		postgresql-8.4-pgrouting \
		postgresql-8.4-pgrouting-dd \
		postgresql-8.4-pgrouting-tsp

	# Install osm2pgrouting package
	sudo apt-get install osm2pgrouting

	# Install workshop material (optional)
	sudo apt-get install pgrouting-workshop

This will also install all required packages such as PostgreSQL and PostGIS if not installed yet.

.. note::

	* "Multiverse" packages must be available as software sources. Currently only packages for Ubuntu 10.04 have been built, but further packages are likely to come if there is demand for them.
	* To be up-to-date with changes and improvements you might run ``sudo apt-get update & sudo apt-get upgrade`` from time to time, especially if you use an older version of the LiveDVD.


--------------------------------------------------------------------------------------------------------------
Data
--------------------------------------------------------------------------------------------------------------

The pgRouting workshop will make use of OpenStreetMap data of Barcelona, which is already available on the LiveDVD. If you don't use the LiveDVD or want to download the latest data or the data of your choice, you can make use of OpenStreetMap's API from your terminal window:

.. code-block:: bash
	
	# Dowload as file barcelona.osm
	wget --progress=dot:mega -O barcelona.osm \
		http://osmxapi.hypercube.telascience.org/api/0.6/map?bbox=1.998653,41.307213,2.343693,41.495207

The API has a download size limitation, which can make it a bit inconvenient to download large areas with many features. An alternative is `JOSM Editor <http://josm.openstreetmap.de>`_, which also makes API calls to dowload data, but it provides an user friendly interface. You can save the data as ``.osm`` file to use it in this workship. JOSM is also available on the LiveDVD.

.. note::

	* OpenStreetMap API v0.6, see for more information http://wiki.openstreetmap.org/index.php/OSM_Protocol_Version_0.6 . 
	* Barcelona data is available at the LiveDVD in ``/usr/local/share/osm/``

An alternative for very large areas is the download service of `CloudMade <http://www.cloudemade.com>`_. The company offers extracts of maps from countries around the world. For data of Spain for example go to http://download.cloudmade.com/europe/spain and download the compressed ``.osm.bz2`` file:

.. code-block:: bash

	wget --progress=dot:mega http://download.cloudmade.com/europe/spain/spain.osm.bz2
	
.. warning::

	Data of a whole country might be too big for the LiveDVD as well as processing time might take very long.  
	
--------------------------------------------------------------------------------------------------------------
Workshop
--------------------------------------------------------------------------------------------------------------

If you installed the workshop package you will find all documents in ``/usr/share/pgrouting/workshop/``.

We recommend to copy the files to your home directory and make a symbolic link to your webserver's root folder:

.. code-block:: bash
	
	cp -R /usr/share/pgrouting/workshop ~/Desktop/pgrouting-workshop
	sudo ln -s ~/Desktop/pgrouting-workshop/web /var/www/pgrouting-workshop

You can then find all workshop files in the ``pgrouting-workshop`` folder and access to

* Web directory: http://localhost/pgrouting-workshop
* Online manual: http://localhost/pgrouting-workshop/docs/_build/html/index.html








