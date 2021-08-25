set -e

# from-here
osm2pgrouting \
    -f "sdg11.osm" \
    -c "../waterways.xml" \
    --schema "waterways" \
    --prefix "waterways_"  \
    --tags \
    -d sdg11 \
    -U user \
    -W user \
    --clean
# to-here
