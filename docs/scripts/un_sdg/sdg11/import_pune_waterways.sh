set -e

#from-here
osm2pgrouting \
    -f "pune.osm" \
    -c "pune_waterways.xml" \
    --schema "waterways" \
    --prefix "waterways_"  \
    --tags \
    -d pune\
    -U user \
    -W user \
    --clean
#to-here
