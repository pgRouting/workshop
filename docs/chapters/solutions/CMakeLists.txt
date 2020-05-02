

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
d-0.txt
d-1.txt
d-2.txt
d-3.txt
d-4.txt
d-5.txt
d-6.txt

ad-7.txt
ad-8.txt
ad-9.txt
  ad-10.txt
ad-11.txt

ch7-e1.txt
ch7-e2.txt
ch7-e3.txt
ch7-e4.txt
ch7-e5.txt
ch7-e6.txt
ch7-e7.txt
ch7-e8.txt
ch7-e9.txt
ch7-e10.txt

ch8-e1.txt
ch8-e2.txt
ch8-e3.txt
ch8-e4.txt

cost_manipulation-1.txt
cost_manipulation-2.txt

info-1.txt
info-2.txt

advanced_problems.sql
fromAtoB.sql
manipulate_costs.sql
shortest_problems.sql
wrapper_problems.sql
  )
set(FOO_FILES
ch8-e5.txt
cost_manipulation-3.txt
tmp.txt

advancedsaveForQgis.sql
landmarks.sql
two_chapters.sql
wrapper_problems.sql
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

