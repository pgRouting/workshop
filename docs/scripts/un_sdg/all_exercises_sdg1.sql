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
