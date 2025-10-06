
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  points_on_map.png
  points_routing.png
)


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "      -> ${f}")
  endif()
  configure_file(${f} ${f} COPYONLY)
endforeach()
