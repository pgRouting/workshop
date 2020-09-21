#---------------------------------------------
# Finding osm2pgRouting
#
# licence: GPL-2
# developer: vicky vergara
#
# This will define
#
#   Osm2pgrouting_EXECUTABLE - full path to osm2pgrouting
#   Osm2pgrouting_VERSION    - the version of osm2pgrouting
#
# Usage:
# find_package(Osm2pgrouting REQUIRED)
#
# Define if needed before call
# if Osm2pgrouting_FIND_VERSION is set then will check the required version
# if Osm2pgrouting_DIR top-level directory containing the osm2pgrouting executable)
#---------------------------------------------

include(FindPackageHandleStandardArgs)

# Checks an environment variable; note that the first check
# does not require the usual CMake $-sign.
IF(DEFINED ENV{Osm2pgrouting_DIR})
  SET(Osm2pgrouting_DIR "$ENV{Osm2pgrouting_DIR}")
ENDIF()

find_program (Osm2pgrouting_EXECUTABLE osm2pgrouting
  HINTS ${Osm2pgrouting_DIR}
  PATHS /usr/local/bin/)

if (NOT Osm2pgrouting_EXECUTABLE)
  message(FATAL_ERROR "osm2pgrouting not found")
endif()

execute_process(
  COMMAND ${Osm2pgrouting_EXECUTABLE} --version
  OUTPUT_VARIABLE Osm2pgrouting_V
  OUTPUT_STRIP_TRAILING_WHITESPACE)

string(REGEX MATCH "[0-9]+\\.[0-9]+\\.[0-9]+" Osm2pgrouting_V ${Osm2pgrouting_V})
set(Osm2pgrouting_VERSION ${Osm2pgrouting_V} CACHE STRING "Osm2pgrouting VERSION")

if (Osm2pgrouting_FIND_VERSION)
  # Check if version found is >= required version
  if ("${Osm2pgrouting_VERSION}" VERSION_LESS "${Osm2pgrouting_FIND_VERSION}")
    message(FATAL_ERROR  "Found osm2pgrouting version ${Osm2pgrouting_VERSION} which is less than requested version ${Osm2pgrouting_FIND_VERSION}")
  endif()
endif()

find_file (Osm2pgrouting_Mapconfig
  NAMES mapconfig.xml
  PATHS /usr/local/share/osm2pgrouting /usr/share/osm2pgrouting
  )

find_package_handle_standard_args(osm2pgrouting
  REQUIRED_VARS Osm2pgrouting_EXECUTABLE
  VERSION_VAR Osm2pgrouting_VERSION
  HANDLE_COMPONENTS)


if (Osm2pgrouting_FOUND)
  mark_as_advanced(
    Osm2pgrouting_VERSION
    Osm2pgrouting_EXECUTABLE
    )
endif()

if (Osm2pgrouting_FOUND AND NOT TARGET Osm2pgrouting::Osm2pgrouting)
  add_executable(Osm2pgrouting::Osm2pgrouting IMPORTED)
  set_property(TARGET Osm2pgrouting::Osm2pgrouting PROPERTY IMPORTED_LOCATION ${Osm2pgrouting_EXECUTABLE})
endif()
