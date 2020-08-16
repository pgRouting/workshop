

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

if ("${MAPCONFIG}" EQUAL "MAPCONFIG-NOTFOUND")
  message(FATAL_ERROR "mapconfig.xml not found. Check the osm2pgrouting installation!")
else()
  message(STATUS "mapconfig.xml found: ${MAPCONFIG}")
endif()


#----------------------------------------------
# 4.1 Creating the database
#---------------------------------------------

add_custom_command(
    OUTPUT database_created.txt

    COMMAND bash section-4.1.1.sh > created_database.txt

    DEPENDS section-4.1.1.sh

    )

#----------------------------------------------
# 4.2 Download and unzipping the data
#---------------------------------------------

add_custom_command(
  OUTPUT ~/Desktop/${PGR_WORKSHOP_DOWNLOAD_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm

  COMMAND bash section-4.2.2.sh

  DEPENDS
  section-4.2.2.sh
  )

#----------------------------------------------
# 4.3.1 Run osm2pgrouting converter
#---------------------------------------------

add_custom_command(
  OUTPUT section-4.3.1.txt

  COMMAND bash section-4.3.1.sh > section-4.3.1.txt

  DEPENDS
  ~/Desktop/${PGR_WORKSHOP_DOWNLOAD_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm
  section-4.3.1.sh
  )

#----------------------------------------------
# 4.3.2 generated tables
#---------------------------------------------

add_custom_command(
  OUTPUT section-4.3.2.txt

  COMMAND bash section-4.3.2.sh > section-4.3.2.txt

  DEPENDS section-4.3.2.sh
          section-4.3.1.txt
  )

add_custom_target(chapter_4_scripts
  DEPENDS "~/Desktop/${PGR_WORKSHOP_DOWNLOAD_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm"
  DEPENDS "database_created.txt"
  DEPENDS "section-4.3.2.txt"
  )
