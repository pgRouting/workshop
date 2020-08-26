

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "osmid_configuration.sql"
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

#----------------------------------------------
# 5.1.1 Exercise 1 - Single pedestrian routing.
#---------------------------------------------

execute_process(
  OUTPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/osmid_configuration.txt
  COMMAND psql -d city_routing -f ${CMAKE_CURRENT_BINARY_DIR}/osmid_configuration.sql
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/osmid_configuration.sql
  )

add_custom_target(configuration_scripts)
