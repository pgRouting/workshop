

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  # TODO these files need to be processed
  all_exercises_sdg11.sql
  create_bangladesh.sh
  get_bangladesh.sh
  import_bangladesh_waterways.sh

  # TODO these files need to be generated
    )


add_custom_target(un_sdg11_scripts)
#---------------------------------------------
# Adding the documentation files
#---------------------------------------------

foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

