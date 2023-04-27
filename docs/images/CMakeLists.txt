#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_IMG_SUBDIRS
  introduction
  logos
  osgeolive
  )


#---------------------------------------------
# Adding the documentation subdirectories & files
#---------------------------------------------

foreach (dir ${PGR_WORKSHOP_IMG_SUBDIRS})
  add_subdirectory(${dir})
  if (PGR_WORKSHOP_DEBUG)
    message(STATUS "   Adding images directory ${dir}")
  endif()
endforeach()

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  hanosiav_example.png
  network.png
  )

foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "    Adding file ${f}")
  endif()
  FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

