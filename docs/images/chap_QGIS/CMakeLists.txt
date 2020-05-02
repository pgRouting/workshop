
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  )

#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_IMG_SUBDIRS
    )



#---------------------------------------------
# Adding the documentation subdirectories & files
#---------------------------------------------

foreach (dir ${PGR_WORKSHOP_IMG_SUBDIRS})
    file(COPY "${dir}" DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
    if (PGR_WORKSHOP_DEBUG)
        message(STATUS "   Adding images directory ${dir}")
    endif()
endforeach()

foreach (f ${PGR_WORKSHOP_IMG_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

