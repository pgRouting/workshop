..
  ****************************************************************************
  pgRouting Workshop Manual Copyright(c) pgRouting Contributors

  This documentation is licensed under a Creative Commons Attribution-Share
  Alike 3.0 License: http://creativecommons.org/licenses/by-sa/3.0/
  ****************************************************************************

Sustainable Cities and Communities
###############################################################################

`Sustainable Cities and Communities` is the 11th Sustainable Development Goal which
aspires to make cities inclusive, safe, resilient and sustainable.The world is 
becoming increasingly urbanized. Since 2007, more than half the world’s
population has been living in cities. This makes it very important for the cities
to remain alert when there is a chance of disaster like floods. Local 
administration should know if their city is going to get affected by the rains
which happen in their proximity so that they can raise an alert amongst the citizens.
This exercise will solve one of such problems.

.. image:: images/sdg11/un_sdg11.png 
  :align: center
  :alt: Sustainable Development Goal 11: Sustainable Cities and Communities

`Image Source <https://sdgs.un.org/goals/goal11>`__

.. contents:: Chapter Contents

Problem: City getting affected by rain or not
================================================================================

**Problem Statement**

To determine the areas where if it rains will affect a city/town

.. image:: images/sdg11/sdg11_output.png 
  :align: center
  :scale: 50%

**Core Idea** 

If it rains in vicinity of a river connecting the city, the city will get 
affected by the rains.

**Approach**

* Choose a city
* Get the Rivers (Edges) 
* Create river components
* Create a Buffer around the city
* Finding the components intersecting the buffer
* Finding the rain zones



 
Choose a city
--------------------------------------------------------------------------------
For this exercise, Munshigang city from Bangladesh is chosen. This city has multiple 
rivers in its proximity which makes it an apt location to demonstrate this exercise. 
The exercise will try to find the areas, where if it rains the city will be affected.
To define the location of this city and use it in for further steps, create a table to
store the name along with latitude and longitude values of City's location. This stores
the city as a point.

**Exercise 1: Create a point for the city**

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o Exercise_1.txt
    :end-before:  \o Exercise_6.txt
    :language: sql
    :linenos:
    
:ref:`Query results for Chapter 4 Exercise 1`

Latitude and longitude values are converted into ``geometry`` form using ST_Point 
which returns a point with the given X and Y coordinate values. ST_SetSRID is used 
to set the SRID (Spatial Reference Identifier) on the point geometry to 4326.


Pre-processing waterways data
--------------------------------------------------------------------------------
First step is to pre-process the data obtained from :ref:`Data for Sustainable Development Goals`
This section will work the graph that is going to be used for processing. While 
building the graph, the data has to be inspected to determine if there is any 
invalid data. This is a very important step to make sure that the data is of 
requires quality. pgRouting can also be used to do some Data Adjustments. 
This will be discussed in further sections.

Setting the Search Path of Waterways
...............................................................................
First step in pre processing is to set the search path for our downloaded data.
Search path is a list of schemas helps the system determine how a particular table 
is to be imported. In this case, search path of waterways table is set to ``waterways`` 
schema and ``waterways.xml`` configuration file as we say in Chapter 2.3. ``\dn`` 
is used to list down all the present schemas. ``SHOW search_path`` command shows 
the current search path. ``SET search_path`` is used to set the search path to 
``Waterways``. Finally, ``\dt`` is used to verify if the  Schema have been 
changed correctly.

**Exercise 2: Inspecting the schemas**

.. code-block:: bash

        \dn

.. code-block:: bash

           List of schemas
           Name    |  Owner   
        -----------+----------
         public    | postgres
         waterway  | <user-name>
        (2 rows)

The schema names are ``waterway``  and ``public``. The owner depends on who has the rights to the database. 

**Exercise 3: Inspecting the** ``search path``

.. code-block:: bash

        SHOW search_path;

.. code-block:: bash

           search_path   
        -----------------
         "$user", public
        (1 row)

This is the current search path. Tables cannot be accessed using this.

**Exercise 4: Fixing the** ``search path``

.. code-block:: bash

        SET search_path TO waterways,public;
        SHOW search_path;

.. code-block:: bash

            search_path    
        -------------------
         waterways, public
        (1 row)

**Exercise 5: Enumerating tables**

.. code-block:: bash

        \dt

.. code-block:: bash

                             List of relations
          Schema   |            Name             | Type  |  Owner  
        -----------+-----------------------------+-------+---------
         public    | spatial_ref_sys             | table | <user-name>
         waterways | configuration               | table | user
         waterways | waterways_pointsofinterest  | table | user
         waterways | waterways_ways              | table | user
         waterways | waterways_ways_vertices_pgr | table | user
        (5 rows)


**Exercise 6: Counting the number of Waterways**

Counting the number of edges present in the gives the information if the amount 
of data. Also, some of the rows can be seen to  understand the sructure of the 
table and how the data is stored in it.


.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o Exercise_6.txt
    :end-before:  \o Exercise_7.txt
    :language: sql
    :linenos:   
 
:ref:`Query results for Chapter 4 Exercise 6`

Removing the Rivers which are not on land
...............................................................................
This exercise focusses only the areas on land, where if it rains the city is 
affected. Hence the rivers which are there in the swamp area have to be removed
from the ``waterways_ways`` table.

**Exercise 7: Removing the Rivers which are not on land**

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o Exercise_7.txt
    :end-before:  \o Exercise_8.txt
    :language: sql
    :linenos:
 

:ref:`Query results for Chapter 4 Exercise 7`

Process to get Connected Components of Waterways
--------------------------------------------------------------------------------
As the rivers in the data are not having single edge, i.e, multiple edges make up 
a river, it is important to find out the connected edges and store the information
in the ``waterways_ways`` table. This will help us to identify which edges belong to
a river. First, the connected components are found and then stored in a new column 
named ``component``. 

**Exercise 8: Process to get Connected Components of Waterways**

1. Add a column named ``component`` to store component number.

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: -- Add a column for storing the component
    :end-before: \o Exercise_9.txt
    :language: sql 
    :linenos:

:ref:`Query results for Chapter 4 Exercise 8`

pgr_connectedComponents for preprocessing waterways
...............................................................................
For the next step ``pgr_connectedComponents`` will be used. It is used to find the 
connected components of an undirected graph using a Depth First Search-based approach.
`pgr_connectedComponents Documentation <https://docs.pgrouting.org/3.1/en/pgr_connectedComponents.html>`__ 
can be found at this link for more information.

Get the Connected Components of Waterways
...............................................................................

pgRouting function ``pgr_connectedComponents`` is used to complete this task.
A sub-query is created to find out all the connected components. After that,
the ``component`` column is updated using the results obtained from the sub-query.
This helps in storing the component id in the ``waterways_ways_vertices_pgr`` table.
Next query uses this output and stores the component id in the  waterways_ways
(edges) table.

**Exercise 9: Get the Connected Components of Waterways**

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: \o Exercise_9.txt
    :end-before:  \o Exercise_10.txt
    :language: sql
    :linenos:  

With component id stored in both vertex and edge table of waterways, lets proceed 
to next step.

:ref:`Query results for Chapter 4 Exercise 9`  

Create a Buffer around city
--------------------------------------------------------------------------------
Create a buffer around the city to define an area, inside which the intersection 
of rivers would be found. ``ST_Buffer`` is used to create this buffer.

**Exercise 10: Creating buffer around the city**

1.  Adding column to store Buffer geometry

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after:  -- Adding column to store Buffer geometry
    :end-before:   -- Storing Buffer geometry      
    :language: sql
    :linenos:

2. Storing Buffer geometry

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after:  -- Storing Buffer geometry
    :end-before:   -- Showing results of Buffer operation      
    :language: sql
    :linenos:

3. Showing results of Buffer operation

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after:  -- Showing results of Buffer operation
    :end-before:   \o Exercise_11.txt       
    :language: sql
    :linenos:

:ref:`Query results for Chapter 4 Exercise 10`  

A function can be created for the same task. this will be helpfun when the table 
has more than one city.

**Exercise 11: Creating a function that gets the city buffer**

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after:  \o Exercise_11.txt
    :end-before:   \o Exercise_12.txt  
    :linenos:


Finding the components intersecting the buffer
...............................................................................
Next ste is to find the components of waterways which lie in the buffer zone of 
the city. These are the waterways which will affect the city when it rains around 
them. This is done using `ST_Intersects`.

**Exercise 12: Finding the components intersecting the buffer**

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: -- Intersection of City Buffer and River Components
    :end-before:  \o Exercise_13.txt
    :language: sql
    :linenos:    
    
Output shows the distinct component numbers which lie in the buffer zone of the city.
Next step is to get all the edges that have those components.

:ref:`Query results for Chapter 4 Exercise 12`  

Create a Buffer around the river components to get the rain zones
--------------------------------------------------------------------------------
This is the final step of the exercise. In this, the area where if it rains, the 
city would be affected, also can be called as `rain zone` is being found. 
First, add columns named `rain_zone` in waterways_ways to store buffer geometry
of the rain zones. Then, find the buffer for every edge which intersects the buffer
area using ST_Buffer and update the `rain_zone` column.

**Exercise 13: Create a Buffer around the river components to get the rain zones**

1. Adding column to store Buffer geometry

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: -- Buffer of River Components
    :end-before:  -- Storing Buffer geometry      
    :language: sql 
    :linenos:

2. Storing Buffer geometry

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: -- Storing Buffer geometry
    :end-before:  \o      
    :language: sql 
    :linenos:

:ref:`Query results for Chapter 4 Exercise 13`

This will give us the requires area, where if it rains, the city will be affected. 
Multiple polygons that are obtained can also be merged using ST_Union. This will give
a single polygon as the output.

**Exercise 14: Create a union of rain zones**

.. literalinclude:: ../scripts/un_sdg/sdg11/all_exercises_sdg11.sql
    :start-after: -- Combining mutliple rain zones
    :end-before:  \o     
    :language: sql  
    :linenos:

:ref:`Query results for Chapter 4 Exercise 14`

