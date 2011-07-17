# ------------------------------------------------------------------------------
# Setup template containing PostGIS and/or pgRouting
# ------------------------------------------------------------------------------
#
# To create a GIS database as non-superuser run: 
#
# 	"createdb -h hostname -W -T template_postgis mydb
#
# Source: http://geospatial.nomad-labs.com/2006/12/24/postgis-template-database/
#
# Note: requires "libpq-dev" package

POSTGIS_SQL_PATH=`pg_config --sharedir`/contrib
ROUTING_SQL_PATH=/usr/share/postlbs

# Create "template_postgis"
# -------------------------
sudo -u postgres createdb -E UTF8 -T template0 template_postgis
sudo -u postgres createlang -d template_postgis plpgsql

sudo -u postgres psql --quiet -d template_postgis -f $POSTGIS_SQL_PATH/postgis-1.5/postgis.sql
sudo -u postgres psql --quiet -d template_postgis -f $POSTGIS_SQL_PATH/postgis-1.5/spatial_ref_sys.sql
sudo -u postgres psql --quiet -d template_postgis -f $POSTGIS_SQL_PATH/postgis_comments.sql

sudo -u postgres psql -d template_postgis -c "GRANT ALL ON geometry_columns TO PUBLIC;"
sudo -u postgres psql -d template_postgis -c "GRANT ALL ON geography_columns TO PUBLIC;"
sudo -u postgres psql -d template_postgis -c "GRANT ALL ON spatial_ref_sys TO PUBLIC;"

sudo -u postgres psql -d template_postgis -c "VACUUM FULL;"
sudo -u postgres psql -d template_postgis -c "VACUUM FREEZE;"

sudo -u postgres psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_postgis';"
sudo -u postgres psql -d postgres -c "UPDATE pg_database SET datallowconn='false' WHERE datname='template_postgis';"

# Create "template_routing"
# -------------------------
sudo -u postgres createdb -E UTF8 -T template_postgis template_routing

sudo -u postgres psql --quiet -d template_routing -f $ROUTING_SQL_PATH/routing_core.sql
sudo -u postgres psql --quiet -d template_routing -f $ROUTING_SQL_PATH/routing_core_wrappers.sql
sudo -u postgres psql --quiet -d template_routing -f $ROUTING_SQL_PATH/routing_topology.sql
sudo -u postgres psql --quiet -d template_routing -f $ROUTING_SQL_PATH/routing_tsp.sql
sudo -u postgres psql --quiet -d template_routing -f $ROUTING_SQL_PATH/routing_tsp_wrappers.sql
sudo -u postgres psql --quiet -d template_routing -f $ROUTING_SQL_PATH/routing_dd.sql
sudo -u postgres psql --quiet -d template_routing -f $ROUTING_SQL_PATH/routing_dd_wrappers.sql
sudo -u postgres psql --quiet -d template_routing -f $ROUTING_SQL_PATH/matching.sql

sudo -u postgres psql -d template_routing -c "VACUUM FULL;"
sudo -u postgres psql -d template_routing -c "VACUUM FREEZE;"

sudo -u postgres psql -d postgres -c "UPDATE pg_database SET datistemplate='true' WHERE datname='template_routing';"
sudo -u postgres psql -d postgres -c "UPDATE pg_database SET datallowconn='false' WHERE datname='template_routing';"


