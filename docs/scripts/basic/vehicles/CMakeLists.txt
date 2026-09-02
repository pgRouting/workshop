add_custom_target(basic_vehicles_scripts DEPENDS vehicles.sql)

configure_file(vehicles.sql vehicles.sql)

add_custom_command(
  TARGET basic_vehicles_scripts
  PRE_BUILD
  BYPRODUCTS
    oneway_cost.txt
    oneway_revc.txt
    route_going.txt
    route_coming.txt
    time_is_money.txt
    add_penalty.txt
    create_penalized_view.txt
    use_penalty.txt
    same_result_as_comming.txt
    update_penalty.txt
    show_penalties.txt
    get_penalized_route.txt
    time_in_secs.txt
    vehicles_end.txt

  COMMAND cmake -E echo "dummy psql"
  COMMENT "running vehicles scripts")
