
cmake_minimum_required(VERSION 2.8 FATAL_ERROR)
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
set(WORKSHOP_AREA "FOSS4G Argentina") 
set(COPYRIGHT "2010-2021 Daniel Kastl, Vicky Vergara")
set(PGR_WORKSHOP_VERSION_MAJOR "2")
set(PGR_WORKSHOP_VERSION_MINOR "7")
set(PGR_WORKSHOP_VERSION_PATCH "0")
set(PGR_WORKSHOP_VERSION_DEV "dev")
set(PGR_WORKSHOP_VERSION "${PGR_WORKSHOP_VERSION_MAJOR}.${PGR_WORKSHOP_VERSION_MINOR}")
set(PGR_WORKSHOP_RELEASE "${PGR_WORKSHOP_VERSION_MAJOR}.${PGR_WORKSHOP_VERSION_MINOR}.${PGR_WORKSHOP_VERSION_PATCH}${PGR_WORKSHOP_VERSION_DEV}")
set(PGR_WORKSHOP_NAME "pgRouting workshop")
set(PGR_HTML_TITLE "Workshop - FOSS4G 2021 Argentina - Routing with pgRouting")
set(PGR_HTML_SHORT_TITLE "Workshop - Argentina")
set(OSGeoLive_VERSION "14.0")


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
set(PGR_WORKSHOP_CITY "Buenos Aires")
set(PGR_WORKSHOP_CITY_FILE "BA_AR")
set(PGR_WORKSHOP_CITY_BBOX "-58.48,-34.60,-58.32,-34.521")
set(PGR_WORKSHOP_LITTLE_NET_BBOX "-58.41,-34.596,-58.36,-34.57")
set(PGR_WORKSHOP_DOWNLOAD_DIR "workshop-2021")

set(OSMID_1 "192903446")
set(OSMID_2 "4289340366")
set(OSMID_3 "2153015792")
set(OSMID_4 "6357258588")
set(OSMID_5 "196017392")


set(PLACE_1 "Plaza Intendente Alvear")
set(PLACE_2 "Hard Rock Café")
set(PLACE_3 "Facultad de Derecho")
set(PLACE_4 "Centro de Convenciones Buenos Aires")
set(PLACE_5 "Palacio Duhau-Park Hyatt Buenos Aires")


#TODO set points that are routable on chapter 8
set(POINT1_LAT "-58.40")
set(POINT1_LON "-34.55")
set(POINT2_LAT "-58.41")
set(POINT2_LON "-34.57")

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
    "Set ON|OFF (default=OFF) to build Documentation library tree as HTML" OFF)

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
    "Set ON|OFF (default=OFF) to build the locale files of all languages.
    All other options are ignored
    All supported languages are considered" OFF
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
set(PGR_WORKSHOP_SUPPORTED_LANGUAGES "es")
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
