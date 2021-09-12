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
UPDATE roads_ways_vertices_pgr 
SET component = subquery.component 
FROM (
	SELECT * FROM pgr_connectedComponents(
		'SELECT gid AS id, source, target, cost, reverse_cost 
		FROM roads_ways'
			)
		) 
AS subquery
WHERE id = node;

-- These components are to be removed
WITH
subquery AS (
	SELECT component, count(*) 
	FROM roads_ways_vertices_pgr 
	GROUP BY component
	)
SELECT component FROM subquery 
WHERE count != (SELECT max(count) FROM subquery);

-- The edges that need to be removed
WITH
subquery AS (
	SELECT component, count(*) 
	FROM roads_ways_vertices_pgr 
	GROUP BY component
	),
to_remove AS (
	SELECT component FROM subquery 
	WHERE count != (SELECT max(count) FROM subquery)
	)
SELECT id FROM roads_ways_vertices_pgr 
WHERE component IN (SELECT * FROM to_remove);

-- Removing the unwanted edges
DELETE FROM roads_ways WHERE source IN (
	WITH
	subquery AS (
		SELECT component, count(*) 
		FROM roads_ways_vertices_pgr 
		GROUP BY component
		),
to_remove AS (
		SELECT component FROM subquery 
		WHERE count != (SELECT max(count) FROM subquery)
		)
	SELECT id FROM roads_ways_vertices_pgr 
	WHERE component IN (SELECT * FROM to_remove)
);

-- Deleting unused vertices
WITH
subquery AS (
	SELECT component, count(*) 
	FROM roads_ways_vertices_pgr 
	GROUP BY component
	),
to_remove AS (
	SELECT com ponent FROM subquery 
	WHERE count != (SELECT max(count) FROM subquery)
	)
DELETE FROM roads_ways_vertices_pgr 
WHERE component IN (SELECT * FROM to_remove);

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
UPDATE roads_ways SET population = sum
FROM (SELECT edge_id, sum(population) FROM buildings_ways GROUP BY edge_id) AS subquery
WHERE gid = edge_id;                                                                                                              
               
-- testing
SELECT population FROM roads_ways WHERE gid = 441;


-- road_population_to_here
/*
-- SOLVING THE PROBLEM 

-- Use pgr_DrivingDistance to get the vertices that go to the different locations.


-- Finding the Centroids of polygons

SELECT ST_AsText(ST_Centroid(buildings_ways.poly_geom));


-- Function for calculating Service area of each hospital
CREATE OR REPLACE FUNCTION  service_area(tag_id INTEGER)
RETURNS INTEGER AS 
$BODY$
DECLARE 
service_area GEOMETRY;
BEGIN 
  IF tag_id <= 318 THEN 
  CREATE TABLE distances AS (SELECT a.node AS id, a.agg_cost AS distance, b.the_geom
    FROM pgr_drivingDistance(
        SELECT ( AS id, source, target, population as cost, population as reverse_cost FROM roads_ways,
        Node1,
        Node2,
        true
    ) a, ways_vertices_pgr b WHERE a.node = b.id
	);
  END IF;
  RETURN service_area;
END;
$BODY$
LANGUAGE plpgsql;


-- Creatating a Table to store Service area of each hospital
DROP TABLE IF EXISTS distances;
CREATE TABLE distances (
    gid        INTEGER,
    service_area     GEOMETRY,
);

-- Calculating and storing Service area of each hospital
UPDATE distances 
SET service_area = service_area(tag_id)::GEOMETRY; 

-- Finding the areas which are not covered by current hospitals

	-- 1. Finding Polygons of the service area of the current hospitals
	-- 2. Finding intersection of the buildings and polygons with the service area


-- Proposing new locations for mobile hospitals

	-- 1. Checking availability of schools/universities/hotels/grounds for temporary hospital locations
	-- 2. If present, assigning the optimal locations to them.
	-- 3. Check the service area once again. If the service area cover the whole study area, Task is completed.
	
	-- Questions: 
		-- i. What if no schools/universities/hotels/grounds are available?
		-- ii. What is the service area of new polygon doesnot satisfy the needs of complete area?



*/














\o
