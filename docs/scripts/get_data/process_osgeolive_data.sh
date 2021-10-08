set -e

dropdb --if-exists city_routing
dropdb --if-exists bangladesh
dropdb --if-exists mumbai

echo  4.1.1 from-here

# Create the database
createdb city_routing

# login as user "user"
psql city_routing << EOF

-- add PostGIS functions
CREATE EXTENSION postgis;

-- add pgRouting functions
CREATE EXTENSION pgrouting;

-- Inspect the pgRouting installation
\dx+ pgrouting

-- View pgRouting version
SELECT pgr_version();

EOF

echo  4.1.1 to-here

psql -c 'DROP ROLE IF EXISTS "user"; CREATE ROLE "user" SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN PASSWORD $$user$$;' -d city_routing

echo 4.3.1 from-here
@Osm2pgrouting_EXECUTABLE@ \
    -f "@PGR_WORKSHOP_CITY_FILE@.osm" \
    -c "@Osm2pgrouting_mapconfig@" \
    -d city_routing \
    -U user \
    -W user \
    --clean
echo 4.3.1 to-here

