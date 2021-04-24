
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

WITH results AS (
  SELECT seq, edge AS id, cost AS seconds,
    node
  FROM pgr_dijkstra(
      'SELECT * FROM vehicle_net',
      @OSMID_3@, @OSMID_1@)
  )
SELECT
  seq, id, seconds,
  CASE
      WHEN node = source THEN ST_AsText(the_geom)
      ELSE ST_AsText(ST_Reverse(the_geom))
  END AS route_readable,

  CASE
      WHEN node = source THEN the_geom
      ELSE ST_Reverse(the_geom)
  END AS route_geom

FROM results
LEFT JOIN vehicle_net USING (id)
ORDER BY seq;

\o exercise_7_9.txt

WITH
results AS (
  SELECT seq, edge AS id, cost AS seconds,
    node
  FROM pgr_dijkstra(
      'SELECT * FROM vehicle_net',
      @OSMID_3@, @OSMID_1@)
  ),
additional AS (
  SELECT
    seq, id, seconds,
    CASE
        WHEN node = source THEN ST_AsText(the_geom)
        ELSE ST_AsText(ST_Reverse(the_geom))
    END AS route_readable,

    CASE
        WHEN node = source THEN the_geom
        ELSE ST_Reverse(the_geom)
    END AS route_geom

  FROM results
  LEFT JOIN ways ON (gid = id)
)
SELECT seq, id, seconds,
  degrees(ST_azimuth(ST_StartPoint(route_geom), ST_EndPoint(route_geom))) AS azimuth
FROM additional
ORDER BY seq;

\o exercise_7_10.txt
-- DROP FUNCTION wrk_dijkstra(regclass, bigint, bigint);

CREATE OR REPLACE FUNCTION wrk_dijkstra(
        IN edges_subset REGCLASS,
        IN source BIGINT,  -- in terms of osm_id
        IN target BIGINT,  -- in terms of osm_id
        OUT seq INTEGER,
        OUT id BIGINT,
        OUT seconds FLOAT,
        OUT name TEXT,
        OUT length_m FLOAT,
        OUT route_readable TEXT,
        OUT route_geom geometry,
        OUT azimuth FLOAT
    )
    RETURNS SETOF record AS
$BODY$
  WITH
  results AS (
    SELECT seq, edge AS id, cost AS seconds,
      node
    FROM pgr_dijkstra(
        'SELECT * FROM ' || edges_subset,
        source, target)
    ),
  additional AS (
    SELECT
      seq, id, seconds,
      name, length_m,
      CASE
          WHEN node = source THEN ST_AsText(the_geom)
          ELSE ST_AsText(ST_Reverse(the_geom))
      END AS route_readable,

      CASE
          WHEN node = source THEN the_geom
          ELSE ST_Reverse(the_geom)
      END AS route_geom

    FROM results
    LEFT JOIN ways ON (gid = id)
  )
  SELECT *,
    degrees(ST_azimuth(ST_StartPoint(route_geom), ST_EndPoint(route_geom))) AS azimuth
  FROM additional
  ORDER BY seq;
$BODY$
LANGUAGE 'sql';
\o exercise_7_11.txt

SELECT *
FROM wrk_dijkstra('vehicle_net',  @OSMID_3@, @OSMID_1@);

SELECT *
FROM wrk_dijkstra('taxi_net',  @OSMID_3@, @OSMID_1@);

SELECT *
FROM wrk_dijkstra('walk_net',  @OSMID_3@, @OSMID_1@);


