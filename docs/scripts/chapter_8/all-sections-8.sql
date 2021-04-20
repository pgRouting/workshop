-- NOTE A change on the queries will need to change the line numbers on the chapter

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
) AS subq;

\o section-8.2.1.3.txt
SELECT count(*)
FROM (
  SELECT source
  FROM little_net

  UNION

  SELECT target
  FROM little_net
) AS subq;

\o section-8.2.2.1.txt

SELECT *
INTO vehicle_net_vertices_pgr
FROM (
  SELECT
    source AS id,
    ST_StartPoint(the_geom) AS the_geom
  FROM vehicle_net

  UNION

  SELECT
    target,
    ST_EndPoint(the_geom)
  FROM vehicle_net
) AS subq;

\o section-8.2.2.2.txt

SELECT *
INTO little_net_vertices_pgr
FROM (
  SELECT
    source AS id,
    ST_StartPoint(the_geom) AS the_geom
  FROM little_net

  UNION

  SELECT
    target,
    ST_EndPoint(the_geom)
  FROM little_net
) AS subq;

\o section-8.2.3.1.txt

SELECT id
FROM ways_vertices_pgr
ORDER BY the_geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o section-8.2.3.2.txt

SELECT id
FROM vehicle_net_vertices_pgr
ORDER BY the_geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o section-8.2.3.3.txt

SELECT id
FROM little_net_vertices_pgr
ORDER BY the_geom <-> ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326)
LIMIT 1;

\o section-8.2.4.txt

CREATE OR REPLACE FUNCTION wrk_NearestVertex(
  IN vertex_table REGCLASS,
  IN lat numeric,
  IN lon numeric)
RETURNS BIGINT AS
$BODY$
DECLARE result BIGINT;
BEGIN

  EXECUTE format(
    $$
      SELECT id
      FROM %1$I
      ORDER BY the_geom <-> ST_SetSRID(ST_Point(%3$s, %2$s), 4326)
      LIMIT 1
    $$,
    vertex_table, lat, lon) INTO result;
  RETURN result;

END
$BODY$
LANGUAGE 'plpgsql';

\o section-8.2.5.1.txt

SELECT *
FROM wrk_NearestVertex('ways_vertices_pgr', -58.40, -34.55);

\o section-8.2.5.2.txt

SELECT *
FROM wrk_NearestVertex('vehicle_net_vertices_pgr', -58.40, -34.55);

\o section-8.2.5.3.txt

SELECT *
FROM wrk_NearestVertex('little_net_vertices_pgr', -58.40, -34.55);

\o section-8.3.1.txt

-- DROP FUNCTION wrk_fromAtoB(varchar, numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION wrk_fromAtoB(
    IN edges_subset regclass,
    IN x1 numeric, IN y1 numeric,
    IN x2 numeric, IN y2 numeric,
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

    final_query :=
        FORMAT( $$
            WITH
            vertices AS (
                SELECT * FROM ways_vertices_pgr
                WHERE id IN (
                    SELECT source FROM %1$I
                    UNION
                    SELECT target FROM %1$I)
            ),
            dijkstra AS (
                SELECT *
                FROM wrk_dijkstra(
                    '%1$I',
                    -- source
                    (SELECT osm_id FROM vertices
                        ORDER BY the_geom <-> ST_SetSRID(ST_Point(%2$s, %3$s), 4326) LIMIT 1),
                    -- target
                    (SELECT osm_id FROM vertices
                        ORDER BY the_geom <-> ST_SetSRID(ST_Point(%4$s, %5$s), 4326) LIMIT 1))
            )
            SELECT
                seq,
                dijkstra.gid,
                dijkstra.name,
                ways.length_m/1000.0 AS length,
                dijkstra.cost AS the_time,
                azimuth,
                route_geom AS geom
            FROM dijkstra JOIN ways USING (gid);$$,
        edges_subset, x1,y1,x2,y2); -- %1 to %5 of the FORMAT function
    RAISE notice '%', final_query;
    RETURN QUERY EXECUTE final_query;
END;
$BODY$
LANGUAGE 'plpgsql';

\o section-8.3.2.txt

SELECT *  FROM wrk_fromAtoB(
    'vehicle_net',
    @POINT1_LON@, @POINT1_LAT@,
    @POINT2_LON@, @POINT2_LAT@);

SELECT *  FROM wrk_fromAtoB(
    'little_net',
    @POINT1_LON@, @POINT1_LAT@,
    @POINT2_LON@, @POINT2_LAT@);

-- saving results in a table
SELECT * INTO example
FROM wrk_fromAtoB(
    'ways',
    @POINT1_LON@, @POINT1_LAT@,
    @POINT2_LON@, @POINT2_LAT@);

