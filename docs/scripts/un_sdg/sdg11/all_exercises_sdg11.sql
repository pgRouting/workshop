\o setting_search_path.txt
-- Enumerate all the schemas
\dn


-- Show the current search path
SHOW search_path;

-- Set the search path
SET search_path TO waterways,public;
SHOW search_path;


-- Enumerate all the tables
\dt

\o count_waterways.txt
-- Counting the number of Edges of waterways
SELECT count(*) FROM waterways_ways;

-- Counting the number of Vertices of waterways
SELECT count(*) FROM waterways_ways_vertices_pgr;




























\o

