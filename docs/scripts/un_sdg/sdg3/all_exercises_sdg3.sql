\o setting_search_path.txt
-- Enumerate all the schemas
\dn

-- Show the current search path
SHOW search_path;

-- Set the search path
SET search_path TO roads,buildings,public;
SHOW search_path;


-- Enumerate all the tables
\dt


\o count_roads_and_buildings.txt
-- Counting the number of Edges of roads
SELECT count(*) FROM roads_ways;

-- Counting the number of Vertices of roads
SELECT count(*) FROM roads_ways_vertices_pgr;


-- Counting the number of buildings 
SELECT count(*) FROM buildings_ways;


-- Showing the structure of the table
\dS+ buildings_ways


\o preprocessing_buildings.txt

--Add a spatial column to the table
SELECT AddGeometryColumn ('buildings','buildings_ways','poly_geom',4326,'POLYGON',2);


-- Removing the geometries that are not polygons 
DELETE FROM buildings_ways 
WHERE ST_NumPoints(the_geom) < 4 
OR ST_IsClosed(the_geom) = false;


-- Creating the polygons
UPDATE buildings_ways 
SET poly_geom = ST_MakePolygon(the_geom);



\o buildings_population_calculation.txt
-- Adding a column for storing the area
ALTER TABLE buildings_ways
ADD COLUMN area INTEGER;


-- Calculating the area
UPDATE buildings_ways 
SET area = ST_Area(poly_geom::geography)::INTEGER;




-- UN SDG3: Good Health and Well Being

-- population_function_from_here

CREATE OR REPLACE FUNCTION  population(tag_id INTEGER,area INTEGER)
RETURNS INTEGER AS 
$BODY$
DECLARE 
population INTEGER;
BEGIN 
  IF tag_id <= 100 THEN population = 1; -- Negligible
  ELSIF 100 < tag_id AND tag_id <= 200 THEN  population = GREATEST(2, area * 0.0002); -- Very Sparse
  ELSIF 200 < tag_id AND tag_id <= 300 THEN  population = GREATEST(3, area * 0.002); -- Sparse
  ELSIF 300 < tag_id AND tag_id <= 400 THEN population = GREATEST(5,  area * 0.05); -- Moderate
  ELSIF 400 < tag_id AND tag_id <= 500  THEN population = GREATEST(7, area * 0.7); -- Dense
  ELSIF tag_id > 500  THEN population = GREATEST(10,area * 1); -- Very Dense
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

-- population_function_to_here

\o discard_disconnected_roads.txt

-- Process to discard disconnected roads

-- Add a column for storing the component
ALTER TABLE roads_ways_vertices_pgr
ADD COLUMN component INTEGER;

-- Update the vertices with the component number
UPDATE roads_ways_vertices_pgr set component = subquery.component
FROM (SELECT * FROM pgr_connectedComponents('SELECT gid AS id, source, target, cost, reverse_cost FROM roads_ways')) AS subquery
WHERE id = node;

-- These components are to be removed
WITH
subquery AS (SELECT component, count(*) FROM roads_ways_vertices_pgr GROUP BY component)
SELECT component FROM subquery where count != (SELECT max(count) FROM subquery);

-- The edges that need to be removed
WITH
subquery AS (SELECT component, count(*) FROM roads_ways_vertices_pgr GROUP BY component),
to_remove AS (SELECT component FROM subquery where count != (SELECT max(count) FROM subquery))
SELECT id FROM roads_ways_vertices_pgr WHERE component IN (SELECT * FROM to_remove);

-- Removing the unwanted edges
DELETE FROM roads_ways WHERE source IN (
WITH
subquery AS (SELECT component, count(*) FROM roads_ways_vertices_pgr GROUP BY component),
to_remove AS (SELECT component FROM subquery where count != (SELECT max(count) FROM subquery))
SELECT id FROM roads_ways_vertices_pgr WHERE component IN (SELECT * FROM to_remove)
);

-- Deleting unused vertices
WITH
subquery AS (SELECT component, count(*) FROM roads_ways_vertices_pgr GROUP BY component),
to_remove AS (SELECT component FROM subquery where count != (SELECT max(count) FROM subquery))
DELETE FROM roads_ways_vertices_pgr WHERE component IN (SELECT * FROM to_remove);



\o population_residing_along_the_road.txt

-- Calculating the population residing along the road

-- nearest_road_from_here

-- Create Function for finding the nearest edge
CREATE OR REPLACE FUNCTION closest_edge(geom GEOMETRY)
RETURNS BIGINT AS
$BODY$
SELECT gid FROM roads_ways ORDER BY geom <-> the_geom LIMIT 1;
$BODY$
LANGUAGE SQL;

-- Add a column for storing the nearest edge
ALTER TABLE buildings_ways
ADD COLUMN edge_id INTEGER;

-- Store the edge_id of the nearest edge in the column
UPDATE buildings_ways SET edge_id = closest_edge(poly_geom);

-- nearest_road_to_here

-- road_population_from_here

-- Add population column to roads table
ALTER TABLE roads_ways
ADD COLUMN population INTEGER;

-- Update the roads with the sum of population of buildings nearest to it
UPDATE roads_ways set population = sum
FROM (SELECT edge_id, sum(population) FROM buildings_ways GROUP BY edge_id) AS subquery
WHERE gid = edge_id;                                                                                                              
               
-- testing
SELECT population FROM roads_ways WHERE gid = 441;


-- road_population_to_here




















\o
