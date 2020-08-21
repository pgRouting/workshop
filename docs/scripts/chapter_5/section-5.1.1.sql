-- 5.1.1 from-here 

\o section-5.1.1.txt

SELECT * FROM pgr_dijkstra(
    '
      SELECT gid AS id,
        source,
        target,
        length AS cost
      FROM ways
    ',
    279,
    16826,
    directed := false);

-- 5.1.1 to-here
