set -e

#4.3.1 from-here
@Osm2pgrouting_EXECUTABLE@ \
    -f "@PGR_WORKSHOP_CITY_FILE@.osm" \
    -c "@Osm2pgrouting_mapconfig@" \
    -d city_routing \
    -U user \
    -W user \
    --clean
#4.3.1 to-here
