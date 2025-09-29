
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  ch7-e3.png
  vehicle_net.png
  walk_net.png
  taxi_net.png
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

