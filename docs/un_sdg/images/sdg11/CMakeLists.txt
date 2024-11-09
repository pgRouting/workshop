
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  un_sdg11.png
  sdg11_output.png
  remove_waterways.png
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

