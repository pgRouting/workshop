add_custom_target(basic_chapter_7_scripts)

#---------------------
# Files
#---------------------
configure_file(all_sections.sql all_sections.sql)

#----------------------------------------------
# Generating the results files
#---------------------------------------------

add_custom_command(
  TARGET basic_chapter_7_scripts
  PRE_BUILD
  BYPRODUCTS
    exercise_7_1.txt
    exercise_7_2.txt
    exercise_7_3.txt
    exercise_7_4.txt
    exercise_7_5.txt
    exercise_7_6.txt
    exercise_7_7.txt
    exercise_7_8.txt
    exercise_7_9.txt
    exercise_7_10.txt
    exercise_7_11.txt
  COMMAND psql -d city_routing -f all_sections.sql
  COMMENT "running chapter 7 scripts"
  DEPENDS all_sections.sql
  )
