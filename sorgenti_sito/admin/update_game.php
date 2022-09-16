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
			$_SESSION['gid'] = $result['gid'];
			$_SESSION['gametype'] = $_POST['type'];
			switch ($_POST['type']) {
				case 0:
					require_once ('games_form/update_videogm_form.inc.php');
					break;
				case 1:
					require_once ('games_form/update_tablegm_form.inc.php');
					break;
				case 2:
					require_once ('games_form/update_cardgm_form.inc.php');
					break;
				case 3:
					require_once ('games_form/update_othergm_form.inc.php');
			}
		}
		else print("<p>This game doesn't exist. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-update name of the game.</p>");
		pg_free_result($resource);
	}
	
	else if ( isSet($_POST['nplayer']) && isSet($_POST['age']) ) {
		if ( !empty($_POST['nplayer']) && !empty($_POST['age']) ) {
			/* Check not right data */
			if ( !(is_numeric($_POST['nplayer'])) || !(is_numeric($_POST['age'])) ) {
				print("<p>Please, insert a numeric value for both <strong>number player</strong> and <strong>suggested age</strong>. Click ");
				print("<a href=\"../index.php?mod=moder\" target=\"_parent\">here</a> to come back and retry</p>");
			}
			else {
				$player = $_POST['nplayer'];
				$age = $_POST['age'];
				$gid = $_SESSION['gid'];
				$type = $_SESSION['gametype'];
				unset ($_SESSION['gid']);
				unset ($_SESSION['gametype']);
				$resource = $db->query("UPDATE Game SET sugg_age='$age',n_player='$player' WHERE gid='$gid'");
				pg_free_result($resource);
				/* Videogame */
				if (!empty($_POST['console'])) {
					$resource = $db->query("DELETE FROM Reference WHERE gid='$gid'");
					pg_free_result($resource);
					foreach ($_POST['console'] as $value) {
						$resource = $db->query("INSERT INTO Reference VALUES('$gid','$value')");
						pg_free_result($resource);
					}
				}
				/* Tablegame */
				else if ( !empty($_POST['sugg_num']) || !empty($_POST['duration']) ) {
					if ( (!empty($_POST['sugg_num']) && !is_numeric($_POST['sugg_num'])) || (!empty($_POST['duration']) && !is_numeric($_POST['duration'])) ) {
						print("<p>Error on updating Suggested Number of player and Duration because <em>suggested number</em> and <em>duration</em> must be numeric! Click ");	print ("<a href=\"../index.php?mod=moder\" target=\"_parent\">here</a> to retry.</p>"); 
					}				
					else {
						/* Test empty parameters */
						if (!empty($_POST['sugg_num']) && !empty($_POST['duration'])) {
							$resource = $db->query("UPDATE Tablegame SET sugg_num='{$_POST['sugg_num']}',duration='{$_POST['duration']}' WHERE gid='$gid'");
							pg_free_result($resource);
						}
						else if (!empty($_POST['sugg_num'])) {
							$resource = $db->query("UPDATE Tablegame SET sugg_num='{$_POST['sugg_num']}' WHERE gid='$gid'");
							pg_free_result($resource);
						}
						else if (!empty($_POST['duration'])) {
							$resource = $db->query("UPDATE Tablegame SET duration='{$_POST['duration']}' WHERE gid='$gid'");
							pg_free_result($resource);
						}
					}
				}
				/* Cardgame */
				else if ( !empty($_POST['deck']) ) {
					$resource = $db->query("UPDATE Cardgame SET deck='{$_POST['deck']}' WHERE gid='$gid'");
					pg_free_result($resource);
				}
				/* other */
				print("<p>Click <a href=\"../profile_game.php?gid=$gid&type=$type\" target=\"_parent\">here</a> to get profile of game.</p>");
			}
		}
		else {	/* Incomplete data */
			print("<p>You haven't inserted all info required. Please, click <a href=\"../index.php?mod=moder\" target=\"_parent\">here</a> to come back and retry</p>");
		}
	}
	else print("<p>All the values are necessaries for the activity of moderate. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-update e-mail and name of the game.</p>");
	$db->disconnection();
?>
