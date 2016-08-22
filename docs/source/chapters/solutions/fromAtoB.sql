BEGIN;

-- atob-1.txt

-- DROP FUNCTION my_dijkstra_2(character varying,bigint,bigint);

CREATE OR REPLACE FUNCTION my_dijkstra_2(
    IN edges_table varchar,
    IN source BIGINT, 
    IN target BIGINT,
    OUT seq INTEGER,
    OUT gid BIGINT,
    OUT geom geometry
)   

RETURNS SETOF record AS
$$
DECLARE 
    inner_sql text;
BEGIN

    inner_sql := 'SELECT gid as id, source, target, cost FROM ' || quote_ident(edges_table);

    RETURN QUERY EXECUTE
    'WITH dijkstra AS (
        SELECT * FROM pgr_dijkstra(
            $1,
            $2,  $3, FALSE)
    )

    SELECT seq, gid, the_geom     
    FROM dijkstra JOIN ' || quote_ident(edges_table) || 
    ' ON (edge = gid) ORDER BY seq ' USING inner_sql, source, target;

END 
$$

LANGUAGE 'plpgsql';

-- atob-2.txt

-- DROP FUNCTION pgr_fromAtoB(varchar, double precision, double precision, double precision, double precision);

CREATE OR REPLACE FUNCTION pgr_fromAtoB(
    IN edges_subset varchar,
    IN x1 double precision,
    IN y1 double precision,
    IN x2 double precision,
    IN y2 double precision,
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
        'SELECT gid as id, source, target, length_m AS cost FROM ' || $1,
        -- source
        (SELECT id FROM ways_vertices_pgr
            ORDER BY the_geom <-> ST_SetSRID(ST_Point(x1,y1),4326) LIMIT 1),
        -- target
        (SELECT id FROM ways_vertices_pgr
            ORDER BY the_geom <-> ST_SetSRID(ST_Point(x2,y2),4326) LIMIT 1),
        false) -- undirected
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

\o atob-3.txt

SELECT seq, cost, name, heading, ST_AsText(geom) FROM pgr_fromAtoB('ways',7.1192,50.7149,7.0979,50.7346);

ROLLBACK;
