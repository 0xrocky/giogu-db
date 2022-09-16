<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once('Class_db.php');
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: index.php?mod=login");
	
	$db = new Classdb();
	$db->connection();
	
	/* Search for name of game */
	if (isSet($_POST['game']) && !empty($_POST['game'])) {
		$game = $_POST['game'];
		$game = pg_escape_string($game);
		$resource = $db->query("SELECT * FROM GamesType WHERE game ILIKE '$game'");
		if (searchg_result($resource)==0) print("<strong>Sorry but there isn't game in Giogu with this name</strong>");
	}
	/* Search for tags of game */
	else if (isSet($_POST['tag']) && !empty($_POST['tag'])) {
		$tag = $_POST['tag'];
		$tag = pg_escape_string($tag);
		$resource = $db->query("SELECT * FROM GamesType NATURAL JOIN Association WHERE tid ILIKE '$tag'");
		if (searchg_result($resource)==0) print("<strong>Sorry but there isn't game in Giogu with associated this tag</strong>");
	}

	$db->disconnection();
	
	/* searchg_result display any results if existing */
	function searchg_result($resource) {
		$row = pg_num_rows($resource);
		if ($row >= 1) {
			print ("<table border=\"1\">\r\n");
				print ("<tr>\r\n");
					print ("<th>Name</th>\r\n");
					print ("<th>Typology</th>\r\n");
					print ("<th>Profile</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
					print ("<td>". $result['game'] ."</td>\r\n");
					switch ($result['type']) {
						case 0:
							print ("<td>Videogame</td>\r\n");
							break;
						case 1:
							print ("<td>Tablegame</td>\r\n");
							break;
						case 2:
							print ("<td>Cardgame</td>\r\n");
							break;
						case 3:
						default:
							print ("<td>Other</td>\r\n");
					}
					print ("<td><a href=\"profile_game.php?gid={$result['gid']}&type={$result['type']}\" target=\"_parent\">Get profile</a></td>\r\n");					print ("</tr>\r\n");
			}
			print ("</table>");
			pg_free_result($resource);
			return 1;
		}
		else {
			pg_free_result($resource);
			return 0;
		}
	}
?>
