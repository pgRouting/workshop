set -e

#from-here
osm2pgrouting \
    -f "pune.osm" \
    -c "pune_buildings.xml" \
    --schema "buildings" \
    --prefix "buildings_"  \
    --tags \
    -d pune \
    -U user \
    -W user \
    --clean
#to-here
