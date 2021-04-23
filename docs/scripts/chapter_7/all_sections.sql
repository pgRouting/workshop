
DROP VIEW IF EXISTS taxi_net CASCADE;
DROP VIEW IF EXISTS vehicle_net CASCADE;
DROP FUNCTION IF EXISTS wrk_dijkstra(regclass, bigint, bigint);

\o section_7.1.1.txt

-- DROP VIEW vehicle_net CASCADE;

CREATE VIEW vehicle_net AS
  SELECT
    gid,
    source_osm AS source, target_osm AS target,
    cost_s AS cost, reverse_cost_s AS reverse_cost,
    length_m, the_geom
  FROM ways JOIN configuration AS c
  USING (tag_id)
  WHERE  c.tag_value NOT IN ('steps','footway','path');

-- Verification
SELECT count(*) FROM ways;
SELECT count(*) FROM vehicle_net;

\o section_7.1.2.txt

-- DROP VIEW taxi_net;

CREATE VIEW taxi_net AS
    SELECT *
    FROM vehicle_net
    WHERE vehicle_net.the_geom && ST_MakeEnvelope(@PGR_WORKSHOP_LITTLE_NET_BBOX@);

-- Verification
SELECT count(*) FROM taxi_net;


\o section_7.1.3.txt

SELECT *
FROM pgr_dijkstra(
    'SELECT gid AS id, * FROM vehicle_net',
    -- source
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_3@),
    -- target
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_1@));


\o section_7.1.4.txt

SELECT dijkstra.*, ways.name
FROM pgr_dijkstra(
    'SELECT gid AS id, * FROM vehicle_net',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_3@),
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_1@)
    ) AS dijkstra
LEFT JOIN ways
ON (edge = gid) ORDER BY seq;

\o section_7.2.1.txt

SELECT dijkstra.*, ways.name, ST_AsText(ways.the_geom)
FROM pgr_dijkstra(
    'SELECT gid AS id, * FROM vehicle_net',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_3@),
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_1@)
    ) AS dijkstra
LEFT JOIN ways
ON (edge = gid) ORDER BY seq;


\o section_7.2.2.txt


WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT gid AS id, * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_3@),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_1@))
)
SELECT dijkstra.*, ways.name, ways.the_geom AS route_geom
FROM dijkstra LEFT JOIN ways ON (edge = gid)
ORDER BY seq;


\o section_7.2.3.txt


WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT gid AS id, * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_3@),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_1@))
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


\o section_7.2.4.txt


WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT gid AS id, * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_3@),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_1@))
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

\o section_7.3.1.txt

--DROP FUNCTION wrk_dijkstra(regclass, bigint, bigint);

CREATE OR REPLACE FUNCTION wrk_dijkstra(
        IN edges_subset REGCLASS,
        IN source BIGINT,  -- in terms of osm_id
        IN target BIGINT,  -- in terms of osm_id
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
            'SELECT gid AS id, source, target, cost_s AS cost, reverse_cost_s AS reverse_cost FROM ' || $1,
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

\o section_7.3.2.txt

SELECT *
FROM wrk_dijkstra('vehicle_net',  @OSMID_3@, @OSMID_1@);


