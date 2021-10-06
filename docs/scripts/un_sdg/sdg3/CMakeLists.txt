add_custom_target(un_sdg3_scripts)

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  create_mumbai.sh
  get_mumbai_data.sh
  import_mumbai_roads.sh
  import_mumbai_buildings.sh
  all_exercises_sdg3.sql
)


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

add_custom_command(
  TARGET un_sdg3_scripts
  PRE_BUILD
  BYPRODUCTS
    exercise_5.txt
    exercise_6.txt
    exercise_7.txt
    exercise_8.txt
    exercise_9.txt
    exercise_10.txt
    exercise_11.txt
    exercise_12.txt
    exercise_13.txt
    exercise_14.txt
    exercise_15.txt
    exercise_16.txt
    exercise_17.txt
    exercise_18.txt
    exercise_19.txt
    exercise_20.txt
  COMMAND psql -d mumbai -f all_exercises_sdg3.sql
  COMMENT "running chapter sdg3 scripts"
  DEPENDS all_exercises_sdg3.sql
  )

