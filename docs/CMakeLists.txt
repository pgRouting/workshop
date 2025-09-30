

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
add_subdirectory(un_sdg)
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

foreach (format ${PGR_WORKSHOP_DOC_TARGETS})

  message(STATUS "format=${format}")
  if ("${format}" STREQUAL "locale")

    find_program(SPHINX_INTL_EXECUTABLE
      NAMES sphinx-intl
      DOC "Sphinx Documentation Builder (sphinx-doc.org)"
    )

    if (SPHINX_INTL_EXECUTABLE)

      add_custom_target(locale
        COMMAND ${SPHINX_EXECUTABLE}
        -b gettext
        -c "${SPHINX_DOCUMENTATION_DIR}"
        "${SPHINX_DOCUMENTATION_DIR}"
        "${CMAKE_SOURCE_DIR}/locale/pot"

        COMMAND ${SPHINX_INTL_EXECUTABLE} update
        -d ${CMAKE_SOURCE_DIR}/locale
        -l en > locale_changes.txt

        COMMENT "Generating POT and PO files"
        SOURCES ${PROJECT_DOC_FILES})

      add_dependencies("${format}" examples general-intro advanced  appendix  basic un_sdg scripts interactions)
      add_dependencies(doc "${format}")

    else()

      message(WARNING "sphinx-intl not found.
      Not building the pot and po locale files")

    endif()

  else()

    add_custom_target("${format}"
      COMMENT "Building ${format} documentation with Sphinx")

    configure_file(
      "${CMAKE_CURRENT_SOURCE_DIR}/forward.html"
      "${SPHINX_BUILD_DIR}/${format}/index.html")

    foreach (lang ${PGR_WORKSHOP_BUILD_LANGUAGES})

      add_custom_target(
        "${format}-${lang}"
        COMMAND ${SPHINX_EXECUTABLE}
        -c ${CMAKE_CURRENT_BINARY_DIR}
        -d ${CMAKE_CURRENT_BINARY_DIR}/doctrees
        -b ${format}
        -D language='${lang}'
        ${sphinx_flags}
        "${CMAKE_CURRENT_BINARY_DIR}"
        "${SPHINX_BUILD_DIR}/${format}/${lang}"

        COMMENT "Generating ${format}/${lang} documentation"
        DEPENDS "conf.py"
      )
      add_dependencies("${format}-${lang}" examples general-intro advanced  appendix  basic un_sdg scripts interactions)
      add_dependencies("${format}" "${format}-${lang}")
    endforeach()

    add_dependencies(doc "${format}")

  endif()

endforeach()
