add_custom_target(scripts ALL)

## directory with no files


#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_SUBDIRS
  basic
  un_sdg
  )


#---------------------
# Needed to at configuration time
#---------------------
add_subdirectory(get_data)
add_subdirectory(configuration)
include(workshop/OsmidConf)


#---------------------------------------------
# Scripts by sections
#---------------------------------------------

foreach (dir ${PGR_WORKSHOP_SUBDIRS})
    if (PGR_WORKSHOP_DEBUG)
        message(STATUS "   Adding directory scripts/${dir}")
    endif()
    add_subdirectory(${dir})
    add_dependencies(scripts "${dir}_scripts")
endforeach()


add_dependencies(scripts configuration_scripts)
