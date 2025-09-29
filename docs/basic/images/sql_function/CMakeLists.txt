
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  ch7-e4.png
  ch7-e5.png
  ch7-e6.png
  ch7-e7.png
  ch7-e8-1.png
  ch7-e8.png
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

