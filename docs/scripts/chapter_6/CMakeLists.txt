

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "section-6.1.sql"
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
# 6.1 Creating the database
#---------------------------------------------

add_custom_command(
    OUTPUT section-6.1-1.txt section-6.1-2.txt

    COMMAND psql -d city_routing -f section-6.1.sql

    DEPENDS section-6.1.sql

    )


add_custom_target(chapter_4_scripts
  DEPENDS "~/Desktop/${PGR_WORKSHOP_DOWNLOAD_DIR}/${PGR_WORKSHOP_CITY_FILE}.osm"
  DEPENDS "database_created.txt"
  DEPENDS "section-4.3.2.txt"
  )
