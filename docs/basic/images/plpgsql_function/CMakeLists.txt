
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  closest_vertex.png
  ch8-e7.png
  ch8-taxinet.png
  ch8-vehiclenet.png
  ch8-walknet.png
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "      -> ${f}")
  endif()
  configure_file(${f} ${f} COPYONLY)
endforeach()
