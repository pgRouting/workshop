add_custom_target(chapter_6_scripts)

#---------------------
# Files
#---------------------
configure_file(section-6.1.sql section-6.1.sql)

#----------------------------------------------
# Generating the results files
#---------------------------------------------

add_custom_command(
  TARGET chapter_6_scripts
  PRE_BUILD
  BYPRODUCTS
    section-6.1-1.txt
    section-6.1-2.txt
    section-6.1.1.txt
    section-6.1.2.txt
    section-6.1.3.txt
  COMMAND psql -d city_routing -f section-6.1.sql
  COMMENT "running chapter 6 scripts"
  DEPENDS section-6.1.sql)

