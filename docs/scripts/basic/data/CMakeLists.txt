# Script for basic/data chapter
configure_file(data.sh data.sh)

add_custom_command(
  OUTPUT data.txt
  COMMAND bash data.sh > data.txt
)

add_custom_target(basic_data_scripts
  DEPENDS "data.txt"
)
