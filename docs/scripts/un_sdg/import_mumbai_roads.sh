set -e

# from-here
osm2pgrouting \
    -f "mumbai.osm" \
    -c "mumbai_roads.xml" \
    --schema "roads" \
    -d mumbai \
    -U user \
    -W user \
    --prefix "roads_" \
    --clean
# to-here
