add_custom_target(un_sdg11_scripts)

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  get_bangladesh.sh
  get_bangladesh_data.sh
  create_bangladesh.sh
  import_bangladesh_waterways.sh
  all_exercises_sdg11.sql
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

if (NOT EXISTS bangladesh.osm)
execute_process(
  OUTPUT_FILE bangladesh.osm
  COMMAND bash get_bangladesh_data.sh
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE get_bangladesh_data.sh
  )
endif()

execute_process(
  OUTPUT_FILE created_bangladesh.txt
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/create_bangladesh.sh > created_bangladesh.txt
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/create_bangladesh.sh
  )

execute_process(
  OUTPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/import_bangladesh_waterways.txt
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/import_bangladesh_waterways.sh > ${CMAKE_CURRENT_BINARY_DIR}/import_bangladesh_waterways.txt
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/import_bangladesh_waterways.sh
  )

add_custom_command(
  TARGET un_sdg11_scripts
  PRE_BUILD
  BYPRODUCTS
    exercise_1.txt
    exercise_2.txt
    exercise_3.txt
    exercise_4.txt
    exercise_5.txt
    exercise_6.txt
    exercise_7.txt
    exercise_8.txt
    exercise_9.txt
    exercise_10.txt
  COMMAND psql -d bangladesh -f all_exercises_sdg11.sql
  COMMENT "running sdg11 scripts"
  DEPENDS all_exercises_sdg11.sql
  )
