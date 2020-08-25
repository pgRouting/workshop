

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "all_sections.sql"
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
    OUTPUT
      section-7.1.1.txt
      section-7.1.2.txt
      section-7.1.3.txt
      section-7.1.4.txt
      section-7.2.1.txt
      section-7.2.2.txt
      section-7.2.3.txt
      section-7.2.4.txt
      section-7.3.1.txt
      section-7.3.2.txt
    COMMAND psql -d city_routing -f all_sections.sql
    DEPENDS all_sections.sql
    )


add_custom_target(chapter_7_scripts
  DEPENDS "section-7.1.1.txt"
  DEPENDS "section-7.1.2.txt"
  DEPENDS "section-7.1.3.txt"
  DEPENDS "section-7.1.4.txt"
  DEPENDS "section-7.2.1.txt"
  DEPENDS "section-7.2.2.txt"
  DEPENDS "section-7.2.3.txt"
  DEPENDS "section-7.2.4.txt"
  DEPENDS "section-7.3.1.txt"
  DEPENDS "section-7.3.2.txt"
  )
