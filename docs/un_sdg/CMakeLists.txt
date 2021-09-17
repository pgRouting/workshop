
add_custom_target(un_sdg ALL)

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  chapter_1_introduction.rst
  chapter_2_get_data.rst
  chapter_3_sdg3.rst
  chapter_4_sdg11.rst
  chapter_5_sdg7.rst
  Appendix_SDG.rst
  )


set(PGR_WORKSHOP_SUBDIRS
  images
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

