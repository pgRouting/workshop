
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  un_sdg3.png
  remove_disconnected_roads.png
  roads_and_buildings.png
  finding_closest_vertex.png
  service_area.png
  generalised_service_area.png
  road_population.png
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

