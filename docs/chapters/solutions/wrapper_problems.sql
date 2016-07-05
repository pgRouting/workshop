BEGIN;


\o w-11.txt

SELECT a.*, ST_AsText(b.the_geom) FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s as reverse_cost
        FROM ways',
    13224, 6549) AS a
 LEFT JOIN ways as b
 ON (a.edge = b.gid) ORDER BY seq;



\o w-12.txt

SELECT a.*, b.the_geom FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s as reverse_cost
        FROM ways',
    13224, 6549) AS a
 LEFT JOIN ways as b
 ON (edge = gid) ORDER BY seq;

\o w-13.txt

WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra('
        SELECT gid AS id,
        source,
        target,
        cost_s AS cost,
        reverse_cost_s as reverse_cost
        FROM ways',
        13224, 6549)
)
SELECT dijkstra.*,
    CASE
        WHEN dijkstra.node = ways.source THEN ST_AsText(the_geom)
        ELSE ST_AsText(ST_Reverse(the_geom))
    END AS route_geom
    FROM dijkstra JOIN ways
    ON (edge = gid) ORDER BY seq;


\o w-14.txt


\o

ROLLBACK;
