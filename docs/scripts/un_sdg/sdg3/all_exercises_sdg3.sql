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


\o Exercise_5.txt
-- Counting the number of Edges of roads
SELECT COUNT(*) FROM roads_ways;

-- Counting the number of Vertices of roads
SELECT COUNT(*) FROM roads_ways_vertices_pgr;

-- Counting the number of buildings 
SELECT COUNT(*) FROM buildings_ways;
\o Exercise_6.txt
--Add a spatial column to the table
SELECT AddGeometryColumn('buildings','buildings_ways','poly_geom',4326,'POLYGON',2);
\o Exercise_7.txt 
DELETE FROM buildings_ways 
WHERE ST_NumPoints(the_geom) < 4 
OR ST_IsClosed(the_geom) = FALSE;
\o Exercise_8.txt 
UPDATE buildings_ways 
SET poly_geom = ST_MakePolygon(the_geom);
\o Exercise_9.txt 
-- Adding a column for storing the area
ALTER TABLE buildings_ways
ADD COLUMN area INTEGER;
-- Storing the area
UPDATE buildings_ways 
SET area = ST_Area(poly_geom::geography)::INTEGER;
-- Process to discard disconnected roads
\o Exercise_10.txt
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
\o Exercise_11.txt
-- These components are to be removed
WITH
subquery AS (
	SELECT component, COUNT(*) 
	FROM roads_ways_vertices_pgr 
	GROUP BY component
	)
SELECT component FROM subquery 
WHERE COUNT != (SELECT max(COUNT) FROM subquery);
\o Exercise_12.txt
-- The edges that need to be removed
WITH
subquery AS (
	SELECT component, COUNT(*) 
	FROM roads_ways_vertices_pgr 
	GROUP BY component
	),
to_remove AS (
	SELECT component FROM subquery 
	WHERE COUNT != (SELECT max(COUNT) FROM subquery)
	)
SELECT id FROM roads_ways_vertices_pgr 
WHERE component IN (SELECT * FROM to_remove);
\o Exercise_13.txt
-- Removing the unwanted edges
DELETE FROM roads_ways WHERE source IN (
	WITH
	subquery AS (
		SELECT component, COUNT(*) 
		FROM roads_ways_vertices_pgr 
		GROUP BY component
		),
	to_remove AS (
		SELECT component FROM subquery 
		WHERE COUNT != (SELECT max(COUNT) FROM subquery)
		)
	SELECT id FROM roads_ways_vertices_pgr 
	WHERE component IN (SELECT * FROM to_remove)
);
-- Removing unused vertices
WITH
subquery AS (
	SELECT component, COUNT(*) 
	FROM roads_ways_vertices_pgr 
	GROUP BY component
	),
to_remove AS (
	SELECT component FROM subquery 
	WHERE COUNT != (SELECT max(COUNT) FROM subquery)
	)
DELETE FROM roads_ways_vertices_pgr 
WHERE component IN (SELECT * FROM to_remove);
-- finding the service area
\o nearest_vertex.txt
-- finding the closest road vertex
CREATE OR REPLACE FUNCTION closest_vertex(geom GEOMETRY)
RETURNS BIGINT AS
$BODY$
SELECT id FROM roads_ways_vertices_pgr ORDER BY geom <-> the_geom LIMIT 1;
$BODY$
LANGUAGE SQL;
-- service area
\o Exercise_15.txt
SELECT gid,source,target,agg_cost,r.the_geom
FROM pgr_drivingDistance(
        'SELECT gid as id,source,target, length_m/60 AS cost,length_m/60 AS reverse_cost 
        FROM roads.roads_ways',
        (SELECT closest_vertex(poly_geom) 
        FROM buildings.buildings_ways 
        WHERE tag_id = '318'
        ), 10, FALSE
      ), roads.roads_ways AS r
WHERE edge = r.gid 
LIMIT 10;
\o Exercise_16.txt
WITH subquery AS (
SELECT r.gid, edge,source,target,agg_cost,r.the_geom 
FROM pgr_drivingDistance(
        'SELECT gid as id,source,target, length_m/60 AS cost, length_m/60 AS reverse_cost 
        FROM roads.roads_ways',
        (SELECT closest_vertex(poly_geom) 
        FROM buildings.buildings_ways 
        WHERE tag_id = '318'
        ), 10, FALSE
      ),roads.roads_ways AS r
WHERE edge = r.gid)
SELECT r.gid, s.source, s.target, s.agg_cost,r.the_geom 
FROM subquery AS s, roads.roads_ways AS r 
WHERE r.source = s.source OR r.target = s.target
ORDER BY r.gid
LIMIT 10;
-- Calculating the population residing along the road

\o Exercise_17.txt
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

-- nearest_road_from_here
\o Exercise_18.txt
-- Create Function for finding the closest edge
CREATE OR REPLACE FUNCTION closest_edge(geom GEOMETRY)
RETURNS BIGINT AS
$BODY$
SELECT gid FROM roads_ways ORDER BY geom <-> the_geom LIMIT 1;
$BODY$
LANGUAGE SQL;
-- Add a column for storing the closest edge
ALTER TABLE buildings_ways
ADD COLUMN edge_id INTEGER;
-- Store the edge_id of the closest edge in the column
UPDATE buildings_ways SET edge_id = closest_edge(poly_geom);
-- nearest_road_to_here
\o Exercise_19.txt
-- road_population_from_here
-- Add population column to roads table
ALTER TABLE roads_ways
ADD COLUMN population INTEGER;
-- Update the roads with the SUM of population of buildings closest to it
UPDATE roads_ways SET population = SUM
FROM (
	SELECT edge_id, SUM(population) 
	FROM buildings_ways GROUP BY edge_id
	) 
AS subquery 
WHERE gid = edge_id;                                                                                                                       
-- testing
SELECT population FROM roads_ways WHERE gid = 441;
-- road_population_to_here
\o Exercise_20.txt
-- finding total population
WITH subquery
AS (
	WITH subquery AS (
	SELECT r.gid,source,target,agg_cost, r.population,r.the_geom 
	FROM pgr_drivingDistance(
		    'SELECT gid as id,source,target, length_m/60 AS cost, length_m/60 AS reverse_cost 
		    FROM roads.roads_ways',
		    (SELECT closest_vertex(poly_geom) 
		    FROM buildings.buildings_ways 
		    WHERE tag_id = '318'
		    ), 10, FALSE
		  ),roads.roads_ways AS r
	WHERE edge = r.gid)
	SELECT r.gid, r.the_geom, s.population
	FROM subquery AS s,roads.roads_ways AS r 
	WHERE r.source = s.source OR r.target = s.target
	)
SELECT SUM(population) FROM subquery;
\o
