
DROP VIEW IF EXISTS little_net;
DROP VIEW IF EXISTS vehicle_net;
-- DROP FUNCTION IF EXISTS wrk_dijkstra_heading(regclass, bigint, bigint);

\o ch7-e1.txt

-- DROP VIEW vehicle_net CASCADE;

CREATE VIEW vehicle_net AS
    SELECT gid AS id,
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

\o ch7-e2.txt

-- DROP VIEW little_net;

CREATE VIEW little_net AS
    SELECT *
    FROM vehicle_net
    WHERE vehicle_net.the_geom && ST_MakeEnvelope(-71.05, 42.34,-71.03, 42.36);

-- Verification
SELECT count(*) FROM little_net;


\o ch7-e3.txt

SELECT *
FROM pgr_dijkstra(
    'SELECT * FROM vehicle_net',
    -- source
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
    -- target
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912));


\o ch7-e4.txt

SELECT dijkstra.*, ways.name
FROM pgr_dijkstra(
    'SELECT * FROM vehicle_net',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912)
    ) AS dijkstra
LEFT JOIN ways
ON (edge = gid) ORDER BY seq;

\o ch7-e5.txt

SELECT dijkstra.*, ways.name, ST_AsText(ways.the_geom)
FROM pgr_dijkstra(
    'SELECT * FROM vehicle_net',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912)
    ) AS dijkstra
LEFT JOIN ways
ON (edge = gid) ORDER BY seq;


\o ch7-e6.txt


WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912))
)
SELECT dijkstra.*, ways.name, ways.the_geom AS route_geom 
FROM dijkstra LEFT JOIN ways ON (edge = gid)
ORDER BY seq;


\o ch7-e7.txt


WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912))
),
get_geom AS (
    SELECT dijkstra.*, ways.name, ways.the_geom AS route_geom 
    FROM dijkstra JOIN ways ON (edge = gid)
    ORDER BY seq)
SELECT seq, name, cost,
    -- calculating the azimuth
    ST_azimuth(ST_StartPoint(route_geom), ST_EndPoint(route_geom)) AS azimuth,
    ST_AsText(route_geom),
    route_geom
FROM get_geom
ORDER BY seq;


\o ch7-e8.txt


WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT * FROM vehicle_net',
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
    ST_azimuth(ST_StartPoint(route_geom), ST_EndPoint(route_geom)) AS azimuth,
    ST_AsText(route_geom),
    route_geom
FROM get_geom
ORDER BY seq;

\o ch7-e9.txt

--DROP FUNCTION wrk_dijkstra(regclass, bigint, bigint);

CREATE OR REPLACE FUNCTION wrk_dijkstra_heading(
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
            'SELECT * FROM ' || $1,
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
        ST_azimuth(ST_StartPoint(route_geom), ST_EndPoint(route_geom)) AS azimuth,
        ST_AsText(route_geom),
        route_geom
    FROM get_geom
    ORDER BY seq;
$BODY$
LANGUAGE 'sql';

\o ch7-e10.txt

SELECT *
FROM wrk_dijkstra_heading('vehicle_net',  61350413, 61479912);

\o tmp.txt
\o

