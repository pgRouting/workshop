

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  get_mumbai.sh
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

