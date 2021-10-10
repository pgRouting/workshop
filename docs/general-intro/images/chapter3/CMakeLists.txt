
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  downloadOSGeoLive.png
  install-disk.png
  install-display.png
  install-final.png
  install-general.png
  install-memory.png
  install-name.png
  install-vm.png
  install-welcome.png
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

