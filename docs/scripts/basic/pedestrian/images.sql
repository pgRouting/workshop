CREATE VIEW stars AS
SELECT osm_id, id, geom,
CASE
  WHEN osm_id = @OSMID_1@ THEN '@PLACE_1@'
  WHEN osm_id = @OSMID_2@ THEN '@PLACE_2@'
  WHEN osm_id = @OSMID_3@ THEN '@PLACE_3@'
  WHEN osm_id = @OSMID_4@ THEN '@PLACE_4@'
  WHEN osm_id = @OSMID_5@ THEN '@PLACE_5@'
END AS name
FROM vertices
WHERE osm_id IN (@OSMID_1@, @OSMID_2@, @OSMID_3@, @OSMID_4@, @OSMID_5@)
ORDER BY osm_id;

CREATE VIEW pedestrian_one_to_one AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target,
    length AS cost
    FROM walk_net',
  @ID_1@,
  @ID_3@,
  directed := false)
)
SELECT seq, start_vid, end_vid, geom AS geom FROM dijkstra JOIN walk_net ON(edge = id);

CREATE VIEW pedestrian_many_to_one AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target,
    length/1000 AS cost
    FROM walk_net',
  ARRAY[@ID_1@, @ID_2@],
  @ID_3@,
  directed := false)
)
SELECT seq, start_vid, end_vid, geom AS geom FROM dijkstra JOIN walk_net ON(edge = id);

CREATE VIEW pedestrian_one_to_many AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target,
    cost
    FROM walk_net',
  @ID_3@,
  ARRAY[@ID_1@, @ID_2@],
  directed := false)
)
SELECT seq, start_vid, end_vid, geom AS geom FROM dijkstra JOIN walk_net ON(edge = id);

CREATE VIEW pedestrian_many_to_many AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target,
    length / 1.3 / 60 AS cost
    FROM walk_net',
  ARRAY[@ID_1@, @ID_2@],
  ARRAY[@ID_4@, @ID_5@],
  directed := false)
)
SELECT seq, start_vid, end_vid, geom AS geom FROM dijkstra JOIN walk_net ON(edge = id);

CREATE VIEW pedestrian_combinations AS
WITH dijkstra AS (
 SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target,
    length / 1.3 / 60 AS cost
    FROM walk_net',
  'SELECT * FROM (VALUES
    (@ID_1@, @ID_4@),
    (@ID_2@, @ID_5@))
  AS combinations (source, target)',
  directed := false)
)
SELECT seq, start_vid, end_vid, geom AS geom FROM dijkstra JOIN walk_net ON(edge = id);

CREATE VIEW pedestrian_dijkstraCost AS
WITH dijkstra AS (
SELECT start_vid, end_vid, round(agg_cost::numeric,2) AS agg_cost
FROM pgr_dijkstraCost(
  'SELECT id, source, target,
    length / 1.3 / 60 AS cost
    FROM walk_net',
  ARRAY[@ID_1@, @ID_2@],
  ARRAY[@ID_4@, @ID_5@],
  directed := false)
)
SELECT row_number() over() AS gid, start_vid, end_vid, agg_cost, ST_MakeLine(v1.geom, v2.geom) AS geom FROM dijkstra
JOIN vertices AS v1 ON (start_vid = v1.id)
JOIN vertices AS v2 ON (end_vid = v2.id);
