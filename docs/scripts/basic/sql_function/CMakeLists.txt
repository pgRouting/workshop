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
    wrong_directionality.txt
    fix_directionality.txt
    good_directionality.txt
    use_directionality.txt
    using_fn1.txt
    using_fn2.txt
    using_fn3.txt

  COMMAND psql -d city_routing -f sql_function.sql
  COMMENT "running sql function scripts"
)
