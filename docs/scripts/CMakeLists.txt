
## directory with no files


#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_SUBDIRS
  "chapter_4"
  )



#---------------------------------------------
# Adding the documentation subdirectories & files
#---------------------------------------------

foreach (dir ${PGR_WORKSHOP_SUBDIRS})
    if (PGR_WORKSHOP_DEBUG)
        message(STATUS "   Adding directory ${dir}")
    endif()
    add_subdirectory(${dir})
endforeach()

if ("${MAPCONFIG}" EQUAL "MAPCONFIG-NOTFOUND")
  message(FATAL_ERROR "mapconfig.xml not found. Check the osm2pgrouting installation!")
else()
  message(STATUS "mapconfig.xml found: ${MAPCONFIG}")
endif()

add_custom_target(db_scripts)
add_dependencies(db_scripts create_db)
