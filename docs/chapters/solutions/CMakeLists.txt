

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES

ch8-e1.txt
ch8-e2.txt
ch8-e3.txt
ch8-e4.txt

cost_manipulation-1.txt
cost_manipulation-2.txt

info-1.txt
info-2.txt

fromAtoB.sql
manipulate_costs.sql
  )
set(FOO_FILES
ch8-e5.txt
cost_manipulation-3.txt
tmp.txt

advancedsaveForQgis.sql
landmarks.sql
two_chapters.sql
wrapperSaveForQgis.sql

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

