

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "create-db.sh"
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

#----------------------------------------------
# Creating the database
#---------------------------------------------

add_custom_command(
    OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/database_created.txt

    COMMAND bash ${CMAKE_CURRENT_BINARY_DIR}/create-db.sh

    DEPENDS 
    ${CMAKE_CURRENT_BINARY_DIR}/create-db.sh
   
    )

add_custom_target(create_db ALL DEPENDS ${CMAKE_CURRENT_BINARY_DIR}/database_created.txt)
