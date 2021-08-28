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

\o count_waterways_and_cities.txt
-- Counting the number of Edges of waterways
SELECT * FROM waterways_ways WHERE tag_id < 200; 

-- Counting the number of Vertices of waterways
SELECT count(*) FROM waterways_ways_vertices_pgr;


\o connected_components.txt

-- Add a column for storing the component
ALTER TABLE waterways_ways_vertices_pgr
ADD COLUMN component INTEGER;
ALTER TABLE waterways_ways
ADD COLUMN component INTEGER;

-- remove rivers on the swamp area (we want the rivers which are only on land)
DELETE FROM waterways_ways WHERE osm_id IN (721133202, 908102930, 749173392, 652172284, 126774195, 720395312);

-- Update the vertices with the component number
UPDATE waterways_ways_vertices_pgr set component = subquery.component
FROM (SELECT * FROM pgr_connectedComponents('SELECT gid AS id, source, target, cost, reverse_cost FROM waterways_ways')) AS subquery
WHERE id = node;

UPDATE waterways_ways set component=a.component FROM (SELECT id, component FROM waterways_ways_vertices_pgr) AS a  WHERE id = source;

-- Create a city
CREATE TABLE city_vertex (id BIGINT, name TEXT, geom geometry);
INSERT INTO city_vertex(id, name, geom) VALUES (5,'Munshigang', ST_SetSRID(ST_Point(89.1967,22.2675),4326));


\o creating_buffers_city.txt

-- Creating buffers for city

-- Adding column to store Buffer geometry
ALTER TABLE waterways.city_vertex
ADD COLUMN city_buffer geometry;

-- Storing Buffer geometry
UPDATE waterways.city_vertex SET city_buffer = ST_Buffer((geom),0.005) WHERE  name = 'Munshigang' ;

-- Showing results of Buffer operation
SELECT city_buffer FROM waterways.city_vertex;


-- Creating a function that gets the city_buffer (Usefull if the table has more than one city)
CREATE OR REPLACE FUNCTION get_city_buffer(city_id INTEGER)
RETURNS geometry AS
$BODY$                                                                         
SELECT city_buffer FROM city_vertex WHERE id = city_id;
$BODY$
LANGUAGE SQL;

\o Intersecting_components.txt

-- Intersection of City Buffer andiver Components
SELECT DISTINCT component
FROM waterways.city_vertex, waterways.waterways_ways
WHERE ST_Intersects(the_geom, get_city_buffer(5));

\o creating_rain_zones_buffers_waterways.txt
-- Buffer of River Components

-- Adding column to store Buffer geometry
ALTER TABLE waterways_ways
ADD COLUMN rain_zone geometry;

-- Storing Buffer geometry
UPDATE waterways.waterways_ways SET rain_zone = ST_Buffer((the_geom),0.005) WHERE waterways_ways.component IS NOT NULL;

-- Showing the zone, where if it rains,the city would be affected
SELECT rain_zone FROM waterways.waterways_ways;













\o

