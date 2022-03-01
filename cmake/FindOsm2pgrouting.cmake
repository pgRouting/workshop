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

if (false)
if (Osm2pgrouting_FIND_VERSION)
  # Check if version found is >= required version
  if ("${Osm2pgrouting_VERSION}" VERSION_LESS "${Osm2pgrouting_FIND_VERSION}")
    message(FATAL_ERROR  "Found osm2pgrouting version ${Osm2pgrouting_VERSION} which is less than requested version ${Osm2pgrouting_FIND_VERSION}")
  endif()
endif()
endif()

if(Osm2pgrouting_FIND_COMPONENTS)
  foreach(comp ${Osm2pgrouting_FIND_COMPONENTS})
    message (STATUS "looking for component ${comp}")
    if(NOT TARGET ${comp})
      message(STATUS "finding file")
      find_file (Osm2pgrouting_${comp}
        NAMES ${comp}.xml
        PATHS /usr/local/share/osm2pgrouting /usr/share/osm2pgrouting
        )

      if (Osm2pgrouting_${comp})
        set(Osm2pgrouting_${comp}_FOUND 1)
      endif()
      message(STATUS "Osm2pgrouting_mapconfig ${Osm2pgrouting_mapconfig}")
      message(STATUS "Osm2pgrouting_mapconfig_FOUND ${Osm2pgrouting_mapconfig_FOUND}")

      if(NOT Osm2pgrouting_${comp}_FOUND AND Osm2pgrouting_FIND_REQUIRED_${comp})
        message(FATAL_ERROR "Osm2pgrouting ${comp} not available.")
      endif()
    else()
      message(STATUS "hrere")
    endif()
  endforeach()
endif()


find_package_handle_standard_args(Osm2pgrouting
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
