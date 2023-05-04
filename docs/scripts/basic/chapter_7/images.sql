DROP FUNCTION wrk_image;
DROP VIEW chap7_view;

CREATE OR REPLACE FUNCTION wrk_image(
  IN edges_subset REGCLASS,
  IN source BIGINT,  -- in terms of osm_id
  IN target BIGINT,  -- in terms of osm_id
  OUT seq INTEGER,
  OUT id BIGINT,
  OUT node BIGINT,
  OUT source BIGINT,
  OUT seconds FLOAT,
  OUT name TEXT,
  OUT length_m FLOAT,
  OUT geom geometry,
  OUT geom_readable TEXT,
  OUT azimuth_geom FLOAT,
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
  seq, id, node, source_osm, seconds,
  name, length_m,
  the_geom,
  ST_AsText(the_geom),
  degrees(ST_azimuth(ST_StartPoint(the_geom), ST_EndPoint(the_geom))) AS azimuth_geom,
  CASE
    WHEN node = source_osm THEN ST_AsText(the_geom)
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

CREATE VIEW using_vehicle AS
SELECT *
FROM wrk_image('vehicle_net',  @CH7_OSMID_1@, @CH7_OSMID_2@);

CREATE VIEW using_taxi AS
SELECT *
FROM wrk_image('taxi_net',  @CH7_OSMID_1@, @CH7_OSMID_2@);

CREATE VIEW using_walk AS
SELECT *
FROM wrk_image('walk_net',  @CH7_OSMID_1@, @CH7_OSMID_2@);
