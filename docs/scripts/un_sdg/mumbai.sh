#!/bin/bash
set -e

# from-here
CITY="mumbai"
BBOX="19.1021,72.8263,19.1166,72.8379"

wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"
# to-here
