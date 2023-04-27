add_custom_target(general-intro ALL)

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  introduction.rst
  overview.rst
  osgeolive.rst
  )

#---------------------------------------------
# Adding the documentation subdirectories & files
#---------------------------------------------
foreach (f ${PGR_WORKSHOP_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  configure_file(${f} ${f})
endforeach()

