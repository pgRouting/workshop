

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "all-sections-8.sql"
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

add_custom_command(
    OUTPUT
      section-8.2.1.txt
      section-8.2.2.txt
      section-8.3.1.txt
      section-8.3.2.txt
    COMMAND psql -d city_routing -f all-sections-8.sql
    DEPENDS psql all-sections-8.sql
    )


add_custom_target(chapter_8_scripts
  DEPENDS "section-8.2.1.txt"
  DEPENDS "section-8.2.2.txt"
  DEPENDS "section-8.3.1.txt"
  DEPENDS "section-8.3.2.txt"
  )
