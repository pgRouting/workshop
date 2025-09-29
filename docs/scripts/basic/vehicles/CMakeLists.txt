add_custom_target(basic_vehicles_scripts)

#---------------------
# Files
#---------------------
configure_file(vehicles.sql vehicles.sql)
configure_file(images.sql images.sql)

#----------------------------------------------
# Generating the results files
#---------------------------------------------

add_custom_command(
  TARGET basic_vehicles_scripts
  PRE_BUILD
  BYPRODUCTS
    section-6.1-1.txt
    section-6.1-2.txt
    section-6.1.1.txt
    section-6.1.2.txt
    section-6.1.3.txt
    section-6.2-1.txt
    section-6.2-2.txt
    section-6.2-3.txt
    section-6.2.1.txt
    section-6.2.2-1.txt
    section-6.2.2-2.txt
    section-6.6.txt

 COMMAND psql -d city_routing -f vehicles.sql
 COMMAND psql -d city_routing -f images.sql
 COMMENT "running vehicles scripts"
 DEPENDS vehicles.sql)
