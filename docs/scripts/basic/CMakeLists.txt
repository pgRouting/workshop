add_custom_target(basic_scripts ALL)

#---------------------
# Directories
#---------------------
SET(PGR_WORKSHOP_DIR 
  chapter_4
  chapter_5
  chapter_6
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

add_dependencies(basic_chapter_5_scripts basic_chapter_4_scripts)
add_dependencies(basic_chapter_6_scripts basic_chapter_5_scripts)
add_dependencies(basic_chapter_7_scripts basic_chapter_6_scripts)
add_dependencies(basic_chapter_8_scripts basic_chapter_7_scripts)
