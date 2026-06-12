#---------------------
# Files
#---------------------
configure_file(withPoints.sql withPoints.sql)
configure_file(images.sql images.sql)

set(GENERATED_FILES
    closestedges.txt
    route_withPoints.txt
    wrk_withPoints.txt
    use_fn_1.txt
    use_fn_2.txt
    use_fn_3.txt
    file_end.txt
    warnings.txt
)

add_custom_command(
  COMMAND psql -d city_routing -f withPoints.sql 2> warnings.txt
  COMMAND psql -d city_routing -f images.sql
  OUTPUT ${GENERATED_FILES}

  DEPENDS withPoints.sql images.sql
  COMMENT "running chapter withPoints scripts"
)

add_custom_target(basic_withPoints_scripts
  DEPENDS ${GENERATED_FILES}
)
