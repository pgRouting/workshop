#---------------------
# Files
#---------------------
add_custom_target(basic_withPoints_scripts)

configure_file(withPoints.sql withPoints.sql)

add_custom_command(
  TARGET basic_withPoints_scripts
  PRE_BUILD
  BYPRODUCTS
    closestedges.txt
    route_withPoints.txt
    wrk_withPoints.txt
    use_fn_1.txt
    use_fn_2.txt
    use_fn_3.txt
    file_end.txt
    warnings.txt

  COMMAND psql -d city_routing -f withPoints.sql 2> warnings.txt
  COMMENT "running chapter withPoints scripts"
  DEPENDS withPoints.sql
)
