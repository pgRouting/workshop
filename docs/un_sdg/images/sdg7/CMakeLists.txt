
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  un_sdg7.png
  sdg7_output.png
)


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "      -> ${f}")
  endif()
  configure_file(${f} ${f} COPYONLY)
endforeach()
