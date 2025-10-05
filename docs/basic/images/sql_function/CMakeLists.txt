
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  sql_azimuth_fixed.png
  sql_route_geom.png
  sql_route_names.png
  sql_route_readable.png
  sql_route_geom_detail.png
)


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "      -> ${f}")
  endif()
  configure_file(${f} ${f} COPYONLY)
endforeach()
