#---------------------------------------------
# Finding osm2pgRouting
#
# licence: GPL-2
# developer: vicky vergara
#
# This will define
#
#   OSM2PGROUTING_EXECUTABLE - full path to osm2pgrouting
#   OSM2PGROUTING_VERSION    - the version of osm2pgrouting
#
# Usage:
# include(workshop/FindOsm2pgrouting)
# if OSM2PGROUITNG_MIN_VERSION is set then will check the required version
#---------------------------------------------


find_program (OSM2PGROUTING_EXECUTABLE osm2pgrouting)
if (NOT OSM2PGROUTING_EXECUTABLE)
  message(FATAL_ERROR "osm2pgrouting not found")
endif()

execute_process(
  COMMAND ${OSM2PGROUTING_EXECUTABLE} --version
  OUTPUT_VARIABLE OSM2PGROUTING_VERSION
  OUTPUT_STRIP_TRAILING_WHITESPACE)

string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+" OSM2PGROUTING_VERSION ${OSM2PGROUTING_VERSION})

if (OSM2PGROUITNG_MIN_VERSION)
  # Check if version found is >= required version
  if ("${OSM2PGROUTING_VERSION}" VERSION_LESS "${OSM2PGROUITNG_MIN_VERSION}")
    message(FATAL_ERROR  "Found osm2pgrouting version ${OSM2PGROUTING_VERSION} which is less than requested version ${OSM2PGROUITNG_MIN_VERSION}")
  endif()
endif()

mark_as_advanced(
  OSM2PGROUTING_VERSION
  OSM2PGROUTING_EXECUTABLE
  )
message(STATUS "osm2pgrouting version ${OSM2PGROUTING_VERSION} found at ${OSM2PGROUTING_EXECUTABLE}")

