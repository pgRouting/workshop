set -e

#from-here
osm2pgrouting \
    -f "pune.osm" \
    -c "pune_waterways.xml" \
    --schema "waterways" \
    --prefix "waterways_"  \
    --tags \
    -d mh_waterways\
    -U user \
    -W user \
    --clean
#to-here
