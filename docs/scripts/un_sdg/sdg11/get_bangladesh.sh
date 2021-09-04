#!/bin/bash
set -e

# get_bangladesh from-here
CITY="bangladesh"
BBOX="88.9515,22.2192,89.3806,22.4310"
wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"
# get_bangladesh to-here
