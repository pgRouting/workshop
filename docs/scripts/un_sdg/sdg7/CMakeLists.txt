

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
  count_roads.txt
  discard_disconnected_roads.txt
  kruskal_minimum_spanning_tree.txt
  setting_search_path.txt
  comparison.txt
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

