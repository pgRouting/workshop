BEGIN;

\o w-11.txt

SELECT a.*, ST_AsText(b.the_geom) FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s as reverse_cost
        FROM ways',
    3986, 13009
    ) AS a
 LEFT JOIN ways as b
 ON (a.edge = b.gid) ORDER BY seq;



\o w-12.txt

SELECT a.*, b.the_geom FROM pgr_dijkstra(
    'SELECT gid AS id,
         source,
         target,
         cost_s AS cost,
         reverse_cost_s as reverse_cost
        FROM ways',
    3986, 13009
    ) AS a
 LEFT JOIN ways as b
 ON (edge = gid) ORDER BY seq;

\o w-13.txt

WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT gid AS id,
        source,
        target,
        cost_s AS cost,
        reverse_cost_s as reverse_cost
        FROM ways',
     3986, 13009)
)
SELECT dijkstra.*,
    CASE
        WHEN dijkstra.node = ways.source THEN ST_AsText(the_geom)
        ELSE ST_AsText(ST_Reverse(the_geom))
    END AS route_geom
FROM dijkstra JOIN ways
ON (edge = gid)
ORDER BY seq;

\o w-14.txt

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

\o w-15.txt


CREATE VIEW my_area AS
    SELECT gid AS id,
        source,
        target,
        cost_s AS cost,
        reverse_cost_s AS reverse_cost,
        the_geom
    FROM ways
    WHERE ways.the_geom && ST_MakeEnvelope(-71.05, 42.34,-71.03, 42.36);


SELECT count(*) FROM ways;
SELECT count(*) FROM my_area;


\o w-16.txt

WITH
dijkstra AS (
    SELECT * FROM pgr_dijkstra(
        'SELECT * FROM my_area',
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

\o w-17.txt


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
FROM my_dijkstra('my_area', 61350413, 61479912);

\o w-18.txt

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
FROM my_dijkstra_heading('my_area',  61350413, 61479912);

\o tmp.txt
\o

ROLLBACK;
