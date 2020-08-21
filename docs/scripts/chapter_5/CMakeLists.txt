

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "section-5.1.sql"
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

add_custom_command(
  OUTPUT 
    section-5.1-1.txt
    section-5.1.1.txt
    section-5.1.2.txt
    section-5.1.3.txt
    section-5.1.4.txt
  COMMAND psql -d city_routing -f section-5.1.sql
  DEPENDS section-5.1.sql
  )

add_custom_target(chapter_5_scripts
  DEPENDS "section-5.1-1.txt"
  DEPENDS "section-5.1.1.txt"
  DEPENDS "section-5.1.2.txt"
  DEPENDS "section-5.1.3.txt"
  DEPENDS "section-5.1.4.txt"
  )
