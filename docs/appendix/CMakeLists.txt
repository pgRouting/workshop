
add_custom_target(appendix ALL)

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  appendix-2.rst
  appendix-3.rst
  appendix-4.rst
  )


set(PGR_WORKSHOP_SUBDIRS
  code
  )



#---------------------------------------------
# Adding the documentation subdirectories & files
#---------------------------------------------

foreach (dir ${PGR_WORKSHOP_SUBDIRS})
  if (PGR_WORKSHOP_DEBUG)
    message(STATUS "   Adding directory ${dir}")
  endif()
  add_subdirectory(${dir})
endforeach()

foreach (f ${PGR_WORKSHOP_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  configure_file(${f} ${f})
endforeach()

