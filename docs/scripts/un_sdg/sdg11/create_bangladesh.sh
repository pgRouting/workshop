set -e
echo "Processing create_bangladesh"

dropdb --if-exists bangladesh

# create_bangladesh from-here

# Create the database
createdb bangladesh

# login as user "user"
psql bangladesh << EOF


-- add PostGIS functions
CREATE EXTENSION postgis;

-- add pgRouting functions
CREATE EXTENSION pgrouting;
CREATE EXTENSION hstore;
-- creating schemas for data
CREATE SCHEMA waterways;


EOF

# create_bangladesh to-here



echo "End create_bangladesh"
