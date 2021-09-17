

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  # TODO these files need to be processed
  create_mumbai.sh
  get_mumbai.sh
  import_mumbai_roads.sh
  import_mumbai_buildings.sh
  all_exercises_sdg3.sql

  # TODO these files need to be generated
  import_mumbai_roads.txt
  import_mumbai_buildings.txt
  total_population.txt
  count_roads_and_buildings.txt
  preprocessing_buildings.txt
  discard_disconnected_roads.txt
  nearest_vertex.txt
  service_area.txt
  correct_service_area.txt
  buildings_population_calculation.txt
  population_residing_along_the_road.txt
    )


add_custom_target(un_sdg3_scripts)
#---------------------------------------------
# Adding the documentation files
#---------------------------------------------

foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

