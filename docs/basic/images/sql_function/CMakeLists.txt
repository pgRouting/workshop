
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  route_azimuth.png
  route_names.png
  route_readable.png
  route_final.png
  good_directionality.png
  wrong_directionality.png
)

foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "      -> ${f}")
  endif()
  configure_file(${f} ${f} COPYONLY)
endforeach()
