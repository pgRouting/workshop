

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
      exercise_7_1.txt
      exercise_7_2.txt
      exercise_7_3.txt
      exercise_7_4.txt
      exercise_7_5.txt
      exercise_7_6.txt
      exercise_7_7.txt
      exercise_7_8.txt
      exercise_7_9.txt
      exercise_7_10.txt
      exercise_7_11.txt
    COMMAND psql -d city_routing -f all_sections.sql
    DEPENDS psql all_sections.sql
    )


add_custom_target(chapter_7_scripts
  DEPENDS "exercise_7_1.txt"
  DEPENDS "exercise_7_2.txt"
  DEPENDS "exercise_7_3.txt"
  DEPENDS "exercise_7_4.txt"
  DEPENDS "exercise_7_5.txt"
  DEPENDS "exercise_7_6.txt"
  DEPENDS "exercise_7_7.txt"
  DEPENDS "exercise_7_8.txt"
  DEPENDS "exercise_7_9.txt"
  DEPENDS "exercise_7_10.txt"
  DEPENDS "exercise_7_11.txt"
  )
