

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "chapter-1.rst"
  "chapter-2.rst"
  "chapter-3.rst"
  "chapter-4.rst"
  "chapter-5.rst"
  "chapter-6.rst"
  "chapter-7.rst"
  "chapter-8.rst"
  "chapter-9.rst"
  "chapter-10.rst"
  "chapter-11.rst"
  "chapter-12.rst"
  "appendix-1.rst"
  "appendix-2.rst"
  "appendix-3.rst"
  "appendix-4.rst"
  "appendix-5.rst"
  "appendix-6.rst"
    )


#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_SUBDIRS
  "solutions"
  "code"
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

add_custom_target(chapters)
