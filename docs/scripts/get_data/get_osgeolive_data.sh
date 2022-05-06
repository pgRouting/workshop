#!/bin/bash
set -e

# 4.2.2 from-here
# TODO Use the /15/osm  instead of data/osm/FIRENZE_IT
CITY="@PGR_WORKSHOP_CITY_FILE@"
wget -N --progress=dot:mega \
"http://download.osgeo.org/livedvd/data/osm/FIRENZE_IT/$CITY.osm.bz2"
bunzip2 -f "$CITY.osm.bz2"
# 4.2.2 to-here

