-- Calculating the population residing along the road

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
SELECT gid AS building_id, closest_edge(poly_geom) AS edge_id FROM buildings_ways;

-- Add population column to roads table
ALTER TABLE roads_ways
ADD COLUMN population INTEGER;

-- Update the roads with the sum of population of buildings nearest to it
UPDATE roads_ways set population = sum
FROM (SELECT edge_id, sum(population) FROM buildings_ways GROUP BY edge_id) AS SUBQUERY
WHERE gid = edge_id;                                                                                                              
               
