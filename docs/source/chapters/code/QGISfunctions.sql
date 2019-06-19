/*
.. |id_1| replace:: ``3363``
.. |id_2| replace:: ``14745``
.. |id_3| replace:: ``14441``
.. |id_4| replace:: ``6649``
.. |id_5| replace:: ``1175``
*/

DROP VIEW IF EXISTS d_0 ; CREATE VIEW d_0 AS 

SELECT osm_id, id FROM ways_vertices_pgr
WHERE osm_id IN (123392877, 255093299, 1886700005, 6159253045, 6498351588)
ORDER BY osm_id;

DROP VIEW IF EXISTS d_1 ; CREATE VIEW d_1 AS 


SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
        source,
        target,
        length AS cost
      FROM ways
    ',
    3363,
    14441,
    directed := false);





DROP VIEW IF EXISTS d_2 ; CREATE VIEW d_2 AS 


SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
        source,
        target,
        length_m AS cost
      FROM ways
    ',
    ARRAY[3363,14745],
    14441,
    directed := false);




DROP VIEW IF EXISTS d_3 ; CREATE VIEW d_3 AS 


SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
        source,
        target,
        length_m / 1.3 AS cost
      FROM ways
    ',
    14441,
    ARRAY[3363,14745],
    directed := false);




DROP VIEW IF EXISTS d_4 ; CREATE VIEW d_4 AS 



SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
       source,
       target,
       length_m / 1.3 / 60 AS cost
      FROM ways
    ',
    ARRAY[3363,14745],
    ARRAY[6649, 1175],
    directed := false);



DROP VIEW IF EXISTS d_5 ; CREATE VIEW d_5 AS 



SELECT *
FROM pgr_dijkstraCost(
    '
      SELECT gid AS id,
       source,
       target,
       length_m  / 1.3 / 60 AS cost
      FROM ways
    ',
    ARRAY[3363,14745],
    ARRAY[6649, 1175],
    directed := false);



DROP VIEW IF EXISTS d_6 ; CREATE VIEW d_6 AS 


SELECT start_vid, sum(agg_cost)
FROM pgr_dijkstraCost(
    '
      SELECT gid AS id,
        source,
        target,
        length_m  / 1.3 / 60 AS cost
      FROM ways
    ',
    ARRAY[3363,14745],
    ARRAY[6649, 1175],
    directed := false)
GROUP BY start_vid
ORDER BY start_vid;
/*
.. |id_1| replace:: ``3363``
.. |id_2| replace:: ``14745``
.. |id_3| replace:: ``14441``
.. |id_4| replace:: ``6649``
.. |id_5| replace:: ``1175``
*/

ALTER TABLE configuration DROP COLUMN IF EXISTS penalty;

DROP VIEW IF EXISTS ad_7 ; CREATE VIEW ad_7 AS 

SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s AS reverse_cost
        FROM ways',
    3363, 1175,
    directed := true);


DROP VIEW IF EXISTS ad_8 ; CREATE VIEW ad_8 AS 

SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s AS reverse_cost
        FROM ways',
    1175, 3363,
    directed := true);



DROP VIEW IF EXISTS ad_9 ; CREATE VIEW ad_9 AS 


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
        source,
        target,
        cost_s / 3600 * 100 AS cost,
        reverse_cost_s / 3600 * 100 AS reverse_cost
        FROM ways',
    1175, 3363);

DROP VIEW IF EXISTS info_1 ; CREATE VIEW info_1 AS 


SELECT tag_id, tag_key, tag_value FROM configuration ORDER BY tag_id;


DROP VIEW IF EXISTS info_2 ; CREATE VIEW info_2 AS 


SELECT distinct tag_id, tag_key, tag_value
FROM ways JOIN configuration USING (tag_id)
ORDER BY tag_id;




ALTER TABLE configuration ADD COLUMN penalty FLOAT;
-- No penalty
UPDATE configuration SET penalty=1;


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
        source,
        target,
        cost_s * penalty AS cost,
        reverse_cost_s * penalty AS reverse_cost
    FROM ways JOIN configuration
    USING (tag_id)',
    1175, 14441);




-- Not including pedestrian ways
UPDATE configuration SET penalty=-1.0 WHERE tag_value IN ('steps','footway','pedestrian');
-- Penalizing with 5 times the costs
UPDATE configuration SET penalty=5 WHERE tag_value IN ('residential');
-- Encuraging the use of "fast" roads
UPDATE configuration SET penalty=0.5 WHERE tag_value IN ('tertiary');
UPDATE configuration SET penalty=0.3 WHERE tag_value
IN ('primary','primary_link',
    'trunk','trunk_link',
    'motorway','motorway_junction','motorway_link',
    'secondary');

DROP VIEW IF EXISTS ad_11 ; CREATE VIEW ad_11 AS 

SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
        source,
        target,
        cost_s * penalty AS cost,
        reverse_cost_s * penalty AS reverse_cost
    FROM ways JOIN configuration
    USING (tag_id)',
    1175, 14441);






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
    FROM ways JOIN configuration AS c
    USING (tag_id)
    WHERE  c.tag_value NOT IN ('steps','footway','path');

-- Verification
SELECT count(*) FROM ways;
SELECT count(*) FROM vehicle_net;



-- DROP VIEW little_net;

CREATE VIEW little_net AS
    SELECT *
    FROM vehicle_net
    WHERE vehicle_net.the_geom && ST_MakeEnvelope(39.27, -6.79, 39.30, -6.83);

-- Verification
SELECT count(*) FROM little_net;


DROP VIEW IF EXISTS ch7_e3 ; CREATE VIEW ch7_e3 AS 

SELECT *
FROM pgr_dijkstra(
    'SELECT gid AS id, * FROM vehicle_net',
    -- source
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 252643343),
    -- target
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 302057309));


DROP VIEW IF EXISTS ch7_e4 ; CREATE VIEW ch7_e4 AS 

SELECT dijkstra.*, ways.name
FROM pgr_dijkstra(
    'SELECT gid AS id, * FROM vehicle_net',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 252643343),
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 302057309)
    ) AS dijkstra
LEFT JOIN ways
ON (edge = gid) ORDER BY seq;

DROP VIEW IF EXISTS ch7_e5 ; CREATE VIEW ch7_e5 AS 

SELECT dijkstra.*, ways.name, ST_AsText(ways.the_geom)
FROM pgr_dijkstra(
    'SELECT gid AS id, * FROM vehicle_net',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 252643343),
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 302057309)
    ) AS dijkstra
LEFT JOIN ways
ON (edge = gid) ORDER BY seq;


DROP VIEW IF EXISTS ch7_e6 ; CREATE VIEW ch7_e6 AS 


WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT gid AS id, * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 252643343),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 302057309))
)
SELECT dijkstra.*, ways.name, ways.the_geom AS route_geom
FROM dijkstra LEFT JOIN ways ON (edge = gid)
ORDER BY seq;


DROP VIEW IF EXISTS ch7_e7 ; CREATE VIEW ch7_e7 AS 


WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT gid AS id, * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 252643343),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 302057309))
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


DROP VIEW IF EXISTS ch7_e8 ; CREATE VIEW ch7_e8 AS 


WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT gid AS id, * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 252643343),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 302057309))
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
FROM wrk_dijkstra('vehicle_net',  252643343, 302057309);





DROP VIEW IF EXISTS ch8_e1 ; CREATE VIEW ch8_e1 AS 
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

DROP VIEW IF EXISTS ch8_e2 ; CREATE VIEW ch8_e2 AS 

-- Closest osm_id in the original graph
SELECT osm_id FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_SetSRID(ST_Point(39.291852, -6.811437), 4326) LIMIT 1;

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
    ORDER BY the_geom <-> ST_SetSRID(ST_Point(39.291852, -6.811437), 4326) LIMIT 1;

-- Closest osm_id in the little_net graph
WITH
vertices AS (
    SELECT * FROM ways_vertices_pgr
    WHERE id IN (
        SELECT source FROM little_net
        UNION
        SELECT target FROM little_net)
)
SELECT osm_id FROM vertices
    ORDER BY the_geom <-> ST_SetSRID(ST_Point(39.291852, -6.811437), 4326) LIMIT 1;


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

DROP VIEW IF EXISTS ch8_e4 ; CREATE VIEW ch8_e4 AS 


SELECT *  FROM wrk_fromAtoB(
    'vehicle_net',
    39.291852, -6.811437,
    39.287737, -6.811389);

SELECT *  FROM wrk_fromAtoB(
    'little_net',
    39.291852, -6.811437,
    39.287737, -6.811389);

-- saving results in a table
SELECT * INTO example
FROM wrk_fromAtoB(
    'ways',
    39.291852, -6.811437,
    39.287737, -6.811389);






