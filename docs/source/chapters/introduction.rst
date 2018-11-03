..
  ****************************************************************************
  pgRouting Workshop Manual
  Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Introduction
===============================================================================

.. rubric:: Abstract

`pgRouting <http://www.pgrouting.org>`_ adds routing functionality to `PostGIS
<http://www.postgis.org>`_. This introductory workshop will show you how.
Providing practical examples using  `OpenStreetMap
<http://www.openstreetmap.org>`_
road network data. Covering from how to prepare the data, make routing queries,
write a custom 'plpgsql' functions up to draw your route in a web-mapping
application. In other words, integrating pgRouting with other FOSS4G tools.

Navigation for road networks requires complex routing algorithms that support
turn restrictions and even time-dependent attributes. pgRouting is an extendible
open-source library that provides a variety of tools for shortest path search as
extension of PostgreSQL and PostGIS.

The workshop will focus on shortest path search with pgRouting in real road
networks. It will cover the following topics:

* Installing pgRouting,
* Creating a routing topology,
* Using pgRouting algorithms,
* Importing `OpenStreetMap <http://www.openstreetmap.org>`_ road network data,
* Writing advanced queries,
* Writing a custom PostgreSQL stored procedure in ‘plpgsql’,
* Building a simple browser application,
* Building a basic map interface with OpenLayers.

.. rubric:: Prerequisites

* Workshop level: intermediate.
* Attendee's previous knowledge: SQL (PostgreSQL, PostGIS), Javascript, HTML.
* Equipments: This workshop uses `OSGeo Live <http://live.osgeo.org>`_ (Version
  12.0)

.. rubric:: Presenters and Authors

.. Reminder: this lists only presenters of last 2 years + current yer & authors(s) of current workshop
    2 years back:
        Daniel: presented on Korea 2015
    Last year:
        Vicky & Daniel rewrites
        Daniel: presented on Bonn  2016
        Vicky: presented on India 2017
    Current
        Vicky & Steve rewrites
        Steve: presents on Boston 2017
        Steve: presents on Germany 2017
        Vicky: presents on Argentina 2017

Alphabetical Order:

* *Daniel Kastl* is founder and CEO of `Georepublic <http://georepublic.info>`_
  and works in Germany and Japan. He is moderating and promoting the pgRouting
  community and development since the beginning of the project, and he's an
  active OSM contributor in Japan. OSGeo Charter member.
* *Ko Nagase* works at `Georepublic <http://georepublic.info>`_  and works in Japan.
  tests of pgRouting project on Windows and Mac OSX environment.
  One of the contributors  of pgRoutingLayers for QGIS. OSGeo Charter member.
* *Stephen Woodbridge* works at `iMaptools <http://iMaptools.com>`_ in the greater Boston, MA area.
  He is a pgrouting PSC member and developer. He develops solutions for mapping, geocoding,
  reverse geocoding, routing and processing of remote sensing imagery. OSGeo Charter member.
* *Vicky Vergara* works at `Georepublic <http://georepublic.info>`_ and works in
  Mexico. She's the core developer of pgRouting project and GSoC Mentor. OSGeo Charter member.


.. rubric:: License

This work is licensed under a `Creative Commons Attribution-Share Alike 3.0 License <http://creativecommons.org/licenses/by-sa/3.0/>`_.

.. image:: /images/license.png

.. rubric:: Supported by

.. image:: /images/georepublic.png
  :alt: Georepublic
  :target: https://georepublic.info

.. image:: /images/imaptools-small.gif
  :alt: iMapTools
  :target: https://imaptools.com
