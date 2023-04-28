
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
set(WORKSHOP_AREA "FOSS4G Prizren")
set(COPYRIGHT "2010-2023 pgRouting Developers")
set(PGR_WORKSHOP_VERSION_MAJOR "2")
set(PGR_WORKSHOP_VERSION_MINOR "9")
set(PGR_WORKSHOP_VERSION_PATCH "0")
set(PGR_WORKSHOP_VERSION_DEV "dev")
set(PGR_WORKSHOP_VERSION "${PGR_WORKSHOP_VERSION_MAJOR}.${PGR_WORKSHOP_VERSION_MINOR}")
set(PGR_WORKSHOP_RELEASE "${PGR_WORKSHOP_VERSION_MAJOR}.${PGR_WORKSHOP_VERSION_MINOR}.${PGR_WORKSHOP_VERSION_PATCH}${PGR_WORKSHOP_VERSION_DEV}")
set(PGR_WORKSHOP_NAME "pgRouting workshop")
set(PGR_HTML_TITLE "Workshop - FOSS4G 2023 Prizren - Routing with pgRouting")
set(PGR_HTML_SHORT_TITLE "Workshop - Prizren")
set(OSGeoLive_VERSION "16.0")


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
set(PGR_WORKSHOP_CITY "Prizren")
set(PGR_WORKSHOP_CITY_FILE "Prizren_XK")

# https://github.com/OSGeo/OSGeoLive/blob/master/bin/install_osm.sh
# around line 117
set(PGR_WORKSHOP_CITY_BBOX "21.1922265,42.0816364,20.2206175,42.6653875")

# Make it smaller
set(PGR_WORKSHOP_LITTLE_NET_BBOX "20.70,42.20,20.76,42.23")

# Use git blame to get the date when the line was changed
set(PGR_WORKSHOP_DOWNLOAD_DIR "workshop-2023")
set(DATE_OF_DATA "March 2023")

# 2036025350 2036027314
set(OSMID_1 "6917727056")
# 2238637626
set(OSMID_2 "9885778732")
# 2506811043
set(OSMID_3 "1838481592")
# 1840522508
set(OSMID_4 "1840522495")
# 1837558219
set(OSMID_5 "6348206975")
# qgis filter:
# osm_id IN (6917727056, 9885778732, 1838481592, 1840522495, 6348206975)


set(PLACE_1 "Inovation and Training Park")
set(PLACE_2 "Antalya Restaurant")
set(PLACE_3 "Qendra Sprotive")
set(PLACE_4 "Nadir Xhemali Danijolli")
set(PLACE_5 "Pizzeria Linda")


set(POINT1_LON "11.2384")
set(POINT1_LAT "43.784")
set(POINT2_LON "11.2492")
set(POINT2_LAT "43.778")

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
