CREATE VIEW stars AS
SELECT osm_id, id, the_geom,
CASE
  WHEN osm_id = @OSMID_1@ THEN '@PLACE_1@'
  WHEN osm_id = @OSMID_2@ THEN '@PLACE_2@'
  WHEN osm_id = @OSMID_3@ THEN '@PLACE_3@'
  WHEN osm_id = @OSMID_4@ THEN '@PLACE_4@'
  WHEN osm_id = @OSMID_5@ THEN '@PLACE_5@'
END AS name
FROM ways_vertices_pgr
WHERE osm_id IN (@OSMID_1@, @OSMID_2@, @OSMID_3@, @OSMID_4@, @OSMID_5@)
ORDER BY osm_id;

CREATE VIEW route_png AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
    ' SELECT gid AS id, source, target, length AS cost FROM ways ',
    @ID_1@,
    @ID_3@,
    directed := false)
)
SELECT seq, the_geom AS geom FROM dijkstra JOIN ways ON(edge = gid);

CREATE VIEW pedestrian_route1 AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
    ' SELECT gid AS id, source, target, length AS cost FROM ways ',
    @ID_1@,
    @ID_3@,
    directed := false)
)
SELECT seq, the_geom AS geom FROM dijkstra JOIN ways ON(edge = gid);

CREATE VIEW pedestrian_route2 AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
    ' SELECT gid AS id, source, target, length_m AS cost FROM ways ',
    ARRAY[@ID_1@,@ID_2@],
    @ID_3@,
    directed := false)
)
SELECT seq, start_vid, the_geom AS geom FROM dijkstra JOIN ways ON(edge = gid);


CREATE VIEW pedestrian_route4 AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
    ' SELECT gid AS id, source, target, length_m / 1.3 / 60 AS cost FROM ways ',
    ARRAY[@ID_1@, @ID_2@],
    ARRAY[@ID_4@, @ID_5@],
    directed := false)
)
SELECT seq, start_vid, end_vid, the_geom AS geom FROM dijkstra JOIN ways ON(edge = gid);


CREATE VIEW pedestrian_route5 AS
WITH dijkstra AS (
SELECT start_vid, end_vid, round(agg_cost::numeric,2) AS agg_cost
FROM pgr_dijkstraCost(
    ' SELECT gid AS id, source, target, length_m  / 1.3 / 60 AS cost FROM ways ',
    ARRAY[@ID_1@, @ID_2@],
    ARRAY[@ID_4@, @ID_5@],
    directed := false)
)
SELECT row_number() over() AS gid, start_vid, end_vid, agg_cost, ST_MakeLine(v1.the_geom, v2.the_geom) AS geom FROM dijkstra
JOIN ways_vertices_pgr AS v1 ON (start_vid = v1.id)
JOIN ways_vertices_pgr AS v2 ON (end_vid = v2.id);

CREATE VIEW pedestrian_combinations AS
WITH dijkstra AS (
 SELECT * FROM pgr_dijkstra(
  'SELECT gid AS id, source, target, length_m / 1.3 / 60 AS cost FROM ways',
  'SELECT * FROM (VALUES (@ID_1@, @ID_4@), (@ID_2@, @ID_5@)) AS combinations (source, target)',
  directed := false)
)
SELECT seq, start_vid, end_vid, the_geom AS geom FROM dijkstra JOIN ways ON(edge = gid);
