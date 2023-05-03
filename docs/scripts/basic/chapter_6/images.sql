
CREATE VIEW ad7_png AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  ' SELECT gid AS id, source, target, cost, reverse_cost FROM ways ',
@ID_1@,
@ID_3@,
directed := true)
)
SELECT seq, the_geom AS geom FROM dijkstra JOIN ways ON(edge = gid);


CREATE VIEW ad8_png AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  ' SELECT gid AS id, source, target, cost, reverse_cost FROM ways ',
@ID_3@, @ID_1@,
directed := true)
)
SELECT seq, the_geom AS geom FROM dijkstra JOIN ways ON(edge = gid);


ALTER TABLE configuration ADD COLUMN penalty FLOAT;
-- No penalty
UPDATE configuration SET penalty=1;


-- Not including pedestrian ways
UPDATE configuration SET penalty=-1.0 WHERE tag_value IN ('steps','footway','pedestrian');

-- Penalizing with 5 times the costs
UPDATE configuration SET penalty=5 WHERE tag_value IN ('unclassified');

-- Encuraging the use of "fast" roads
UPDATE configuration SET penalty=0.5 WHERE tag_value IN ('tertiary');
UPDATE configuration SET penalty=0.3 WHERE tag_value IN (
    'primary','primary_link',
    'trunk','trunk_link',
    'motorway','motorway_junction','motorway_link',
    'secondary');



CREATE VIEW ad11_png AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  ' SELECT gid AS id, source, target, cost_s * penalty AS cost, reverse_cost_s * penalty AS reverse_cost
  FROM ways JOIN configuration
  USING (tag_id) ',
  @ID_3@, @ID_1@)
)
SELECT seq, start_vid, end_vid, the_geom AS geom FROM dijkstra JOIN ways ON(edge = gid);

CREATE VIEW penalty_routes AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  ' SELECT gid AS id, source, target, cost_s * penalty AS cost, reverse_cost_s * penalty AS reverse_cost
  FROM ways JOIN configuration
  USING (tag_id) ',
ARRAY[@ID_1@,@ID_2@,@ID_3@,@ID_4@, @ID_5@],
ARRAY[@ID_1@,@ID_2@,@ID_3@,@ID_4@, @ID_5@])
)
SELECT seq,
  CASE WHEN start_vid = @ID_1@ THEN '@PLACE_1@' WHEN start_vid = @ID_2@ THEN '@PLACE_2@'
  WHEN start_vid = @ID_3@ THEN '@PLACE_3@' WHEN start_vid = @ID_4@ THEN '@PLACE_4@'
  WHEN start_vid = @ID_5@ THEN '@PLACE_5@' END
  ||','||
  CASE WHEN end_vid = @ID_1@ THEN '@PLACE_1@' WHEN end_vid = @ID_2@ THEN '@PLACE_2@'
  WHEN end_vid = @ID_3@ THEN '@PLACE_3@' WHEN end_vid = @ID_4@ THEN '@PLACE_4@'
  WHEN end_vid = @ID_5@ THEN '@PLACE_5@' END
  AS name,
  start_vid, end_vid, the_geom AS geom
FROM dijkstra JOIN ways ON(edge = gid);

CREATE VIEW no_penalty_routes AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  ' SELECT gid AS id, source, target, cost_s AS cost, reverse_cost_s AS reverse_cost FROM ways ',
ARRAY[@ID_1@,@ID_2@,@ID_3@,@ID_4@, @ID_5@],
ARRAY[@ID_1@,@ID_2@,@ID_3@,@ID_4@, @ID_5@])
)
SELECT seq,
  CASE WHEN start_vid = @ID_1@ THEN '@PLACE_1@' WHEN start_vid = @ID_2@ THEN '@PLACE_2@'
  WHEN start_vid = @ID_3@ THEN '@PLACE_3@' WHEN start_vid = @ID_4@ THEN '@PLACE_4@'
  WHEN start_vid = @ID_5@ THEN '@PLACE_5@' END
  ||','||
  CASE WHEN end_vid = @ID_1@ THEN '@PLACE_1@' WHEN end_vid = @ID_2@ THEN '@PLACE_2@'
  WHEN end_vid = @ID_3@ THEN '@PLACE_3@' WHEN end_vid = @ID_4@ THEN '@PLACE_4@'
  WHEN end_vid = @ID_5@ THEN '@PLACE_5@' END
  AS name,
  start_vid, end_vid, the_geom AS geom
FROM dijkstra JOIN ways ON(edge = gid);
