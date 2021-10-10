set -e
echo "Processing create_bangladesh"

dropdb --if-exists bangladesh

# create_bangladesh from-here
# Create the database
createdb bangladesh

# login as user "user"
psql bangladesh << EOF

-- Commands inside the database
-- add PostGIS extension
CREATE EXTENSION postgis;

-- add pgRouting extension
CREATE EXTENSION pgrouting;
CREATE EXTENSION hstore;
-- creating schemas for data
CREATE SCHEMA waterways;
-- create_bangladesh to-here

EOF



echo "End create_bangladesh"
