#---------------------------------------------
#  OSM identifiers configuration
#---------------------------------------------
#
# Gets the corresponding id from the osm_id data
#----------------------

#
# file:
# build/docs/scripts/configuration/osmid_configuration.conf
# must exists

MACRO(INSERT_INTO_MAP_NAME _NAME _VALUE)
    SET("${_NAME}" "${_VALUE}" PARENT_SCOPE)
    SET("${_NAME}" "${_VALUE}")
ENDMACRO(INSERT_INTO_MAP_NAME)

message(STATUS "PROJECT_BINARY_DIR ${PROJECT_BINARY_DIR}")
# Get the configuration strings
file(STRINGS "${PROJECT_BINARY_DIR}/docs/scripts/configuration/osmid_configuration.conf" CONFIGURATION_STRINGS)


foreach(line ${CONFIGURATION_STRINGS})
    string(REGEX REPLACE "^(.*)\\|(.*)" "\\1" id_name ${line})
    string(REGEX REPLACE "^(.*)\\|(.*)" "\\2" id_value ${line})

    ## remove leading & trailing spaces
    string(STRIP ${id_name} id_name)
    string(STRIP ${id_value} id_value)

    INSERT_INTO_MAP_NAME("${id_name}" "${id_value}")
endforeach()
