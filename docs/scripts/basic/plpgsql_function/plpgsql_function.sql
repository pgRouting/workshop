SELECT *
INTO points
FROM (
  SELECT 1 AS gid, ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326) AS geom
  UNION
  SELECT 2, ST_SetSRID(ST_Point(@POINT2_LON@, @POINT2_LAT@), 4326)
  ) AS info;

\o created_points.txt

SELECT * FROM points;

\o views_vertices1.txt

SELECT * INTO vehicle_net_vertices
FROM pgr_extractVertices(
  'SELECT id, source, target
  FROM vehicle_net ORDER BY id');

UPDATE vehicle_net_vertices AS v
SET (x,y,geom) = (w.x, w.y, w.geom)
FROM ways_vertices AS w WHERE v.id = w.id;

\o views_vertices2.txt
SELECT * INTO taxi_net_vertices
FROM pgr_extractVertices(
  'SELECT id, source, target
  FROM taxi_net ORDER BY id');

UPDATE taxi_net_vertices AS v
SET (x,y,geom) = (w.x, w.y, w.geom)
FROM ways_vertices AS w WHERE v.id = w.id;
\o views_vertices3.txt
SELECT * INTO walk_net_vertices
FROM pgr_extractVertices(
  'SELECT id, source, target
  FROM walk_net ORDER BY id');

UPDATE walk_net_vertices AS v
SET (x,y,geom) = (w.x, w.y, w.geom)
FROM ways_vertices AS w WHERE v.id = w.id;
\o exercise_8_3_1.txt

SELECT id
FROM ways_vertices
ORDER BY geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o exercise_8_3_2.txt

SELECT id
FROM vehicle_net_vertices
ORDER BY geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o exercise_8_3_3.txt

SELECT id
FROM taxi_net_vertices
ORDER BY geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o exercise_8_3_4.txt

SELECT id
FROM walk_net_vertices
ORDER BY geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o exercise_8_4.txt
CREATE OR REPLACE FUNCTION wrk_Nearest(
  IN vertex_table REGCLASS,
  IN lat NUMERIC,
  IN lon NUMERIC)
RETURNS BIGINT AS
$BODY$
DECLARE result BIGINT;
BEGIN

  EXECUTE format(
    $$
      SELECT id
      FROM %1$I
      ORDER BY geom <-> ST_SetSRID(ST_Point(%3$s, %2$s), 4326)
      LIMIT 1
    $$,
    vertex_table, lat, lon)
  INTO result;
  RETURN result;

END
$BODY$
LANGUAGE 'plpgsql';
\o exercise_8_5_1.txt

SELECT wrk_Nearest('ways_vertices', @POINT1_LAT@, @POINT1_LON@);

\o exercise_8_5_2.txt

SELECT wrk_Nearest('vehicle_net_vertices', @POINT1_LAT@, @POINT1_LON@);

\o exercise_8_5_3.txt

SELECT wrk_Nearest('taxi_net_vertices', @POINT1_LAT@, @POINT1_LON@);

\o exercise_8_5_4.txt

SELECT wrk_Nearest('walk_net_vertices', @POINT1_LAT@, @POINT1_LON@);

\o exercise_8_6.txt
CREATE OR REPLACE FUNCTION wrk_fromAtoB(
  IN edges_subset REGCLASS,
  IN lat1 NUMERIC, IN lon1 NUMERIC,
  IN lat2 NUMERIC, IN lon2 NUMERIC,
  IN do_debug BOOLEAN DEFAULT false,

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
-- signature ends
$BODY$
DECLARE
final_query TEXT;
BEGIN
  final_query := format(
    $$
      SELECT *
      FROM wrk_dijkstra(
        '%1$I',
        (SELECT wrk_Nearest('%1$I_vertices', %2$s, %3$s)),
        (SELECT wrk_Nearest('%1$I_vertices', %4$s, %5$s))
      )
    $$,
    -- Subtitutions on the query are in order
    edges_subset, lat1, lon1, lat2, lon2);

    IF do_debug THEN
      RAISE NOTICE '%', final_query;
      RETURN;
    END IF;
    RETURN QUERY EXECUTE final_query;
END;
$BODY$
LANGUAGE 'plpgsql';
\o exercise_8_7_1.txt

SELECT DISTINCT name
FROM wrk_fromAtoB(
  'vehicle_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);

\o exercise_8_7_2.txt

SELECT *
FROM wrk_fromAtoB(
  'taxi_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@,
  true);

\o exercise_8_7_3.txt

SELECT *
INTO example
FROM wrk_fromAtoB(
  'walk_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);

SELECT * FROM example;

\o

WITH the_points AS (
SELECT 1 AS id, ST_MakePoint(@POINT1_LON@, @POINT1_LAT@)
UNION
SELECT 1 AS id, ST_MakePoint(@POINT2_LON@, @POINT2_LAT@)
)
SELECT * INTO points_on_the_fly
FROM the_points;

CREATE VIEW ch8_using_vehicle AS
SELECT *  FROM wrk_fromAtoB(
  'vehicle_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);

CREATE VIEW ch8_using_taxi AS
SELECT *  FROM wrk_fromAtoB(
  'taxi_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);

CREATE VIEW ch8_using_walk AS
SELECT *
FROM wrk_fromAtoB(
  'walk_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);
