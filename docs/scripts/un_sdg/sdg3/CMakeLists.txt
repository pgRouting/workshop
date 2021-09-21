

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  create_mumbai.sh
  get_mumbai_data.sh
  import_mumbai_roads.sh
  import_mumbai_buildings.sh

  # TODO these files need to be processed
  all_exercises_sdg3.sql

  # works but does not need to be processed
  get_mumbai.sh

  # TODO these files need to be generated
  Exercise_5.txt
  Exercise_6.txt
  Exercise_7.txt
  Exercise_8.txt
  Exercise_9.txt
  Exercise_10.txt
  Exercise_11.txt
  Exercise_12.txt
  Exercise_13.txt
  Exercise_15.txt
  Exercise_16.txt
  Exercise_17.txt
  Exercise_18.txt
  Exercise_19.txt
  Exercise_20.txt
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

if (NOT EXISTS mumbai.osm)
execute_process(
  OUTPUT_FILE mumbai.osm
  COMMAND bash get_mumbai_data.sh
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE get_mumbai_data.sh
  )
endif()


execute_process(
  OUTPUT_FILE created_mumbai.txt
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/create_mumbai.sh > created_mumbai.txt
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/create_mumbai.sh
  )

execute_process(
  OUTPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/import_mumbai_buildings.txt
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/import_mumbai_buildings.sh > ${CMAKE_CURRENT_BINARY_DIR}/import_mumbai_buildings.txt
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/import_mumbai_buildings.sh
  )

execute_process(
  OUTPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/import_mumbai_roads.txt
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/import_mumbai_roads.sh > ${CMAKE_CURRENT_BINARY_DIR}/import_mumbai_roads.txt
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/import_mumbai_roads.sh
  )
