add_custom_target(un_sdg7_scripts DEPENDS sdg7.sql)

configure_file(sdg7.sql sdg7.sql)

add_custom_command(
  TARGET un_sdg7_scripts
  PRE_BUILD
  BYPRODUCTS
    set_path.txt
    show_path2.txt
    revert_changes.txt
    only_connected1.txt
    only_connected2.txt
    only_connected3.txt
    only_connected4.txt
    only_connected5.txt
    only_connected6.txt
    only_connected7.txt
    only_connected8.txt
    exercise_10-1.txt
    exercise_10-2.txt
    exercise_11.txt
    exercise_12.txt
  COMMAND cmake -E echo "dummy psql"
  COMMENT "running chapter sdg7 scripts"
)
