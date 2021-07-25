set -e

#4.3.1 from-here
osm2pgrouting \
    -f "mumbai.osm" \
    -c "mumbai_buildings.xml" \
    -d mumbai \
    -U user \
    -W user \
    --clean
#4.3.1 to-here
