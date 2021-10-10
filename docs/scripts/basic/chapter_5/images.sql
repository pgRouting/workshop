-- psql -f images.sql --no-align city_routing
\t
\o map_5.1.json
SELECT jsonb_pretty(ST_AsGeoJson(the_geom)::jsonb) from (select * from ways limit 2) a;
