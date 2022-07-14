
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  downloadOSGeoLive.png
  install-1.png
  install-2.png
  install-3.png
  install-4.png
  install-4.png
  install-vm.png
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

