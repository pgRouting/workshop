set -e
echo "Processing create_mh"

dropdb --if-exists mh_waterways

# create_mh_waterways from-here

# Create the database
createdb mh_waterways

# login as user "user"
psql mh_waterways << EOF


-- add PostGIS functions
CREATE EXTENSION postgis;

-- add pgRouting functions
CREATE EXTENSION pgrouting;

-- creating schemas for data
CREATE SCHEMA waterways;
CREATE EXTENSION hstore;


EOF

# create_mh_waterways to-here



echo "End create_mh_waterways"
