#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  get_bangladesh_data.sh
  get_mumbai_data.sh
  get_osgeolive_data.sh  
  process_osgeolive_data.sh
)


foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

#----------------------------------------------
# Download
#---------------------------------------------

if (NOT EXISTS ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_CITY_FILE}.osm)
execute_process(
  OUTPUT_FILE ${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_CITY_FILE}.osm
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/get_osgeolive_data.sh
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/downloads
  INPUT_FILE  ${CMAKE_CURRENT_BINARY_DIR}/get_osgeolive_data.sh
  )
endif()
configure_file(${CMAKE_SOURCE_DIR}/downloads/${PGR_WORKSHOP_CITY_FILE}.osm ${PGR_WORKSHOP_CITY_FILE}.osm)

if (NOT EXISTS ${CMAKE_SOURCE_DIR}/downloads/mumbai.osm)
execute_process(
  OUTPUT_FILE ${CMAKE_SOURCE_DIR}/downloads/mumbai.osm
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/get_mumbai_data.sh
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/downloads/
  INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/get_mumbai_data.sh
  )
endif()
configure_file(${CMAKE_SOURCE_DIR}/downloads/mumbai.osm ${CMAKE_CURRENT_BINARY_DIR}/../un_sdg/sdg3/mumbai.osm)

if (NOT EXISTS ${CMAKE_SOURCE_DIR}/downloads/bangladesh.osm)
execute_process(
  OUTPUT_FILE ${CMAKE_SOURCE_DIR}/downloads/bangladesh.osm
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/get_bangladesh_data.sh
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}/downloads
  INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/get_bangladesh_data.sh
  )
endif()
configure_file(${CMAKE_SOURCE_DIR}/downloads/bangladesh.osm ${CMAKE_CURRENT_BINARY_DIR}/../un_sdg/sdg11/bangladesh.osm)

execute_process(
  OUTPUT_FILE process_osgeolive_data.txt
  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/process_osgeolive_data.sh > processes_osgeolive_data.txt
  WORKING_DIRECTORY ${CMAKE_CURRENT_BINARY_DIR}
  INPUT_FILE ${CMAKE_CURRENT_BINARY_DIR}/process_osgeolive_data.sh
  )
