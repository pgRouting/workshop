
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  un_17_sdgs.png
  un_logo.jpg
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

