set -e

#4.3.1 from-here
@OSM2PGROUTING_EXECUTABLE@ \
    -f "@PGR_WORKSHOP_CITY_FILE@.osm" \
    -c "@MAPCONFIG@" \
    -d city_routing \
    -U user \
    -W user \
    --clean
#4.3.1 to-here
