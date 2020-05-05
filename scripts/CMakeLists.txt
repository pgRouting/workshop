

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "section-4.1.1.sh"
  "section-4.2.2.sh"
  "section-4.3.1.sh"
  "section-4.3.2.sh"
    )


#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_SUBDIRS

    )



#---------------------------------------------
# Adding the documentation subdirectories & files
#---------------------------------------------

foreach (dir ${PGR_WORKSHOP_SUBDIRS})
    if (PGR_WORKSHOP_DEBUG)
        message(STATUS "   Adding directory ${dir}")
    endif()
    add_subdirectory(${dir})
endforeach()

foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

if ("${MAPCONFIG}" EQUAL "MAPCONFIG-NOTFOUND")
  message(FATAL_ERROR "mapconfig.xml not found. Check the osm2pgrouting installation!")
else()
  message(STATUS "mapconfig.xml found: ${MAPCONFIG}")
endif()

file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/outputs)
file(MAKE_DIRECTORY ${CMAKE_BINARY_DIR}/outputs/chapter4)


#----------------------------------------------
# 4.1 Creating the database
#---------------------------------------------

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/database_created.txt

    COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/create-db.sh

    DEPENDS
    ${CMAKE_CURRENT_BINARY_DIR}/section-4.1.1.sh

    )

#----------------------------------------------
# 4.2 Download and unzipping the data
#---------------------------------------------

add_custom_command(
  OUTPUT ~/Desktop/${PGR_WORKSHOP_DOWNLOAD_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm

  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/download_data.sh

  DEPENDS
  ${CMAKE_CURRENT_BINARY_DIR}/section-4.2.2.sh
  )

#----------------------------------------------
# 4.3.1 Run osm2pgrouting converter
#---------------------------------------------

add_custom_command(
  OUTPUT ${CMAKE_BINARY_DIR}/outputs/chapter4/osm2pgroutingOutput.txt

  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/run_osm2pgRouting.sh > ${CMAKE_BINARY_DIR}/outputs/chapter4/osm2pgroutingOutput.txt

  DEPENDS
  ~/Desktop/${PGR_WORKSHOP_DOWNLOAD_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm
  ${CMAKE_CURRENT_BINARY_DIR}//section-4.3.1.sh
  )

#----------------------------------------------
# 4.3.2 generated tables
#---------------------------------------------

add_custom_command(
  OUTPUT ${CMAKE_BINARY_DIR}/outputs/chapter4/section-4.3.2.txt

  COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/section-4.3.2.sh > ${CMAKE_BINARY_DIR}/outputs/chapter4/section-4.3.2.txt

  DEPENDS
  ${CMAKE_CURRENT_BINARY_DIR}/section-4.3.2.sh
  ${CMAKE_BINARY_DIR}/outputs/chapter4/osm2pgroutingOutput.txt
  )

add_custom_target(create_db ALL
  DEPENDS "${CMAKE_CURRENT_BINARY_DIR}/database_created.txt"
  DEPENDS "~/Desktop/${PGR_WORKSHOP_DOWNLOAD_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm"
  DEPENDS "${CMAKE_BINARY_DIR}/outputs/chapter4/section-4.3.2.txt"
  )
