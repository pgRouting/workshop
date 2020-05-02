
DROP TABLE IF EXISTS ad_7;
DROP TABLE IF EXISTS ad_8;
DROP TABLE IF EXISTS ad_9;
DROP TABLE IF EXISTS ad_10a;
DROP TABLE IF EXISTS ad_10b;
DROP TABLE IF EXISTS ad_11;


/*
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413) -- venue
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61441749) -- airport
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912) -- brewery
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61493634) -- market
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 1718017636) -- westing
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 2481136250) -- aquarium
*/

SELECT a.*, the_geom INTO ad_7 FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s AS reverse_cost
        FROM ways',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413) -- venue
    ,
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912) -- brewery
    ,
    directed := true) a join ways on a.edge = ways.gid;



SELECT a.*, the_geom INTO ad_8 FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s AS reverse_cost
        FROM ways',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912) -- brewery
    ,
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413) -- venue
    ,
    directed := true) a join ways on a.edge = ways.gid;





SELECT a.*, the_geom INTO ad_9 FROM pgr_dijkstra('
    SELECT gid AS id,
        source,
        target,
        cost_s / 3600 * 100 AS cost,
        reverse_cost_s / 3600 * 100 AS reverse_cost
        FROM ways',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912) -- brewery
    ,
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413) -- venue
    ,
    directed := true) a join ways on a.edge = ways.gid;


SELECT DISTINCT tag_key FROM osm_way_classes;
SELECT * FROM osm_way_classes;


SELECT a.*, the_geom INTO ad_10 FROM pgr_dijkstra($$
    SELECT ways.gid AS id,
        source,
        target,
        CASE
            WHEN c.name IN ('pedestrian','steps','footway') THEN -1 
            ELSE cost_s
        END AS cost,
        CASE
            WHEN c.name IN ('pedestrian','steps','footway') THEN -1 
            ELSE reverse_cost_s
        END AS reverse_cost
        FROM ways JOIN osm_way_classes AS c
        USING (class_id)$$,

    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912) -- brewery
    ,
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413) -- venue
    ,
    directed := true) a join ways on a.edge = ways.gid;



ALTER TABLE osm_way_classes ADD COLUMN penalty FLOAT;
-- No penalty
UPDATE osm_way_classes SET penalty=1;
-- Dont's use this roads (edges with costs with negative values not used)
UPDATE osm_way_classes SET penalty=-1 WHERE name IN ('pedestrian','steps','footway');
-- Double the costs
UPDATE osm_way_classes SET penalty=2.0 WHERE name IN ('cicleway','living_street','path');
UPDATE osm_way_classes SET penalty=0.8 WHERE name IN ('secondary','tertiary');
UPDATE osm_way_classes SET penalty=0.6 WHERE name IN ('primary','primary_link');
UPDATE osm_way_classes SET penalty=0.4 WHERE name IN ('trunk','trunk_link');
-- Encuraging the use of "fast" roads
UPDATE osm_way_classes SET penalty=0.3 WHERE name IN ('motorway','motorway_junction','motorway_link');


SELECT a.*, the_geom INTO ad_11 FROM pgr_dijkstra('
    SELECT ways.gid AS id,
        source,
        target,
        cost_s * penalty AS cost,
        reverse_cost_s * penalty AS reverse_cost
    FROM ways JOIN osm_way_classes
    USING (class_id)',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912) -- brewery
    ,
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413) -- venue
    ,
    directed := true) a join ways on a.edge = ways.gid;



