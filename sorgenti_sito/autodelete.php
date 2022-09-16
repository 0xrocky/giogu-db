<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once ('file_config_db.php');
	
	/* Static connession as admin: he's the unique who can delete games */
	$id_connection = pg_connect("host=$dbhost port=$dbport dbname=$dbname user=$dbadmin password=$dbadmin_pass");
	/* Delete Games not referenced from almost 3 people for more than 5 days */
	$resource = pg_query($id_connection, "SELECT * FROM Autodelete");
	$row = pg_num_rows($resource);
	if ($row >= 1) {
		for ($i = 0; $i < $row; $i++) {
			$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
			$gid = $result['gid'];
			$reference = pg_query($id_connection, "DELETE FROM Game WHERE gid='$gid'");
			pg_free_result($reference);
		}
	}
	pg_free_result($resource);
	pg_close($id_connection);
?>
