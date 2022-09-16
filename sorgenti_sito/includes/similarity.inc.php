<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once ('Class_db.php');
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: index.php?mod=login");
	else $uid = $_SESSION['uid'];
	$db = new Classdb();
	$db->connection();
	
	if ($_GET['mod']=='simil') {
		/* Select first 10 users simil */
		print ("<p><strong>List of first 10 users similar to you based on the number of games reported, and the average score assigned to each of those tested.</strong></p>");
		$resource = $db->query("SELECT * FROM similarity($uid) AS (uid integer,name varchar(20),surname varchar(20),similarity integer) WHERE similarity<>'0' ORDER BY similarity DESC LIMIT '10'");
		$row = pg_num_rows($resource);
		if ($row >= 1) {
		print ("<fieldset><legend><strong>User</strong></legend>\r\n");
			print ("<ul>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<li>User: <a href=\"index.php?mod=profile&uid={$result['uid']}\" target=\"_parent\">". $result['name'] ." ". $result['surname'] ."</a> - Affinity: ". $result['similarity'] ." %</li>\r\n");
			}
		print ("</ul></fieldset>");
		}
		else print ("<p><em>Sorry, not enough data to compute similarity.</em></p>");
	}
	pg_free_result($resource);
	$db->disconnection();
?>
