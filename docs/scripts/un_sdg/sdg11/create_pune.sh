set -e
echo "Processing create_mh"

dropdb --if-exists pune

# create_pune from-here

# Create the database
createdb pune

# login as user "user"
psql pune << EOF


-- add PostGIS functions
CREATE EXTENSION postgis;

-- add pgRouting functions
CREATE EXTENSION pgrouting;

-- creating schemas for data
CREATE SCHEMA waterways;
CREATE SCHEMA roads;
CREATE SCHEMA buildings;
CREATE EXTENSION hstore;


EOF

# create_pune to-here



echo "End create_mh_waterways"
