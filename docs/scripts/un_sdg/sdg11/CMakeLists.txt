add_custom_target(un_sdg11_scripts DEPENDS sdg11.sql)

configure_file(sdg11.sql  sdg11.sql)

add_custom_command(
  TARGET un_sdg11_scripts
  PRE_BUILD
  BYPRODUCTS
    create_city1.txt
    create_city2.txt
    create_city3.txt
    create_city4.txt
    set_path.txt
    get_extensions.txt
    get_tables.txt
    exercise_6.txt
    delete1.txt
    delete2.txt
    only_connected1.txt
    only_connected2.txt
    only_connected3.txt
    only_connected4.txt
    only_connected5.txt
    exercise_10.txt
    exercise_11.txt
    get_rain_zone1.txt
    get_rain_zone2.txt
    exercise_13.txt
  COMMAND cmake -E echo "dummy psql"
  COMMENT "running sdg11 scripts"
)
