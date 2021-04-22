-- NOTE A change on the queries will need to change the line numbers on the chapter

\o section-8.1.1.txt

SELECT *
INTO points
FROM (
  SELECT 1 AS gid, ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326) AS geom
  UNION
  SELECT 2, ST_SetSRID(ST_Point(@POINT2_LON@, @POINT2_LAT@), 4326)
  ) AS info;

\o section-8.2.1.1.txt

SELECT count(*)
FROM ways_vertices_pgr;

\o section-8.2.1.2.txt
SELECT count(*)
FROM (
  SELECT source
  FROM vehicle_net

  UNION

  SELECT target
  FROM vehicle_net
) AS id_list;

\o section-8.2.1.3.txt

SELECT count(*)
FROM (
  SELECT source
  FROM little_net

  UNION

  SELECT target
  FROM little_net
) AS id_list;

\o section-8.2.2.1.txt

WITH id_list AS (
  SELECT source AS id
  FROM vehicle_net

  UNION

  SELECT target
  FROM vehicle_net)

SELECT osm_id, the_geom
INTO vehicle_net_vertices_pgr
FROM id_list
JOIN ways_vertices_pgr USING (id);

\o section-8.2.2.2.txt

WITH id_list AS (
  SELECT source AS id
  FROM little_net

  UNION

  SELECT target
  FROM little_net)

SELECT osm_id, the_geom
INTO little_net_vertices_pgr
FROM id_list
JOIN ways_vertices_pgr USING (id);

\o section-8.2.3.1.txt

SELECT osm_id
FROM ways_vertices_pgr
ORDER BY the_geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o section-8.2.3.2.txt

SELECT osm_id
FROM vehicle_net_vertices_pgr
ORDER BY the_geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o section-8.2.3.3.txt

SELECT osm_id
FROM little_net_vertices_pgr
ORDER BY the_geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o section-8.2.4.txt

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
      SELECT osm_id
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

\o section-8.2.5.1.txt

SELECT wrk_NearestOSM('ways_vertices_pgr', @POINT1_LAT@, @POINT1_LON@);

\o section-8.2.5.2.txt

SELECT wrk_NearestOSM('vehicle_net_vertices_pgr', @POINT1_LAT@, @POINT1_LON@);

\o section-8.2.5.3.txt

SELECT wrk_NearestOSM('little_net_vertices_pgr', @POINT1_LAT@, @POINT1_LON@);

\o section-8.3.1.txt

-- DROP FUNCTION wrk_fromAtoB(text, numeric, numeric, numeric, numeric, boolean);

CREATE OR REPLACE FUNCTION wrk_fromAtoB(
  IN edges_subset regclass,
  IN lat1 numeric, IN lon1 numeric,
  IN lat2 numeric, IN lon2 numeric,
  IN do_debug BOOLEAN DEFAULT false,
  OUT seq INTEGER,
  OUT gid BIGINT,
  OUT name TEXT,
  OUT length FLOAT,
  OUT the_time FLOAT,
  OUT azimuth FLOAT,
  OUT geom geometry
)
RETURNS SETOF record AS
$BODY$
DECLARE
final_query TEXT;
BEGIN
  final_query := format(
    $$
      WITH
      dijkstra AS (
        SELECT *
        FROM wrk_dijkstra(
          '%1$I',
          (SELECT wrk_NearestOSM('%1$I_vertices_pgr', %2$s, %3$s)),
          (SELECT wrk_NearestOSM('%1$I_vertices_pgr', %4$s, %5$s)))
      )
      SELECT
        seq,
        dijkstra.gid,
        dijkstra.name,
        ways.length_m/1000.0 AS length,
        dijkstra.cost AS the_time,
        azimuth,
        route_geom AS geom
      FROM dijkstra
      JOIN ways USING (gid)
      $$,
      edges_subset,
      lat1,lon1,
      lat2,lon2);

    IF do_debug THEN
      RAISE notice '%', final_query;
    END IF;
    RETURN QUERY EXECUTE final_query;
END;
$BODY$
LANGUAGE 'plpgsql';

\o section-8.3.2.1.txt

SELECT *  FROM wrk_fromAtoB(
  'vehicle_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);

\o section-8.3.2.2.txt

SELECT *  FROM wrk_fromAtoB(
  'little_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@,
  true);

\o section-8.3.2.3.txt

SELECT *
INTO example
FROM wrk_fromAtoB(
  'ways',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);

SELECT *
FROM example;
