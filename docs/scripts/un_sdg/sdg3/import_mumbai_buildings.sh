set -e

#from-here
@Osm2pgrouting_EXECUTABLE@ \
    -f "mumbai.osm" \
    -c "buildings.xml" \
    --schema "buildings" \
    --prefix "buildings_"  \
    --tags \
    -d mumbai \
    -U user \
    -W user \
    --clean
#to-here
