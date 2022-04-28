#!/bin/bash
set -e

# mumbai data from-here
CITY="bangladesh"
wget -N --progress=dot:mega \
  "https://upload.osgeo.org/pgrouting/workshops/$CITY.osm.bz2"
bunzip2 -f "$CITY.osm.bz2"
# mumbai data to-here
