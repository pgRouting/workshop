set -e
rm -f database_created.txt
dropdb --if-exists city_routing

# 4.1.1 from-here

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

# 4.1.1 to-here

psql -c 'DROP ROLE IF EXISTS "user"; CREATE ROLE "user" SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN PASSWORD $$user$$;' -d city_routing


