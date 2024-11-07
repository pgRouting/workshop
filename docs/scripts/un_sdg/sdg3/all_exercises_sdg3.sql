\o show_schemas.txt
\dn
\o show_path1.txt
SHOW search_path;
\o set_path.txt
SET search_path TO roads,buildings,public,contrib,postgis;
\o show_path2.txt
SHOW search_path;
\o enumerate_tables.txt
\dt
\o count1.txt
SELECT COUNT(*) FROM roads_ways;
\o count2.txt
SELECT COUNT(*) FROM buildings_ways;
\o clean_buildings.txt
ALTER TABLE buildings.buildings_ways
DROP source, DROP target,
DROP source_osm, DROP target_osm,
DROP length, DROP length_m,
DROP cost, DROP reverse_cost,
DROP cost_s, DROP reverse_cost_s,
DROP one_way, DROP oneway,
DROP priority, DROP osm_id, DROP rule,
DROP x1, DROP x2,
DROP y1, DROP y2,
DROP maxspeed_forward,
DROP maxspeed_backward;
\o exercise_6.txt
SELECT AddGeometryColumn('buildings','buildings_ways','poly_geom',4326,'POLYGON',2);
\o buildings_description.txt
\dS+ buildings_ways
\o exercise_7.txt
DELETE FROM buildings_ways
WHERE ST_NumPoints(the_geom) < 4
OR ST_IsClosed(the_geom) = FALSE;
\o exercise_8.txt
UPDATE buildings_ways
SET poly_geom = ST_MakePolygon(the_geom);
\o add_area_col.txt

ALTER TABLE buildings_ways ADD COLUMN area INTEGER;

\o get_area.txt

UPDATE buildings_ways
SET area = ST_Area(poly_geom::geography)::INTEGER;

\o kind_of_buildings.txt

SELECT DISTINCT tag_id, tag_value
FROM buildings_ways JOIN buildings.configuration USING (tag_id)
ORDER BY tag_id;

\o population_function.txt

CREATE OR REPLACE FUNCTION  population(tag_id INTEGER,area INTEGER)
RETURNS INTEGER AS
$BODY$
DECLARE
population INTEGER;
BEGIN
  IF tag_id <= 100 THEN population = 1; -- Negligible
  ELSIF 100 < tag_id AND tag_id <= 200 THEN  population = GREATEST(2, area * 0.0002); -- Very Sparse
  ELSIF 200 < tag_id AND tag_id <= 300 THEN  population = GREATEST(3, area * 0.002); -- Sparse
  ELSIF 300 < tag_id AND tag_id <= 400 THEN population = GREATEST(5,  area * 0.05); -- Moderate
  ELSIF 400 < tag_id AND tag_id <= 500  THEN population = GREATEST(7, area * 0.7); -- Dense
  ELSIF tag_id > 500  THEN population = GREATEST(10,area * 1); -- Very Dense
  ELSE population = 1;
  END IF;
  RETURN population;
END;
$BODY$
LANGUAGE plpgsql;

\o add_population_col.txt

ALTER TABLE buildings_ways ADD COLUMN population INTEGER;

\o get_population.txt

UPDATE buildings_ways
SET population = population(tag_id,area);

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

\o nearest_vertex1.txt

CREATE OR REPLACE FUNCTION closest_vertex(geom GEOMETRY)
RETURNS BIGINT AS
$BODY$
SELECT id FROM roads_vertices ORDER BY geom <-> $1 LIMIT 1;
$BODY$
LANGUAGE SQL;

\o nearest_vertex2.txt

SELECT closest_vertex(poly_geom) FROM buildings_ways;

\o prepare_edges.txt

PREPARE edges AS
SELECT gid as id,source,target, length_m/60 AS cost,length_m/60 AS reverse_cost
FROM roads.roads_ways;

\o exercise_15.txt

SELECT gid, source, target, agg_cost AS minutes, the_geom
FROM pgr_drivingDistance(
  'edges', -- the prepared statement
  (
    SELECT closest_vertex(poly_geom)
    FROM buildings.buildings_ways
    WHERE tag_id = '318'
  ), -- the starting vertex
  10,  -- 10 minutes
  false -- graph is undirected
) AS results
JOIN roads.roads_ways AS r ON (edge = gid);

\o exercise_16.txt

WITH
subquery AS (
  SELECT edge, source, target, agg_cost AS minutes, the_geom
  FROM pgr_drivingDistance(
    'edges',
    (
      SELECT closest_vertex(poly_geom)
      FROM buildings.buildings_ways
      WHERE tag_id = '318'
    ), 10, FALSE
  ) AS results
  JOIN roads.roads_ways AS r ON (edge = gid)
),
connected_edges AS (
  SELECT r.gid, r.source, r.target, length_m/60, r.the_geom
  FROM subquery AS s JOIN roads.roads_ways AS r
  ON ((s.source = r.source OR s.source = r.target))
)
SELECT * FROM subquery
UNION ALL
SELECT * FROM connected_edges;

\o closest_edge1.txt

CREATE OR REPLACE FUNCTION closest_edge(geom GEOMETRY)
RETURNS BIGINT AS
$BODY$
  SELECT gid FROM roads_ways ORDER BY geom <-> the_geom LIMIT 1;
$BODY$
LANGUAGE SQL;

\o closest_edge2.txt

ALTER TABLE buildings_ways
ADD COLUMN edge_id INTEGER;

\o closest_edge3.txt

UPDATE buildings_ways SET edge_id = closest_edge(poly_geom);

\o add_road_population1.txt

ALTER TABLE roads_ways ADD COLUMN population INTEGER;

\o add_road_population2.txt

UPDATE roads_ways SET population = SUM
FROM (
	SELECT edge_id, SUM(population)
	FROM buildings_ways GROUP BY edge_id
	)
AS subquery
WHERE gid = edge_id;

\o add_road_population3.txt

SELECT population FROM roads_ways WHERE gid = 441;

\o exercise_20.txt

WITH
subquery AS (
  SELECT source, target
  FROM pgr_drivingDistance(
    'edges',
    (
      SELECT closest_vertex(poly_geom)
      FROM buildings.buildings_ways
      WHERE tag_id = '318'
    ), 10, FALSE
  )
  AS results
  JOIN roads.roads_ways AS r ON (edge = gid)
),
connected_edges AS (
  SELECT DISTINCT gid, population
  FROM subquery AS s JOIN roads.roads_ways AS r
  ON (
    (s.source = r.source OR s.source = r.target) OR
    (s.target = r.source OR s.target = r.target)
  )
)
SELECT SUM(population) FROM connected_edges;

\o
