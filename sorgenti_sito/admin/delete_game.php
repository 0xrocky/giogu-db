<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once('../Class_db.php');
	if (!isSet($_SESSION['uid'])) header ("Location: ../index.php?mod=login");
	$db = new Classdb();
	$db->connection();
	
	if (!empty($_POST['game'])) {
		$game = $_POST['game'];
		$game = pg_escape_string($game);
		$resource = $db->query("SELECT gid FROM Game WHERE name ILIKE '$game' AND type={$_POST['type']}");
		$row = pg_num_rows($resource);
		if ($row == 1) {
			$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
			$gid = $result['gid'];
			pg_free_result($resource);
			$resource = $db->query("DELETE FROM Game WHERE gid='$gid'");
			print("<p>Game deleted. Click <a href=\"../index.php?mod=moder\" target=\"_parent\"> here </a> to continue to moderate.</p>");
		}
		else print("<p>This Game doesn't exist. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert e-mail and name of the game.</p>");
		pg_free_result($resource);
	}
	else print("<p>All the values are necessaries for the activity of moderate. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert name of the game.</p>");
	$db->disconnection();
?>
