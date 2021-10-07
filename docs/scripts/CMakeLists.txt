add_custom_target(scripts ALL)

## directory with no files


#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_SUBDIRS
  "chapter_5"
  "chapter_6"
  "chapter_7"
  "chapter_8"
  )


add_subdirectory(get_data)
add_subdirectory(configuration)
include(workshop/OsmidConf)

add_subdirectory(chapter_4)
add_dependencies(scripts chapter_4_scripts)
add_dependencies(scripts configuration_scripts)

add_subdirectory(un_sdg)
add_dependencies(scripts un_scripts)

#---------------------------------------------
# Adding the documentation subdirectories & files
#---------------------------------------------

foreach (dir ${PGR_WORKSHOP_SUBDIRS})
    if (PGR_WORKSHOP_DEBUG)
        message(STATUS "   Adding directory scripts/${dir}")
    endif()
    add_subdirectory(${dir})
    add_dependencies(scripts "${dir}_scripts")
endforeach()


add_dependencies(configuration_scripts chapter_4_scripts)
add_dependencies(chapter_5_scripts chapter_4_scripts)
add_dependencies(chapter_6_scripts chapter_5_scripts)
add_dependencies(chapter_7_scripts chapter_6_scripts)
add_dependencies(chapter_8_scripts chapter_7_scripts)
