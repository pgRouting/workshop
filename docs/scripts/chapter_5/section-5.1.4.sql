-- 5.1.4 from-here

\o section-5.1.4.txt

SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
       source,
       target,
       length_m / 1.3 / 60 AS cost
      FROM ways
    ',
    ARRAY[279,13734],
    ARRAY[2340, 1442],
    directed := false);

-- 5.1.4 to-here

