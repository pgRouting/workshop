\o section-6.1-1.txt

SELECT count(*)
FROM ways
WHERE cost < 0;

\o section-6.1-2.txt


SELECT count(*)
FROM ways
WHERE reverse_cost < 0;


\o section-6.1.1.txt

SELECT * FROM pgr_dijkstra(
  '
  SELECT gid AS id,
    source,
    target,
    cost_s AS cost,
    reverse_cost_s AS reverse_cost
  FROM ways
  ',
@ID_3@,
@ID_1@,
directed := true);

\o section-6.1.2.txt

SELECT * FROM pgr_dijkstra(
  '
    SELECT gid AS id,
      source,
      target,
      cost_s AS cost,
      reverse_cost_s AS reverse_cost
    FROM ways
  ',
@ID_1@,
@ID_3@,
directed := true);

\o section-6.1.3.txt

SELECT * FROM pgr_dijkstra(
  '
    SELECT gid AS id,
      source,
      target,
      cost_s / 3600 * 100 AS cost,
      reverse_cost_s / 3600 * 100 AS reverse_cost
    FROM ways
  ',
@ID_1@,
@ID_3@);

\o section-6.2-1.txt
\dS+ configuration
\o section-6.2-2.txt

SELECT tag_id, tag_key, tag_value
FROM configuration
ORDER BY tag_id;

\o section-6.2-3.txt

SELECT distinct tag_id, tag_key, tag_value
FROM ways JOIN configuration USING (tag_id)
ORDER BY tag_id;

\o section-6.2.1.txt

ALTER TABLE configuration ADD COLUMN penalty FLOAT;
-- No penalty
UPDATE configuration SET penalty=1;


SELECT *
FROM pgr_dijkstra(
  '
    SELECT gid AS id,
        source,
        target,
        cost_s * penalty AS cost,
        reverse_cost_s * penalty AS reverse_cost
    FROM ways JOIN configuration
    USING (tag_id)
  ',
@ID_3@,
@ID_1@);

\o section-6.2.2-1.txt

-- Not including pedestrian ways
UPDATE configuration SET penalty=-1.0 WHERE tag_value IN ('steps','footway','pedestrian');

-- Penalizing with 5 times the costs
UPDATE configuration SET penalty=5 WHERE tag_value IN ('residential');

-- Encuraging the use of "fast" roads
UPDATE configuration SET penalty=0.5 WHERE tag_value IN ('tertiary');
UPDATE configuration SET penalty=0.3 WHERE tag_value IN (
    'primary','primary_link',
    'trunk','trunk_link',
    'motorway','motorway_junction','motorway_link',
    'secondary');

\o section-6.2.2-2.txt

SELECT * FROM pgr_dijkstra(
  '
    SELECT gid AS id,
        source,
        target,
        cost_s * penalty AS cost,
        reverse_cost_s * penalty AS reverse_cost
    FROM ways JOIN configuration
    USING (tag_id)
  ',
@ID_3@,
@ID_1@);
