


\o d-1.txt


SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length AS cost
        FROM ways',
    1639, 1195,
    directed := false);





\o d-2.txt


SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length_m AS cost
        FROM ways',
    ARRAY[1639, 1195], 856,
    directed := false);




\o d-3.txt


SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length_m / 1.3 AS cost
        FROM ways',
    856, ARRAY[1639, 1195],
    directed := false);




\o d-4.txt



SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length_m / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[1639, 1195],
    ARRAY[856, 1256],
    directed := false);



\o d-5.txt



SELECT *
FROM pgr_dijkstraCost(
    'SELECT gid AS id,
         source,
         target,
         length_m  / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[1639, 1195],
    ARRAY[856, 1256],
    directed := false);



\o d-6.txt


SELECT end_vid, sum(agg_cost)
FROM pgr_dijkstraCost(
    'SELECT gid AS id,
    source,
    target,
    length_m  / 1.3 / 60 AS cost
    FROM ways',
    ARRAY[1639, 1195],
    ARRAY[856, 1256],
    directed := false)
GROUP BY end_vid
ORDER BY end_vid;
