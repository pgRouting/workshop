
\o ch8-e1.txt
-- Number of vertices in the original graph
SELECT count(*) FROM ways_vertices_pgr;

-- Number of vertices in the vehicles_net graph
SELECT count(*) FROM ways_vertices_pgr
WHERE id IN (
    SELECT source FROM vehicle_net 
    UNION
    SELECT target FROM vehicle_net);

-- Number of vertices in the little_net graph
SELECT count(*) FROM ways_vertices_pgr
WHERE id IN (
    SELECT source FROM little_net 
    UNION
    SELECT target FROM little_net);

\o ch8-e2.txt

-- Closest osm_id in the original graph
SELECT osm_id FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_SetSRID(ST_Point(-71.04143, 42.35126), 4326) LIMIT 1;

-- Closest osm_id in the vehicle_net graph
WITH
vertices AS (
    SELECT * FROM ways_vertices_pgr
    WHERE id IN (
        SELECT source FROM vehicle_net
        UNION
        SELECT target FROM vehicle_net)
)
SELECT osm_id FROM vertices
    ORDER BY the_geom <-> ST_SetSRID(ST_Point(-71.04143, 42.35126), 4326) LIMIT 1;

-- Closest osm_id in the little_net graph
WITH
vertices AS (
    SELECT * FROM ways_vertices_pgr
    WHERE id IN (
        SELECT source FROM little_net
        UNION
        SELECT target FROM little_net)
)
SELECT osm_id FROM vertices;

\o ch8-e3.txt

-- DROP FUNCTION wrk_fromAtoB(varchar, numeric, numeric, numeric, numeric);

CREATE OR REPLACE FUNCTION wrk_fromAtoB(
    IN edges_subset regclass,
    IN x1 numeric, IN y1 numeric,
    IN x2 numeric, IN y2 numeric,
    OUT seq INTEGER,
    OUT gid BIGINT,
    OUT name TEXT,
    OUT length FLOAT,
    OUT the_time FLOAT,
    OUT azimuth FLOAT,
    OUT geom geometry
)
RETURNS SETOF record AS
$BODY$
DECLARE
    final_query TEXT;
BEGIN
        
    final_query :=
        FORMAT( $$
            WITH
            vertices AS (
                SELECT * FROM ways_vertices_pgr
                WHERE id IN (
                    SELECT source FROM %1$I 
                    UNION
                    SELECT target FROM %1$I)
            ),
            dijkstra AS (
                SELECT *
                FROM wrk_dijkstra(
                    '%1$I',
                    -- source
                    (SELECT osm_id FROM vertices 
                        ORDER BY the_geom <-> ST_SetSRID(ST_Point(%2$s, %3$s), 4326) LIMIT 1),
                    -- target
                    (SELECT osm_id FROM vertices
                        ORDER BY the_geom <-> ST_SetSRID(ST_Point(%4$s, %5$s), 4326) LIMIT 1))
            )
            SELECT
                seq,
                dijkstra.gid,
                dijkstra.name,
                ways.length_m/1000.0 AS length,
                dijkstra.cost AS the_time,
                azimuth,
                route_geom AS geom
            FROM dijkstra JOIN ways USING (gid);$$,
        edges_subset, x1,y1,x2,y2); -- %1 to %5 of the FORMAT function
    RAISE notice '%', final_query;
    RETURN QUERY EXECUTE final_query;
END;
$BODY$
LANGUAGE 'plpgsql';

\o ch8-e4.txt


SELECT *  FROM wrk_fromAtoB(
    'vehicle_net',
    -71.04136, 42.35089,
    -71.03483, 42.34595);

SELECT *  FROM wrk_fromAtoB(
    'little_net',
    -71.04136, 42.35089,
    -71.03483, 42.34595);

SELECT *  FROM wrk_fromAtoB(
    'ways',
    -71.04136, 42.35089,
    -71.03483, 42.34595);


\o ch8-e5.txt

\o

