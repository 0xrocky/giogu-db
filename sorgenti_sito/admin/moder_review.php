<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once('../Class_db.php');
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: ../index.php?mod=login");
	$db = new Classdb();
	$db->connection();
	
	if (!empty($_POST['email']) && !empty($_POST['game'])) {
		$email = $_POST['email'];
		$email = pg_escape_string($email);
		$game = $_POST['game'];
		$game = pg_escape_string($game);
		$resource = $db->query("SELECT uid FROM Users WHERE email='$email'");
		$row = pg_num_rows($resource);
		if ($row == 1) {
			$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
			$uid = $result['uid'];
			pg_free_result($resource);
			$resource = $db->query("SELECT gid FROM Game WHERE name ILIKE '$game' AND type={$_POST['type']}");
			$row = pg_num_rows($resource);
			if ($row == 1) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				$gid = $result['gid'];
				pg_free_result($resource);
				$resource = $db->query("SELECT review,vote FROM HadTried WHERE uid='$uid' AND gid='$gid'");
				$row = pg_num_rows($resource);
				if ($row == 1) {
					/* print vote, review */
					print ("<table border=\"1\">\r\n");
						print ("<tr>\r\n");
							print ("<th>Game</th>\r\n");
							print ("<th>Review</th>\r\n");
							print ("<th>Vote</th>\r\n");
						print ("</tr>\r\n");
						$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);	
						print ("<tr>\r\n");
							print ("<td>". $game ."</td>\r\n");
							print ("<td>". $result['review'] ."</td>\r\n");
							print ("<td>". $result['vote'] ."</td>\r\n");
						print ("</tr>\r\n");
					print ("</table>");
					print("<fieldset>");
					print("<form id=\"reviewform\" class=\"padding-el\" method=\"post\" action=\"../review_vote.php?gid=$gid&uid=$uid\">");
						print("<table>");
			 				print("<tr><td>Grade</td><td><select name=\"grade\"/>");
								print("<option value=\"{$result['vote']}\">unchanged</option>  <option value=\"1\">1</option>  <option value=\"2\">2</option>  <option value=\"3\">3</option>  <option value=\"4\">4</option>  <option value=\"5\">5</option>  <option value=\"6\">6</option>  <option value=\"7\">7</option>  <option value=\"8\">8</option>  <option value=\"9\">9</option>  <option value=\"10\">10</option> </select></td></tr>");
							print("<tr><td>Review</td><td><textarea name=\"review\" style=\"width:25em; height:5em;\"/></textarea></td></tr>");
						print("</table>");
						print("<input type=\"submit\" value=\"send\" class=\"button\"/>");
					print("</form></fieldset>");
				}
				else print("<p>This user hasn't played this game. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert e-mail and name of the game.</p>");
				pg_free_result($resource);
			}
			else {
				print("<p>This game doesn't exist. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert e-mail and name of the game.</p>");
				pg_free_result($resource);
			}
		}
		else {
			print("<p>This user doesn't exist. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert e-mail and name of the game.</p>");
			pg_free_result($resource);
		}
	}
	else print("<p>All the values are necessaries for the activity of moderate. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert e-mail and name of the game.</p>");
	
	$db->disconnection();
?>
