\o setting_search_path.txt
-- Enumerate all the schemas
\dn


-- Show the current search path
SHOW search_path;

-- Set the search path
SET search_path TO waterways, city, public;
SHOW search_path;


-- Enumerate all the tables
\dt

\o count_waterways_and_cities.txt
-- Counting the number of Edges of waterways
select * from waterways_ways where tag_id < 200; 

-- Counting the number of Vertices of waterways
SELECT count(*) FROM waterways_ways_vertices_pgr;


-- Counting the number of Vertices of town
select * from osm_nodes where tag_name ='place' and tag_value = 'town';


\o connected_components.txt

-- Process to discard disconnected waterways

-- Add a column for storing the component
ALTER TABLE waterways_ways
ADD COLUMN component INTEGER;

-- Update the vertices with the component number
UPDATE waterways_ways set component = subquery.component
FROM (SELECT * FROM pgr_connectedComponents('SELECT gid AS id, source, target, cost, reverse_cost FROM waterways_ways')) AS subquery
WHERE gid = node;

-- These components are to be removed
WITH
subquery AS (SELECT component, count(*) FROM waterways_ways GROUP BY component)
SELECT component FROM subquery where count != (SELECT max(count) FROM subquery);

-- The edges that need to be removed
WITH
subquery AS (SELECT component, count(*) FROM waterways_ways GROUP BY component),
to_remove AS (SELECT component FROM subquery where count != (SELECT max(count) FROM subquery))
SELECT gid FROM waterways_ways WHERE component IN (SELECT * FROM to_remove);

-- Removing the unwanted edges
DELETE FROM waterways_ways WHERE source IN (
WITH
subquery AS (SELECT component, count(*) FROM waterways_ways GROUP BY component),
to_remove AS (SELECT component FROM subquery where count != (SELECT max(count) FROM subquery))
SELECT gid FROM waterways_ways WHERE component IN (SELECT * FROM to_remove)
);


\o creating_buffers.txt

-- Creating buffers for city
SELECT osm_id,st_buffer((the_geom),0.005) as buffer_zone
FROM city.osm_nodes where tag_name ='place' and tag_value = 'town';


-- Function for calculating Buffer (To be corrected)

CREATE OR REPLACE FUNCTION  buffer_city(city INTEGER,buffer_distance INTEGER)
RETURNS GEOMETRY AS 
$BODY$
DECLARE 
buffer_zone GEOMETRY;
buffer_distance INTEGER;

BEGIN 
  SELECT osm_id,st_buffer((the_geom),buffer_distance/111) as buffer_zone --ST_BUFFER takes input on degrees. 1 degree = 111km, therefore x km = x/111 degrees.
  FROM city.osm_nodes where tag_name ='place' and tag_value = 'town';
  RETURN buffer_zone;
END;
$BODY$
LANGUAGE plpgsql;

-- Intersection of City Buffer and River Components

select c.buffer_zone, w.component
from waterways_ways as w, city.osm_nodes as c
where c.tag_name ='place' and c.tag_value = 'town';
and st_intersects(c.buffer_zone,w.the_geom)

-- Buffer of River Components

SELECT gid,st_buffer((the_geom),0.005) as rain_zone
FROM waterways_ways where waterways_ways.component is not null;



















\o

