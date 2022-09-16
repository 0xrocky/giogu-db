<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once('../Class_db.php');
	if (!isSet($_SESSION['uid'])) header ("Location: ../index.php?mod=login");
	$db = new Classdb();
	$db->connection();
	
	if (!empty($_POST['tag']) && !empty($_POST['game'])) {
		$tag = $_POST['tag'];
		$tag = pg_escape_string($tag);
		$game = $_POST['game'];
		$game = pg_escape_string($game);
		$resource = $db->query("SELECT * FROM Tag WHERE tid='$tag'");
		$row = pg_num_rows($resource);
		if ($row == 1) {
			pg_free_result($resource);
			$resource = $db->query("SELECT gid FROM Game WHERE name ILIKE '$game' AND type={$_POST['type']}");
			$row = pg_num_rows($resource);
			if ($row == 1) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				$gid = $result['gid'];
				pg_free_result($resource);
				$resource = $db->query("SELECT * FROM Association WHERE tid='$tag' AND gid='$gid'");
				$row = pg_num_rows($resource);
				if ($row == 1) {
					pg_free_result($resource);
					$resource = $db->query("DELETE FROM Association WHERE tid='$tag' AND gid='$gid'");
					print("<p>Tag $tag dissociated from $game. Click <a href=\"../index.php?mod=moder\" target=\"_parent\">here</a> to continue to moderate.</p>");		}
				else print("<p>This Tag hasn't associated with this game. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert.</p>");
				pg_free_result($resource);
				}
			else {
				print("<p>This game doesn't exist. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert name of the game.</p>");
				pg_free_result($resource);
			}
		}
		else {
			print("<p>This Tag doesn't exist. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert tag.</p>");
			pg_free_result($resource);
		}
	}
	else print("<p>All the values are necessaries for the activity of moderate. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert e-mail and name of the game.</p>");
	
	$db->disconnection();
?>
