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
