\t
\o osmid_configuration.conf
WITH a AS (SELECT 1 AS r, osm_id, id FROM ways_vertices_pgr
WHERE osm_id = @OSMID_1@)
SELECT 'ID_' || r, id from a;

WITH a AS (SELECT 2 AS r, osm_id, id FROM ways_vertices_pgr
WHERE osm_id = @OSMID_2@)
SELECT 'ID_' || r, id from a;

WITH a AS (SELECT 3 AS r, osm_id, id FROM ways_vertices_pgr
WHERE osm_id = @OSMID_3@)
SELECT 'ID_' || r, id from a;

WITH a AS (SELECT 4 AS r, osm_id, id FROM ways_vertices_pgr
WHERE osm_id = @OSMID_4@)
SELECT 'ID_' || r, id from a;

WITH a AS (SELECT 5 AS r, osm_id, id FROM ways_vertices_pgr
WHERE osm_id = @OSMID_5@)
SELECT 'ID_' || r, id from a;
