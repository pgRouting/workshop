

#---------------------
# Files
#---------------------

set(PGR_WORKSHOP_FILES
  )

set(FOO_FILES
ol-routing-base.html
ol-routing-final.html
osm2pgroutingOutput.txt
create-test.sh
functions.sql
QGISfunctions.sql
  )


#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_SUBDIRS
  )



#---------------------------------------------
# Adding the documentation subdirectories & files
#---------------------------------------------

foreach (dir ${PGR_WORKSHOP_SUBDIRS})
  if (PGR_WORKSHOP_DEBUG)
    message(STATUS "   Adding directory ${dir}")
  endif()
  add_subdirectory(${dir})
endforeach()

foreach (f ${PGR_WORKSHOP_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  configure_file(${f} ${f})
endforeach()

