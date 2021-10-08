
add_custom_target(un_sdg ALL)
add_dependencies(un_sdg scripts)

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  introduction.rst
  data.rst
  sdg3-health.rst
  sdg7-energy.rst
  sdg11-cities.rst
  appendix.rst
  )


set(PGR_WORKSHOP_SUBDIRS
  images
  )

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
