
#---------------------
# Directories
#---------------------
set(PGR_WORKSHOP_IMG_SUBDIRS
  introduction
  sdg3
  sdg11
  sdg7
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
