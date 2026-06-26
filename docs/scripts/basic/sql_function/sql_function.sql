
DROP FUNCTION IF EXISTS wrk_dijkstra(regclass, bigint, bigint);


\o get_more_info.txt

-- DROP FUNCTION wrk_dijkstra(regclass, bigint, bigint);

CREATE OR REPLACE FUNCTION wrk_dijkstra(
  IN source BIGINT, IN target BIGINT,
  OUT seq INTEGER, OUT id BIGINT,
  OUT seconds FLOAT, OUT name TEXT, OUT length FLOAT,
  OUT azimuth FLOAT, OUT readable TEXT,
  OUT geom GEOMETRY
)
RETURNS SETOF record AS
$BODY$
WITH
results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra(
    -- on purpose to have wrong direccionality
    'SELECT * FROM vehicle_net',
    source, target)
)
SELECT
  seq, id, seconds, name, length,
  degrees(ST_azimuth(ST_StartPoint(geom), ST_EndPoint(geom))),
  ST_AsText(geom),
  geom
FROM results
LEFT JOIN vehicle_net USING (id)
ORDER BY seq;

$BODY$
LANGUAGE SQL;

\o get_read_geom.txt

SELECT seq, readable FROM wrk_dijkstra(@CH7_ID_1@, @CH7_ID_2@);

\o get_geom.txt

SELECT seq, geom FROM wrk_dijkstra(@CH7_ID_1@, @CH7_ID_2@);

\o get_azimuth.txt

SELECT seq, azimuth FROM wrk_dijkstra(@CH7_ID_1@, @CH7_ID_2@);

\o wrong_directionality.txt

SELECT seq, azimuth, readable FROM wrk_dijkstra(@CH7_ID_1@, @CH7_ID_2@)
ORDER BY seq LIMIT 3;

\o fix_directionality.txt

DROP FUNCTION IF EXISTS wrk_dijkstra_fixed(bigint, bigint);

CREATE OR REPLACE FUNCTION wrk_dijkstra_fixed(
  IN source BIGINT, IN target BIGINT,
  OUT seq INTEGER, OUT id BIGINT,
  OUT seconds FLOAT, OUT name TEXT, OUT length FLOAT,
  OUT azimuth FLOAT, OUT readable TEXT,
  OUT geom GEOMETRY
)
RETURNS SETOF record AS
$BODY$
WITH
results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra(
    -- on purpose to have wrong direccionality
    'SELECT * FROM vehicle_net',
    source, target)
),
additional AS (
  SELECT
  seq, id, seconds, name, length,
  CASE
        WHEN node = source THEN geom
        ELSE ST_Reverse(geom)
  END AS geom
  FROM results
  LEFT JOIN vehicle_net USING (id)
  ORDER BY seq)

SELECT seq, id, seconds, name, length,
  degrees(ST_azimuth(ST_StartPoint(geom), ST_EndPoint(geom))) AS azimuth,
  ST_AsText(geom), geom
FROM additional ORDER BY seq;

$BODY$
LANGUAGE SQL;


\o good_directionality.txt

SELECT seq, azimuth, readable FROM wrk_dijkstra_fixed(@CH7_ID_1@, @CH7_ID_2@)
ORDER BY seq LIMIT 3;

\o final_function.txt

DROP FUNCTION IF EXISTS wrk_dijkstra_final(bigint, bigint);

CREATE OR REPLACE FUNCTION wrk_dijkstra_final(
  IN source BIGINT, IN target BIGINT,
  OUT seq INTEGER, OUT id BIGINT,
  OUT seconds FLOAT, OUT name TEXT, OUT length FLOAT,
  OUT azimuth FLOAT, OUT readable TEXT,
  OUT geom GEOMETRY
)
RETURNS SETOF record AS
$BODY$
WITH
results AS (
  SELECT seq, edge AS id, node, cost AS seconds
  FROM pgr_dijkstra(
    'SELECT * FROM vehicle_penalized_net',
    source, target)
),
additional AS (
  SELECT
  seq, id, seconds, name, length,
  CASE
        WHEN node = source THEN geom
        ELSE ST_Reverse(geom)
  END AS geom
  FROM results
  LEFT JOIN vehicle_net USING (id)
  ORDER BY seq)

SELECT seq, id, seconds, name, length,
  degrees(ST_azimuth(ST_StartPoint(geom), ST_EndPoint(geom))) AS azimuth,
  ST_AsText(geom), geom
FROM additional ORDER BY seq;

$BODY$
LANGUAGE SQL;

\o using_fn1.txt

SELECT seq, name FROM wrk_dijkstra_final(@CH7_ID_1@, @CH7_ID_2@);

\o helpers.txt
SELECT seq, a.azimuth = b.azimuth FROM wrk_dijkstra_fixed(@ID_1@, @ID_2@) a JOIN wrk_dijkstra(@ID_1@, @ID_2@) b USING (seq, id, seconds, name, length) WHERE a.azimuth != b.azimuth;
SELECT seq, a.azimuth = b.azimuth FROM wrk_dijkstra_fixed(@ID_1@, @ID_3@) a JOIN wrk_dijkstra(@ID_1@, @ID_3@) b USING (seq, id, seconds, name, length) WHERE a.azimuth != b.azimuth;

CREATE OR REPLACE VIEW using_vehicle AS
SELECT *
FROM wrk_dijkstra(@CH7_ID_1@, @CH7_ID_2@);

CREATE OR REPLACE VIEW sql_route_geom AS
SELECT seq, id, geom
FROM wrk_dijkstra(@CH7_ID_1@, @CH7_ID_2@)
JOIN vehicle_net USING (id);
