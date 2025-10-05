add_custom_target(basic_sql_function_scripts)

#---------------------
# Files
#---------------------
configure_file(sql_function.sql sql_function.sql)
configure_file(images.sql images.sql)

#----------------------------------------------
# Generating the results files
#---------------------------------------------

add_custom_command(
  TARGET basic_sql_function_scripts
  PRE_BUILD
  BYPRODUCTS
    exercise_7_1.txt
    exercise_7_2.txt
    exercise_7_3.txt
    exercise_7_4.txt
    get_more_info.txt
    get_read_geom.txt
    get_geom.txt
    fix_directionality.txt
    use_directionality.txt
    create_function.txt
    exercise_7_11.txt
  COMMAND psql -d city_routing -f sql_function.sql
  COMMAND psql -d city_routing -f images.sql
  COMMENT "running sql function scripts"
  )
