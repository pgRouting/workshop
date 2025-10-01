
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

#---------------------------------------------
# Adding the documentation subdirectories & files
#---------------------------------------------

foreach (dir ${PGR_WORKSHOP_IMG_SUBDIRS})
  if (PGR_WORKSHOP_DEBUG)
    message(STATUS "   -> basic/images/${dir}")
  endif()
  add_subdirectory("${dir}")
  if (PGR_WORKSHOP_DEBUG)
    message(STATUS "   <- basic/images/${dir}")
  endif()
endforeach()
