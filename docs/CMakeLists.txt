

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


# build the locale files
if (LOCALE)
  add_custom_target(locale ALL
  COMMAND ${SPHINX_EXECUTABLE}

    -b gettext

    # the location of the documentation to be build
    "${CMAKE_CURRENT_BINARY_DIR}"
    "${CMAKE_SOURCE_DIR}/locale/pot"

  COMMAND sphinx-intl update -d ${CMAKE_SOURCE_DIR}/locale -l ${SPHINXINTL_LANGUAGE} > locale_changes.txt
  DEPENDS "conf.py"

  COMMENT "Generating POT & PO files ..."
  )
  add_dependencies(locale examples general-intro advanced  appendix  basic un_sdg scripts interactions)
  add_dependencies(doc locale)
endif()



foreach (target ${PGR_WORKSHOP_DOC_TARGETS})
  add_custom_target(${target} ALL
    COMMENT "Building documentation with Sphinx")

  configure_file("forward.html" "${SPHINX_BUILD_DIR}/${target}/index.html")

  foreach (lang ${PGR_WORKSHOP_BUILD_LANGUAGES})
    if (lang STREQUAL "en")
      set(WARNINGS_TO_ERRORS "")
    else()
      set(WARNINGS_TO_ERRORS "")
    endif()
    message(STATUS "lang ${lang}")
    message(STATUS "WARNINGS_TO_ERRORS ${WARNINGS_TO_ERRORS}")


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

      COMMENT "Generating ${target}/${lang} documentation ${WARNINGS_TO_ERRORS}..."

      DEPENDS "conf.py"
      )
    add_dependencies("${target}-${lang}" examples general-intro advanced  appendix  basic un_sdg scripts interactions)
    add_dependencies("${target}" "${target}-${lang}")
  endforeach()
  add_dependencies(doc "${target}")
endforeach()

return()

foreach (format ${WORKSHOP_DOC_TARGETS})

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
        -c "${PGR_DOCUMENTATION_SOURCE_DIR}"
        "${PGR_DOCUMENTATION_SOURCE_DIR}"
        "${CMAKE_SOURCE_DIR}/locale/pot"

        COMMAND ${SPHINX_INTL_EXECUTABLE} update
        -d ${CMAKE_SOURCE_DIR}/locale
        -l en > locale_changes.txt

        COMMENT "Generating POT and PO files"
        SOURCES ${WORKSHOP_DOC_FILES})

    else()

      message(WARNING "sphinx-intl not found.
      Not building the pot and po locale files")

    endif()


  else()

    add_custom_target("${format}"
      COMMENT "Building ${format} documentation with Sphinx")

    configure_file(
      "${CMAKE_CURRENT_SOURCE_DIR}/forward.html"
      "${PGR_DOCUMENTATION_BUILD_DIR}/${format}/index.html")

    foreach (lang ${WORKSHOP_BUILD_LANGUAGES})
      add_custom_target(
        "${format}-${lang}"
        COMMAND ${SPHINX_EXECUTABLE}
        -c ${CMAKE_CURRENT_BINARY_DIR}
        -d ${CMAKE_CURRENT_BINARY_DIR}/doctrees
        -b ${format}
        -D language='${lang}'
        ${sphinx_flags}
        "${PGR_DOCUMENTATION_SOURCE_DIR}"
        "${PGR_DOCUMENTATION_BUILD_DIR}/${format}/${lang}"

        COMMENT "Generating ${format}/${lang} documentation"
        SOURCES ${WORKSHOP_DOC_FILES}  ${PROJECT_IMG_FILES}
        DEPENDS ${WORKSHOP_DOC_FILES}  ${PROJECT_IMG_FILES}
      )
      add_dependencies(${format} "${format}-${lang}")

    endforeach()
    add_dependencies(doc "${format}")

  endif()
endforeach()
