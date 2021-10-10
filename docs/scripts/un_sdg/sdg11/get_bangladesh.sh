#!/bin/bash
set -e

# get_bangladesh from-here
CITY="bangladesh"
BBOX="88.9515,22.2192,89.3806,22.4310"
wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"

osmconvert --drop-author --drop-version bangladesh.osm -o=bangladesh_pass1.osm
osmfilter bangladesh_pass1.osm -o=bangladesh.osm --drop="highway= building="
# get_bangladesh to-here
