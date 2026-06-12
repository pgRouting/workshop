# Script for basic/graphs chapter
configure_file(pedestrian.sql pedestrian.sql)
configure_file(images.sql images.sql)

set(GENERATED_FILES
  combinations.txt
  get_id.txt
  many_to_many.txt
  many_to_one.txt
  note_1.txt
  one_to_many.txt
  one_to_one.txt
  dijkstracost.txt
)

#----------------------------------------------
# Generating the results files
#---------------------------------------------

add_custom_command(
  COMMAND psql -d city_routing -f pedestrian.sql
  COMMAND psql -d city_routing -f images.sql
  OUTPUT ${GENERATED_FILES}

  DEPENDS pedestrian.sql images.sql
  COMMENT "running chapter pedestrian scripts"
)

add_custom_target(basic_pedestrian_scripts
  DEPENDS ${GENERATED_FILES}
)
