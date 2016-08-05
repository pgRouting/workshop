..
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _osm2pgrouting:

Appendix: osm2pgrouting Import Tool
-------------------------------------------------------------------------------

**osm2pgrouting** is a command line tool that allows to import OpenStreetMap data into a pgRouting database.
It builds the routing network topology automatically and creates tables for feature types and road classes.
osm2pgrouting was primarily written by Daniel Wendt and is currently hosted on the pgRouting project site: http://www.pgrouting.org/docs/tools/osm2pgrouting.html
The current documentation is at: https://github.com/pgRouting/osm2pgrouting/wiki/Documentation-for-osm2pgrouting-v2.1

.. note::

    There are some limitations, especially regarding the network size.
    The way to handle large data sets is to current version of osm2pgrouting needs to load all data into memory,
    which makes it fast but also requires a lot or memory for large datasets.
    An alternative tool to osm2pgrouting without the network size limitation is **osm2po** (http://osm2po.de). It's available under "Freeware License".


Raw OpenStreetMap data contains much more features and information than needed for routing.
Also the format is not suitable for pgRouting out-of-the-box.
An ``.osm`` XML file consists of three major feature types:

* nodes
* ways
* relations

.. rubric:: Version and Help Options

This workshop use the osm2pgrouting version 2.1

.. literalinclude:: code/osm2pgroutingVersion.txt
   :language: bash

.. code-block:: bash

    osm2pgrouting -v
    osm2pgrouting --help

.. rubric:: An osm file example looks like this:

.. literalinclude:: code/osm_sample.osm
    :language: xml

The detailed description of all possible OpenStretMap types and classes can be found here:  http://wiki.openstreetmap.org/index.php/Map_features.

.. rubric:: mapconfig.xml

When using osm2pgrouting, we take only nodes and ways of types and classes specified in a ``mapconfig.xml`` file that will be imported into the routing database:

.. literalinclude:: code/mapconfig_sample.xml
    :language: xml

The default ``mapconfig.xml`` is installed in ``/usr/share/osm2pgrouting/``.



* osm2pgrouting creates more tables and imports more attributes than we will use in this workshop.
* See the  `description of the tables <https://github.com/pgRouting/osm2pgrouting/wiki/Documentation-for-osm2pgrouting-v2.1#table-structure>`_

