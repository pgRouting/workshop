add_custom_target(un_sdg7_scripts)

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  all_exercises_sdg7.sql
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
  TARGET un_sdg7_scripts
  PRE_BUILD
  BYPRODUCTS
    exercise_5.txt
    exercise_6.txt
    exercise_7.txt
    exercise_8.txt
    exercise_9.txt
    exercise_10.txt
    exercise_11.txt
    exercise_12.txt
  COMMAND psql -d mumbai -f all_exercises_sdg7.sql
  COMMENT "running chapter sdg7 scripts"
  DEPENDS all_exercises_sdg7.sql
  )
