set -e
echo "Processing create_sdg11"

dropdb --if-exists sdg11

# create_sdg11 from-here

# Create the database
createdb sdg11

# login as user "user"
psql sdg11 << EOF


-- add PostGIS functions
CREATE EXTENSION postgis;

-- add pgRouting functions
CREATE EXTENSION pgrouting;
CREATE EXTENSION hstore;
-- creating schemas for data
CREATE SCHEMA waterways;
# CREATE SCHEMA city;


EOF

# create_sdg11 to-here



echo "End create_sdg11"
