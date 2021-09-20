

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  # TODO these files need to be processed
  create_mumbai_sdg7.sh
  get_mumbai_sdg7.sh
  import_mumbai_sdg7_roads.sh
  all_exercises_sdg7.sql

  # TODO these files need to be generated
  Exercise_5.txt
  Exercise_6.txt
  Exercise_7.txt
  Exercise_8.txt
  Exercise_9.txt
  Exercise_10.txt
  Exercise_11.txt
  Exercise_12.txt
    )


add_custom_target(un_sdg7_scripts)
#---------------------------------------------
# Adding the documentation files
#---------------------------------------------

foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

