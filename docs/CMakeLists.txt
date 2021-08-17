

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "index.rst"
    )

add_custom_target(doc COMMENT "Building documentation with Sphinx")



#---------------------------------------------
# Adding the documentation subdirectories & files
#---------------------------------------------

add_subdirectory(scripts)
add_subdirectory(general-intro)
add_subdirectory(basic)
add_subdirectory(advanced)
add_subdirectory(examples)
add_subdirectory(interactions)
add_subdirectory(appendix)
configure_file("conf.py" "conf.py" @ONLY)

foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

add_subdirectory(images)


#---------------------------------------------
# Adding the sphinx subdirectories and files
#---------------------------------------------
add_subdirectory(_themes)

set(SPHINX_DOCUMENTATION_DIR "${CMAKE_CURRENT_BINARY_DIR}")
set(SPHINX_BUILD_DIR "${CMAKE_CURRENT_BINARY_DIR}/_build")


# Internal variables.
option(LATEX_PAPER_SIZE
    "Set a4|letter (default=letter) paper size" "letter")

option(SPHINX_OPTS
    "Set Sphinx options (default are sphinx defaults)")

message(STATUS "SPHINX_OPTS=${SPHINX_OPTS}")

set(LATEX_PAPER_SIZE " -D latex_paper_size=${LATEX_PAPER_SIZE}")


# build the locale files
if (LOCALE)
  add_custom_target(locale ALL
  COMMAND ${SPHINX_EXECUTABLE}

    -b gettext

    # the location of the documentation to be build
    "${CMAKE_CURRENT_BINARY_DIR}"
    "${CMAKE_SOURCE_DIR}/locale/pot"

  COMMAND sphinx-intl update -d ${CMAKE_SOURCE_DIR}/locale -l en > locale_changes.txt
  DEPENDS "conf.py"

  COMMENT "Generating POT & PO files ..."
  )
  add_dependencies(locale chapters scripts)
  add_dependencies(doc locale)
endif()



foreach (target ${PGR_WORKSHOP_DOC_TARGETS})
  add_custom_target(${target} ALL
    COMMENT "Building documentation with Sphinx")

  configure_file("forward.html" "${SPHINX_BUILD_DIR}/${target}/index.html")

  foreach (lang ${PGR_WORKSHOP_BUILD_LANGUAGES})
    if (lang EQUAL "en")
      set(WARNINGS_TO_ERRORS "-W")
    else()
      set(WARNINGS_TO_ERRORS "")
    endif()


    add_custom_target(
      "${target}-${lang}"
      COMMAND ${SPHINX_EXECUTABLE}

      -b ${target}
      -c "${CMAKE_CURRENT_BINARY_DIR}"
      -D language='${lang}'

      # Convert warnings to errors
      ${WARNINGS_TO_ERRORS}

      # the location of the documentation to be build
      "${CMAKE_CURRENT_BINARY_DIR}"

      #where the documentations is written
      "${SPHINX_BUILD_DIR}/${target}/${lang}"

      COMMENT "Generating ${target}/${lang} documentation ..."

      DEPENDS "conf.py"
      )
    add_dependencies("${target}-${lang}" scripts)
    add_dependencies("${target}" "${target}-${lang}")
  endforeach()
  add_dependencies(doc "${target}")
endforeach()

