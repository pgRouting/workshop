set -e

# 5.1-1 from-here

# Identifiers for the Queries
# Connect to the database, if not connected
\o section-5.1-1.txt

psql city_routing << EOF

SELECT osm_id, id FROM ways_vertices_pgr
WHERE osm_id IN (123392877, 255093299, 1886700005, 6159253045, 6498351588)
ORDER BY osm_id;

EOF

# 5.1-1 to-here