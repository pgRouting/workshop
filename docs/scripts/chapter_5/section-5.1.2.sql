-- 5.1.2 from-here

\o section-5.1.2.txt

SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
        source,
        target,
        length_m AS cost
      FROM ways
    ',
    ARRAY[279,13734],
    16826,
    directed := false);

-- 5.1.2 to-here

