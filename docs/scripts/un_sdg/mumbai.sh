#!/bin/bash
set -e

# from-here
CITY="mumbai"
BBOX="72.8263,19.1021,73.8379,20.1166"

wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"
# to-here
