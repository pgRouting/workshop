.. 
   ****************************************************************************
    pgRouting Workshop Manual
    Copyright(c) pgRouting Contributors

    This documentation is licensed under a Creative Commons Attribution-Share  
    Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
   ****************************************************************************

.. _geoserverwms:

WMS server with GeoServer
===============================================================================

Now that we have a pl/pgsql wrapper, we will make it available as a WMS layer using `GeoServer <http://geoserver.org/>`_.

The installation of GeoServer is out of the scope of this workshop, but if you're using the `OSGeo Live <http://live.osgeo.org>`_ for this workshop then you have GeoServer installed already.

Connect to the administration page
-------------------------------------------------------------------------------

In order to create the WMS layer, we need to connect to the administration interface of GeoServer. On `OSGeo LiveDVD <http://live.osgeo.org>`_ Desktop, open the *Applications* menu on the desktop and then *Geospatial* > *Web Services* > *GeoServer* > *Start GeoServer*.

Once the server is up and running, open the `administration page <http://localhost:8082/geoserver/web>`_ in your browser, click the *Login* button, and enter the GeoServer admin credentials:

:Username: ``admin``
:Password: ``geoserver``

Create the layer
-------------------------------------------------------------------------------

Now that your are logged in as an administrator you can create the WMS layer. In GeoServer terminology you will create an SQL View (see the `official documentation <http://docs.geoserver.org/latest/en/user/data/database/sqlview.html>`_ for more info).

The first thing to do is to create a new **Workspace** for pgrouting: in the left menu of the page, inside the *Data* section, click *Workspaces* and then *Add new workspace*.

Fill the form with:

:Name: ``pgrouting``
:Namespace URI: ``http://pgrouting.org``

And press the ``submit`` button.

Next step: create a new **Store** linked to the workspace. Still in the left menu, click *Stores* and then *Add new Store*. Here you can choose the type of data source to configure. Choose *PostGIS*.

Fill the form with:

* Basic Store Info:

:Workspace: ``pgrouting``
:Data Source: ``pgrouting``

* Connection Parameters:

:host: ``localhost``
:port: ``5432``
:database: ``pgrouting-workshop``
:schema: ``public``
:user: ``user``
:password: ``user``

The rest of the values can be left untouched.

Finally, your next task is to create the **Layer**. Click the *Layers* menu and then *Add a new resource*. Select the newly created workspace and store pair: ``pgrouting:pgrouting``.

Inside the text, click *Configure new SQL view*.

Name the view ``pgrouting`` and fill the *SQL statement* with:

.. code-block:: sql

  SELECT ST_MakeLine(route.geom) FROM (
      SELECT geom FROM pgr_fromAtoB('ways', %x1%, %y1%, %x2%, %y2%
    ) ORDER BY seq) AS route

In the *SQL view parameters*, click *Guess parameters from SQL*; the
list displayed represents the parameters from the SQL above.

For each parameter:

* Set the default value to: `0`
* Change the validation regular expression to ``^-?[\d.]+$``

The regular expression will only match numbers.

In the *Attributes* list:

* Hit *Refresh*, one attribute should appear (called *st_makeline*)
* Change the type to ``LineString`` and the SRID of the geometry column from ``-1`` to ``4326``

Save the form.

Finally, we need to setup the rest of the layer.

The only thing to do in this screen is to make sure that the coordinate reference system is correct: the geometries in the database are in ``EPSG:4326`` but we want to display them in `EPSG:3857` because the OpenLayers map where the layer will be dispayed is in this projection.

Scroll down to the *coordinate reference system* section and change the **Declared SRS** to ``EPSG:3857`` and the **SRS handling** to ``Reproject native to declared``.

Click the *Compute from data* and *Compute from native bounds* link to automatically set the layer bounds. Click the *Save* at the bottom of the page to create the layer.
