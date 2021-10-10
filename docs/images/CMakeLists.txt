
#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_IMG_FILES
ad10.png
hanosiav_example.png
network.png
  )

set (BAR
imaptools-small.gif
ad9.png
camptocamp.png
car-route1.png
car-route2.png
car-route3.png
detailofroute.png
openlayers_logo.png
wrapper1.png
wrapper2.png
wrapper3.png
    )


foreach (f ${PGR_WORKSHOP_IMG_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    FILE(COPY ${f} DESTINATION "${CMAKE_CURRENT_BINARY_DIR}")
endforeach()

