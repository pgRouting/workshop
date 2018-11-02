


\o d-1.txt


SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length AS cost
        FROM ways',
    1060, 1661,
    directed := false);





\o d-2.txt


SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length_m AS cost
        FROM ways',
    ARRAY[1060, 1661], 1253,
    directed := false);




\o d-3.txt


SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length_m / 1.3 AS cost
        FROM ways',
    1253, ARRAY[1060, 1661],
    directed := false);




\o d-4.txt



SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length_m / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[1060, 1661],
    ARRAY[1253, 115],
    directed := false);



\o d-5.txt



SELECT *
FROM pgr_dijkstraCost(
    'SELECT gid AS id,
         source,
         target,
         length_m  / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[1060, 1661],
    ARRAY[1253, 115],
    directed := false);



\o d-6.txt


SELECT end_vid, sum(agg_cost)
FROM pgr_dijkstraCost(
    'SELECT gid AS id,
    source,
    target,
    length_m  / 1.3 / 60 AS cost
    FROM ways',
    ARRAY[1060, 1661],
    ARRAY[1253, 115],
    directed := false)
GROUP BY end_vid
ORDER BY end_vid;
