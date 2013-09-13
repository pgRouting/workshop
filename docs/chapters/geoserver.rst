==============================================================================================================
WMS server with GeoServer
==============================================================================================================

Now that we have a pl/pgsql wrapper, we will make it available as a
WMS layer using `GeoServer <http://geoserver.org/>`_.

The installation of GeoServer is out of scope of this workshop but if
you're using the `OSGeo LiveDVD <http://live.osgeo.org>`_ the server
is already installed and only needs to be started.


Connect to the administration page
-------------------------------------------------------------------------------

In order to create the WMS layer, we need to connect to the
administration page of GeoServer. On the OSGeo LiveDVD, open the
*Applications* menu on the desktop and then *Geoservers* > *GeoServer*
> *Start GeoServer*.

Once the server is up, the `administration page
<http://localhost:8082/geoserver/web>`_ should open, click the *Login*
button and entrer the admin credentials:

 * Username: ``admin``
 * Password: ``geoserver``

Create the layer
-------------------------------------------------------------------------------

Now that we are logged in as an administrator we can start create our
layer.
In GeoServer terminology we will create an SQL View (see the `official
documentation
<http://docs.geoserver.org/latest/en/user/data/database/sqlview.html>`_
for more info).

The first thing to do is to create a new **Workspace** for pgrouting:
in the left menu of the page, inside the *Data* section, click
*Workspaces* and then *Add new workspace*.
Fill the form with:

 * Name: ``pgrouting``
 * Namespace URI: ``http://pgrouting.org/``

Add press the submit button.

Next step: create a new **Store** FIXME
Still in the left menu, click *Stores* and then *Add new Store*.
Here we can choose the type of data source to configure. Choose *PostGIS*.
Fill the form with:

 * Basic Store Info:

  * Workspace (select): ``pgrouting``
  * Data Source Name: ``pgrouting``

 * Connection Parameters:

  * host: ``localhost``
  * port: ``5432``
  * database: ``pgrouting`` (FIXME)
  * schema: ``public``
  * user: ``postgres`` (FIXME)
  * password: blank (FIXME)

The rest of the values can be left untouched.

Finally, our next task is to create the **Layer**. Click the *Layers*
menu and then *Add a new resource*. Select the newly created workspace
and store pair: ``pgrouting:pgrouting``.

Inside the text, click *Configure new SQL view*.

Name the view ``pgrouting`` and fill the *SQL statement* with:

.. code-block:: sql

  SELECT ST_MakeLine(route.geom) FROM (SELECT geom FROM pgr_fromAtoB('ways', %x1%, %y1%, %x2%, %y2%) ORDER BY seq) AS route

In the SQL view parameters:

 * Guess parameters from SQL
 * Set the default value to: `0`
 * Change the Validation regular expression to ``^-?[\d.]+$``

In the Attributes list:

 * Hit Refresh, one attribute should appear (called *st_makeline*)
 * Change the type to ``LineString`` and the SRID of the geometry column from ``-1`` to ``4326``

Save the form.

*Edit Layer*: needs to be in the same projection as our view: `EPSG:3857`

 * Declared SRS: ``EPSG:3857``
 * SRS handling: ``Reproject native to declared``
 * Native Bounding Box: click the *Compute from data* link
 * Lat/Lon Bounding Box: click the *Compute from native bounds* link
 * Save
