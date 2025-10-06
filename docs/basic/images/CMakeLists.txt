
#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_IMG_SUBDIRS
  data
  pedestrian
  vehicle
  graphs
  sql_function
  plpgsql_function
)

foreach (dir ${PGR_WORKSHOP_IMG_SUBDIRS})
  if (PGR_WORKSHOP_DEBUG)
    message(STATUS "   -> ${CMAKE_CURRENT_SOURCE_DIR}/${dir}")
  endif()
  add_subdirectory("${dir}")
  if (PGR_WORKSHOP_DEBUG)
    message(STATUS "   <- ${CMAKE_CURRENT_SOURCE_DIR}/${dir}")
  endif()
endforeach()
