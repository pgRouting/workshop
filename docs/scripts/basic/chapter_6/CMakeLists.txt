add_custom_target(basic_chapter_6_scripts)

#---------------------
# Files
#---------------------
configure_file(all_exercises.sql all_exercises.sql)
configure_file(images.sql images.sql)

#----------------------------------------------
# Generating the results files
#---------------------------------------------

add_custom_command(
  TARGET basic_chapter_6_scripts
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

 COMMAND psql -d city_routing -f all_exercises.sql
 COMMAND psql -d city_routing -f images.sql
 COMMENT "running chapter 6 scripts"
 DEPENDS section-6.1.sql)
