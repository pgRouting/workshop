#!/bin/bash
set -e

# get_sdg11 from-here
CITY="sdg11"
BBOX="88.9515,22.2192,89.3806,22.4310"
wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"
# get_sdg11 to-here
