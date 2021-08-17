
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  pedestrian-route1.png
  pedestrian-route2.png
  pedestrian-route4.png
  pedestrian-route5.png
  route.png
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

