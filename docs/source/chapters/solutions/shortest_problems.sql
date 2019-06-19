/*
.. |id_1| replace:: ``3363``
.. |id_2| replace:: ``14745``
.. |id_3| replace:: ``14441``
.. |id_4| replace:: ``6649``
.. |id_5| replace:: ``1175``
*/

\o d-0.txt

SELECT osm_id, id FROM ways_vertices_pgr
WHERE osm_id IN (123392877, 255093299, 1886700005, 6159253045, 6498351588)
ORDER BY osm_id;

\o d-1.txt


SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
        source,
        target,
        length AS cost
      FROM ways
    ',
    3363,
    14441,
    directed := false);





\o d-2.txt


SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
        source,
        target,
        length_m AS cost
      FROM ways
    ',
    ARRAY[3363,14745],
    14441,
    directed := false);




\o d-3.txt


SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
        source,
        target,
        length_m / 1.3 AS cost
      FROM ways
    ',
    1175,
    ARRAY[3363,14745],
    directed := false);




\o d-4.txt



SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
       source,
       target,
       length_m / 1.3 / 60 AS cost
      FROM ways
    ',
    ARRAY[3363,14745],
    ARRAY[6649, 1175],
    directed := false);



\o d-5.txt



SELECT *
FROM pgr_dijkstraCost(
    '
      SELECT gid AS id,
       source,
       target,
       length_m  / 1.3 / 60 AS cost
      FROM ways
    ',
    ARRAY[3363,14745],
    ARRAY[6649, 1175],
    directed := false);



\o d-6.txt


SELECT start_vid, sum(agg_cost)
FROM pgr_dijkstraCost(
    '
      SELECT gid AS id,
        source,
        target,
        length_m  / 1.3 / 60 AS cost
      FROM ways
    ',
    ARRAY[3363,14745],
    ARRAY[6649, 1175],
    directed := false)
GROUP BY start_vid
ORDER BY start_vid;
