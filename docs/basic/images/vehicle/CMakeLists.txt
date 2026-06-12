#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
  vehicle_route_coming.png
  vehicle_route_going.png
  vehicle_time_is_money.png
  vehicle_use_penalty.png
)


foreach (f ${PGR_WORKSHOP_IMG_FILES})
  if (PGR_WORKSHOP_VERBOSE_DEBUG)
    message(STATUS "      -> ${f}")
  endif()
  configure_file(${f} ${f} COPYONLY)
endforeach()
