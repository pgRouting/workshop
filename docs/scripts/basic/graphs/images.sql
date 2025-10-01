DROP TABLE IF EXISTS costMatrix_png;

SELECT row_number() over() as gid, ST_makeline(v1.geom, v2.geom) AS geom,
'('||start_vid||', '||end_vid||') t= ' || round(agg_cost::NUMERIC, 2) AS name
INTO costMatrix_png
FROM pgr_dijkstraCostMatrix(
  'SELECT * FROM vehicle_net',
  ARRAY[@ID_1@, @ID_2@, @ID_3@, @ID_4@, @ID_5@])
JOIN vertices v1 ON (start_vid=v1.id)
JOIN vertices v2 ON (end_vid=v2.id);
