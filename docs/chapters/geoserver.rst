==============================================================================================================
WMS server with GeoServer
==============================================================================================================

 * start GeoServer: Applications > Geoservers > GeoServer > Start GeoServer
 * If the web page don't automatically appear, go to `http://localhost:8082/gerserver/web/ <http://localhost:8082/gerserver/web/>`
 * Log on as ``admin`` user (password is ``geoserver``)
 
 * left menu: Data > Workspace, Add new workspace
 * Name: ``pgrouting``, Namespace URI ``http://pgrouting.org/``

 * left menu: Data > Stores, Add new Store
 * PostGIS
 * Workspace: ``pgrouting``
 * Data Source Name: ``pgrouting``
 * database: ``pgrouting``
 * user: ``postgres``
 * password: blank

 * left menu: Data > Layers
 * Add a new resource
 * Add layer from: ``pgrouting:pgrouting``
 * Configure new SQL view
 * View Name: ``pgrouting``
 * SQL statement: ``FIXME``

 * Guess parameters from SQL
 * Set the default value to: `0`
 * Change the Validation regular expression to ``^[\d]+$``


FIXME: WMS proj


http://docs.geoserver.org/latest/en/user/data/database/sqlview.html

