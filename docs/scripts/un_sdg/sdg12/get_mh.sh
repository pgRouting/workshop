#!/bin/bash
set -e

# get_mumbai from-here
CITY="mumbai"
BBOX="73.521,17.688,744444444444444444444444444444444444444444444.662,18.570"
wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"
# get_mumbai to-here
