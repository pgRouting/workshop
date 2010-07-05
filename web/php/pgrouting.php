<?php

   // Database connection settings
   define("PG_DB"  , "routing");
   define("PG_HOST", "localhost"); 
   define("PG_USER", "postgres");
   define("PG_PORT", "5432"); 
   define("TABLE",   "routing"); 

   // Retrieve start point
   $start = split(' ',$_REQUEST['startpoint']);
   $startPoint = array($start[0], $start[1]);

   // Retrieve end point
   $end = split(' ',$_REQUEST['finalpoint']);
   $endPoint = array($end[0], $end[1]);
   
?>

<?php

   // Find the nearest edge
   $startEdge = findNearestEdge($startPoint);
   $endEdge   = findNearestEdge($endPoint);

   // FUNCTION findNearestEdge
   function findNearestEdge($lonlat) {

      // Connect to database
      $con = pg_connect("dbname=".PG_DB." host=".PG_HOST." user=".PG_USER);

      $sql = "SELECT gid, source, target, the_geom, 
		          distance(the_geom, GeometryFromText(
	                   'POINT(".$lonlat[0]." ".$lonlat[1].")', 4326)) AS dist 
	             FROM ".TABLE."  
	             WHERE the_geom && setsrid(
	                   'BOX3D(".($lonlat[0]-0.1)." 
	                          ".($lonlat[1]-0.1).", 
	                          ".($lonlat[0]+0.1)." 
	                          ".($lonlat[1]+0.1).")'::box3d, 4326) 
	             ORDER BY dist LIMIT 1";

      $query = pg_query($con,$sql);  

      $edge['gid']      = pg_fetch_result($query, 0, 0);  
      $edge['source']   = pg_fetch_result($query, 0, 1);  
      $edge['target']   = pg_fetch_result($query, 0, 2);  
      $edge['the_geom'] = pg_fetch_result($query, 0, 3);  

      // Close database connection
      pg_close($con);

      return $edge;
   }
   
?>

<?php

   // Select the routing algorithm
   switch($_REQUEST['method']) {

      case 'SPD' : // Shortest Path Dijkstra 

        $sql = "SELECT rt.gid, ST_AsGeoJSON(rt.the_geom) AS geojson, 
	                 length(rt.the_geom) AS length, ".TABLE.".id 
	              FROM ".TABLE.", 
	                  (SELECT gid, the_geom 
	                      FROM dijkstra_sp_delta(
	                          '".TABLE."',
	                          ".$startEdge['source'].",
	                          ".$endEdge['target'].",
	                          0.1)
	                   ) as rt 
	              WHERE ".TABLE.".gid=rt.gid;";
        break;
        
      case 'SPA' : // Shortest Path A* 

        $sql = "SELECT rt.gid, ST_AsGeoJSON(rt.the_geom) AS geojson, 
	                   length(rt.the_geom) AS length, ".TABLE.".id 
	                FROM ".TABLE.", 
	                    (SELECT gid, the_geom 
	                        FROM astar_sp_delta(
	                            '".TABLE."',
	                            ".$startEdge['source'].",
	                            ".$endEdge['target'].",
	                            0.1)
	                     ) as rt 
	                WHERE ".TABLE.".gid=rt.gid;";  
        break;

      case 'SPS' : // Shortest Path Shooting*

        $sql = "SELECT rt.gid, ST_AsGeoJSON(rt.the_geom) AS geojson, 
	                   length(rt.the_geom) AS length, ".TABLE.".id 
	                FROM ".TABLE.", 
	                    (SELECT gid, the_geom 
	                        FROM shootingstar_sp(
	                            '".TABLE."',
	                            ".$startEdge['gid'].",
	                            ".$endEdge['gid'].",
	                            0.1, 'length', true, true)
	                     ) as rt 
	                WHERE ".TABLE.".gid=rt.gid;";
        break;   

   } // close switch

   // Connect to database
   $dbcon = pg_connect("dbname=".PG_DB." host=".PG_HOST." user=".PG_USER);

   // Perform database query
   $query = pg_query($dbcon,$sql); 
   
?>

<?php

   // Return route as GeoJSON
   $geojson = array(
      'type'      => 'FeatureCollection',
      'features'  => array()
   ); 
  
   // Add edges to GeoJSON array
   while($edge=pg_fetch_assoc($query)) {  

      $feature = array(
         'type' => 'Feature',
         'geometry' => json_decode($edge['geojson'], true),
         'crs' => array(
            'type' => 'EPSG',
            'properties': array('code' => '4326')
         ),
         'properties' => array(
            'id' => $edge['id'],
            'length' => $edge['length']
         )
      );
      
      // Add feature array to feature collection array
      array_push($geojson['features'], $feature);
   }

	
   // Close database connection
   pg_close($dbcon);

   // Return routing result
   header('Content-type: application/json',true);
   echo json_encode($geojson);
   
?>

