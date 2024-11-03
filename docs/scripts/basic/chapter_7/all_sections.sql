
DROP VIEW IF EXISTS vehicle_net CASCADE;
DROP VIEW IF EXISTS taxi_net CASCADE;
DROP MATERIALIZED VIEW IF EXISTS walk_net CASCADE;
DROP FUNCTION IF EXISTS wrk_dijkstra(regclass, bigint, bigint);

\o create_vertices.txt

SELECT * INTO ways_vertices
FROM pgr_extractVertices(
  'SELECT gid AS id, source_osm AS source, target_osm AS target
  FROM ways ORDER BY id');

\o vertices_description.txt
\dS+ ways_vertices
\o selected_rows.txt
SELECT * FROM ways_vertices Limit 10;

\o fill_columns_1.txt
SELECT count(*) FROM ways_vertices WHERE geom IS NULL;
\o fill_columns_2.txt
UPDATE ways_vertices SET geom = ST_startPoint(the_geom) FROM ways WHERE source_osm = id;
\o fill_columns_3.txt
SELECT count(*) FROM ways_vertices WHERE geom IS NULL;
\o fill_columns_4.txt
UPDATE ways_vertices SET geom = ST_endPoint(the_geom) FROM ways WHERE geom IS NULL AND target_osm = id;
\o fill_columns_5.txt
SELECT count(*) FROM ways_vertices WHERE geom IS NULL;
\o fill_columns_6.txt
UPDATE ways_vertices set (x,y) = (ST_X(geom), ST_Y(geom));


\o exercise_7_1.txt
ALTER TABLE ways ADD COLUMN component BIGINT;
ALTER TABLE ways_vertices ADD COLUMN component BIGINT;

UPDATE ways_vertices SET component = c.component
FROM (SELECT * FROM pgr_connectedComponents(
  'SELECT gid as id, source_osm AS source, target_osm AS target, cost, reverse_cost FROM ways'
)) AS c
WHERE id = node;

UPDATE ways SET component = v.component
FROM (SELECT id, component FROM ways_vertices) AS v
WHERE source_osm = v.id;

WITH allc AS (SELECT component, count(*) FROM ways GROUP BY component),
maxc AS (SELECT max(count) from allc)
SELECT * FROM allc WHERE count = (SELECT max FROM maxc);

-- DROP VIEW vehicle_net CASCADE;

CREATE VIEW vehicle_net AS

WITH allc AS (SELECT component, count(*) FROM ways GROUP BY component),
maxcount AS (SELECT max(count) from allc),
the_component AS (SELECT component FROM allc WHERE count = (SELECT max FROM maxcount))

SELECT
  gid AS id,
  source_osm AS source, target_osm AS target, -- line 6
  cost_s AS cost, reverse_cost_s AS reverse_cost, -- line 7
  name, length_m AS length, the_geom AS geom
FROM ways JOIN the_component USING (component) JOIN configuration USING (tag_id)
WHERE  tag_value NOT IN ('steps','footway','path','cycleway');

-- Verification1
SELECT count(*) FROM ways;
SELECT count(*) FROM vehicle_net;

\dS+ vehicle_net


\o exercise_7_2.txt

-- DROP VIEW taxi_net;

CREATE VIEW taxi_net AS
    SELECT
      id,
      source, target,
      cost * 1.10 AS cost, reverse_cost * 1.10 AS reverse_cost,
      name, length, geom
    FROM vehicle_net
    WHERE vehicle_net.geom && ST_MakeEnvelope(@PGR_WORKSHOP_LITTLE_NET_BBOX@);

-- Verification2
SELECT count(*) FROM taxi_net;
\dS+ taxi_net


\o exercise_7_3.txt

-- DROP MATERIALIZED VIEW walk_net CASCADE;

CREATE MATERIALIZED VIEW walk_net AS

WITH
allc AS (SELECT component, count(*) FROM ways GROUP BY component),
maxcount AS (SELECT max(count) from allc),
the_component AS (SELECT component FROM allc WHERE count = (SELECT max FROM maxcount))

SELECT
  gid AS id,
  source_osm AS source, target_osm AS target,
  cost_s AS cost, reverse_cost_s AS reverse_cost,
  name, length_m AS length, the_geom AS geom
FROM ways JOIN the_component USING (component) JOIN configuration USING (tag_id)
WHERE  tag_value NOT IN ('motorway','primary','secondary');

-- Verification3
SELECT count(*) FROM walk_net;
\dS+ taxi_net

\o exercise_7_4.txt

SELECT start_vid, end_vid, agg_cost AS seconds
FROM pgr_dijkstraCost(
  'SELECT * FROM vehicle_net',
  @CH7_OSMID_1@, @CH7_OSMID_2@);

-- For taxi_net

SELECT start_vid, end_vid, agg_cost AS seconds
FROM pgr_dijkstraCost(
  'SELECT * FROM taxi_net',
  @CH7_OSMID_1@, @CH7_OSMID_2@);

-- For walk_net

SELECT start_vid, end_vid, agg_cost AS seconds
FROM pgr_dijkstraCost(
  'SELECT * FROM walk_net',
  @CH7_OSMID_1@, @CH7_OSMID_2@);

\o exercise_7_5.txt

SELECT
  seq, id, seconds, name, length
FROM (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra(
      'SELECT * FROM vehicle_net',
      @CH7_OSMID_1@, @CH7_OSMID_2@)
  ) AS results
LEFT JOIN vehicle_net
  USING (id)
ORDER BY seq;

\o exercise_7_6.txt

WITH
results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra('SELECT * FROM vehicle_net', @CH7_OSMID_1@, @CH7_OSMID_2@)
)
SELECT
  -- from previous excercise
  seq,
  -- id, seconds, name, length,

  -- additionally get
  ST_AsText(geom) AS route_readable
FROM results
LEFT JOIN vehicle_net
  USING (id)
ORDER BY seq;

\o exercise_7_7.txt

WITH results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra('SELECT * FROM vehicle_net', @CH7_OSMID_1@, @CH7_OSMID_2@)
  )
SELECT
  -- from previous excercise
  seq,
  -- id, seconds, name, length, ST_AsText(geom) AS route_readable,

  -- additionally get
  geom AS route_geom
FROM results
LEFT JOIN vehicle_net
  USING (id)
ORDER BY seq;

\o wrong_directionality.txt

WITH
results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra('SELECT * FROM vehicle_net', @CH7_OSMID_1@, @CH7_OSMID_2@)
),
compare AS (
  SELECT seq, id, lead(seq) over(ORDER BY seq) AS next_seq,
  ST_AsText(ST_endPoint(geom)) AS id_end,
  ST_AsText(ST_startPoint(lead(geom) over(ORDER BY seq))) AS next_id_start

  FROM results LEFT JOIN vehicle_net USING (id)
  ORDER BY seq)
SELECT * FROM compare WHERE id_end != next_id_start;

\o exercise_7_8.txt

WITH results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra('SELECT * FROM vehicle_net', @CH7_OSMID_1@, @CH7_OSMID_2@)
  )
SELECT
  -- from previous excercise
  seq,
  -- id, seconds, name, length,

  -- fixing the directionality
  CASE
      WHEN node = source THEN ST_AsText(geom)
      ELSE ST_AsText(ST_Reverse(geom))
  END AS route_readable,

  CASE
      WHEN node = source THEN geom
      ELSE ST_Reverse(geom)
  END AS route_geom

FROM results
LEFT JOIN vehicle_net USING (id)
ORDER BY seq;

\o good_directionality.txt

WITH
results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra('SELECT * FROM vehicle_net', 5661895682, 10982869752)
),
fix AS (
  SELECT seq, id,
  CASE
      WHEN node = source THEN geom
      ELSE ST_Reverse(geom)
  END AS geom
FROM results LEFT JOIN vehicle_net USING (id)
),
compare AS (
  SELECT seq, id, lead(geom) over(ORDER BY seq) AS next_id,
  ST_AsText(ST_endPoint(geom)) AS id_end, ST_AsText(ST_startPoint(lead(geom) over(ORDER BY seq))) AS next_id_start

FROM fix
ORDER BY seq)
SELECT * FROM compare WHERE id_end != next_id_start;

\o exercise_7_9.txt

WITH
results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra('SELECT * FROM vehicle_net', @CH7_OSMID_1@, @CH7_OSMID_2@)
  ),
additional AS (
  SELECT
    seq, id, seconds, name, length,
    CASE
        WHEN node = source THEN ST_AsText(geom)
        ELSE ST_AsText(ST_Reverse(geom))
    END AS route_readable,

    CASE
        WHEN node = source THEN geom
        ELSE ST_Reverse(geom)
    END AS route_geom

  FROM results
  LEFT JOIN vehicle_net USING (id)
)
SELECT
  seq,
  -- from previous excercise
  -- id, seconds, name, length, route_readable, route_geom

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
          WHEN node = source_osm THEN the_geom
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
-- Names of the streets in the route
SELECT DISTINCT name
FROM wrk_dijkstra('vehicle_net',  @CH7_OSMID_1@, @CH7_OSMID_2@);

-- Total seconds spent in each street
SELECT name, sum(seconds)
FROM wrk_dijkstra('taxi_net',  @CH7_OSMID_1@, @CH7_OSMID_2@)
GROUP BY name;

SELECT *
FROM wrk_dijkstra('walk_net',  @CH7_OSMID_1@, @CH7_OSMID_2@);


