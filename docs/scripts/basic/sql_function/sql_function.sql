
DROP FUNCTION IF EXISTS wrk_dijkstra(regclass, bigint, bigint);


\o get_more_info.txt

-- DROP FUNCTION wrk_dijkstra(regclass, bigint, bigint);

CREATE OR REPLACE FUNCTION wrk_dijkstra(
  IN edges_subset REGCLASS, IN source BIGINT, IN target BIGINT,
  OUT seq INTEGER, OUT id BIGINT, OUT seconds FLOAT, OUT name TEXT, OUT length FLOAT
)
RETURNS SETOF record AS
$BODY$
SELECT
seq, id, seconds, name, length
FROM (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra(
    'SELECT * FROM ' || $1,
    source, target)
) AS results
LEFT JOIN vehicle_net USING (id)
ORDER BY seq;
$BODY$
LANGUAGE SQL;

SELECT * FROM wrk_dijkstra('vehicle_net', @CH7_ID_1@, @CH7_ID_2@);

\o get_read_geom.txt

DROP FUNCTION wrk_dijkstra(regclass, bigint, bigint);

CREATE OR REPLACE FUNCTION wrk_dijkstra(
  IN edges_subset REGCLASS, IN source BIGINT, IN target BIGINT,
  OUT seq INTEGER, OUT id BIGINT, OUT seconds FLOAT, OUT name TEXT, OUT length FLOAT,
  OUT route_readable TEXT
)
RETURNS SETOF record AS
$BODY$
WITH
results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra(
    'SELECT * FROM ' || $1,
    source, target)
)
SELECT
  seq, id, seconds, name, length,
  ST_AsText(geom)
FROM results
LEFT JOIN vehicle_net USING (id)
ORDER BY seq;
$BODY$
LANGUAGE SQL;

SELECT seq, route_readable FROM wrk_dijkstra('vehicle_net', @CH7_ID_1@, @CH7_ID_2@);

\o get_geom.txt

DROP FUNCTION wrk_dijkstra(regclass, bigint, bigint);

CREATE OR REPLACE FUNCTION wrk_dijkstra(
  IN edges_subset REGCLASS, IN source BIGINT, IN target BIGINT,
  OUT seq INTEGER, OUT id BIGINT, OUT seconds FLOAT, OUT name TEXT, OUT length FLOAT,
  OUT route_readable TEXT,
  OUT route_geom geometry
)
RETURNS SETOF record AS
$BODY$
WITH
results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra(
    'SELECT * FROM ' || $1,
    source, target)
)
SELECT
  seq, id, seconds, name, length,
  ST_AsText(geom),
  geom
FROM results
LEFT JOIN vehicle_net USING (id)
ORDER BY seq;
$BODY$
LANGUAGE SQL;

SELECT seq, route_geom FROM wrk_dijkstra('vehicle_net', @CH7_ID_1@, @CH7_ID_2@);

\o wrong_directionality.txt

WITH
results AS (
  SELECT seq, id, route_geom
  FROM wrk_dijkstra('vehicle_net', @CH7_ID_1@, @CH7_ID_2@)
),
compare AS (
  SELECT seq, id, lead(seq) over(ORDER BY seq) AS next_seq,
  ST_AsText(ST_endPoint(route_geom)) AS id_end,
  ST_AsText(ST_startPoint(lead(route_geom) over(ORDER BY seq))) AS next_id_start

  FROM results
  ORDER BY seq)
SELECT * FROM compare WHERE id_end != next_id_start;

\o fix_directionality.txt

DROP FUNCTION wrk_dijkstra(regclass, bigint, bigint);

CREATE OR REPLACE FUNCTION wrk_dijkstra(
  IN edges_subset REGCLASS, IN source BIGINT, IN target BIGINT,
  OUT seq INTEGER, OUT id BIGINT, OUT seconds FLOAT, OUT name TEXT, OUT length FLOAT,
  OUT route_readable TEXT,
  OUT route_geom geometry
)
RETURNS SETOF record AS
$BODY$
WITH
results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra(
    'SELECT * FROM ' || $1,
    source, target)
)
SELECT
  seq, id, seconds, name, length,
  CASE
      WHEN node = source THEN ST_AsText(geom)
      ELSE ST_AsText(ST_Reverse(geom))
  END,

  CASE
      WHEN node = source THEN geom
      ELSE ST_Reverse(geom)
  END
FROM results
LEFT JOIN vehicle_net USING (id)
ORDER BY seq;
$BODY$
LANGUAGE SQL;

SELECT seq, route_readable FROM wrk_dijkstra('vehicle_net', @CH7_ID_1@, @CH7_ID_2@);

\o good_directionality.txt

WITH
results AS (
  SELECT seq, id, seconds, route_geom
  FROM wrk_dijkstra('vehicle_net', @CH7_ID_1@, @CH7_ID_2@)
),
compare AS (
  SELECT seq, id, lead(route_geom) over(ORDER BY seq) AS next_id,
  ST_AsText(ST_endPoint(route_geom)) AS id_end,
  ST_AsText(ST_startPoint(lead(route_geom) over(ORDER BY seq))) AS next_id_start
FROM results
ORDER BY seq)
SELECT * FROM compare WHERE id_end != next_id_start;

\o use_directionality.txt

DROP FUNCTION wrk_dijkstra(regclass, bigint, bigint);

CREATE OR REPLACE FUNCTION wrk_dijkstra(
  IN edges_subset REGCLASS, IN source BIGINT, IN target BIGINT,
  OUT seq INTEGER, OUT id BIGINT, OUT seconds FLOAT, OUT name TEXT, OUT length FLOAT,
  OUT route_readable TEXT,
  OUT route_geom geometry,
  OUT azimuth FLOAT
)
RETURNS SETOF record AS
$BODY$
WITH
results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra(
    'SELECT * FROM ' || $1,
    source, target)),
additional AS (
  SELECT
  seq, id, seconds, name, length,
  CASE
        WHEN node = source THEN ST_AsText(geom)
        ELSE ST_AsText(ST_Reverse(geom))
  END AS readable,

  CASE
        WHEN node = source THEN geom
        ELSE ST_Reverse(geom)
  END AS geom
  FROM results
  LEFT JOIN vehicle_net USING (id)
  ORDER BY seq)

SELECT *,
  degrees(ST_azimuth(ST_StartPoint(geom), ST_EndPoint(geom))) AS azimuth
FROM additional ORDER BY seq;
$BODY$
LANGUAGE SQL;

SELECT seq, azimuth FROM wrk_dijkstra('vehicle_net', @CH7_ID_1@, @CH7_ID_2@);

\o using_fn1.txt
SELECT DISTINCT name
FROM wrk_dijkstra('vehicle_net',  @CH7_ID_1@, @CH7_ID_2@);

\o using_fn2.txt
SELECT name, sum(seconds)
FROM wrk_dijkstra('taxi_net',  @CH7_ID_1@, @CH7_ID_2@)
GROUP BY name;

\o using_fn3.txt
SELECT *
FROM wrk_dijkstra('walk_net',  @CH7_ID_1@, @CH7_ID_2@);
