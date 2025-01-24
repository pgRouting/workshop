
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  pedestrian_combinations.png
  pedestrian_route1.png
  pedestrian_route2.png
  pedestrian_route4.png
  pedestrian_route5.png
  route.png
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

