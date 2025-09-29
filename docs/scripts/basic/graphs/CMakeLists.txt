add_custom_target(basic_graphs_scripts)

#---------------------
# Files
#---------------------
configure_file(graphs.sql graphs.sql)

#----------------------------------------------
# Generating the results files
#---------------------------------------------

add_custom_command(
  TARGET basic_graphs_scripts
  PRE_BUILD
  BYPRODUCTS

  create_vertices.txt
  vertices_description.txt
  selected_rows.txt
  fill_columns_1.txt
  fill_columns_2.txt
  fill_columns_3.txt
  fill_columns_4.txt
  fill_columns_5.txt
  fill_columns_6.txt
  set_components1.txt
  set_components2.txt
  set_components3.txt
  see_components1.txt
  see_components2.txt
  see_components3.txt
  see_components4.txt
  create_vehicle_net1.txt
  create_vehicle_net2.txt
  create_vehicle_net3.txt
  create_taxi_net1.txt
  create_taxi_net2.txt
  create_taxi_net3.txt
  create_walk_net1.txt
  create_walk_net2.txt
  create_walk_net3.txt
  test_view1.txt
  test_view2.txt
  test_view3.txt

  COMMAND psql -d city_routing -f graphs.sql
  COMMENT "running graphs scripts"
  DEPENDS graphs.sql
)
