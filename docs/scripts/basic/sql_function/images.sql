
CREATE OR REPLACE VIEW using_vehicle AS
SELECT *
FROM wrk_dijkstra('ways',  @CH7_ID_1@, @CH7_ID_2@);

CREATE OR REPLACE VIEW sql_route_geom AS
SELECT seq, id, geom
FROM wrk_dijkstra('ways',  @CH7_ID_1@, @CH7_ID_2@)
JOIN ways USING (id);
