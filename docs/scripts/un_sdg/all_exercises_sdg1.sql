\o all_exercises_sdg1.txt
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

-- Add a spatial column to the table
SELECT AddGeometryColumn ('buildings','buildings_ways','poly_geom',4326,'POLYGON',2);

-- Removing the geometries that are not polygons 
DELETE FROM buildings_ways WHERE ST_NumPoints(the_geom) < 4 OR ST_IsClosed(the_geom) = false;

-- Creating the polygons
UPDATE buildings_ways SET poly_geom = ST_MakePolygon(the_geom);

ALTER TABLE buildings_ways
ADD COLUMN area INTEGER;


UPDATE buildings_ways SET area = ST_Area(poly_geom::geography)::INTEGER;


CREATE OR REPLACE FUNCTION  population(tag_id INTEGER,area INTEGER)
RETURNS INTEGER AS 
$BODY$
DECLARE 
population INTEGER;
BEGIN 
  IF tag_id < 120 THEN population = area * 1;
  ELSIF tag_id < 130 THEN population = area * 2;
  ELSIF tag_id < 150 THEN population = area * 0.8;
  ELSE population = area * 3;
  END IF;
  RETURN population;
END;
$BODY$
LANGUAGE plpgsql;






























\o
