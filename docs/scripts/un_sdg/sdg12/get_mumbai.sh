#!/bin/bash
set -e

# get_mumbai from-here
CITY="mumbai"
BBOX="72.8263,19.1021,72.8379,19.1166"
wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"
# get_mumbai to-here
