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
