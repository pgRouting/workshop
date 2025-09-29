
DROP FUNCTION IF EXISTS wrk_dijkstra(regclass, bigint, bigint);


\o exercise_7_5.txt

SELECT
  seq, id, seconds, name, length
FROM (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra(
      'SELECT * FROM vehicle_net',
      @CH7_OSMID_1@, @CH7_OSMID_2@)
  ) AS results
LEFT JOIN vehicle_net USING (id)
ORDER BY seq;

\o exercise_7_6.txt

WITH
results AS (  -- line 2
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra('SELECT * FROM vehicle_net', @CH7_OSMID_1@, @CH7_OSMID_2@)
)
SELECT
  -- from previous excercise
  seq,                            -- line 8
  -- id, seconds, name, length,

  -- additionally get
  ST_AsText(geom) AS route_readable  --line 12
FROM results
LEFT JOIN vehicle_net USING (id)  -- line 14
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
\o using_fn1.txt
SELECT DISTINCT name
FROM wrk_dijkstra('vehicle_net',  @CH7_OSMID_1@, @CH7_OSMID_2@);

\o using_fn2.txt
SELECT name, sum(seconds)
FROM wrk_dijkstra('taxi_net',  @CH7_OSMID_1@, @CH7_OSMID_2@)
GROUP BY name;

\o using_fn3.txt
SELECT *
FROM wrk_dijkstra('walk_net',  @CH7_OSMID_1@, @CH7_OSMID_2@);


