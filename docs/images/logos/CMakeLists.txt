
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  Linux-Foundation-OG-Image.png
  OCF-logo.png
  osgeo.png
  osm_logo.png
  osm2pgrouting.png
  osm2pgrouting.png
  pgrouting.png
  paragon.png
  erosion.png
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "      -> ${f}")
  endif()
  configure_file(${f} ${f} COPYONLY)
endforeach()
