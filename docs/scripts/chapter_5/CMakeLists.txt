

#---------------------
# Files
#---------------------
set(PGR_WORKSHOP_FILES
  "section-5.1.sh"
  "section-5.1.1.sql"
  "section-5.1.2.sql"
  "section-5.1.3.sql"
  "section-5.1.4.sql"
  "section-5.2.1.sql"
  "section-5.2.1.sql"
    )


#---------------------------------------------
# Adding the documentation files
#---------------------------------------------

foreach (f ${PGR_WORKSHOP_FILES})
    if (PGR_WORKSHOP_VERBOSE_DEBUG)
        message(STATUS "    Adding file ${f}")
    endif()
    configure_file(${f} ${f})
endforeach()

#----------------------------------------------
# 5.1 Identifiers for the Queries
#---------------------------------------------

add_custom_command(
    OUTPUT section-5.1-1.txt

    COMMAND bash section-5.1.sh > section-5.1-1.txt

    DEPENDS section-5.1-1.txt

    )

#----------------------------------------------
# 5.1.1 Exercise 1 - Single pedestrian routing.
#---------------------------------------------

add_custom_command(
  OUTPUT section-5.1.1.txt

  COMMAND psql -d city_routing -f section5.1.1.sql

  DEPENDS section-5.1.1.sql
  )

#----------------------------------------------
# 5.1.2 Exercise 2 - Many Pedestrians going to the same destination
#---------------------------------------------

add_custom_command(
  OUTPUT section-5.1.2.txt

  COMMAND psql -d city_routing -f section-5.1.2.sql 

  DEPENDS section-5.1.2.sql
  )

#----------------------------------------------
# 5.1.3 Exercise 3 - Many Pedestrians departing from the same location
#---------------------------------------------

add_custom_command(
  OUTPUT section-5.1.3.txt

  COMMAND psql -d city_routing -f section-5.1.3.sql 

  DEPENDS section-5.1.3.sql
  )

#----------------------------------------------
# 5.1.4 Exercise 4 - Many Pedestrians going to different destinations
#---------------------------------------------

add_custom_command(
  OUTPUT section-5.1.4.txt

  COMMAND psql -d city_routing -f section-5.1.4.sql 

  DEPENDS section-5.1.4.sql
  )

#----------------------------------------------
# 5.2.1 Exercise 5 - Many Pedestrians going to 
# different destinations returning aggregate costs.
#---------------------------------------------

add_custom_command(
  OUTPUT section-5.2.1.txt

  COMMAND psql -d city_routing -f section-5.2.1.sql 

  DEPENDS section-5.2.1.sql
  )

#---------------------------------------------
# 5.2.2 Exercise 6 -  Exercise 6 - Many Pedestrians 
# going to different destinations summarizing the 
# total costs per departure
#---------------------------------------------

add_custom_command(
  OUTPUT section-5.2.2.txt

  COMMAND psql -d city_routing -f section-5.2.2.sql 

  DEPENDS section-5.2.2.sql
  )

add_custom_target(chapter_5_scripts
  DEPENDS "section-5.1-1.txt"
  DEPENDS "section-5.1.1.txt"
  DEPENDS "section-5.1.2.txt"
  DEPENDS "section-5.1.3.txt"
  DEPENDS "section-5.1.4.txt"
  DEPENDS "section-5.2.1.txt"
  DEPENDS "section-5.2.2.txt"
  )
