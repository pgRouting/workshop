
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  costMatrix.png
  pedestrian_only_roads.png
  roads_tag_ids.png
  taxi_net.png
  vehicle_net.png
  walk_net.png
)


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "      -> ${f}")
  endif()
  configure_file(${f} ${f} COPYONLY)
endforeach()
