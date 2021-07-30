\o output_all_exercises_sdg1.txt
-- Enumerate all the schemas
\dn


-- Show the current search path
SHOW search_path;

-- Set the search path
SET search_path TO roads,buildings,public;
SHOW search_path;


-- Enumerate all the tables
\dt


-- Counting the number of Edges of roads
SELECT count(*) FROM roads_ways;

-- Counting the number of Vertices of roads
SELECT count(*) FROM roads_ways_vertices_pgr;


-- Counting the number of buildings 
SELECT count(*) FROM buildings_ways;


-- Showing the structure of the table
\dS+ buildings_ways

--Add a spatial column to the table
SELECT AddGeometryColumn ('buildings','buildings_ways','poly_geom',4326,'POLYGON',2);


-- Removing the geometries that are not polygons 
DELETE FROM buildings_ways 
WHERE ST_NumPoints(the_geom) < 4 
OR ST_IsClosed(the_geom) = false;


-- Creatinthe polygons
UPDATE buildings_ways 
SET poly_geom = ST_MakePolygon(the_geom);


-- Adding a column for storing the area
ALTER TABLE buildings_ways
ADD COLUMN area INTEGER;


-- Calculating the area
UPDATE buildings_ways 
SET area = ST_Area(poly_geom::geography)::INTEGER;



-- Function for computing the population based on the area of the polygon

-- Negligible: People donot live in these places. But the default is 1 because of homeless people.
-- Very Sparse: People donot live in these places. But the deafault is 2 because there may be people guarding the place.
-- Sparse: Considering the universities and college because the students live there.
-- Moderate: A family unit housing kind of location.
-- Dense: A meduim sized residential building.
-- Very Dense: A large sized resiential building.
-- All these are estimations based on this particular area. 
-- More complicated functions can be done that consider height of the apartments but the design of a function is 
-- going to depend on the availability of the data. For example, using census data can achieve more accurate estimation.

CREATE OR REPLACE FUNCTION  population(tag_id INTEGER,area INTEGER)
RETURNS INTEGER AS 
$BODY$
DECLARE 
population INTEGER;
BEGIN 
  IF tag_id <= 30 THEN population = 1; -- Negligible
  ELSIF 10 < tag_id AND tag_id < 100 THEN  population = GREATEST(2, area * 0.0002); -- Very Sparse
  ELSIF 100 < tag_id AND tag_id < 200 THEN  population = GREATEST(3, area * 0.002); -- Sparse
  ELSIF 200 < tag_id AND tag_id < 400 THEN population = GREATEST(5,  area * 0.05); -- Moderate
  ELSIF 400 < tag_id AND tag_id < 600  THEN population = GREATEST(7, area * 0.7); -- Dense
  ELSIF tag_id > 600  THEN population = GREATEST(10,area * 1); -- Very Dense
  ELSE population = 1;
  END IF;
  RETURN population;
END;
$BODY$
LANGUAGE plpgsql;

-- Adding a column for storing the population
ALTER TABLE buildings_ways
ADD COLUMN population INTEGER;


-- Storing the population
UPDATE buildings_ways 
SET population = population(tag_id,area)::INTEGER;



























\o
