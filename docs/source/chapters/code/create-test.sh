
cat  ../solutions/shortest_problems.sql \
    ../solutions/advanced_problems.sql \
    ../solutions/wrapper_problems.sql \
    ../solutions/fromAtoB.sql > functions.sql

perl -pi -e 's/\\o.*$//' functions.sql

psql city_routing <<EOF
BEGIN;
\o tmp.tmp
    ALTER TABLE osm_way_classes DROP COLUMN penalty;
    \i functions.sql
\o
END;
EOF


cat  ../solutions/shortest_problems.sql \
    ../solutions/advanced_problems.sql \
    ../solutions/wrapper_problems.sql \
    ../solutions/fromAtoB.sql > QGISfunctions.sql

perl -pi -e 's/^.*ad-/ad_/' QGISfunctions.sql
perl -pi -e 's/^.*d-/d_/' QGISfunctions.sql

perl -pi -e 's/^.*ch7-e1.*$//' QGISfunctions.sql
perl -pi -e 's/^.*ch7-e2.*$//' QGISfunctions.sql
perl -pi -e 's/^.*ch7-e9.*$//' QGISfunctions.sql
perl -pi -e 's/^.*ch7-/ch7_/' QGISfunctions.sql

perl -pi -e 's/^.*ch8-e3.*$//' QGISfunctions.sql
perl -pi -e 's/^.*ch8-e5.*$//' QGISfunctions.sql
perl -pi -e 's/^.*ch8-/ch8_/' QGISfunctions.sql
perl -pi -e 's/^.*info-/info_/' QGISfunctions.sql

perl -pi -e 's/\\o.*$//' QGISfunctions.sql

perl -pi -e 's/(.+)\.txt$/DROP VIEW IF EXISTS \1 ; CREATE VIEW \1 AS /' QGISfunctions.sql

psql city_routing <<EOF
BEGIN;
    ALTER TABLE osm_way_classes DROP COLUMN penalty;
    \i QGISfunctions.sql
END;
EOF


