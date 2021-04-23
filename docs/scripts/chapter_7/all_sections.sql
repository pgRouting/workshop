
DROP VIEW IF EXISTS vehicle_net CASCADE;
DROP VIEW IF EXISTS taxi_net CASCADE;
DROP MATERIALIZED VIEW IF EXISTS walk_net CASCADE;
DROP FUNCTION IF EXISTS wrk_dijkstra(regclass, bigint, bigint);

\o exercise_7_1.txt

-- DROP VIEW vehicle_net CASCADE;

CREATE VIEW vehicle_net AS
  SELECT
    gid AS id,
    source_osm AS source, target_osm AS target,
    cost_s AS cost, reverse_cost_s AS reverse_cost,
    name, length_m, the_geom
  FROM ways JOIN configuration AS c
  USING (tag_id)
  WHERE  c.tag_value NOT IN ('steps','footway','path');

-- Verification1
SELECT count(*) FROM ways;
SELECT count(*) FROM vehicle_net;

\o exercise_7_2.txt

-- DROP VIEW taxi_net;

CREATE VIEW taxi_net AS
    SELECT
      id,
      source, target,
      cost * 0.90 AS cost, reverse_cost * 0.90 AS reverse_cost,
      name, length_m, the_geom
    FROM vehicle_net
    WHERE vehicle_net.the_geom && ST_MakeEnvelope(@PGR_WORKSHOP_LITTLE_NET_BBOX@);

-- Verification2
SELECT count(*) FROM taxi_net;


\o exercise_7_3.txt

-- DROP MATERIALIZED VIEW walk_net;

CREATE MATERIALIZED VIEW walk_net AS
  SELECT
    gid AS id,
    source_osm AS source, target_osm AS target,
    length_m / 2 AS cost, length_m / 2 AS reverse_cost,
    name, length_m, the_geom
  FROM ways JOIN configuration AS c
  USING (tag_id)
  WHERE  c.tag_value NOT IN ('motorway','primary');

-- Verification3
SELECT count(*) FROM taxi_net;

\o exercise_7_4.txt

SELECT seq, edge AS id, cost AS seconds
FROM pgr_dijkstra(
    'SELECT * FROM vehicle_net',
    @OSMID_3@, @OSMID_1@);

-- For taxi_net

SELECT seq, edge AS id, cost AS seconds
FROM pgr_dijkstra(
    'SELECT * FROM taxi_net',
    @OSMID_3@, @OSMID_1@);

-- For walk_net

SELECT seq, edge AS id, cost AS seconds
FROM pgr_dijkstra(
    'SELECT * FROM walk_net',
    @OSMID_3@, @OSMID_1@);

\o exercise_7_5.txt

SELECT
  results.*,
  name, length_m
FROM (
  SELECT seq, edge AS id, cost AS seconds
  FROM pgr_dijkstra(
      'SELECT * FROM vehicle_net',
      @OSMID_3@, @OSMID_1@)
  ) AS results
LEFT JOIN vehicle_net
  USING (id)
ORDER BY seq;

\o exercise_7_6.txt

WITH results AS (
  SELECT seq, edge AS id, cost AS seconds
  FROM pgr_dijkstra(
      'SELECT * FROM vehicle_net',
      @OSMID_3@, @OSMID_1@)
  )
SELECT
  results.*,
  ST_AsText(the_geom) AS route_readable
FROM results
LEFT JOIN vehicle_net
  USING (id)
ORDER BY seq;


\o exercise_7_7.txt


WITH results AS (
  SELECT seq, edge AS id, cost AS seconds
  FROM pgr_dijkstra(
      'SELECT * FROM vehicle_net',
      @OSMID_3@, @OSMID_1@)
  )
SELECT
  results.*,
  the_geom AS route_geom
FROM results
LEFT JOIN vehicle_net
  USING (id)
ORDER BY seq;

\o exercise_7_8.txt


WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_3@),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_1@))
),
get_geom AS (
    SELECT dijkstra.*, name, the_geom AS route_geom
    FROM dijkstra JOIN vehicle_net ON (edge = id)
    ORDER BY seq)
SELECT seq, name, cost,
    -- calculating the azimuth
    degrees(ST_azimuth(ST_StartPoint(route_geom), ST_EndPoint(route_geom))) AS azimuth,
    ST_AsText(route_geom),
    route_geom
FROM get_geom
ORDER BY seq;


\o exercise_7_9.txt


WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT * FROM vehicle_net',
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_3@),
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = @OSMID_1@))
),
get_geom AS (
    SELECT dijkstra.*, name,
        -- adjusting directionality
        CASE
            WHEN dijkstra.node = source THEN the_geom
            ELSE ST_Reverse(the_geom)
        END AS route_geom
    FROM dijkstra JOIN vehicle_net ON (edge = id)
    ORDER BY seq)
SELECT seq, name, cost,
    degrees(ST_azimuth(ST_StartPoint(route_geom), ST_EndPoint(route_geom))) AS azimuth,
    ST_AsText(route_geom),
    route_geom
FROM get_geom
ORDER BY seq;

\o exercise_7_10.txt

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
            'SELECT * FROM ' || $1,
            $2,
            $3)
    ),
    get_geom AS (
        SELECT dijkstra.*, name,
            CASE
                WHEN dijkstra.node = source THEN the_geom
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

\o exercise_7_11.txt

SELECT *
FROM wrk_dijkstra('vehicle_net',  @OSMID_3@, @OSMID_1@);


