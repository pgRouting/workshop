add_custom_target(basic_scripts ALL)

#---------------------
# Directories
#---------------------
SET(PGR_WORKSHOP_DIR
  data
  pedestrian
  vehicles
  chapter_7
  chapter_8
)

foreach (d ${PGR_WORKSHOP_DIR})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Processing directory ${d}")
    endif()
    add_subdirectory("${d}")
    add_dependencies(basic_scripts basic_${d}_scripts)
endforeach()

add_dependencies(basic_pedestrian_scripts basic_data_scripts)
add_dependencies(basic_vehicles_scripts basic_pedestrian_scripts)
add_dependencies(basic_chapter_7_scripts basic_vehicles_scripts)
add_dependencies(basic_chapter_8_scripts basic_chapter_7_scripts)
