
add_custom_target(general-intro ALL)

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  chapter-1.rst
  chapter-2.rst
  chapter-3.rst
  )


set(PGR_WORKSHOP_SUBDIRS
  images
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

