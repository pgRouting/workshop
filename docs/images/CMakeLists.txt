#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_IMG_SUBDIRS
  introduction
  logos
  osgeolive
  )

foreach (dir ${PGR_WORKSHOP_IMG_SUBDIRS})
  if (PGR_WORKSHOP_DEBUG)
    message(STATUS "   -> ${CMAKE_CURRENT_SOURCE_DIR}/${dir}")
  endif()
  add_subdirectory("${dir}")
  if (PGR_WORKSHOP_DEBUG)
    message(STATUS "   <- ${CMAKE_CURRENT_SOURCE_DIR}/${dir}")
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
    message(STATUS "      -> ${f}")
  endif()
  configure_file(${f} ${f} COPYONLY)
endforeach()
