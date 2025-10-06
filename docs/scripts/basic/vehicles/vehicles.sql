\o oneway_cost.txt

SELECT count(*) FROM vehicle_net
WHERE cost < 0;

\o oneway_revc.txt


SELECT count(*) FROM vehicle_net
WHERE reverse_cost < 0;


\o route_going.txt

SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target, cost, reverse_cost
   FROM vehicle_net',
  @ID_1@, @ID_3@,
  directed := true);

\o route_coming.txt

SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target, cost, reverse_cost
  FROM vehicle_net',
  @ID_3@, @ID_1@,
  directed := true);

\o time_is_money.txt

SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target,
    cost / 3600 * 100 AS cost,
    reverse_cost / 3600 * 100 AS reverse_cost
   FROM taxi_net',
  @ID_3@, @ID_1@);

\o add_penalty.txt

ALTER TABLE configuration ADD COLUMN penalty FLOAT DEFAULT 1.0;

\o use_penalty.txt

SELECT * FROM pgr_dijkstra(
  'SELECT v.id, source, target,
     cost * penalty AS cost,
     reverse_cost * penalty AS reverse_cost
   FROM vehicle_net AS v JOIN configuration
   USING (tag_id)',
  @ID_3@, @ID_1@);

\o update_penalty.txt

-- Not including cycleways
UPDATE configuration SET penalty=-1.0
WHERE tag_key IN ('cycleway') OR tag_value IN ('cycleway');

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

\o get_penalized_route.txt

SELECT * FROM pgr_dijkstra(
  'SELECT v.id, source, target,
     cost * penalty AS cost,
     reverse_cost * penalty AS reverse_cost
   FROM vehicle_net AS v JOIN configuration
   USING (tag_id)',
  @ID_3@, @ID_1@);

\o time_in_secs.txt

SELECT * FROM pgr_dijkstra(
  $$
  SELECT id, source, target, cost, reverse_cost
  FROM (
    -- Nested call
    SELECT edge AS id FROM pgr_dijkstra(
      '
        SELECT v.id, source, target,
        cost * penalty AS cost,
        reverse_cost * penalty AS reverse_cost
        FROM vehicle_net AS v JOIN configuration
        USING (tag_id)
      ',
      @ID_3@, @ID_1@) ) AS edges_in_route
  JOIN vehicle_net USING (id)
  $$,
  @ID_3@, @ID_1@);

\o penalized_view.txt

CREATE OR REPLACE VIEW penalized AS
SELECT
  v.id, source, target,
  cost * penalty AS cost,
  reverse_cost * penalty AS reverse_cost
FROM vehicle_net AS v JOIN configuration
USING (tag_id);

\o using_view.txt

SELECT * FROM pgr_dijkstra(
  $$
  SELECT id, source, target, cost, reverse_cost
  FROM (
    -- Nested call
    SELECT edge AS id FROM pgr_dijkstra(
      'SELECT id, source, target, cost, reverse_cost
       FROM penalized',
      @ID_3@, @ID_1@) ) AS edges_in_route
  JOIN vehicle_net USING (id)
  $$,
  @ID_3@, @ID_1@);

\o vehicles_end.txt
\o
