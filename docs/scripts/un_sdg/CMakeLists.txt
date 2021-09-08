add_custom_target(un_scripts ALL)

## directory with no files


add_subdirectory(sdg3)
add_dependencies(un_scripts un_sdg3_scripts)
add_subdirectory(sdg11)
add_dependencies(un_scripts un_sdg11_scripts)
