\o section-6.1-1.txt

SELECT count(*)
FROM ways
WHERE cost < 0;

\o section-6.1-2.txt


SELECT count(*)
FROM ways
WHERE reverse_cost < 0;


\o section-6.1.1.txt

SELECT * FROM pgr_dijkstra(
  '
  SELECT gid AS id,
    4source,
    target,
    cost_s AS cost,
    reverse_cost_s AS reverse_cost
  FROM ways
  '
@ID_3@,
@ID_1@,
directed := true);

