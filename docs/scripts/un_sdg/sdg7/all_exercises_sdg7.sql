-- Enumerate all the schemas
\dn

-- Show the current search path
SHOW search_path;

-- Set the search path
SET search_path TO roads,public;
SHOW search_path;


-- Enumerate all the tables
\dt

\o Exercise_5.txt
-- Counting the number of Edges of roads
SELECT count(*) FROM roads_ways;

-- Counting the number of Vertices of roads
SELECT count(*) FROM roads_ways_vertices_pgr;
\o Exercise_6.txt
-- Add a column for storing the component
ALTER TABLE roads_ways_vertices_pgr
ADD COLUMN component INTEGER;
-- Update the vertices with the component number
UPDATE roads_ways_vertices_pgr 
SET component = subquery.component
FROM (
	SELECT * FROM pgr_connectedComponents(
		'SELECT gid AS id, source, target, cost, reverse_cost 
		FROM roads_ways')
		) 
AS subquery
WHERE id = node;
\o Exercise_7.txt
WITH
subquery AS (
	SELECT component, count(*) 
	FROM roads_ways_vertices_pgr 
	GROUP BY component
	)
SELECT component FROM subquery 
WHERE count != (
	SELECT max(count) FROM subquery
);
\o Exercise_8.txt
WITH
subquery AS (
	SELECT component, count(*) 
	FROM roads_ways_vertices_pgr 
	GROUP BY component),
	to_remove AS (
		SELECT component FROM subquery 
		WHERE count != (
		SELECT max(count) FROM subquery
	)
)
SELECT id FROM roads_ways_vertices_pgr 
WHERE component IN (SELECT * FROM to_remove);
\o Exercise_9.txt
DELETE FROM roads_ways WHERE source IN (
		WITH
		subquery AS (
			SELECT component, count(*) 
			FROM roads_ways_vertices_pgr 
			GROUP BY component
			),
		to_remove AS (
			SELECT component FROM subquery 
			WHERE count != (
				SELECT max(count) FROM subquery
				)
	)
	SELECT id FROM roads_ways_vertices_pgr 
	WHERE component IN (SELECT * FROM to_remove)
);
-- Removing unused vertices
WITH
subquery AS (
	SELECT component, count(*) 
	FROM roads_ways_vertices_pgr 
	GROUP BY component
	),
	to_remove AS (
		SELECT component FROM subquery 
		WHERE count != (SELECT max(count) FROM subquery)
		)
	DELETE FROM roads_ways_vertices_pgr 
	WHERE component IN (SELECT * FROM to_remove
);
\o Exercise_10.txt
SELECT source,target,edge, r.the_geom
FROM pgr_kruskalDFS(
    'SELECT gid AS id, source, target, cost, reverse_cost, the_geom 
    FROM roads.roads_ways ORDER BY id',
    91), 
roads.roads_ways AS r
WHERE edge = r.gid
LIMIT 10;
-- list_of_edges_with_costs
SELECT source,target,edge,agg_cost
FROM pgr_kruskalDFS(
    'SELECT gid AS id, source, target, cost, reverse_cost, the_geom 
    FROM roads.roads_ways 
    ORDER BY id',91), 
roads.roads_ways AS r
WHERE edge = r.gid 
ORDER BY agg_cost
LIMIT 10;
\o Exercise_11.txt
SELECT SUM(length_m)/1000 
FROM (
	SELECT source,target,edge,agg_cost,r.length_m             
	FROM pgr_kruskalDFS(
		'SELECT gid AS id, source, target, cost, reverse_cost, the_geom 
		FROM roads.roads_ways 
		ORDER BY id',91), 
	roads.roads_ways AS r
	WHERE edge = r.gid 
	ORDER BY agg_cost) 
AS subquery;
\o Exercise_12.txt
-- Compute total length of roads in km
SELECT SUM(length_m)/1000 FROM roads_ways;
\o
