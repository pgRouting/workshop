#!/bin/bash
set -e

# 4.2.2 from-here
CITY="@PGR_WORKSHOP_CITY_FILE@"
wget -N --progress=dot:mega \
"http://download.osgeo.org/livedvd/14/osm/$CITY.osm.bz2"
bunzip2 -f "$CITY.osm.bz2"
# 4.2.2 to-here

