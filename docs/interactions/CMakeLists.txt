
add_custom_target(interactions ALL)

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  chapter-9.rst
  chapter-10.rst
  chapter-11.rst
  )


#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_SUBDIRS
  code
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

