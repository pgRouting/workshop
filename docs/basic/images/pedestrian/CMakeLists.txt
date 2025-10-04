
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  pedestrian_combinations.png
  pedestrian_dijkstracost.png
  pedestrian_many_to_many.png
  pedestrian_one_to_many.png
  pedestrian_one_to_one.png
)


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

