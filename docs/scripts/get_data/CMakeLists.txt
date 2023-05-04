#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  get_all_data.sh
  process_osgeolive_data.sh
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
    if ( NOT EXISTS ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/bangladesh.osm)
  message(FATAL_ERROR "Data not found: Failed to get bangladesh data")
endif()

configure_file(${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm ${PGR_WORKSHOP_CITY_FILE}.osm)
configure_file(${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/mumbai.osm ${CMAKE_CURRENT_BINARY_DIR}/../un_sdg/sdg3/mumbai.osm)
configure_file(${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_DOWNLOAD_DIR}/bangladesh.osm ${CMAKE_CURRENT_BINARY_DIR}/../un_sdg/sdg11/bangladesh.osm)

execute_process(
  OUTPUT_FILE process_osgeolive_data.txt
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/process_osgeolive_data.sh > processes_osgeolive_data.txt
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/process_osgeolive_data.sh
  )
