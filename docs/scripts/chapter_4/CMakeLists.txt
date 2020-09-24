

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "section-4.1.1.sh"
  "section-4.2.2.sh"
  "section-4.3.1.sh"
  "section-4.3.2.sh"
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
# 4.1 Creating the database
#---------------------------------------------

message(STATUS "chapter 4 1")
execute_process(
  OUTPUT_FILE created_database.txt
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/section-4.1.1.sh > created_database.txt
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/section-4.1.1.sh
  )

message(STATUS "chapter 4 2")
#----------------------------------------------
# 4.2 Download and unzipping the data
#---------------------------------------------

if (NOT EXISTS ${CMAKE_CURRENT_BINARY_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm)
execute_process(
  OUTPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/section-4.2.2.sh
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE  ${CMAKE_CURRENT_BINARY_DIR}/section-4.2.2.sh
  )
endif()

message(STATUS "chapter 4 3")
#----------------------------------------------
# 4.3.1 Run osm2pgrouting converter
#---------------------------------------------

execute_process(
  OUTPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/section-4.3.1.txt
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/section-4.3.1.sh > ${CMAKE_CURRENT_BINARY_DIR}/section-4.3.1.txt
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/section-4.3.1.sh
  )

message(STATUS "chapter 4 4")
#----------------------------------------------
# 4.3.2 generated tables
#---------------------------------------------

add_custom_command(
  OUTPUT section-4.3.2.txt
  COMMAND bash section-4.3.2.sh > section-4.3.2.txt
  DEPENDS section-4.3.2.sh
  )

message(STATUS "chapter 4 5")
add_custom_target(chapter_4_scripts
  DEPENDS "section-4.3.2.txt"
  )
