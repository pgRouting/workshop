


\o d-1.txt


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         length AS cost
        FROM ways',
    9411, 3986, directed := false);





\o d-2.txt


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         length_m AS cost
        FROM ways',
    ARRAY[3986, 9411], 13009, directed := false);




\o d-3.txt


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         length_m / 1.3 AS cost
        FROM ways',
    13009, ARRAY[3986, 9411], directed := false);




\o d-4.txt



SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         length_m / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[3986, 9411],
    ARRAY[8401, 12235],
    directed := false);



\o d-5.txt



SELECT *
FROM pgr_dijkstraCost('
    SELECT gid AS id,
         source,
         target,
         length_m  / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[3986, 9411],
    ARRAY[8401, 12235],
    directed := false);



\o d-6.txt


SELECT end_vid, sum(agg_cost)
FROM pgr_dijkstraCost('
    SELECT gid AS id,
    source,
    target,
    length_m  / 1.3 / 60 AS cost
    FROM ways',
    ARRAY[3986, 9411],
    ARRAY[8401, 12235],
    directed := false)
GROUP BY end_vid
ORDER BY end_vid;
