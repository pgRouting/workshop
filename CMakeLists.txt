
cmake_minimum_required(VERSION 3.12)
if ( ${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR} )
    message(FATAL_ERROR "In-source builds not allowed.
    Please make a new directory (called a build directory) and run CMake from there.
    You may need to remove CMakeCache.txt." )
endif()

#---------------------------------------------

project(PGR_WORKSHOP LANGUAGES NONE)
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

#---------------------------------------------

#---------------------------------------------
# Setting the version number
#---------------------------------------------
set(PGR_WORKSHOP_CITY "Belém")
set(WORKSHOP_AREA "FOSS4G ${PGR_WORKSHOP_CITY}")
set(COPYRIGHT "2010-2024 pgRouting Developers")
set(PGR_WORKSHOP_VERSION_MAJOR "3")
set(PGR_WORKSHOP_VERSION_MINOR "0")
set(PGR_WORKSHOP_VERSION_PATCH "1")
set(PGR_WORKSHOP_VERSION_DEV "")
set(PGR_WORKSHOP_VERSION "${PGR_WORKSHOP_VERSION_MAJOR}.${PGR_WORKSHOP_VERSION_MINOR}")
set(PGR_WORKSHOP_RELEASE "${PGR_WORKSHOP_VERSION_MAJOR}.${PGR_WORKSHOP_VERSION_MINOR}.${PGR_WORKSHOP_VERSION_PATCH}${PGR_WORKSHOP_VERSION_DEV}")
set(PGR_WORKSHOP_NAME "pgRouting workshop")
set(PGR_HTML_TITLE "Workshop - ${WORKSHOP_AREA} - Routing with pgRouting")
set(PGR_HTML_SHORT_TITLE "Workshop - ${PGR_WORKSHOP_CITY}")
set(OSGeoLive_VERSION "17")

#---------------------------------------------
# setting debug options
#---------------------------------------------

option(PGR_WORKSHOP_DEBUG
    "Set ON|OFF (default=OFF) to display basic DEBUG" OFF)

option(PGR_WORKSHOP_VERBOSE_DEBUG
    "Set ON|OFF (default=OFF) to display detailed DEBUG" OFF)

#---------------------------------------------

#---------------------------------------------
# CONFIGURATION
#---------------------------------------------
set(PGR_WORKSHOP_CITY_FILE "BELEM_BR")

# https://github.com/OSGeo/OSGeoLive/blob/master/bin/install_osm.sh
# around line 117
set(PGR_WORKSHOP_CITY_BBOX "-48.52,-1.49,-48.4,-1.36")

# Make it smaller
set(PGR_WORKSHOP_LITTLE_NET_BBOX "-48.52,-1.46,-48.45,-1.41")

# Use git blame to get the date when the line was changed
set(PGR_WORKSHOP_DOWNLOAD_DIR "workshop-2024")
set(DATE_OF_DATA "Sep 2024")

if (WORKSHOP_DEBUG)
  message(STATUS "WORKSHOP_CITY_FILE=${WORKSHOP_CITY_FILE}")
endif()

set(OSMID_1 "10982869752")
set(OSMID_2 "11818739588")
set(OSMID_3 "491465035")
set(OSMID_4 "1069202329")
set(OSMID_5 "5661895682")

set(LAT1 "-1.422066")
set(LON1 "-48.45665")


# 3->1: routes for vehicles with penalty & no penalty must be different
set(PLACE_1 "Hangar Convention Center")
set(PLACE_2 "Instituto Federal do Pará, Campus Belém")
set(PLACE_3 "Palacete Bolonha")
set(PLACE_4 "Forte do Castelo")
set(PLACE_5 "Estação das Docas")


set(POINT1_LAT "-1.455829")
set(POINT1_LON "-48.446044")
set(POINT2_LAT "-1.453448")
set(POINT2_LON "-48.447142")

# by chapters
set(CH7_PLACE_1 ${PLACE_5})
set(CH7_PLACE_2 ${PLACE_1})
set(CH7_OSMID_1 ${OSMID_5})
set(CH7_OSMID_2 ${OSMID_1})



#---------------------------------------------
# minimum versions
#---------------------------------------------
set(SPHINX_MINIMUM_VERSION "4.0.0")
set(Osm2pgrouting_FIND_VERSION "2.3")


#---------------------------------------------
# Finding sphinx
#---------------------------------------------

find_program(SPHINX_EXECUTABLE
  REQUIRED
  NAMES sphinx-build
  DOC "Sphinx Documentation Builder (sphinx-doc.org)"
)

# Getting sphinx version
execute_process(COMMAND "${SPHINX_EXECUTABLE}" --version
  OUTPUT_VARIABLE SPHINX_EXECUTABLE_VERSION
  OUTPUT_STRIP_TRAILING_WHITESPACE)
string(REPLACE "sphinx-build" "" SPHINX_EXECUTABLE_VERSION "${SPHINX_EXECUTABLE_VERSION}")
string(STRIP "${SPHINX_EXECUTABLE_VERSION}" SPHINX_EXECUTABLE_VERSION)

if ("${SPHINX_EXECUTABLE_VERSION}" VERSION_LESS "${SPHINX_MINIMUM_VERSION}")
  message(FATAL_ERROR "Sphinx required version is ${SPHINX_MINIMUM_VERSION}")
endif()

message(STATUS "Found ${SPHINX_EXECUTABLE} version '${SPHINX_EXECUTABLE_VERSION}'")

if (NOT SPHINX_EXECUTABLE)
  message(FATAL_ERROR "Sphinx not found")
  return()
endif()

set(SPHINX_FLAGS "" CACHE STRING "Flags to pass to sphinx-build")
separate_arguments(sphinx_flags UNIX_COMMAND "${SPHINX_FLAGS}")

#---------------------------------------------
# Finding osm2pgRouting
#---------------------------------------------

find_package(Osm2pgrouting ${Osm2pgrouting_FIND_VERSION} REQUIRED
  COMPONENTS mapconfig)

#---------------------------------------------
# Finding psql
#---------------------------------------------

find_package(PSQL)
message(STATUS "Found psql ${PSQL_EXECUTABLE}")
message(STATUS "Found createdb ${CREATEDB_EXECUTABLE}")
message(STATUS "Found dropdb ${DROPDB_EXECUTABLE}")


#---------------------------------------------
# Perl
#---------------------------------------------
find_package(Perl REQUIRED)


#---------------------------------------------
# Kind of output
# http://www.sphinx-doc.org/en/stable/builders.html
#---------------------------------------------
option(BUILD_HTML "Set ON|OFF (default=OFF) to build Documentation library tree as HTML" ON)
option(BUILD_PDF "Set ON|OFF (default=OFF) to build Documentation library tree as PDF" OFF)
option(BUILD_LOCALE "Set ON|OFF (default=OFF) to build the locale files" OFF)
option(BUILD_LINKCHECK "Set ON|OFF (default=OFF) to build Documentation library tree as LINKCHECK page" OFF)


foreach(opt BUILD_HTML BUILD_PDF BUILD_LOCALE BUILD_LINKCHECK)
  if (${${opt}} OR WITH_ALL_DOC)
    string(TOLOWER ${opt} val)
    string(REPLACE "build_" "" val ${val})
    list(APPEND PGR_WORKSHOP_DOC_TARGETS ${val})
  endif()
endforeach()

if("${PGR_WORKSHOP_DOC_TARGETS}" STREQUAL "")
  message(FATAL_ERROR "No documentation targets found")
endif()

message(STATUS "PGR_WORKSHOP_DOC_TARGETS=${PGR_WORKSHOP_DOC_TARGETS}")


#---------------------------------------------
# LANGUAGES SETTINGS
#---------------------------------------------
list(APPEND WORKSHOP_LANGUAGES_TRANSLATED "EN" "ES" "SV")
list(APPEND WORKSHOP_LANGUAGES "en" "es" "ja" "sv")
message(STATUS "WORKSHOP_LANGUAGES=${WORKSHOP_LANGUAGES}")

foreach(lang ${WORKSHOP_LANGUAGES})
  string(TOUPPER ${lang} val)
  if ("${val}" IN_LIST WORKSHOP_LANGUAGES_TRANSLATED)
    option(${val} "Set ON|OFF (default=ON) build ${lang} Documentation" ON)
  else()
    option(${val} "Set ON|OFF (default=OFF) build ${lang} Documentation" OFF)
  endif()
endforeach()

#---------------------------------------------
# Catching the language options to be build
#---------------------------------------------
foreach(lang ${WORKSHOP_LANGUAGES})
  string(TOUPPER ${lang} opt)
  if (${opt})
    list(APPEND PGR_WORKSHOP_BUILD_LANGUAGES ${lang})
  endif()
endforeach()

if("${PGR_WORKSHOP_BUILD_LANGUAGES}" STREQUAL "")
  message(FATAL_ERROR "No documentation languages found")
endif()

message(STATUS "PGR_WORKSHOP_BUILD_LANGUAGES=${PGR_WORKSHOP_BUILD_LANGUAGES}")



#---------------------------------------------
# All languages po files are to be generated
#---------------------------------------------
if(LOCALE)
  foreach(lang ${WORKSHOP_LANGUAGES})
    set(SPHINXINTL_LANGUAGE "${SPHINXINTL_LANGUAGE},${lang}")
  endforeach()
  message(STATUS "SPHINXINTL_LANGUAGE=${SPHINXINTL_LANGUAGE}")
endif()



#------------------------------------------
# Used to generate the languages bar
#------------------------------------------
MACRO(INSERT_INTO_MAP _KEY _VALUE)
  SET("LangMap_${_KEY}" "${_VALUE}")
ENDMACRO(INSERT_INTO_MAP)

INSERT_INTO_MAP("ca" "Català")
INSERT_INTO_MAP("de" "Deutsch")
INSERT_INTO_MAP("el" "Ελληνικά")
INSERT_INTO_MAP("en" "English")
INSERT_INTO_MAP("es" "Español")
INSERT_INTO_MAP("fr" "Français")
INSERT_INTO_MAP("fi" "Suomen kieli")
INSERT_INTO_MAP("hu" "Hungarian")
INSERT_INTO_MAP("id" "Bahasa Indonesia")
INSERT_INTO_MAP("it" "Italiano")
INSERT_INTO_MAP("ja" "日本語")
INSERT_INTO_MAP("ko" "한국어")
INSERT_INTO_MAP("pl" "Polski")
INSERT_INTO_MAP("pt" "Portugus")
INSERT_INTO_MAP("ru" "Русский")
INSERT_INTO_MAP("sv" "Svenska")
INSERT_INTO_MAP("zh" "中文")


message(STATUS "PGR_WORKSHOP_BUILD_LANGUAGES = ${PGR_WORKSHOP_BUILD_LANGUAGES}")
message(STATUS "SPHINXINTL_LANGUAGE = ${SPHINXINTL_LANGUAGE}")

#---------------------------------------------
# The documentation
#---------------------------------------------

add_subdirectory(docs)
