add_custom_target(basic_sql_function_scripts DEPENDS sql_function.sql)

configure_file(sql_function.sql sql_function.sql)

add_custom_command(
  TARGET basic_sql_function_scripts
  PRE_BUILD
  BYPRODUCTS
    get_more_info.txt
    get_read_geom.txt
    get_geom.txt
    get_azimuth.txt
    wrong_directionality.txt
    fix_directionality.txt
    good_directionality.txt
    final_function.txt
    using_fn1.txt
    vw_initial.txt
    vw_fixed.txt
    vw_final.txt
    helpers.txt

  COMMAND cmake -E echo "dummy psql"
  COMMENT "running sql function scripts")
