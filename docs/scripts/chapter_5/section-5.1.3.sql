-- 5.1.3 from-here

\o section-5.1.3.txt

SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
        source,
        target,
        length_m / 1.3 AS cost
      FROM ways
    ',
    16826,
    ARRAY[279,13734],
    directed := false);

-- 5.1.3 to-here

