#!/bin/bash
set -e

# get_pune from-here
CITY="pune"
BBOX="73.8176,18.5035,73.9249,18.5575"
wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"
# get_pune to-here
