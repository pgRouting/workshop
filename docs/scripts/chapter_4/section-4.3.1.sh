set -e

#4.3.1 from-here
cd ~/Desktop/@PGR_WORKSHOP_DOWNLOAD_DIR@
@OSM2PGROUTING_EXECUTABLE@ \
    -f "@PGR_WORKSHOP_CITY_FILE@.osm" \
    -c "@MAPCONFIG@" \
    -d city_routing \
    -U user \
    --clean
#4.3.1 to-here
