\o get_id.txt

SELECT osm_id, id FROM vertices
WHERE osm_id IN (@OSMID_1@, @OSMID_2@, @OSMID_3@, @OSMID_4@, @OSMID_5@)
ORDER BY osm_id;

\o one_to_one.txt

SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target,
    length AS cost
    FROM walk_net',
  @ID_1@,
  @ID_3@,
  directed := false);

\o many_to_one.txt

SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target,
    length/1000 AS cost
    FROM walk_net',
  ARRAY[@ID_1@, @ID_2@],
  @ID_3@,
  directed := false);

\o one_to_many.txt

SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target,
    cost
    FROM walk_net',
  @ID_3@,
  ARRAY[@ID_1@, @ID_2@],
  directed := false);

\o many_to_many.txt

SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target,
    length / 1.3 / 60 AS cost
    FROM walk_net',
  ARRAY[@ID_1@, @ID_2@],
  ARRAY[@ID_4@, @ID_5@],
  directed := false);

\o combinations.txt

SELECT * FROM pgr_dijkstra(
  'SELECT id, source, target,
    length / 1.3 / 60 AS cost
    FROM walk_net',
  'SELECT * FROM (VALUES
    (@ID_1@, @ID_4@),
    (@ID_2@, @ID_5@))
  AS combinations (source, target)',
  directed := false);

\o dijkstracost.txt

SELECT * FROM pgr_dijkstraCost(
  'SELECT id, source, target,
    length / 1.3 / 60 AS cost
    FROM walk_net',
  ARRAY[@ID_1@, @ID_2@],
  ARRAY[@ID_4@, @ID_5@],
  directed := false);

\o note_1.txt
\t
SELECT 'Inspecting the results, looking for totals (edge = -1):';

SELECT '- From @ID_1@ to vertex @ID_4@ takes ' || round(agg_cost::numeric, 2) || ' minutes (seq = ' || seq || ')'
FROM pgr_dijkstra(
  '
  SELECT id,
  source,
  target,
  length / 1.3 / 60 AS cost
  FROM walk_net
  ',
  ARRAY[@ID_1@, @ID_2@],
  ARRAY[@ID_4@, @ID_5@],
  directed := false)
WHERE edge = -1 AND start_vid = @ID_1@ AND end_vid = @ID_4@;
SELECT '- From @ID_1@ to vertex @ID_5@ takes ' || round(agg_cost::numeric, 2) || ' minutes (seq = ' || seq || ')'
FROM pgr_dijkstra(
  '
  SELECT id,
  source,
  target,
  length / 1.3 / 60 AS cost
  FROM walk_net
  ',
  ARRAY[@ID_1@, @ID_2@],
  ARRAY[@ID_4@, @ID_5@],
  directed := false)
WHERE edge = -1 AND start_vid = @ID_1@ AND end_vid = @ID_5@;
SELECT '- From @ID_2@ to vertex @ID_4@ takes ' || round(agg_cost::numeric, 2) || ' minutes (seq = ' || seq || ')'
FROM pgr_dijkstra(
  '
  SELECT id,
  source,
  target,
  length / 1.3 / 60 AS cost
  FROM walk_net
  ',
  ARRAY[@ID_1@, @ID_2@],
  ARRAY[@ID_4@, @ID_5@],
  directed := false)
WHERE edge = -1 AND start_vid = @ID_2@ AND end_vid = @ID_4@;
SELECT '- From @ID_2@ to vertex @ID_5@ takes ' || round(agg_cost::numeric, 2) || ' minutes (seq = ' || seq || ')'
FROM pgr_dijkstra(
  '
  SELECT id,
  source,
  target,
  length / 1.3 / 60 AS cost
  FROM walk_net
  ',
  ARRAY[@ID_1@, @ID_2@],
  ARRAY[@ID_4@, @ID_5@],
  directed := false)
WHERE edge = -1 AND start_vid = @ID_2@ AND end_vid = @ID_5@;
