\o exercise_5_0.txt

SELECT osm_id, id FROM ways_vertices_pgr
WHERE osm_id IN (@OSMID_1@, @OSMID_2@, @OSMID_3@, @OSMID_4@, @OSMID_5@)
ORDER BY osm_id;

\o exercise_5_1.txt

SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
        source,
        target,
        length AS cost
      FROM ways
    ',
 @ID_1@,
 @ID_3@,
    directed := false);

\o exercise_5_2.txt

SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
        source,
        target,
        length_m AS cost
      FROM ways
    ',
ARRAY[@ID_1@,@ID_2@],
@ID_3@,
directed := false);

\o exercise_5_3.txt

SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
        source,
        target,
        length_m / 1.3 AS cost
      FROM ways
    ',
@ID_3@,
ARRAY[@ID_1@,@ID_2@],
directed := false);

\o exercise_5_4.txt

SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
       source,
       target,
       length_m / 1.3 / 60 AS cost
      FROM ways
    ',
ARRAY[@ID_1@, @ID_2@],
ARRAY[@ID_4@, @ID_5@],
directed := false);

\o exercise_5_5.txt

SELECT *
FROM pgr_dijkstraCost(
    '
      SELECT gid AS id,
       source,
       target,
       length_m  / 1.3 / 60 AS cost
      FROM ways
    ',
ARRAY[@ID_1@, @ID_2@],
ARRAY[@ID_4@, @ID_5@],
directed := false);

\o exercise_5_6.txt

SELECT start_vid, sum(agg_cost)
FROM pgr_dijkstraCost(
    '
      SELECT gid AS id,
        source,
        target,
        length_m  / 1.3 / 60 AS cost
      FROM ways
    ',
    ARRAY[@ID_1@, @ID_2@],
    ARRAY[@ID_4@, @ID_5@],
    directed := false)
GROUP BY start_vid
ORDER BY start_vid;

\o note_1.txt
\t
SELECT 'Inspecting the results, looking for totals (edge = -1):';

SELECT '- From @ID_1@ to vertex @ID_4@ takes ' || round(agg_cost::numeric, 2) || ' minutes (seq = ' || seq || ')'
  FROM pgr_dijkstra(
    '
      SELECT gid AS id,
       source,
       target,
       length_m / 1.3 / 60 AS cost
      FROM ways
    ',
ARRAY[@ID_1@, @ID_2@],
ARRAY[@ID_4@, @ID_5@],
directed := false)
WHERE edge = -1 AND start_vid = @ID_1@ AND end_vid = @ID_4@;
SELECT '- From @ID_1@ to vertex @ID_5@ takes ' || round(agg_cost::numeric, 2) || ' minutes (seq = ' || seq || ')'
  FROM pgr_dijkstra(
    '
      SELECT gid AS id,
       source,
       target,
       length_m / 1.3 / 60 AS cost
      FROM ways
    ',
ARRAY[@ID_1@, @ID_2@],
ARRAY[@ID_4@, @ID_5@],
directed := false)
WHERE edge = -1 AND start_vid = @ID_1@ AND end_vid = @ID_5@;
SELECT '- From @ID_2@ to vertex @ID_4@ takes ' || round(agg_cost::numeric, 2) || ' minutes (seq = ' || seq || ')'
  FROM pgr_dijkstra(
    '
      SELECT gid AS id,
       source,
       target,
       length_m / 1.3 / 60 AS cost
      FROM ways
    ',
ARRAY[@ID_1@, @ID_2@],
ARRAY[@ID_4@, @ID_5@],
directed := false)
WHERE edge = -1 AND start_vid = @ID_2@ AND end_vid = @ID_4@;
SELECT '- From @ID_2@ to vertex @ID_5@ takes ' || round(agg_cost::numeric, 2) || ' minutes (seq = ' || seq || ')'
  FROM pgr_dijkstra(
    '
      SELECT gid AS id,
       source,
       target,
       length_m / 1.3 / 60 AS cost
      FROM ways
    ',
ARRAY[@ID_1@, @ID_2@],
ARRAY[@ID_4@, @ID_5@],
directed := false)
WHERE edge = -1 AND start_vid = @ID_2@ AND end_vid = @ID_5@;
\o note_2.txt
WITH summary AS (SELECT start_vid, sum(agg_cost)
FROM pgr_dijkstraCost(
    'SELECT gid AS id, source, target, length_m  / 1.3 / 60 AS cost FROM ways ',
    ARRAY[@ID_1@, @ID_2@], ARRAY[@ID_4@, @ID_5@],
    directed := false)
GROUP BY start_vid
ORDER BY start_vid),
the_min AS (select min(sum) from summary)
SELECT
'An interpretation of the result can be: In general, it is faster to depart from "' ||
CASE WHEN start_vid = @ID_1@ THEN '@PLACE_1@' WHEN start_vid = @ID_2@ THEN '@PLACE_2@' END
  || '" than from "' ||
CASE WHEN start_vid = @ID_1@ THEN '@PLACE_2@' WHEN start_vid = @ID_2@ THEN '@PLACE_1@' END
  || '"'
FROM summary WHERE sum = (SELECT min from the_min);
