
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

foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "      -> ${f}")
  endif()
  configure_file(${f} ${f} COPYONLY)
endforeach()
