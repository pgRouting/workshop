DROP TABLE IF EXISTS vertices CASCADE;
DROP VIEW IF EXISTS vehicle_net CASCADE;
DROP VIEW IF EXISTS taxi_net CASCADE;
DROP MATERIALIZED VIEW IF EXISTS walk_net CASCADE;

\o configuration_structure.txt
\dS+ configuration
\o configuration_contents.txt

SELECT tag_id, tag_key, tag_value
FROM configuration
ORDER BY tag_id;

\o configuration_used.txt

SELECT distinct tag_id, tag_key, tag_value
FROM ways JOIN configuration USING (tag_id)
ORDER BY tag_id;

\o create_vertices.txt

SELECT id, in_edges, out_edges, x, y, NULL::BIGINT osm_id, NULL::BIGINT component, geom
INTO vertices
FROM pgr_extractVertices(
  'SELECT gid AS id, source, target
  FROM ways ORDER BY id');

\o vertices_description.txt
\dS+ vertices
\o selected_rows.txt
SELECT * FROM vertices Limit 10;

\o fill_columns_1.txt
SELECT count(*) FROM vertices WHERE geom IS NULL;
\o fill_columns_2.txt
UPDATE vertices SET (geom, osm_id) = (ST_startPoint(the_geom), source_osm)
FROM ways WHERE source = id;
\o fill_columns_3.txt
SELECT count(*) FROM vertices WHERE geom IS NULL;
\o fill_columns_4.txt
UPDATE vertices SET (geom, osm_id) = (ST_endPoint(the_geom), target_osm)
FROM ways WHERE geom IS NULL AND target = id;
\o fill_columns_5.txt
SELECT count(*) FROM vertices WHERE geom IS NULL;
\o fill_columns_6.txt
UPDATE vertices set (x,y) = (ST_X(geom), ST_Y(geom));


\o set_components1.txt
ALTER TABLE ways ADD COLUMN component BIGINT;

\o set_components2.txt
UPDATE vertices AS v SET component = c.component
FROM (
  SELECT seq, component, node
  FROM pgr_connectedComponents(
    'SELECT gid as id, source, target, cost, reverse_cost FROM ways'
)) AS c
WHERE v.id = c.node;
\o set_components3.txt

UPDATE ways SET component = v.component
FROM (SELECT id, component FROM vertices) AS v
WHERE source = v.id;

\o see_components1.txt
SELECT count(DISTINCT component) FROM vertices;
\o see_components2.txt
SELECT count(DISTINCT component) FROM ways;
\o see_components3.txt
SELECT component, count(*) FROM ways GROUP BY component
ORDER BY count DESC LIMIT 10;
\o see_components4.txt
WITH
all_components AS (SELECT component, count(*) FROM ways GROUP BY component),
max_component AS (SELECT max(count) from all_components)
SELECT component FROM all_components WHERE count = (SELECT max FROM max_component);

\o create_vehicle_net1.txt
-- DROP VIEW vehicle_net CASCADE;

CREATE VIEW vehicle_net AS

WITH
all_components AS (SELECT component, count(*) FROM ways GROUP BY component), -- line 6
max_component AS (SELECT max(count) from all_components),
the_component AS (
  SELECT component FROM all_components
  WHERE count = (SELECT max FROM max_component))

SELECT
  gid AS id,
  source, target,
  cost_s AS cost, reverse_cost_s AS reverse_cost,
  name, length_m AS length, tag_id, the_geom AS geom
FROM ways JOIN the_component USING (component) JOIN configuration USING (tag_id)
WHERE  tag_value NOT IN ('pedestrian', 'steps','footway','path','cycleway'); -- line 18

\o create_vehicle_net2.txt
SELECT count(*) FROM ways;
SELECT count(*) FROM vehicle_net;
\o create_vehicle_net3.txt
\dS+ vehicle_net
\o create_taxi_net1.txt

-- DROP VIEW taxi_net;

CREATE VIEW taxi_net AS
    SELECT
      id,
      source, target,
      cost * 1.10 AS cost, reverse_cost * 1.10 AS reverse_cost,
      name, length, tag_id, geom
    FROM vehicle_net
    WHERE vehicle_net.geom && ST_MakeEnvelope(@PGR_WORKSHOP_LITTLE_NET_BBOX@);

\o create_taxi_net2.txt
SELECT count(*) FROM taxi_net;
\o create_taxi_net3.txt
\dS+ taxi_net
\o create_walk_net1.txt

-- DROP MATERIALIZED VIEW walk_net CASCADE;

CREATE MATERIALIZED VIEW walk_net AS

WITH
allc AS (SELECT component, count(*) FROM ways GROUP BY component),
maxcount AS (SELECT max(count) from allc),
the_component AS (SELECT component FROM allc WHERE count = (SELECT max FROM maxcount))

SELECT
  gid AS id,
  source, target,
  length_m / 2.0 AS cost, length_m / 2.0 AS reverse_cost,
  name, length_m AS length, the_geom AS geom
FROM ways JOIN the_component USING (component) JOIN configuration USING (tag_id)
WHERE  tag_value IN ('pedestrian', 'steps','footway','path','cycleway'); -- line 18

\o create_walk_net2.txt

SELECT count(*) FROM walk_net;

\o create_walk_net3.txt
\dS+ walk_net
\o create_net_vertices.txt

SELECT * INTO vehicle_vertices
FROM pgr_extractVertices(
  'SELECT id, source, target
  FROM vehicle_net ORDER BY id');

SELECT * INTO taxi_vertices
FROM pgr_extractVertices(
  'SELECT id, source, target
  FROM taxi_net ORDER BY id');

SELECT * INTO walk_vertices
FROM pgr_extractVertices(
  'SELECT id, source, target
  FROM walk_net ORDER BY id');

\o test_view1.txt

SELECT start_vid, end_vid, agg_cost
FROM pgr_dijkstraCostMatrix(
  'SELECT * FROM vehicle_net',
  ARRAY[@ID_1@, @ID_2@, @ID_3@, @ID_4@, @ID_5@]);

\o test_view2.txt

SELECT start_vid, end_vid, agg_cost
FROM pgr_dijkstraCostMatrix(
  'SELECT * FROM taxi_net',
  ARRAY[@ID_1@, @ID_2@, @ID_3@, @ID_4@, @ID_5@]);

\o test_view3.txt

SELECT start_vid, end_vid, agg_cost
FROM pgr_dijkstraCostMatrix(
  'SELECT * FROM walk_net',
  ARRAY[@ID_1@, @ID_2@, @ID_3@, @ID_4@, @ID_5@]);

\o graphs_end.txt
\o
