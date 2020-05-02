


\o cost_manipulation-1.txt


SELECT count(*)
FROM ways
WHERE cost < 0;




\o cost_manipulation-2.txt


SELECT count(*)
FROM ways
WHERE reverse_cost < 0;



\o cost_manipulation-3.txt

-- there is no dijkstra cost on pgRoutingLayer
-- save in a table
with 
a AS (
    select id, st_x(the_geom) as x1, st_y(the_geom) as y1 from ways_vertices_pgr where id in (3986, 9411)
),
b AS (
    select id, st_x(the_geom) as x2 , st_y(the_geom) as y2 from ways_vertices_pgr where id in (8401, 12235)
),   
c AS (
    select row_number() over() as gid,  a.id as start_vid, b.id as end_vid, st_makeline(st_point(x1,y1),st_point(x2,y2)) as geom from a,b
),
d AS ( 
    SELECT *
    FROM pgr_dijkstraCost(
        'SELECT gid AS id,
        source,
        target,
        length_m  / 1.3 / 60 AS cost
        FROM ways',
        ARRAY[3986, 9411],
        ARRAY[8401, 12235],
        directed := false)
)
select c.* , d.agg_cost from c join d using (start_vid,end_vid);





\o d-4.txt



SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         length_m / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[3986, 9411],
    ARRAY[8401, 12235],
    directed := false);



\o d-5.txt



SELECT *
FROM pgr_dijkstraCost(
    'SELECT gid AS id,
         source,
         target,
         length_m  / 1.3 / 60 AS cost
        FROM ways',
    ARRAY[3986, 9411],
    ARRAY[8401, 12235],
    directed := false);



\o d-6.txt


SELECT end_vid, sum(agg_cost)
FROM pgr_dijkstraCost(
    'SELECT gid AS id,
    source,
    target,
    length_m  / 1.3 / 60 AS cost
    FROM ways',
    ARRAY[3986, 9411],
    ARRAY[8401, 12235],
    directed := false)
GROUP BY end_vid
ORDER BY end_vid;
