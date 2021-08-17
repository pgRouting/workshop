#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  mapconfig_sample.xml
  osm2pgroutingVersion.txt
  osm_sample.osm
  )


foreach (f ${PGR_WORKSHOP_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  configure_file(${f} ${f})
endforeach()

