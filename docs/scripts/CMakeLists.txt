add_custom_target(scripts ALL)

## directory with no files


#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_SUBDIRS
  "chapter_5"
  "chapter_6"
  "chapter_7"
  )


if ("${MAPCONFIG}" EQUAL "MAPCONFIG-NOTFOUND")
  message(FATAL_ERROR "mapconfig.xml not found. Check the osm2pgrouting installation!")
else()
  message(STATUS "mapconfig.xml found: ${MAPCONFIG}")
endif()

add_subdirectory(chapter_4)
add_dependencies(scripts chapter_4_scripts)
add_subdirectory(configuration)
include(workshop/OsmidConf)
add_dependencies(scripts configuration_scripts)
message(STATUS "ID_1 = ${ID_1}")
message(STATUS "ID_2 = ${ID_2}")
message(STATUS "ID_3 = ${ID_3}")
message(STATUS "ID_4 = ${ID_4}")
message(STATUS "ID_5 = ${ID_5}")


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
add_dependencies(chapter_5_scripts configuration_scripts)
add_dependencies(chapter_6_scripts configuration_scripts)
add_dependencies(chapter_7_scripts configuration_scripts)
