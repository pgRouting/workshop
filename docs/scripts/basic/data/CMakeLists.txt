#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "data.sh"
)

foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

add_custom_command(
  OUTPUT data.txt
  COMMAND bash data.sh > data.txt
  )

add_custom_target(basic_data_scripts
  DEPENDS "data.txt"
  )
