-- BEGIN;

DROP VIEW IF EXISTS little_net;
DROP VIEW IF EXISTS vehicle_net;
\o ch7-e1.txt

-- DROP VIEW vehicle_net CASCADE;

CREATE VIEW vehicle_net AS
    SELECT gid AS id,
        source,
        target,
        -- converting to minutes
        cost_s / 60 AS cost,
        reverse_cost_s / 60 AS reverse_cost,
        the_geom
    FROM ways JOIN osm_way_classes AS c
    USING (class_id)
    WHERE  c.name NOT IN ('pedestrian','steps','footway','path');

-- Verification
SELECT count(*) FROM ways;
SELECT count(*) FROM full_area;

\o ch7-e2.txt

-- DROP VIEW little_net;

CREATE VIEW little_net AS
    SELECT *
    FROM vehicle_net
    WHERE vehicle_net.the_geom && ST_MakeEnvelope(-71.05, 42.34,-71.03, 42.36);

-- Verification
SELECT count(*) FROM little_net;


\o ch7-e3.txt

SELECT *
FROM pgr_dijkstra(
    'SELECT * FROM vehicle_net',
    -- source
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
    -- target
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912));


\o ch7-e4.txt

SELECT dijkstra.*, ways.name
FROM pgr_dijkstra(
    'SELECT * FROM vehicle_net',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912)
    ) AS dijkstra
 LEFT JOIN ways
 ON (edge = gid) ORDER BY seq;

\o ch7-e5.txt

SELECT dijkstra.*, ways.name, ST_AsText(ways.the_geom)
FROM pgr_dijkstra(
    'SELECT * FROM vehicle_net',
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
    (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912)
    ) AS dijkstra
 LEFT JOIN ways
 ON (edge = gid) ORDER BY seq;


\o ch7-e6.txt


SELECT dijkstra.*, ways.name, ways.the_geom AS route_geom
FROM pgr_dijkstra(
    'SELECT * FROM vehicle_net',
    3986, 13009
    ) AS dijkstra
 LEFT JOIN ways
 ON (edge = gid) ORDER BY seq;


\o ch7-e7.txt

WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT * FROM vehicle_net',
     3986, 13009)
)
SELECT dijkstra.*, ways.name,
    CASE
        WHEN dijkstra.node = ways.source THEN ST_AsText(the_geom)
        ELSE ST_AsText(ST_Reverse(the_geom))
    END AS route_geom
FROM dijkstra JOIN ways
ON (edge = gid)
ORDER BY seq;

\o ch7-e8.txt

WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra('
        SELECT gid AS id,
        source,
        target,
        cost_s AS cost,
        reverse_cost_s as reverse_cost
        FROM ways',
        -- source
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61350413),
        -- target
        (SELECT id FROM ways_vertices_pgr WHERE osm_id = 61479912))
)
SELECT dijkstra.seq, dijkstra.cost, ways.name,
    CASE
        WHEN dijkstra.node = ways.source THEN ST_AsText(the_geom)
        ELSE ST_AsText(ST_Reverse(the_geom))
    END AS route_geom
FROM dijkstra JOIN ways
ON (edge = gid) ORDER BY seq;



--DROP FUNCTION my_dijkstra(regclass, bigint, bigint);

CREATE OR REPLACE FUNCTION my_dijkstra(
        IN edges_subset regclass,
        IN source BIGINT,
        IN target BIGINT,
        OUT seq INTEGER,
        OUT cost FLOAT,
        OUT name TEXT,
        OUT geom geometry
    )
    RETURNS SETOF record AS
$BODY$
    WITH
    dijkstra AS (
        SELECT * FROM pgr_dijkstra(
            'SELECT * FROM ' || $1,
            -- source
            (SELECT id FROM ways_vertices_pgr WHERE osm_id = $2),
            -- target
            (SELECT id FROM ways_vertices_pgr WHERE osm_id = $3))
    )
    SELECT dijkstra.seq, dijkstra.cost, ways.name,
    CASE
        WHEN dijkstra.node = ways.source THEN the_geom
        ELSE ST_Reverse(the_geom)
    END AS route_geom
    FROM dijkstra JOIN ways
    ON (edge = gid) ORDER BY seq;
$BODY$
LANGUAGE 'sql';

SELECT seq, cost, name, ST_AsText(geom)
FROM my_dijkstra('vehicle_net', 61350413, 61479912);


--DROP FUNCTION my_dijkstra_heading(regclass, bigint, bigint);

CREATE OR REPLACE FUNCTION my_dijkstra_heading(
        IN edges_subset regclass,
        IN source BIGINT,
        IN target BIGINT,
        OUT seq INTEGER,
        OUT cost FLOAT,
        OUT name TEXT,
        OUT geom geometry,
        OUT heading FLOAT
    )
    RETURNS SETOF record AS
$BODY$
    WITH
    dijkstra AS (
        SELECT * FROM pgr_dijkstra(
            'SELECT * FROM ' || $1,
            -- source
            (SELECT id FROM ways_vertices_pgr WHERE osm_id = $2),
            -- target
            (SELECT id FROM ways_vertices_pgr WHERE osm_id = $3))
    ),
    with_geom AS (
        SELECT dijkstra.seq, dijkstra.cost, ways.name,
            CASE
                WHEN dijkstra.node = ways.source THEN the_geom
                ELSE ST_Reverse(the_geom)
            END AS route_geom
        FROM dijkstra JOIN ways
        ON (edge = gid) ORDER BY seq
    )
    SELECT *,
        ST_azimuth(ST_StartPoint(route_geom), ST_EndPoint(route_geom))
    FROM with_geom;
$BODY$
LANGUAGE 'sql';


SELECT seq, cost, name, heading, ST_AsText(geom)
FROM my_dijkstra_heading('vehicle_net',  61350413, 61479912);

\o tmp.txt
\o

-- ROLLBACK;
