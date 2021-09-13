

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  # TODO these files need to be processed
  all_exercises_sdg11.sql
  create_bangladesh.sh
  get_bangladesh.sh
  import_bangladesh_waterways.sh

  # TODO these files need to be generated
  import_bangladesh_waterways.txt 
  count_waterways.txt
  creating_buffers.txt
  setting_search_path.txt
  connected_components.txt
  creating_buffers_city.txt
  Intersecting_components.txt
  import_bangladesh_waterways.txt
  creating_rain_zones_buffers_waterways.txt
    )


add_custom_target(un_sdg11_scripts)
#---------------------------------------------
# Adding the documentation files
#---------------------------------------------

foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

