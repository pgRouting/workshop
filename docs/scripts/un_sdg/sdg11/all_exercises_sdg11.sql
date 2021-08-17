\o setting_search_path.txt
-- Enumerate all the schemas
\dn


-- Show the current search path
SHOW search_path;

-- Set the search path
SET search_path TO waterways,roads,buildings,public;
SHOW search_path;


-- Enumerate all the tables
\dt

\o count_waterways_roads_and_buildings.txt
-- Counting the number of Edges of waterways
SELECT count(*) FROM waterways_ways;

-- Counting the number of Vertices of waterways
SELECT count(*) FROM waterways_ways_vertices_pgr;


-- Counting the number of Edges of roads
SELECT count(*) FROM roads_ways;

-- Counting the number of Vertices of roads
SELECT count(*) FROM roads_ways_vertices_pgr;

-- Counting the number of buildings 
SELECT count(*) FROM buildings_ways;


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



























\o

