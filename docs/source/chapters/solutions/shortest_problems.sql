


\o d-1.txt


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         length AS cost
        FROM ways',
    25322, 3991, directed := false);





\o d-2.txt


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         length_m AS cost
        FROM ways',
    ARRAY[12800, 25322, 17794], 3991, directed := false);




\o d-3.txt


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         length_m / 1.3 AS cost
        FROM ways',
    3991, ARRAY[12800, 25322, 17794], directed := false);




\o d-4.txt



SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         length_m / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[12800, 25322, 17794],
    ARRAY[3991, 16061],
    directed := false);



\o d-5.txt



SELECT *
FROM pgr_dijkstraCost('
    SELECT gid AS id,
         source,
         target,
         length_m  / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[12800, 25322, 17794],
    ARRAY[3991, 16061],
    directed := false) ORDER BY end_vid;



\o d-6.txt


SELECT end_vid, sum(agg_cost)
FROM pgr_dijkstraCost('
    SELECT gid AS id,
    source,
    target,
    length_m  / 1.3 / 60 AS cost
    FROM ways',
    ARRAY[12800, 25322, 17794],
    ARRAY[3991, 16061],
    directed := false)
GROUP BY end_vid
ORDER BY end_vid;
