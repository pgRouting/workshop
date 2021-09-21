#!/bin/bash
set -e

# mumbai data from-here
CITY="mumbai"
wget -N --progress=dot:mega \
"https://workshop.pgrouting.org/data/mumbai.osm.bz2"
bunzip2 -f "$CITY.osm.bz2"
# mumbai data to-here
