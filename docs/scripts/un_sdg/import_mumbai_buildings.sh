set -e

#from-here
osm2pgrouting \
    -f "mumbai.osm" \
    -c "mumbai_buildings.xml" \
    --schema "buildings" \
    --prefix "buildings_"  \
    --tags \
    -d mumbai \
    -U user \
    -W user \
    --clean
#to-here
