
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  qgis10.png
  qgis11.png
  qgis12.png
  qgis13.png
  qgis14.png
  qgis15.png
  qgis16.png
  qgis1.png
  qgis2.png
  qgis3.png
  qgis4.png
  qgis5.png
  qgis6.png
  qgis7.png
  qgis8.png
  qgis9.png
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

