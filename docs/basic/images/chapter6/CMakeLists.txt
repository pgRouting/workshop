
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  ad11.png
  ad7.png
  ad8.png
  detailofroute9.png
  pedestrian-only-roads.png
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

