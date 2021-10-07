#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "section-4.3.2.sh"
)


#---------------------------------------------
# Adding the documentation files
#---------------------------------------------

foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

message(STATUS "chapter 4 4")
#----------------------------------------------
# 4.3.2 generated tables
#---------------------------------------------

add_custom_command(
  OUTPUT section-4.3.2.txt
  COMMAND bash section-4.3.2.sh > section-4.3.2.txt
  DEPENDS section-4.3.2.sh
  )

message(STATUS "chapter 4 5")
add_custom_target(chapter_4_scripts
  DEPENDS "section-4.3.2.txt"
  )
