#---------------------------------------------
# Finding psql
#
# licence: GPL-2
# developer: vicky vergara
#
# This will define
#
#   PSQL_EXECUTABLE - full path to psql
#   PSQL_VERSION    - the version of psql
#
# Usage:
# find_package(PSQL REQUIRED)
#
# Define if needed before call
# if PSQL_FIND_VERSION is set then will check the required version
# if PSQL_DIR top-level directory containing the psql executable)
#---------------------------------------------

include(FindPackageHandleStandardArgs)

# Checks an environment variable; note that the first check
# does not require the usual CMake $-sign.
IF(DEFINED ENV{PSQL_DIR})
  SET(PSQL_DIR "$ENV{PSQL_DIR}")
ENDIF()

find_program (PSQL_EXECUTABLE psql
  HINTS ${PSQL_DIR}
  PATHS /usr/local/bin/
  /usr/bin
  )

if (NOT PSQL_EXECUTABLE)
  message(FATAL_ERROR "psql not found")
endif()

execute_process(
  COMMAND ${PSQL_EXECUTABLE} --version
  OUTPUT_VARIABLE PSQL_VERSION
  ERROR_VARIABLE PSQL_ERROR
  OUTPUT_STRIP_TRAILING_WHITESPACE)

IF (NOT PSQL_VERSION)
  message(FATAL_ERROR "PostgreSQL not up and running")
endif()

message(STATUS "PSQL_VERSION ${PSQL_VERSION}")
STRING(REGEX MATCH "[0-9]+" PSQL_VERSION "${PSQL_VERSION}")
message(STATUS "PSQL_VERSION ${PSQL_VERSION}")


if (PSQL_FIND_VERSION)
  # Check if version found is >= required version
  if ("${PSQL_VERSION}" VERSION_LESS "${PSQL_FIND_VERSION}")
    message(FATAL_ERROR  "Found psql version ${PSQL_VERSION} which is less than requested version ${PSQL_FIND_VERSION}")
  endif()
endif()

find_program(CREATEDB_EXECUTABLE createdb
  HINTS ${PSQL_DIR}
  PATHS /usr/local/bin/
  /usr/bin
  )

if (NOT CREATEDB_EXECUTABLE)
  message(FATAL_ERROR "createdb not found")
endif()

find_program (DROPDB_EXECUTABLE dropdb
  HINTS ${PSQL_DIR}
  PATHS /usr/local/bin/
  /usr/bin
  )

if (NOT DROPDB_EXECUTABLE)
  message(FATAL_ERROR "dropdb not found")
endif()



set(FPHSA_NAME_MISMATCHED 1)
find_package_handle_standard_args(psql
  REQUIRED_VARS PSQL_EXECUTABLE
  VERSION_VAR PSQL_VERSION
  HANDLE_COMPONENTS)
unset(FPHSA_NAME_MISMATCHED)


if (PSQL_FOUND)
  mark_as_advanced(
    PSQL_VERSION
    PSQL_EXECUTABLE
    CREATEDB_EXECUTABLE
    DROPDB_EXECUTABLE
    )
endif()

if (PSQL_FOUND AND NOT TARGET psql)
  add_executable(psql IMPORTED)
  set_property(TARGET psql PROPERTY IMPORTED_LOCATION ${PSQL_EXECUTABLE})
endif()

if (CREATEDB_FOUND AND NOT TARGET createdb)
  add_executable(createdb IMPORTED)
  set_property(TARGET createdb PROPERTY IMPORTED_LOCATION ${CREATEDB_EXECUTABLE})
endif()

if (DROPDB_FOUND AND NOT TARGET dropdb)
  add_executable(dropdb IMPORTED)
  set_property(TARGET dropdb PROPERTY IMPORTED_LOCATION ${DROPDB_EXECUTABLE})
endif()
