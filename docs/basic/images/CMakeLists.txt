
#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_IMG_SUBDIRS
  data
  pedestrian
  vehicle
  chapter7
  chapter8
  )



#---------------------------------------------
# Adding the documentation subdirectories & files
#---------------------------------------------

foreach (dir ${PGR_WORKSHOP_IMG_SUBDIRS})
  file(COPY "${dir}" DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
  if (PGR_WORKSHOP_DEBUG)
    message(STATUS "   Adding images directory ${dir}")
  endif()
endforeach()
