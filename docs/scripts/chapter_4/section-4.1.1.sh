set -e
echo "Processing 4.1.1"
rm -f database_created.txt
dropdb --if-exists city_routing

psql -c 'DROP ROLE IF EXISTS "user"; CREATE ROLE "user" SUPERUSER CREATEDB CREATEROLE INHERIT LOGIN PASSWORD $$user$$;' -d template1

# 4.1.1 from-here

# Create the database
createdb -U user city_routing

# login as user "user"
psql -U user city_routing << EOF

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



echo "End 4.1.1"
