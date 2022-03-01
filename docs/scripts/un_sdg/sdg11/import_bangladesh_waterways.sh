set -e

# from-here
osm2pgrouting \
    -f "bangladesh.osm" \
    -c "waterways.xml" \
    --schema "waterways" \
    --prefix "waterways_"  \
    --tags \
    -d bangladesh \
    -U user \
    -W user \
    --clean
# to-here
