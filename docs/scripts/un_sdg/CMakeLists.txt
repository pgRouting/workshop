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
    configure_file(${f} sdg7/${f})
    configure_file(${f} sdg11/${f})
endforeach()



add_custom_target(un_sdg_scripts ALL)

set(PGR_WORKSHOP_SUBDIRS
  sdg3
  sdg7
  sdg11
  )

foreach (dir ${PGR_WORKSHOP_SUBDIRS})
  if (PGR_WORKSHOP_DEBUG)
    message(STATUS "   Adding directory ${dir}")
  endif()
  add_subdirectory(${dir})
  add_dependencies(un_sdg_scripts un_${dir}_scripts)
endforeach()
