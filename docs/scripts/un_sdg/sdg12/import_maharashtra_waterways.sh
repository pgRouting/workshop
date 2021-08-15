set -e

#from-here
osm2pgrouting \
    -f "maharashtra.osm" \
    -c "maharashtra_waterways.xml" \
    --schema "waterways" \
    --prefix "waterways_"  \
    --tags \
    -d mh_waterways\
    -U user \
    -W user \
    --clean
#to-here
