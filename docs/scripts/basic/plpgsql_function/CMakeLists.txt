add_custom_target(basic_chapter_8_scripts)

#---------------------
# Files
#---------------------
configure_file(all-sections-8.sql all-sections-8.sql)

#---------------------------------------------
# Generating the results files
#---------------------------------------------

add_custom_command(
  TARGET basic_chapter_8_scripts
  PRE_BUILD
  BYPRODUCTS
    excercise-8_1_1.txt
    excercise-8_1_2.txt
    excercise-8_1_3.txt
    excercise-8_1_4.txt

    excercise-8_2_1.txt
    excercise-8_2_2.txt
    excercise-8_2_3.txt

    excercise-8_3_1.txt
    excercise-8_3_2.txt
    excercise-8_3_3.txt
    excercise-8_3_4.txt

    excercise-8_4.txt

    excercise-8_5_1.txt
    excercise-8_5_2.txt
    excercise-8_5_3.txt
    excercise-8_5_4.txt

    excercise-8_6.txt

    excercise-8_7_1.txt
    excercise-8_7_2.txt
    excercise-8_7_3.txt

    warnings.txt
  COMMAND psql -d city_routing -f all-sections-8.sql 2> warnings.txt
  COMMENT "running chapter 8 scripts"
  DEPENDS all-sections-8.sql
  )
