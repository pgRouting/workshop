set -e
echo "Processing create_mumbai"
rm -f database_created.txt
dropdb --if-exists mumbai

# create_mumbai from-here

# Create the database
createdb mumbai

# login as user "user"
psql mumbai << EOF

-- add PostGIS functions
CREATE EXTENSION postgis;

-- add pgRouting functions
CREATE EXTENSION pgrouting;


EOF

# create_mumbai to-here



echo "End create_mumbai"
