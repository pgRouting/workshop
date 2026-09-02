add_custom_target(basic_pedestrian_scripts DEPENDS pedestrian.sql)

configure_file(pedestrian.sql pedestrian.sql)

add_custom_command(
  TARGET basic_pedestrian_scripts
  PRE_BUILD
  BYPRODUCTS
    combinations.txt
    get_id.txt
    many_to_many.txt
    many_to_one.txt
    note_1.txt
    one_to_many.txt
    one_to_one.txt
    one_to_one_view.txt
    dijkstracost.txt
    stars.txt

  COMMAND cmake -E echo "dummy psql"
  COMMENT "running chapter pedestrian scripts")
