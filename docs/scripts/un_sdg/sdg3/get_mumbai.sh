#!/bin/bash
set -e

# This is for getting the mumbai data directly using the overpass API
# The results of using this download will affect the results on the workshop
# prefer using the download from OSGeo
# get_mumbai from-here
CITY="mumbai"
BBOX="72.8263,19.1021,72.8379,19.1166"
wget --progress=dot:mega -O "$CITY.osm" "http://www.overpass-api.de/api/xapi?*[bbox=${BBOX}][@meta]"
# get_mumbai to-here
