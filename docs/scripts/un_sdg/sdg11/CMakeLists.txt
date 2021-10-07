

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  # TODO these files need to be processed
  all_exercises_sdg11.sql
  create_bangladesh.sh
  get_bangladesh.sh
  get_bangladesh_data.sh
  import_bangladesh_waterways.sh

  # TODO these files need to be generated
  import_bangladesh_waterways.txt
  Exercise_1.txt
  Exercise_6.txt
  Exercise_7.txt
  Exercise_8.txt
  Exercise_9.txt
  Exercise_10.txt
  Exercise_11.txt
  Exercise_12.txt
  Exercise_13.txt
  Exercise_14.txt
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

if (NOT EXISTS bangladesh.osm)
execute_process(
  OUTPUT_FILE bangladesh.osm
  COMMAND bash get_bangladesh_data.sh
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE get_bangladesh_data.sh
  )
endif()
