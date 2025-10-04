
CREATE VIEW vehicle_route_going_png AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target, cost, reverse_cost
   FROM vehicle_net',
  @ID_1@, @ID_3@,
  directed := true)
)
SELECT seq, start_vid, end_vid, geom FROM dijkstra JOIN vehicle_net ON(edge = id);


CREATE VIEW vehicle_route_coming_png AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target, cost, reverse_cost
  FROM vehicle_net',
  @ID_3@, @ID_1@,
  directed := true)
)
SELECT seq, start_vid, end_vid, geom FROM dijkstra JOIN vehicle_net ON(edge = id);

CREATE VIEW vehicle_time_is_money_png AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target,
    cost / 3600 * 100 AS cost,
    reverse_cost / 3600 * 100 AS reverse_cost
   FROM taxi_net',
  @ID_3@, @ID_1@)
)
SELECT seq, start_vid, end_vid, geom FROM dijkstra JOIN taxi_net ON(edge = id);

UPDATE configuration SET penalty=1;

CREATE VIEW vehicle_use_penalty_png AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  'SELECT v.id, source, target,
     cost * penalty AS cost,
     reverse_cost * penalty AS reverse_cost
   FROM vehicle_net AS v JOIN configuration
   USING (tag_id)',
  @ID_3@, @ID_1@)
)
SELECT seq, start_vid, end_vid, geom FROM dijkstra JOIN vehicle_net ON(edge = id);

-- Not including cycleways
UPDATE configuration SET penalty=-1.0
WHERE tag_key IN ('cycleway');

-- Penalizing with 5 times the costs the unknown
UPDATE configuration SET penalty=5 WHERE tag_value IN ('unclassified');

-- Encuraging the use of "fast" roads
UPDATE configuration SET penalty=0.5 WHERE tag_value IN ('tertiary');
UPDATE configuration SET penalty=0.3
WHERE tag_value IN (
    'primary','primary_link',
    'trunk','trunk_link',
    'motorway','motorway_junction','motorway_link',
    'secondary');

CREATE VIEW vehicle_get_penalized_route_png AS
WITH dijkstra AS (
SELECT * FROM pgr_dijkstra(
  'SELECT v.id, source, target,
     cost * penalty AS cost,
     reverse_cost * penalty AS reverse_cost
   FROM vehicle_net AS v JOIN configuration
   USING (tag_id)',
  @ID_3@, @ID_1@)
)
SELECT seq, geom AS geom FROM dijkstra JOIN vehicle_net ON(edge = id);

CREATE VIEW vehicle_penalty_routes AS
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

CREATE VIEW vehicle_no_penalty_routes AS
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

CREATE VIEW pedestrian_only_roads AS
SELECT * FROM ways where tag_id in (119, 122, 114, 118);
