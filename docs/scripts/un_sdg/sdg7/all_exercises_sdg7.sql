\o set_path.txt
SET search_path TO roads,public,contrib,postgis;
\o show_path2.txt
SHOW search_path;
\o revert_changes.txt

DROP TABLE IF EXISTS roads.roads_vertices;
ALTER TABLE roads.roads_ways DROP component;

\o only_connected1.txt

SELECT * INTO roads.roads_vertices
FROM pgr_extractVertices(
  'SELECT gid AS id, source, target
  FROM roads.roads_ways ORDER BY id');

\o only_connected2.txt

UPDATE roads_vertices SET geom = ST_startPoint(the_geom)
FROM roads_ways WHERE source = id;

UPDATE roads_vertices SET geom = ST_endPoint(the_geom)
FROM roads_ways WHERE geom IS NULL AND target = id;

UPDATE roads_vertices set (x,y) = (ST_X(geom), ST_Y(geom));

\o only_connected3.txt

ALTER TABLE roads_ways ADD COLUMN component BIGINT;
ALTER TABLE roads_vertices ADD COLUMN component BIGINT;

\o only_connected4.txt

UPDATE roads_vertices SET component = c.component
FROM (
  SELECT * FROM pgr_connectedComponents(
  'SELECT gid as id, source, target, cost, reverse_cost FROM roads_ways')
) AS c
WHERE id = node;

\o only_connected5.txt

UPDATE roads_ways SET component = v.component
FROM (SELECT id, component FROM roads_vertices) AS v
WHERE source = v.id;

\o only_connected6.txt

WITH
all_components AS (SELECT component, count(*) FROM roads_ways GROUP BY component),
max_component AS (SELECT max(count) from all_components)
SELECT component FROM all_components WHERE count = (SELECT max FROM max_component);

\o only_connected7.txt

WITH
all_components AS (SELECT component, count(*) FROM roads_ways GROUP BY component),
max_component AS (SELECT max(count) from all_components),
the_component AS (SELECT component FROM all_components WHERE count = (SELECT max FROM max_component))
DELETE FROM roads_ways WHERE component != (SELECT component FROM the_component);

\o only_connected8.txt

WITH
all_components AS (SELECT component, count(*) FROM roads_vertices GROUP BY component),
max_component AS (SELECT max(count) from all_components),
the_component AS (SELECT component FROM all_components WHERE count = (SELECT max FROM max_component))
DELETE FROM roads_vertices WHERE component != (SELECT component FROM the_component);

\o exercise_10-1.txt

PREPARE edges AS
SELECT gid AS id, source, target, length_m AS cost
FROM roads.roads_ways;

\o exercise_10-2.txt

SELECT seq, depth, start_vid, node, edge, round(cost::numeric, 2) AS length, round(agg_cost::numeric, 2) AS agg_cost
FROM pgr_kruskalDFS('edges', 91);

\o exercise_11.txt

SELECT sum(cost)/1000 AS material_km
FROM pgr_kruskalDFS('edges', 91);

\o exercise_12.txt

SELECT sum(length_m)/1000 AS total_km
FROM roads_ways;

\o
