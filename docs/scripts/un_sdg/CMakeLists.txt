#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
buildings.xml
waterways.xml
)
foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} sdg3/${f})
endforeach()



add_custom_target(un_scripts ALL)

add_subdirectory(sdg3)
add_dependencies(un_scripts un_sdg3_scripts)
add_subdirectory(sdg11)
add_dependencies(un_scripts un_sdg11_scripts)
add_subdirectory(sdg7)
add_dependencies(un_scripts un_sdg7_scripts)
