/*
.. |id_1| replace:: ``3363``
.. |id_2| replace:: ``14745``
.. |id_3| replace:: ``14441``
.. |id_4| replace:: ``6649``
.. |id_5| replace:: ``1175``
*/

DROP TABLE IF EXISTS landmarks;

SELECT osm_id, id, ''::TEXT AS name, the_geom
INTO landmarks
FROM ways_vertices_pgr
WHERE osm_id IN (123392877, 255093299, 1886700005, 6159253045, 6498351588)
ORDER BY osm_id;
UPDATE landmarks SET name='Hotel' WHERE id = 3363;
UPDATE landmarks SET name='Hostal' WHERE id = 14745;
UPDATE landmarks SET name='Venue' WHERE id = 14441;
UPDATE landmarks SET name='Workshops' WHERE id = 6649;
UPDATE landmarks SET name='Parliament' WHERE id = 1175;

