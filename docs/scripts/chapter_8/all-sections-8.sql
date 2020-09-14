\o section-8.2.1.txt

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

\o section-8.2.2.txt

-- Closest osm_id in the original graph
SELECT osm_id FROM ways_vertices_pgr
    ORDER BY the_geom <-> ST_SetSRID(ST_Point(39.291852, -6.811437), 4326) LIMIT 1;

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
    ORDER BY the_geom <-> ST_SetSRID(ST_Point(39.291852, -6.811437), 4326) LIMIT 1;

-- Closest osm_id in the little_net graph
WITH
vertices AS (
    SELECT * FROM ways_vertices_pgr
    WHERE id IN (
        SELECT source FROM little_net
        UNION
        SELECT target FROM little_net)
)
SELECT osm_id FROM vertices
    ORDER BY the_geom <-> ST_SetSRID(ST_Point(39.291852, -6.811437), 4326) LIMIT 1;

\o section-8.2.3.txt

