SELECT *
INTO points
FROM (
  SELECT 1 AS gid, ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326) AS geom
  UNION
  SELECT 2, ST_SetSRID(ST_Point(@POINT2_LON@, @POINT2_LAT@), 4326)
  ) AS info;

\o exercise_8_1_1.txt

SELECT count(*)
FROM ways_vertices_pgr;

\o exercise_8_1_2.txt

SELECT count(*)
FROM (
  SELECT source
  FROM vehicle_net

  UNION

  SELECT target
  FROM vehicle_net
) AS id_list;

\o exercise_8_1_3.txt

SELECT count(*)
FROM (
  SELECT source
  FROM taxi_net

  UNION

  SELECT target
  FROM taxi_net
) AS id_list;

\o exercise_8_1_4.txt

SELECT count(*)
FROM (
  SELECT source
  FROM walk_net

  UNION

  SELECT target
  FROM walk_net
) AS id_list;

\o exercise_8_2_1.txt

WITH id_list AS (
  SELECT source AS id
  FROM vehicle_net

  UNION

  SELECT target
  FROM vehicle_net)

SELECT id_list.id, the_geom
INTO vehicle_net_vertices_pgr
FROM id_list
JOIN ways_vertices_pgr ON (id_list.id = osm_id);

\o exercise_8_2_2.txt

WITH id_list AS (
  SELECT source AS id
  FROM taxi_net

  UNION

  SELECT target
  FROM taxi_net)

SELECT id_list.id, the_geom
INTO taxi_net_vertices_pgr
FROM id_list
JOIN ways_vertices_pgr ON (id_list.id = osm_id);

\o exercise_8_2_3.txt

WITH id_list AS (
  SELECT source AS id
  FROM walk_net

  UNION

  SELECT target
  FROM walk_net)

SELECT id_list.id, the_geom
INTO walk_net_vertices_pgr
FROM id_list
JOIN ways_vertices_pgr ON (id_list.id = osm_id);

\o exercise_8_3_1.txt

SELECT osm_id
FROM ways_vertices_pgr
ORDER BY the_geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o exercise_8_3_2.txt

SELECT id
FROM vehicle_net_vertices_pgr
ORDER BY the_geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o exercise_8_3_3.txt

SELECT id
FROM taxi_net_vertices_pgr
ORDER BY the_geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o exercise_8_3_4.txt

SELECT id
FROM walk_net_vertices_pgr
ORDER BY the_geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o exercise_8_4.txt
CREATE OR REPLACE FUNCTION wrk_NearestOSM(
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
      ORDER BY the_geom <-> ST_SetSRID(
                              ST_Point(%3$s, %2$s),
                              4326)
      LIMIT 1
    $$,
    vertex_table, lat, lon)
  INTO result;
  RETURN result;

END
$BODY$
LANGUAGE 'plpgsql';
\o exercise_8_5_1.txt

SELECT wrk_NearestOSM(
  'ways_vertices_pgr',
  @POINT1_LAT@, @POINT1_LON@);

\o exercise_8_5_2.txt

SELECT wrk_NearestOSM(
  'vehicle_net_vertices_pgr',
  @POINT1_LAT@, @POINT1_LON@);

\o exercise_8_5_3.txt

SELECT wrk_NearestOSM(
  'taxi_net_vertices_pgr',
  @POINT1_LAT@, @POINT1_LON@);

\o exercise_8_5_4.txt

SELECT wrk_NearestOSM(
  'walk_net_vertices_pgr',
  @POINT1_LAT@, @POINT1_LON@);

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
        (SELECT wrk_NearestOSM(
            '%1$I_vertices_pgr',
            %2$s, %3$s)),
        (SELECT wrk_NearestOSM('%1$I_vertices_pgr', %4$s, %5$s))
      )
    $$,
    edges_subset,
    lat1,lon1,
    lat2,lon2);

    IF do_debug THEN
      RAISE WARNING '%', final_query;
    END IF;
    RETURN QUERY EXECUTE final_query;
END;
$BODY$
LANGUAGE 'plpgsql';
\o exercise_8_7_1.txt

SELECT *  FROM wrk_fromAtoB(
  'vehicle_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);

\o exercise_8_7_2.txt

SELECT *  FROM wrk_fromAtoB(
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

SELECT *
FROM example;
