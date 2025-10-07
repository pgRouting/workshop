\o closestedges.txt

SELECT 1 AS pid, * from pgr_findCloseEdges(
  'SELECT id, geom from vehicle_net',
   ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326) , 0.5)

UNION

SELECT 2 AS pid, * from pgr_findCloseEdges(
  'SELECT id, geom from vehicle_net',
  ST_SetSRID(ST_Point(@POINT2_LON@, @POINT2_LAT@), 4326) , 0.5);


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
  IN edges_subset REGCLASS,
  IN lat1 NUMERIC, IN lon1 NUMERIC,
  IN lat2 NUMERIC, IN lon2 NUMERIC,
  IN do_debug BOOLEAN DEFAULT false,

  OUT seq INTEGER, OUT id BIGINT, OUT seconds FLOAT, OUT name TEXT, OUT length FLOAT,
  OUT route_readable TEXT,
  OUT route_geom geometry,
  OUT azimuth FLOAT
)
-- signature ends
RETURNS SETOF record AS
$BODY$
DECLARE
  closest_query TEXT;
  resuts_query TEXT;
  additional_query TEXT;
  final_query TEXT;
BEGIN
  -- 0

  closest_query := format(
    $cq$SELECT 1 AS pid, * from pgr_findCloseEdges(
      $q1$ SELECT id, geom from %1$I $q1$,
      ST_SetSRID(ST_Point(%2$s, %3$s), 4326) , 0.5)

      UNION

      SELECT 2 AS pid, * from pgr_findCloseEdges(
      $q1$ SELECT id, geom from %1$I $q1$,
      ST_SetSRID(ST_Point(%4$s, %5$s), 4326) , 0.5)
    $cq$, edges_subset, lon1, lat1, lon2, lat2);

  -- 1

  resuts_query := format(
    $$SELECT seq, edge AS id, node, cost AS seconds
    FROM pgr_withPoints(
      'SELECT * FROM %1$I',
      '%2$s',
      -1, -2)
    $$, edges_subset, closest_query);

  -- 2

  additional_query := format(
    $$SELECT
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
    LEFT JOIN %1$I USING (id)
    ORDER BY seq
    $$, edges_subset);

  -- 3

  final_query :=
    'WITH
    results AS (' || resuts_query || '),
    additional AS ( ' || additional_query || ')
    SELECT *, degrees(ST_azimuth(ST_StartPoint(geom), ST_EndPoint(geom))) AS azimuth
    FROM additional ORDER BY seq';

  -- 4

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
FROM wrk_withPoints(
  'vehicle_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);

\o use_fn_2.txt

SELECT *
FROM wrk_withPoints(
  'taxi_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@,
  true);

\o use_fn_3.txt

SELECT *
INTO example
FROM wrk_withPoints(
  'walk_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);

SELECT * FROM example;

\o file_end.txt
