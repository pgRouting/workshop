\o closestedges.txt

CREATE OR REPLACE VIEW points_on_map AS
SELECT 1 AS pid, * from pgr_findCloseEdges(
  'SELECT id, geom from vehicle_net',
   ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326) , 0.5)

UNION

SELECT 2 AS pid, * from pgr_findCloseEdges(
  'SELECT id, geom from vehicle_net',
  ST_SetSRID(ST_Point(@POINT2_LON@, @POINT2_LAT@), 4326) , 0.5);

SELECT * FROM points_on_map;

\o route_withPoints.txt

SELECT * FROM pgr_withPoints(
  'SELECT id, source, target, cost, reverse_cost from vehicle_net',
  $$
  SELECT 2 AS pid, * from pgr_findCloseEdges(
    'SELECT id, geom from vehicle_net',
    ST_SetSRID(ST_Point(@POINT1_LON@,  @POINT1_LAT@), 4326), 0.5)
  UNION
  SELECT 1 AS pid, * from pgr_findCloseEdges(
    'SELECT id, geom from vehicle_net',
     ST_SetSRID(ST_Point(@POINT2_LON@,  @POINT2_LAT@), 4326), 0.5)
  $$,
  -1, -2);

\o wrk_withPoints.txt
-- DROP FUNCTION wrk_withPoints(regclass, bigint, bigint);


CREATE OR REPLACE FUNCTION wrk_withPoints(
  IN lat1 NUMERIC, IN lon1 NUMERIC,
  IN lat2 NUMERIC, IN lon2 NUMERIC,
  IN do_debug BOOLEAN DEFAULT false,

  OUT seq INTEGER, OUT id BIGINT,
  OUT seconds FLOAT, OUT name TEXT, OUT length FLOAT,
  OUT azimuth FLOAT, OUT readable TEXT,
  OUT geom GEOMETRY
)
-- signature ends
RETURNS SETOF record AS
$BODY$
DECLARE
  points_sql TEXT;
  resuts_query TEXT;
  final_query TEXT;
BEGIN

  -- 0

  points_sql := format(
    $cq$
      SELECT 1 AS pid, * from pgr_findCloseEdges(
      $q1$ SELECT id, geom FROM vehicle_net $q1$,
      ST_SetSRID(ST_Point(%1$s, %2$s), 4326) , 0.5)

      UNION

      SELECT 2 AS pid, * from pgr_findCloseEdges(
      $q1$ SELECT id, geom FROM vehicle_net $q1$,
      ST_SetSRID(ST_Point(%3$s, %4$s), 4326) , 0.5)
    $cq$, lon1, lat1, lon2, lat2);

  -- 1

  resuts_query := format(
    $$SELECT seq, edge AS id, node, cost AS seconds
    FROM pgr_withPoints(
      'SELECT * FROM vehicle_penalized_net',
      '%1$s',
      -1, -2)
    $$, points_sql);

  -- 2

  final_query := '
    WITH
    results AS (' || resuts_query || ' ),

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
    ';

  -- 3

  IF do_debug THEN
    RAISE NOTICE '%', final_query;
    RETURN;
  END IF;

  RETURN QUERY EXECUTE final_query;

END;
$BODY$
LANGUAGE plpgsql;

\o use_fn_1.txt

SELECT DISTINCT name
FROM wrk_withPoints(@POINT1_LAT@, @POINT1_LON@, @POINT2_LAT@, @POINT2_LON@);

\o use_fn_2.txt

SELECT *
FROM wrk_withPoints(@POINT1_LAT@, @POINT1_LON@, @POINT2_LAT@, @POINT2_LON@, true);

\o use_fn_3.txt

CREATE OR REPLACE VIEW example AS
SELECT *
FROM wrk_withPoints(@POINT1_LAT@, @POINT1_LON@, @POINT2_LAT@, @POINT2_LON@);

SELECT seq, name FROM example;

\o file_end.txt
