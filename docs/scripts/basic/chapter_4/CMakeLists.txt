#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "section-4.3.2.sh"
)

foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

add_custom_command(
  OUTPUT section-4.3.2.txt
  COMMAND bash section-4.3.2.sh > section-4.3.2.txt
  DEPENDS section-4.3.2.sh
  )

add_custom_target(basic_chapter_4_scripts
  DEPENDS "section-4.3.2.txt"
  )
