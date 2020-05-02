

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
mapconfig_sample.xml
ol-routing-base.html
ol-routing-final.html
osm2pgroutingOutput.txt
osm2pgroutingVersion.txt
osm_sample.osm
  )
set(FOO_FILES
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

