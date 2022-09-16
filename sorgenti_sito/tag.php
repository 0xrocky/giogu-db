<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once('Class_db.php');
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: index.php?mod=login");
	
	$db = new Classdb();
	$db->connection();
	
	/* Check data empty */
	if (isSet($_POST['tid']) && !empty($_POST['tid'])) {
		$tag = strtolower($_POST['tid']);
		$tag = pg_escape_string($tag);
		$resource = $db->query("SELECT * FROM Tag WHERE tid ILIKE '$tag'");
		$row = pg_num_rows($resource);
		if ($row == 1) {
			/* Tag already existing in the DB */
			print ("<p><strong>You have choosen a tag already existing.</strong></p>");
			pg_free_result($resource);
		}
		else {
			/* New Tag in the DB */
			pg_free_result($resource);
			$resource = $db->query("INSERT INTO Tag VALUES ('$tag')");
			print ("<p><strong>New tag is inserted.</strong></p>");
			pg_free_result($resource);
		}
		/* The tas is dicrecty also associated with a game? */
		if (isSet($_POST['game']) && !empty($_POST['game'])) {
			$game = pg_escape_string($_POST['game']);
			$type = $_POST['type'];
			$resource = $db->query("SELECT * FROM GamesType NATURAL JOIN Association WHERE tid ILIKE '$tag' AND game ILIKE '$game' AND type='$type'");
			$row = pg_num_rows($resource);
			if ($row == 1) {
				print ("<p><strong>The association between tag vs. game of this typology already exists.</strong></p>");
				pg_free_result($resource);
			}
			else {
				pg_free_result($resource);
				$resource = $db->query("SELECT gid FROM GamesType WHERE game ILIKE '$game' AND type='$type'");
				$row = pg_num_rows($resource);			
				if ($row == 1) {
					$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
					$gid = $result['gid'];
					pg_free_result($resource);
					$resource = $db->query("INSERT INTO Association VALUES ('$tag','$gid')");
					print ("<p><em>$game</em> tagged. Get it ");
					print ("<a href=\"profile_game.php?gid=$gid&type=$type\" target=\"_parent\">profile</a>\r\n");
					print (" to see the results.</p>");
					pg_free_result($resource);
				}
				else {
					print ("<p><strong>Error on tag. Game not found</strong></p>");
					pg_free_result($resource);
				}
			}
		}
	}
	$db->disconnection();
?>
