
#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_IMG_SUBDIRS
   Entry_points_of_proposed_locations.png
   remove_disconnected_roads.png
   roads_and_buildings.png
   un_17_sdgs.png
   un_logo.jpg
   un_sdg11.png
   un_sdg3.png
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
