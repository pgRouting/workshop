-- Enumerate all the schemas
\dn


-- Show the current search path
SHOW search_path;

-- Set the search path
SET search_path TO waterways,public;
SHOW search_path;


-- Enumerate all the tables
\dt
\o Exercise_1.txt
CREATE TABLE city_vertex (id BIGINT, name TEXT, geom geometry);
INSERT INTO city_vertex(id, name, geom) VALUES (
5,'Munshigang', ST_SetSRID(ST_Point(89.1967,22.2675),4326));
\o Exercise_6.txt
SELECT count(*) FROM waterways_ways;
\o Exercise_7.txt
DELETE FROM waterways_ways 
WHERE osm_id 
IN (721133202, 908102930, 749173392, 652172284, 126774195, 720395312);
\o Exercise_8.txt
-- Add a column for storing the component
ALTER TABLE waterways_ways_vertices_pgr
ADD COLUMN component INTEGER;

ALTER TABLE waterways_ways
ADD COLUMN component INTEGER;
-- Get the Connected Components of Waterways
UPDATE waterways_ways_vertices_pgr SET component = subquery.component
FROM (SELECT * FROM pgr_connectedComponents(
'SELECT gid AS id, source, target, cost, reverse_cost FROM waterways_ways')
) AS subquery
WHERE id = node;

UPDATE waterways_ways SET component=a.component FROM (
SELECT id, component FROM waterways_ways_vertices_pgr
) AS a  
WHERE id = source;
\o Exercise_9.txt
-- Adding column to store Buffer geometry
ALTER TABLE waterways.city_vertex
ADD COLUMN city_buffer geometry;
-- Storing Buffer geometry
UPDATE waterways.city_vertex 
SET city_buffer = ST_Buffer((geom),0.005) 
WHERE  name = 'Munshigang';
-- Showing results of Buffer operation
SELECT city_buffer FROM waterways.city_vertex;
\o Exercise_10.txt
CREATE OR REPLACE FUNCTION get_city_buffer(city_id INTEGER)
RETURNS geometry AS
$BODY$                                                                         
SELECT city_buffer FROM city_vertex WHERE id = city_id;
$BODY$
LANGUAGE SQL;
\o Exercise_11.txt
-- Intersection of City Buffer and River Components
SELECT DISTINCT component
FROM waterways.city_vertex, waterways.waterways_ways
WHERE ST_Intersects(the_geom, get_city_buffer(5));
\o Exercise_12.txt
-- Buffer of River Components
ALTER TABLE waterways_ways
ADD COLUMN rain_zone geometry;
-- Storing Buffer geometry (rain_zone)
UPDATE waterways.waterways_ways 
SET rain_zone = ST_Buffer((the_geom),0.005) 
WHERE ST_Intersects(the_geom, get_city_buffer(5));
\o Exercise_13.txt
-- Combining mutliple rain zones
SELECT ST_Union(rain_zone) AS Combined_Rain_Zone
FROM waterways_ways;
\o

