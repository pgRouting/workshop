

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  # TODO these files need to be processed
  create_mumbai.sh
  get_mumbai.sh
  import_mumbai_roads.sh
  import_mumbai_buildings.sh
  all_exercises_sdg3.sql

  # TODO these files need to be generated
  import_mumbai_roads.txt
  import_mumbai_buildings.txt
  Exercise_5.txt
  Exercise_6.txt
  Exercise_7.txt
  Exercise_8.txt
  Exercise_9.txt
  Exercise_10.txt
  Exercise_11.txt
  Exercise_12.txt
  Exercise_13.txt
  Exercise_15.txt
  Exercise_16.txt
  Exercise_17.txt
  Exercise_18.txt
  Exercise_19.txt
  Exercise_20.txt
    )


add_custom_target(un_sdg3_scripts)
#---------------------------------------------
# Adding the documentation files
#---------------------------------------------

foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

