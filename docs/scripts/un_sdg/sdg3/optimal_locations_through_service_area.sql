-- Proposed Methodology. Code needs to be corrected (03.08.21)


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






