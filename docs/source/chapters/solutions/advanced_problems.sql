BEGIN;


\o ad-7.txt

SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s AS reverse_cost
        FROM ways',
    3986, 13009,
    directed := true);


\o ad-8.txt

SELECT * FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s AS reverse_cost
        FROM ways',
    13009, 3986, directed := true);



\o ad-9.txt


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
        source,
        target,
        cost_s / 3600 * 100 AS cost,
        reverse_cost_s / 3600 * 100 AS reverse_cost
        FROM ways',
     13009, 3986);

\o info-1.txt


SELECT * FROM osm_way_types ORDER BY type_id;


\o info-2.txt


SELECT * FROM osm_way_classes ORDER BY class_id;


\o ad-10.txt

SELECT * FROM pgr_dijkstra($$
    SELECT gid AS id,
        source,
        target,
        CASE
            WHEN c.name IN ('pedestrian','steps','footway') THEN -1
            ELSE cost_s
        END AS cost,
        CASE
            WHEN c.name IN ('pedestrian','steps','footway') THEN -1
            ELSE reverse_cost_s
        END AS reverse_cost
        FROM ways JOIN osm_way_classes AS c
        USING (class_id)$$,
    13009, 3986);

\o tmp.txt


ALTER TABLE osm_way_classes ADD COLUMN penalty FLOAT;
-- No penalty
UPDATE osm_way_classes SET penalty=1;
-- Penalizing with double costs
UPDATE osm_way_classes SET penalty=2.0 WHERE name IN ('pedestrian','steps','footway');
UPDATE osm_way_classes SET penalty=1.5 WHERE name IN ('cicleway','living_street','path');
UPDATE osm_way_classes SET penalty=0.8 WHERE name IN ('secondary','tertiary');
UPDATE osm_way_classes SET penalty=0.6 WHERE name IN ('primary','primary_link');
UPDATE osm_way_classes SET penalty=0.4 WHERE name IN ('trunk','trunk_link');
-- Encuraging the use of "fast" roads
UPDATE osm_way_classes SET penalty=0.3 WHERE name IN ('motorway','motorway_junction','motorway_link');

\o ad-11.txt

SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
        source,
        target,
        cost_s * penalty AS cost,
        reverse_cost_s * penalty AS reverse_cost
    FROM ways JOIN osm_way_classes
    USING (class_id)',
    13009, 3986);


\o tmp.txt
\o

ROLLBACK;
