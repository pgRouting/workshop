
add_custom_target(basic ALL)
add_dependencies(basic scripts)

#---------------------
# Files order is important
#---------------------
set(PGR_WORKSHOP_FILES
  data.rst
  pedestrian.rst
  vehicle.rst
  graphs.rst
  sql_function.rst
  plpgsql_function.rst
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
