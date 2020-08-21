-- 5.2.1 from-here

\o section-5.2.1.txt

SELECT *
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
    directed := false);

-- 5.2.1 to-here

