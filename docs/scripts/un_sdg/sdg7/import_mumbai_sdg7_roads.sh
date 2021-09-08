set -e

# from-here
osm2pgrouting \
    -f "mumbai.osm" \
    -c "../roads.xml" \
    --schema "roads" \
    -d mumbai \
    -U user \
    -W user \
    --prefix "roads_" \
#    --addnodes \
    --tags \
    --clean
# to-here
