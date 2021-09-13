set -e
echo "Processing create_mumbai"
dropdb --if-exists mumbai

# create_mumbai from-here
# Create the database
createdb mumbai

# login as user "user"
psql mumbai << EOF

-- Commands inside the database
-- add PostGIS extension
CREATE EXTENSION postgis;

-- add pgRouting extension
CREATE EXTENSION pgrouting;

-- creating schemas for data
CREATE SCHEMA roads;
CREATE SCHEMA buildings;
CREATE EXTENSION hstore;
-- create_mumbai to-here
EOF





echo "End create_mumbai"
