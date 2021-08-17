
add_custom_target(basic ALL)
add_dependencies(basic scripts)

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  chapter-4.rst
  chapter-5.rst
  chapter-6.rst
  chapter-7.rst
  chapter-8.rst
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

