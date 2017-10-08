





SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length AS cost
        FROM ways',
    9411, 3986,
    directed := false);








SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length_m AS cost
        FROM ways',
    ARRAY[3986, 9411], 13009,
    directed := false);







SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length_m / 1.3 AS cost
        FROM ways',
    13009, ARRAY[3986, 9411],
    directed := false);








SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length_m / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[3986, 9411],
    ARRAY[8401, 12235],
    directed := false);







SELECT *
FROM pgr_dijkstraCost(
    'SELECT gid AS id,
         source,
         target,
         length_m  / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[3986, 9411],
    ARRAY[8401, 12235],
    directed := false);






SELECT end_vid, sum(agg_cost)
FROM pgr_dijkstraCost(
    'SELECT gid AS id,
    source,
    target,
    length_m  / 1.3 / 60 AS cost
    FROM ways',
    ARRAY[3986, 9411],
    ARRAY[8401, 12235],
    directed := false)
GROUP BY end_vid
ORDER BY end_vid;




SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s AS reverse_cost
        FROM ways',
    3986, 13009,
    directed := true);




SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s AS reverse_cost
        FROM ways',
    13009, 3986, directed := true);






SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
        source,
        target,
        cost_s / 3600 * 100 AS cost,
        reverse_cost_s / 3600 * 100 AS reverse_cost
        FROM ways',
     13009, 3986);




SELECT * FROM osm_way_types ORDER BY type_id;





SELECT * FROM osm_way_classes ORDER BY class_id;




SELECT * FROM pgr_dijkstra($$
    SELECT gid AS id,
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
    13009, 3986);




ALTER TABLE osm_way_classes ADD COLUMN penalty FLOAT;
-- No penalty
UPDATE osm_way_classes SET penalty=1;
-- Not including pedestrian ways
UPDATE osm_way_classes SET penalty=-1.0 WHERE name IN ('pedestrian','steps','footway');
-- Penalizing with double costs
UPDATE osm_way_classes SET penalty=1.5 WHERE name IN ('cicleway','living_street','path');
-- Encuraging the use of "fast" roads
UPDATE osm_way_classes SET penalty=0.8 WHERE name IN ('secondary','tertiary');
UPDATE osm_way_classes SET penalty=0.6 WHERE name IN ('primary','primary_link');
UPDATE osm_way_classes SET penalty=0.4 WHERE name IN ('trunk','trunk_link');
UPDATE osm_way_classes SET penalty=0.3 WHERE name IN ('motorway','motorway_junction','motorway_link');



SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
        source,
        target,
        cost_s * penalty AS cost,
        reverse_cost_s * penalty AS reverse_cost
    FROM ways JOIN osm_way_classes
    USING (class_id)',
    13009, 3986);






DROP VIEW IF EXISTS little_net CASCADE;
DROP VIEW IF EXISTS vehicle_net CASCADE;
-- DROP FUNCTION IF EXISTS wrk_dijkstra(regclass, bigint, bigint);



-- DROP VIEW vehicle_net CASCADE;

CREATE VIEW vehicle_net AS
    SELECT gid,
        source,
        target,
        -- converting to minutes
        cost_s / 60 AS cost,
        reverse_cost_s / 60 AS reverse_cost,
        the_geom
    FROM ways JOIN osm_way_classes AS c
    USING (class_id)
    WHERE  c.name NOT IN ('pedestrian','steps','footway','path');

-- Verification
SELECT count(*) FROM ways;
SELECT count(*) FROM vehicle_net;



-- DROP VIEW little_net;

CREATE VIEW little_net AS
    SELECT *
    FROM vehicle_net
    WHERE vehicle_net.the_geom && ST_MakeEnvelope(-71.05, 42.34,-71.03, 42.36);

-- Verification
SELECT count(*) FROM little_net;




SELECT *
FROM pgr_dijkstra(
    'SELECT gid AS id, * FROM vehicle_net',
    -- source
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
    -- target
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912));




SELECT dijkstra.*, ways.name
FROM pgr_dijkstra(
    'SELECT gid AS id, * FROM vehicle_net',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912)
    ) AS dijkstra
LEFT JOIN ways
ON (edge = gid) ORDER BY seq;



SELECT dijkstra.*, ways.name, ST_AsText(ways.the_geom)
FROM pgr_dijkstra(
    'SELECT gid AS id, * FROM vehicle_net',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912)
    ) AS dijkstra
LEFT JOIN ways
ON (edge = gid) ORDER BY seq;





WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT gid AS id, * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912))
)
SELECT dijkstra.*, ways.name, ways.the_geom AS route_geom 
FROM dijkstra LEFT JOIN ways ON (edge = gid)
ORDER BY seq;





WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT gid AS id, * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912))
),
get_geom AS (
    SELECT dijkstra.*, ways.name, ways.the_geom AS route_geom 
    FROM dijkstra JOIN ways ON (edge = gid)
    ORDER BY seq)
SELECT seq, name, cost,
    -- calculating the azimuth
    degrees(ST_azimuth(ST_StartPoint(route_geom), ST_EndPoint(route_geom))) AS azimuth,
    ST_AsText(route_geom),
    route_geom
FROM get_geom
ORDER BY seq;





WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT gid AS id, * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912))
),
get_geom AS (
    SELECT dijkstra.*, ways.name,
        -- adjusting directionality
        CASE
            WHEN dijkstra.node = ways.source THEN the_geom
            ELSE ST_Reverse(the_geom)
        END AS route_geom
    FROM dijkstra JOIN ways ON (edge = gid)
    ORDER BY seq)
SELECT seq, name, cost,
    degrees(ST_azimuth(ST_StartPoint(route_geom), ST_EndPoint(route_geom))) AS azimuth,
    ST_AsText(route_geom),
    route_geom
FROM get_geom
ORDER BY seq;



--DROP FUNCTION wrk_dijkstra(regclass, bigint, bigint);

CREATE OR REPLACE FUNCTION wrk_dijkstra(
        IN edges_subset regclass,
        IN source BIGINT,
        IN target BIGINT,
        OUT seq INTEGER,
        OUT gid BIGINT,
        OUT name TEXT,
        OUT cost FLOAT,
        OUT azimuth FLOAT,
        OUT route_readable TEXT,
        OUT route_geom geometry
    )
    RETURNS SETOF record AS
$BODY$
    WITH
    dijkstra AS (
        SELECT * FROM pgr_dijkstra(
            -- using parameters instead of specific values
            'SELECT gid AS id, * FROM ' || $1,
            (SELECT id FROM ways_vertices_pgr WHERE osm_id = $2),
            (SELECT id FROM ways_vertices_pgr WHERE osm_id = $3))
    ),
    get_geom AS (
        SELECT dijkstra.*, ways.name,
            CASE
                WHEN dijkstra.node = ways.source THEN the_geom
                ELSE ST_Reverse(the_geom)
            END AS route_geom
        FROM dijkstra JOIN ways ON (edge = gid)
        ORDER BY seq)
    SELECT
        seq,
        edge,  -- will get the name "gid"
        name,
        cost,
        degrees(ST_azimuth(ST_StartPoint(route_geom), ST_EndPoint(route_geom))) AS azimuth,
        ST_AsText(route_geom),
        route_geom
    FROM get_geom
    ORDER BY seq;
$BODY$
LANGUAGE 'sql';



SELECT *
FROM wrk_dijkstra('vehicle_net',  61350413, 61479912);






-- Number of vertices in the original graph
SELECT count(*) FROM ways_vertices_pgr;

-- Number of vertices in the vehicles_net graph
SELECT count(*) FROM ways_vertices_pgr
WHERE id IN (
    SELECT source FROM vehicle_net 
    UNION
    SELECT target FROM vehicle_net);

-- Number of vertices in the little_net graph
SELECT count(*) FROM ways_vertices_pgr
WHERE id IN (
    SELECT source FROM little_net 
    UNION
    SELECT target FROM little_net);



-- Closest osm_id in the original graph
SELECT osm_id FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_SetSRID(ST_Point(-71.04143, 42.35126), 4326) LIMIT 1;

-- Closest osm_id in the vehicle_net graph
WITH
vertices AS (
    SELECT * FROM ways_vertices_pgr
    WHERE id IN (
        SELECT source FROM vehicle_net
        UNION
        SELECT target FROM vehicle_net)
)
SELECT osm_id FROM vertices
    ORDER BY the_geom <-> ST_SetSRID(ST_Point(-71.04143, 42.35126), 4326) LIMIT 1;

-- Closest osm_id in the little_net graph
WITH
vertices AS (
    SELECT * FROM ways_vertices_pgr
    WHERE id IN (
        SELECT source FROM little_net
        UNION
        SELECT target FROM little_net)
)
SELECT osm_id FROM vertices;


-- DROP FUNCTION wrk_fromAtoB(varchar, numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION wrk_fromAtoB(
    IN edges_subset regclass,
    IN x1 numeric, IN y1 numeric,
    IN x2 numeric, IN y2 numeric,
    OUT seq INTEGER,
    OUT gid BIGINT,
    OUT name TEXT,
    OUT length FLOAT,
    OUT the_time FLOAT,
    OUT azimuth FLOAT,
    OUT geom geometry
)
RETURNS SETOF record AS
$BODY$
DECLARE
    final_query TEXT;
BEGIN
        
    final_query :=
        FORMAT( $$
            WITH
            vertices AS (
                SELECT * FROM ways_vertices_pgr
                WHERE id IN (
                    SELECT source FROM %1$I 
                    UNION
                    SELECT target FROM %1$I)
            ),
            dijkstra AS (
                SELECT *
                FROM wrk_dijkstra(
                    '%1$I',
                    -- source
                    (SELECT osm_id FROM vertices 
                        ORDER BY the_geom <-> ST_SetSRID(ST_Point(%2$s, %3$s), 4326) LIMIT 1),
                    -- target
                    (SELECT osm_id FROM vertices
                        ORDER BY the_geom <-> ST_SetSRID(ST_Point(%4$s, %5$s), 4326) LIMIT 1))
            )
            SELECT
                seq,
                dijkstra.gid,
                dijkstra.name,
                ways.length_m/1000.0 AS length,
                dijkstra.cost AS the_time,
                azimuth,
                route_geom AS geom
            FROM dijkstra JOIN ways USING (gid);$$,
        edges_subset, x1,y1,x2,y2); -- %1 to %5 of the FORMAT function
    RAISE notice '%', final_query;
    RETURN QUERY EXECUTE final_query;
END;
$BODY$
LANGUAGE 'plpgsql';




SELECT *  FROM wrk_fromAtoB(
    'vehicle_net',
    -71.04136, 42.35089,
    -71.03483, 42.34595);

SELECT *  FROM wrk_fromAtoB(
    'little_net',
    -71.04136, 42.35089,
    -71.03483, 42.34595);

SELECT *  FROM wrk_fromAtoB(
    'ways',
    -71.04136, 42.35089,
    -71.03483, 42.34595);






