DROP TABLE IF EXISTS points_on_map;
WITH the_points AS (
SELECT 1 AS id, ST_SetSRID(ST_Point(@POINT1_LON@,  @POINT1_LAT@), 4326)
UNION
SELECT 2 AS id, ST_SetSRID(ST_Point(@POINT2_LON@,  @POINT2_LAT@), 4326)
)
SELECT * INTO points_on_map
FROM the_points;


DROP TABLE IF EXISTS closest_walk;
WITH the_closest AS (
SELECT 1 AS pid, * from pgr_findCloseEdges(
  'SELECT id, geom from walk_net',
   ST_SetSRID(ST_Point(@POINT1_LON@, @POINT1_LAT@), 4326) , 0.5)

UNION

SELECT 2 AS pid, * from pgr_findCloseEdges(
  'SELECT id, geom from walk_net',
  ST_SetSRID(ST_Point(@POINT2_LON@, @POINT2_LAT@), 4326) , 0.5)
)
SELECT * INTO closest_walk FROM the_closest;

CREATE OR REPLACE VIEW using_vehicle AS
SELECT * FROM wrk_withPoints(
  'vehicle_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);

CREATE OR REPLACE VIEW using_taxi AS
SELECT * FROM wrk_withPoints(
  'taxi_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);

CREATE OR REPLACE VIEW using_walk AS
SELECT *
FROM wrk_withPoints(
  'walk_net',
  @POINT1_LAT@, @POINT1_LON@,
  @POINT2_LAT@, @POINT2_LON@);
