
cat \
    ../solutions/shortest_problems.sql \
    ../solutions/advanced_problems.sql \
    ../solutions/wrapper_problems.sql \
    ../solutions/fromAtoB.sql > functions.sql

echo past cat 1

perl -pi -e 's/\\o.*$//' functions.sql

echo past 1

cat  ../solutions/shortest_problems.sql \
    ../solutions/advanced_problems.sql \
    ../solutions/wrapper_problems.sql \
    ../solutions/fromAtoB.sql > QGISfunctions.sql

echo past 2

perl -pi -e 's/^.*ad-/ad_/' QGISfunctions.sql
perl -pi -e 's/^.*ad_10.*$//' QGISfunctions.sql

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

echo past 3
exit

psql city_routing <<EOF
    \i QGISfunctions.sql
EOF


