..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: https://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

.. _osm2pgrouting:

Appendix: osm2pgrouting Import Tool
-------------------------------------------------------------------------------

**osm2pgrouting** is a command line tool that allows to import OpenStreetMap
data into a pgRouting database. It builds the routing network topology
automatically and creates tables for feature types and road classes.

* Website: |osm2pgrouting-web|
* Documentation: |osm2pgrouting-wiki|

.. note::
  There are some limitations, especially regarding the network size.  The way to
  handle large data sets is to current version of osm2pgrouting needs to load
  all data into memory, which makes it fast but also requires a lot or memory
  for large datasets. An alternative tool to osm2pgrouting without the network
  size limitation is **osm2po** (https://osm2po.de). It's available under
  "Freeware License".

Raw OpenStreetMap data contains much more features and information than needed
for routing. Also the format is not suitable for pgRouting out-of-the-box. An
``.osm`` XML file consists of three major feature types:

* nodes
* ways
* relations

.. rubric:: Version and Help Options

This workshop use the osm2pgrouting version |osm2pgrouting-ver|

.. code-block:: bash

  osm2pgrouting -v
  osm2pgrouting --help

.. literalinclude:: code/osm2pgroutingVersion.txt
  :language: bash

.. rubric:: An osm file example looks like this:

.. literalinclude:: code/osm_sample.osm
  :language: xml

The detailed description of all possible OpenStretMap types and classes
are described as `map features <https://wiki.openstreetmap.org/wiki/Map_features>`__

.. rubric:: mapconfig.xml

When using osm2pgrouting, we take only nodes and ways of types and classes
specified in a ``mapconfig.xml`` file that will be imported into the routing
database:

.. literalinclude:: code/mapconfig_sample.xml
    :language: xml

The default ``mapconfig.xml`` is installed in ``/usr/share/osm2pgrouting/``.

* osm2pgrouting creates more tables and imports more attributes than we will use
  in this workshop.
* See the description of the tables the |osm2pgrouting-wiki|
