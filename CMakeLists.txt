
cmake_minimum_required(VERSION 2.8...3.22)
if ( ${CMAKE_SOURCE_DIR} STREQUAL ${CMAKE_BINARY_DIR} )
    message(FATAL_ERROR "In-source builds not allowed.
    Please make a new directory (called a build directory) and run CMake from there.
    You may need to remove CMakeCache.txt." )
endif()

#---------------------------------------------
#---------------------------------------------
#---------------------------------------------

project(PGR_WORKSHOP LANGUAGES NONE)
set(CMAKE_MODULE_PATH "${CMAKE_SOURCE_DIR}/cmake")

#---------------------------------------------
#---------------------------------------------
#---------------------------------------------

#---------------------------------------------
# Setting the version number
#---------------------------------------------
set(PGR_WORKSHOP_CITY "Belém")
set(WORKSHOP_AREA "FOSS4G ${PGR_WORKSHOP_CITY}")
set(COPYRIGHT "2010-2024 pgRouting Developers")
set(PGR_WORKSHOP_VERSION_MAJOR "3")
set(PGR_WORKSHOP_VERSION_MINOR "0")
set(PGR_WORKSHOP_VERSION_PATCH "0")
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
set(SPHINX_MINIMUM_VERSION "2.3")
set(Osm2pgrouting_FIND_VERSION "2.3")


#---------------------------------------------
# Finding sphinx
#---------------------------------------------
find_package(Sphinx REQUIRED)
if (NOT SPHINX_FOUND)
  message(FATAL_ERROR "Sphinx not found")
#elseif (SPHINX_VERSION VERSION_LESS SPHINX_MINIMUM_VERSION)
#    message(WARNING "Your Sphinx version is too old!
#    This project requires Sphinx v1.0 or above to produce
#    proper documentation (you have v${SPHINX_VERSION}).
#    You will get output but it will have errors.")
endif()

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
#---------------------------------------------
include(FindPerl)
if(NOT PERL_EXECUTABLE)
    message(FATAL_ERROR " Please check your Perl installation.")
endif(NOT PERL_EXECUTABLE)

execute_process(
    COMMAND ${PERL_EXECUTABLE} -MDateTime -e ""
    ERROR_QUIET RESULT_VARIABLE DATETIME_STAUS
    )


#---------------------------------------------
#---------------------------------------------
#---------------------------------------------
#---------------------------------------------

# Kind of output
# http://www.sphinx-doc.org/en/stable/builders.html

#---------------------------------------------
#---------------------------------------------
#---------------------------------------------
#---------------------------------------------
option(ALL_DOC
    "Set ON|OFF (default=OFF) to build all documentation styles (exept LOCALE)" OFF)

option(HTML
  "Set ON|OFF (default=OFF) to build Documentation library tree as HTML" ON)

option(DIRHTML
  "Set ON|OFF (default=OFF) to build Documentation library tree as DIRHTML
  STATUS: the navigation does not work " OFF
  )

option(SINGLEHTML
  "Set ON|OFF (default=OFF) to build Documentation library tree as a single HTML file" OFF
  )

option(PICKLE
  "Set ON|OFF (default=OFF) to build Documentation library tree as PICKLE" OFF)

option(JSON
  "Set ON|OFF (default=OFF) to build Documentation library tree as JSON page" OFF)

option(HTMLHELP
  "Set ON|OFF (default=OFF) to build Documentation library tree as HTMLHELP page" OFF)

option(DUMMY
  "Set ON|OFF (default=OFF) to build Documentation library tree as DUMMY page" OFF)

option(LATEX
  "Set ON|OFF (default=OFF) to build Documentation library tree as LATEX page" OFF)

option(LINKCHECK
  "Set ON|OFF (default=OFF) to build Documentation library tree as LINKCHECK page" OFF)

option(LOCALE
  "Set ON|OFF (default=OFF) to build the locale files of all languages." OFF
  )

foreach(opt HTML DIRHTML SINGLEHTML PICKLE JSON HTMLHELP LATEX LINKCHECK)
  if (${${opt}} OR ALL_DOC)
    string(TOLOWER ${opt} val)
    list(APPEND PGR_WORKSHOP_DOC_TARGETS ${val})
  endif()
endforeach()

message(STATUS "PGR_WORKSHOP_DOC_TARGETS = ${PGR_WORKSHOP_DOC_TARGETS}")


#---------------------------------------------
#---------------------------------------------
#---------------------------------------------

# LANGUAGES SETINGS

#---------------------------------------------
#---------------------------------------------
#---------------------------------------------

#---------------------------------------------
# Avaliable Languages
# English is allways built

# list of sphinx languges support
# http://www.sphinx-doc.org/en/stable/config.html#confval-language
# TODO: figure out how to support this
#  "el"   "hu"  "id"  "zh")
#---------------------------------------------
set(PGR_WORKSHOP_SUPPORTED_LANGUAGES "es" "ja" "sv")
set(PGR_WORKSHOP_ENGLISH "en")

#---------------------------------------------
# Language options
#---------------------------------------------
option(ALL_LANG
  "Set ON|OFF (default=OFF) to build all documentation supported languages
  ${PGR_WORKSHOP_SUPPORTED_LANGUAGES}" OFF)

foreach(lang ${PGR_WORKSHOP_SUPPORTED_LANGUAGES})
  string(TOUPPER ${lang} val)
  option(${val}
    "Set ON|OFF (default=OFF) build ${lang} Documentation" OFF)
endforeach()

#---------------------------------------------
# Catching the language options to be build
#---------------------------------------------
list(APPEND PGR_WORKSHOP_BUILD_LANGUAGES  ${PGR_WORKSHOP_ENGLISH})
foreach(lang ${PGR_WORKSHOP_SUPPORTED_LANGUAGES})
  string(TOUPPER ${lang} opt)
  if (${opt} OR ALL_LANG)
    list(APPEND PGR_WORKSHOP_BUILD_LANGUAGES ${lang})
  endif()
endforeach()


#---------------------------------------------
# All languages po files are to be generated
#---------------------------------------------
set (SPHINXINTL_LANGUAGE  ${PGR_WORKSHOP_ENGLISH})
if(LOCALE)
  foreach(lang ${PGR_WORKSHOP_SUPPORTED_LANGUAGES})
    set(SPHINXINTL_LANGUAGE "${SPHINXINTL_LANGUAGE},${lang}")
  endforeach()
  set(PGR_WORKSHOP_LANGUAGES ${PGR_WORKSHOP_ENGLISH})
endif()


message(STATUS "SPHINXINTL_LANGUAGE ${SPHINXINTL_LANGUAGE}")


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
#---------------------------------------------
#---------------------------------------------

# The list of projects to be documented

#---------------------------------------------
#---------------------------------------------
#---------------------------------------------

add_subdirectory(docs)
