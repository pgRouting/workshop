set -e

# 4.2.1 from-here
# Create a @PGR_WORKSHOP_DOWNLOAD_DIR@ directory on the Desktop
mkdir -p ~/Desktop/@PGR_WORKSHOP_DOWNLOAD_DIR@

# Go to the directory
cd ~/Desktop/@PGR_WORKSHOP_DOWNLOAD_DIR@
# 4.2.1 to-here

if [ ! -f "@PGR_WORKSHOP_CITY_FILE@.osm" ]; then

# 4.2.2 from-here
  CITY="@PGR_WORKSHOP_CITY_FILE@"
  wget -N --progress=dot:mega \
    "http://download.osgeo.org/livedvd/data/osm/$CITY/$CITY.osm.bz2"
  bunzip2 -f $CITY.osm.bz2
# 4.2.2 to-here

fi

