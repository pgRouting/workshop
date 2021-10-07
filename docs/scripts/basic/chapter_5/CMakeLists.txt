add_custom_target(basic_chapter_5_scripts)

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "all_exercises_5.sql"
    )

foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

add_custom_command(
  TARGET basic_chapter_5_scripts
  PRE_BUILD
  BYPRODUCTS
    exercise_5_1.txt
    exercise_5_2.txt
    exercise_5_3.txt
    exercise_5_4.txt
    exercise_5_5.txt
    exercise_5_6.txt
  COMMAND psql -d city_routing -f all_exercises_5.sql
  COMMENT "running chapter 5 scripts"
  DEPENDS all_exercises_5.sql
  )

