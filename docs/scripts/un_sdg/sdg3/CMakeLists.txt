

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  # TODO these files need to be processed
  create_mumbai.sh
  get_mumbai.sh
  import_mumbai_roads.sh
  import_mumbai_buildings.sh
  all_exercises_sdg1.sql

  # TODO these files need to be generated
  import_mumbai_roads.txt
  import_mumbai_buildings.txt
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
    add_dependencies(un_sdg3_scripts "${f}")
endforeach()

