#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  buildings.xml
  waterways.xml

  osm2pgrouting_compat.sql
  osm2pgrouting_compat_bangladesh.sql
  osm2pgrouting_compat_mumbai.sql

  get_all_data.sh
  setup_city_routing.sh
  setup_bangladesh.sh
  setup_mumbai.sh
)


foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f} @ONLY)
endforeach()

#----------------------------------------------
# Download
#---------------------------------------------

if (NOT EXISTS ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR})
  execute_process(
    COMMAND mkdir -p ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}
    COMMAND_ECHO STDOUT
    )
endif()

if (NOT EXISTS ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm
    OR NOT EXISTS ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/mumbai.osm
    OR NOT EXISTS ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/bangladesh.osm)
  message(STATUS "Data not found: Getting data")
  execute_process(
    OUTPUT_FILE ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm
    COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/get_all_data.sh
    WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}
    INPUT_FILE  ${CMAKE_CURRENT_BINARY_DIR}/get_all_data.sh
    )
endif()

if (NOT EXISTS ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm)
  message(FATAL_ERROR "Data not found: Failed to get ${PGR_WORKSHOP_CITY_FILE} data")
endif()

if (NOT EXISTS ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/mumbai.osm)
  message(FATAL_ERROR "Data not found: Failed to get mumbai data")
endif()

if (NOT EXISTS ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/bangladesh.osm)
  message(FATAL_ERROR "Data not found: Failed to get bangladesh data")
endif()

configure_file(${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm ${PGR_WORKSHOP_CITY_FILE}.osm)
configure_file(${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/mumbai.osm mumbai.osm)
configure_file(${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/bangladesh.osm bangladesh.osm)

# execute_process(
#   OUTPUT_FILE setup_city_routing.txt
#   COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/setup_city_routing.sh > setup_city_routing.txt
#   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
#   INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/setup_city_routing.sh
#   )

# if (Osm2pgrouting_VERSION VERSION_LESS "3.0.0")
#   execute_process(
#     COMMAND psql -d city_routing
#       -f ${CMAKE_CURRENT_BINARY_DIR}/osm2pgrouting_compat.sql
#     WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
#   )
# endif()

# execute_process(
#   OUTPUT_FILE setup_mumbai.txt
#   COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/setup_mumbai.sh > setup_mumbai.txt
#   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
#   INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/setup_mumbai.sh
#   )

# if (Osm2pgrouting_VERSION VERSION_LESS "3.0.0")
#   execute_process(
#     COMMAND psql -d mumbai
#       -f ${CMAKE_CURRENT_BINARY_DIR}/osm2pgrouting_compat_mumbai.sql
#     WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
#   )
# endif()

# execute_process(
#   OUTPUT_FILE setup_bangladesh.txt
#   COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/setup_bangladesh.sh > setup_bangladesh.txt
#   WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
#   INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/setup_bangladesh.sh
#   )

# if (Osm2pgrouting_VERSION VERSION_LESS "3.0.0")
#   execute_process(
#     COMMAND psql -d bangladesh
#       -f ${CMAKE_CURRENT_BINARY_DIR}/osm2pgrouting_compat_bangladesh.sql
#     WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
#   )
# endif()
