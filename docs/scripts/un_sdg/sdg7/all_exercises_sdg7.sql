\o setting_search_path.txt
-- Enumerate all the schemas
\dn

-- Show the current search path
SHOW search_path;

-- Set the search path
SET search_path TO roads,public;
SHOW search_path;


-- Enumerate all the tables
\dt

\o count_roads.txt
-- Counting the number of Edges of roads
SELECT count(*) FROM roads_ways;

-- Counting the number of Vertices of roads
SELECT count(*) FROM roads_ways_vertices_pgr;
\o discard_disconnected_roads.txt
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
-- These components are to be removed
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
-- The edges that need to be removed
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
-- Removing the unwanted edges
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
\o kruskal_minimum_spanning_tree.txt
-- Adding id column
ALTER TABLE roads_ways
ADD COLUMN id INTEGER;
UPDATE roads_ways SET id = gid;
-- Finding the minimum spanning tree
SELECT source,target,edge, r.the_geom 
FROM pgr_kruskalDFS(
    'SELECT id, source, target, cost, reverse_cost, the_geom 
    FROM roads.roads_ways ORDER BY id',
    91), 
roads.roads_ways AS r
WHERE edge = r.gid;
\o list_of_edges_with_costs
SELECT source,target,edge,agg_cost
FROM pgr_kruskalDFS(
    'SELECT id, source, target, cost, reverse_cost, the_geom 
    FROM roads.roads_ways 
    ORDER BY id',91), 
roads.roads_ways AS r
WHERE edge = r.gid 
ORDER BY agg_cost;
\o comparison.txt
-- Compute total length of material required in km
SELECT sum(cost) * 111  
FROM (
	SELECT source,target,edge,agg_cost,r.cost              
	FROM pgr_kruskalDFS(
		'SELECT id, source, target, cost, reverse_cost, the_geom 
		FROM roads.roads_ways 
		ORDER BY id',91), 
	roads.roads_ways AS r
	WHERE edge = r.gid 
	ORDER BY agg_cost) 
AS subquery;

-- Compute total length of roads in km
SELECT SUM(cost) * 111  FROM roads_ways;
\o
