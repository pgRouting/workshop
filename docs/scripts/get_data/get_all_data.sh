#!/bin/bash
set -e

# 4.2.2 from-here
CITY="@PGR_WORKSHOP_CITY_FILE@"
wget -N --progress=dot:mega "https://download.osgeo.org/livedvd/17/osm/@PGR_WORKSHOP_CITY_FILE@.osm.bz2"
bunzip2 -f "@PGR_WORKSHOP_CITY_FILE@.osm.bz2"
# 4.2.2 to-here

# mumbai data from-here
wget -N --progress=dot:mega "https://download.osgeo.org/pgrouting/workshops/mumbai.osm.bz2"
bunzip2 -f "mumbai.osm.bz2"
# mumbai data to-here

# bangladesh data from-here
wget -N --progress=dot:mega "https://download.osgeo.org/pgrouting/workshops/bangladesh.osm.bz2"
bunzip2 -f "bangladesh.osm.bz2"
# bangladesh data to-here
