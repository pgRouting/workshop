\o create_city1.txt

CREATE TABLE bangladesh (
  id BIGINT,
  name TEXT,
  geom geometry,
  city_buffer geometry
);

\o create_city2.txt

INSERT INTO bangladesh(id, name, geom) VALUES
(5, 'Munshigang',  ST_SetSRID(ST_Point(89.1967, 22.2675), 4326));

\o create_city3.txt

UPDATE bangladesh
SET city_buffer = ST_Buffer((geom),0.005)
WHERE  name = 'Munshigang';

\o create_city4.txt
\dS+ bangladesh
\o set_path.txt
SET search_path TO waterways,public;
SHOW search_path;
\o get_extensions.txt
\dx
\o get_tables.txt
\dt
\o exercise_6.txt

SELECT count(*) FROM waterways_ways;

\o delete1.txt

DELETE FROM waterways_ways
WHERE osm_id
IN (721133202, 908102930, 749173392, 652172284, 126774195, 720395312);

\o delete2.txt

DELETE FROM waterways_ways WHERE osm_id = 815893446;

\o only_connected1.txt

SELECT * INTO waterways.waterways_vertices
FROM pgr_extractVertices(
  'SELECT gid AS id, source, target
  FROM waterways.waterways_ways ORDER BY id');

\o only_connected2.txt

UPDATE waterways_vertices SET geom = ST_startPoint(the_geom)
FROM waterways_ways WHERE source = id;

UPDATE waterways_vertices SET geom = ST_endPoint(the_geom)
FROM waterways_ways WHERE geom IS NULL AND target = id;

UPDATE waterways_vertices set (x,y) = (ST_X(geom), ST_Y(geom));

\o only_connected3.txt

ALTER TABLE waterways_ways ADD COLUMN component BIGINT;
ALTER TABLE waterways_vertices ADD COLUMN component BIGINT;

\o only_connected4.txt

UPDATE waterways_vertices SET component = c.component
FROM (
  SELECT * FROM pgr_connectedComponents(
  'SELECT gid as id, source, target, cost, reverse_cost FROM waterways_ways')
) AS c
WHERE id = node;

\o only_connected5.txt

UPDATE waterways_ways SET component = v.component
FROM (SELECT id, component FROM waterways_vertices) AS v
WHERE source = v.id;

\o exercise_10.txt

CREATE OR REPLACE FUNCTION get_city_buffer(city_id INTEGER)
RETURNS geometry AS
$BODY$
  SELECT city_buffer FROM bangladesh WHERE id = city_id;
$BODY$
LANGUAGE SQL;

\o exercise_11.txt

SELECT DISTINCT component
FROM bangladesh JOIN waterways.waterways_ways
ON (ST_Intersects(the_geom, get_city_buffer(5)));

\o get_rain_zone1.txt

ALTER TABLE waterways_ways
ADD COLUMN rain_zone geometry;

\o get_rain_zone2.txt

UPDATE waterways.waterways_ways
SET rain_zone = ST_Buffer((the_geom),0.005)
WHERE ST_Intersects(the_geom, get_city_buffer(5));
\o exercise_13.txt
-- Combining mutliple rain zones
SELECT ST_Union(rain_zone) AS Combined_Rain_Zone
FROM waterways_ways;
\o

