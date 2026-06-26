add_custom_target(basic_sql_function_scripts)

#---------------------
# Files
#---------------------
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
    helpers.txt

  COMMAND psql -d city_routing -f sql_function.sql
  COMMENT "running sql function scripts"
  DEPENDS sql_function.sql)
