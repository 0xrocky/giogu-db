<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	if (!isSet($_SESSION['uid'])) header ("Location: index.php");
	require_once('Class_db.php');
	$db = new Classdb();
	$db->connection();
	
	/* If parameters arrive via POST, then are sent from the insert form */
	if ( isSet($_POST['game']) && isSet($_POST['nplayer']) && isSet($_POST['age']) ) {

		if ( !empty($_POST['game']) && !empty($_POST['nplayer']) && !empty($_POST['age']) ) {
			/* Check data not in the right shape */
			if (!(is_numeric($_POST['nplayer'])) || !(is_numeric($_POST['age']))) {
				print("<p>Please, insert a numeric value for both <strong>number player</strong> and <strong>suggested age</strong>. Click ");
				print("<a href=\"index.php?mod=insert\" target=\"_parent\">here</a> to come back and retry</p>");
			}
			else {	
				$game = pg_escape_string(htmlentities(ucwords(strtolower($_POST['game']))));
				$player = $_POST['nplayer'];
				$age = $_POST['age'];
				$resource = $db->query("SELECT gid,name,type FROM Game WHERE name ILIKE '%$game%'");
				$row = pg_num_rows($resource);
				/* Check if a simil game is already present */
				if ($row >= 1) {
					print("<p>Are you sure you want to insert this game?...or your game is already present in our archives?<br /></p>");
					print("<ul>");
					for ($i = 0; $i < $row; $i++) {
						$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
						switch ($result['type']) {
							case 0:
								print ("<li>Videogame ");
								break;
							case 1:
								print ("<li>Tablegame ");
								break;
							case 2:
								print ("<li>Cardgame ");
								break;
							case 3:
							default:
								print ("<li>Other game ");
						}
						print ("<a href=\"profile_game.php?gid={$result['gid']}&type={$result['type']}\" target=\"_parent\">". $result['name'] ."</a>");
						print("</li>");
					}
					print("</ul>");
					/* If exist a simil game, ask the user for he wants to do */
					print ("<form class=\"padding-el\" action=\"insert_cardgm.php?game=$game&player=$player&age=$age\" method=\"post\">");
						print ("<input type=\"hidden\" name=\"deck\" value=\"{$_POST['deck']}\"/>");
						print ("<input type=\"submit\" name=\"button\" value=\"Yes\" class=\"button\"/>");
						print ("<input type=\"submit\" name=\"button\" value=\"No\" class=\"button\"/>");
					print ("</form>");
					pg_free_result($resource);
				}
				/* Else insert it directly */
				else {
					pg_free_result($resource);
					$resource = $db->query("INSERT INTO Game(name, sugg_age, n_player, type) VALUES('$game','$age','$player','2')");
					pg_free_result($resource);
					/* Recover gid to insert the game in the specific typology table */
					$resource = $db->query("SELECT gid FROM Game WHERE name='$game' AND sugg_age='$age' AND n_player='$player' AND type='2'");
					$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
					$gid = $result['gid'];
					pg_free_result($resource);
					$resource = $db->query("INSERT INTO Cardgame VALUES('$gid','{$_POST['deck']}')");
					pg_free_result($resource);
					print("<p>Click <a href=\"profile_game.php?gid=$gid&type=2\" target=\"_parent\">here</a> to get profile of new game.</p>");
				}
			}
		}
		else {	/* incomplet data */
			print("<p>You haven't inserted all info required. Please, click ");
			print("<a href=\"index.php?mod=insert\" target=\"_parent\">here</a>");
			print(" to come back and retry</p>");
		}
	}
	/* If parameters arrive via GET, then existed a simil game, so the user has sent his intention via POST */
	else if ( isSet($_GET['game']) && isSet($_GET['player']) && isSet($_GET['age']) ) {
			if ($_POST['button']=='Yes') {
				/* Forbid the insert in case of an equal game already existing */
				$resource = $db->query("SELECT gid FROM Game WHERE name='{$_GET['game']}' AND type='2'");
				$row = pg_num_rows($resource);
				if ($row == 1) {
					$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
					print("<p>This game already exists! Click <a href=\"profile_game.php?gid={$result['gid']}&type=2\" target=\"_parent\">here</a> to get profile of it.</p>");			
					pg_free_result($resource);
				}
				else {	
					/* Insert it */
					$resource = $db->query("INSERT INTO Game(name, sugg_age, n_player, type) VALUES('{$_GET['game']}','{$_GET['age']}','{$_GET['player']}','2')");
					pg_free_result($resource);
					/* Recover gid to insert the game in the specific typology table */
					$resource = $db->query("SELECT gid FROM Game WHERE name='{$_GET['game']}' AND sugg_age='{$_GET['age']}' AND n_player='{$_GET['player']}' AND type='2'");
					$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
					$gid = $result['gid'];
					pg_free_result($resource);
					$resource = $db->query("INSERT INTO Cardgame VALUES('$gid','{$_POST['deck']}')");
					pg_free_result($resource);
					print("<p>Click <a href=\"profile_game.php?gid=$gid&type=2\" target=\"_parent\">here</a> to get profile of new game.</p>");
				}
			}
			else if ($_POST['button']=='No') {
				/* Not Insert game */
	 			print("<p>Click <a href=\"index.php\" target=\"_parent\">here</a> to return.</p>");
			}
	}
	$db->disconnection();
?> 
