
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  afterCreateVM.png
  captureMouse.png
  chooseOSGeoLiveISO.png
  chooseTryLubuntu.png
  chooseVirtualDisk.png
  createVirtualHardDisk.png
  createVirtualMachine.png
  downloadOSGeoLive.png
  get_osgeolive_latest.png
  install-vm.png
  osgeoliveStarts.png
  previewOsgeoLive.png
  storageWithEmpty.png
  withISOinstalled.png
  )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "      -> ${f}")
  endif()
  configure_file(${f} ${f} COPYONLY)
endforeach()
