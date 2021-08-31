

#---------------------
# Files
#---------------------

set(PGR_WORKSHOP_FILES
  ol-routing-base.html
  ol-routing-final.html
)

set(FOO_FILES
osm2pgroutingOutput.txt
create-test.sh
functions.sql
QGISfunctions.sql
  )


#---------------------------------------------
# Adding the documentation files
#---------------------------------------------

foreach (f ${PGR_WORKSHOP_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  configure_file(${f} ${f})
endforeach()

