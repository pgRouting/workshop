#!/bin/bash
set -e

# 4.2.2 from-here
CITY="@PGR_WORKSHOP_CITY_FILE@"
wget -N --progress=dot:mega "https://download.osgeo.org/livedvd/16/osm/$CITY.osm.bz2"

bunzip2 -f "$CITY.osm.bz2"
# 4.2.2 to-here

echo "${CITY}"
# mumbai data from-here
CITY="mumbai"
wget -N --progress=dot:mega "https://download.osgeo.org/pgrouting/workshops/$CITY.osm.bz2"
bunzip2 -f "$CITY.osm.bz2"
# mumbai data to-here

echo "${CITY}"
# bangladesh data from-here
CITY="bangladesh"
wget -N --progress=dot:mega "https://download.osgeo.org/pgrouting/workshops/$CITY.osm.bz2"
bunzip2 -f "$CITY.osm.bz2"
# bangladesh data to-here
echo "${CITY}"
