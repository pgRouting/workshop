-- 5.2.2 from-here

\o section-5.2.2.txt

SELECT start_vid, sum(agg_cost)
FROM pgr_dijkstraCost(
    '
      SELECT gid AS id,
        source,
        target,
        length_m  / 1.3 / 60 AS cost
      FROM ways
    ',
    ARRAY[279,13734],
    ARRAY[2340, 1442],
    directed := false)
GROUP BY start_vid
ORDER BY start_vid;

-- 5.2.2 to-here

