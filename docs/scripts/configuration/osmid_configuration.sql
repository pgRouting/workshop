\t
\o osmid_configuration.conf
WITH a AS (SELECT row_number() OVER(), osm_id, id FROM ways_vertices_pgr
WHERE osm_id IN (123392877, 255093299, 1886700005, 6159253045, 6498351588)
)
SELECT 'ID_' || row_number, id from a;
