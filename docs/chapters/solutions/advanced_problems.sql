BEGIN;


\o ad-7.txt
SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s as reverse_cost
        FROM ways',
    13224, 9224, directed := true);



\o ad-8.txt


SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
        source,
        target,
        cost_s / 3600 * 100 AS cost,
        reverse_cost_s / 3600 * 100 as reverse_cost
        FROM ways',
     13224, 9224);

\o tmp.txt

ALTER TABLE osm_way_classes ADD COLUMN penalty FLOAT;
UPDATE osm_way_classes SET penalty=1;
UPDATE osm_way_classes SET penalty=2.0 WHERE name IN ('pedestrian','steps','footway');
UPDATE osm_way_classes SET penalty=1.5 WHERE name IN ('cicleway','living_street','path');
UPDATE osm_way_classes SET penalty=0.8 WHERE name IN ('secondary','tertiary');
UPDATE osm_way_classes SET penalty=0.6 WHERE name IN ('primary','primary_link');
UPDATE osm_way_classes SET penalty=0.4 WHERE name IN ('trunk','trunk_link');
UPDATE osm_way_classes SET penalty=0.3 WHERE name IN ('motorway','motorway_junction','motorway_link');
-- CREATE INDEX ON ways (class_id);
-- CREATE INDEX ON osm_way_classes (class_id);
-- ALTER TABLE ways ADD CONSTRAINT class_id FOREIGN KEY (class_id) REFERENCES osm_way_classes (class_id);

\o ad-9.txt

SELECT * FROM pgr_dijkstra('
    SELECT gid AS id,
        source,
        target,
        cost_s * penalty AS cost,
        reverse_cost_s * penalty AS reverse_cost
    FROM ways JOIN osm_way_classes 
    USING (class_id)',
    13224, 9224);


\o ad-10.txt

SELECT * FROM pgr_dijkstra($$
    SELECT gid AS id,
        source,
        target,
        CASE
            WHEN c.name = 'residential' THEN cost_s * 0.5
            WHEN c.name LIKE 'primary%' THEN cost_s  * 100
            ELSE cost_s * 0.1
        END AS cost,
        CASE
            WHEN c.name = 'residential' THEN reverse_cost_s * 0.5
            WHEN c.name LIKE 'primary%' THEN cost_s  * 100
            WHEN c.name = 'path' THEN reverse_cost_s  * 100
            ELSE reverse_cost_s * 0.1
        END AS reverse_cost
        FROM ways JOIN osm_way_classes AS c
        USING (class_id)$$,
    13224, 9224);

\o tmp.txt
\o

ROLLBACK;
