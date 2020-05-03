set -e
rm -f database_created.txt
dropdb --if-exists __workshop__
createdb __workshop__
touch database_created.txt
