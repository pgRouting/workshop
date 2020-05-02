
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
osgeo.png
pgrouting.png
osm2pgrouting.png
georepublic.png
paragon.png
osm_logo.png
license.png

route.png

ad7.png
ad8.png
  ad10.png
ad11.png

downloadOSGeoLive.png
install-disk.png
install-final.png
install-general.png
install-memory.png
install-name.png
install-vm.png
install-welcome.png

pedestrian-route1.png
pedestrian-route2.png
pedestrian-route4.png
pedestrian-route5.png

network.png
pedestrian-only-roads.png
prepareData.png
detailofroute9.png

hanosiav_example.png
  )

set (BAR
imaptools-small.gif
ad9.png
camptocamp.png
car-route1.png
car-route2.png
car-route3.png
detailofroute.png
openlayers_logo.png
wrapper1.png
wrapper2.png
wrapper3.png
    )


#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_IMG_SUBDIRS
    "chapter7"
    "chapter9"
    "chap_QGIS"
    )



#---------------------------------------------
# Adding the documentation subdirectories & files
#---------------------------------------------

foreach (dir ${PGR_WORKSHOP_IMG_SUBDIRS})
    file(COPY "${dir}" DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
    if (PGR_WORKSHOP_DEBUG)
        message(STATUS "   Adding images directory ${dir}")
    endif()
endforeach()

foreach (f ${PGR_WORKSHOP_IMG_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

