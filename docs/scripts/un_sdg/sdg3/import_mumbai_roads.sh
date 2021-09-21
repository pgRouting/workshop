set -e

# from-here
@Osm2pgrouting_EXECUTABLE@ \
    -f "mumbai.osm" \
    -c "@Osm2pgrouting_mapconfig@" \
    --schema "roads" \
    -d mumbai \
    -U user \
    -W user \
    --prefix "roads_" \
    --tags \
    --clean
# to-here
