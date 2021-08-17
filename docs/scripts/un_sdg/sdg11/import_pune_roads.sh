set -e

# from-here
osm2pgrouting \
    -f "pune.osm" \
    -c "../roads.xml" \
    --schema "roads" \
    -d pune \
    -U user \
    -W user \
    --prefix "roads_" \
    --addnodes \
    --tags \
    --clean
# to-here
