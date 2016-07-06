


\o d-1.txt


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         length AS cost
        FROM ways',
    13224, 6549, directed := false);





\o d-2.txt


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         length_m AS cost
        FROM ways',
    ARRAY[6549, 1458, 9224], 13224, directed := false);




\o d-3.txt


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         length_m / 1.3 AS cost
        FROM ways',
    13224, ARRAY[6549, 1458, 9224], directed := false);




\o d-4.txt



SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         length_m / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[6549, 1458, 9224],
    ARRAY[13224, 6963],
    directed := false);



\o d-5.txt



SELECT * FROM pgr_dijkstraCost('
    SELECT gid AS id,
         source,
         target,
         length_m * 0.001 / 5 AS cost
        FROM ways',
    ARRAY[6549, 1458, 9224],
    ARRAY[13224, 6963],
    directed := false);



\o d-6.txt


SELECT seq, id1 AS node, id2 AS edge, cost FROM pgr_astar('
    SELECT gid::integer AS id,
         source::integer,
         target::integer,
         length::double precision AS cost,
         x1, y1, x2, y2
        FROM ways',
    13224, 6549, false, false);
