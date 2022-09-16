<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once ('Class_db.php');
	
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid']) && !isSet($_SESSION['type'])) header ("Location: index.php?mod=login");
	else $uida = $_SESSION['uid'];
	
	$db = new Classdb();
	$db->connection();
	
	if ($_GET['mod']=='profile') {
		if ( isSet($_GET['uid']) && !is_numeric($_GET['uid']) ) { 
			header ("Location: index.php");
		}
		/* logged user is watching his profile */
		else if ( !isSet($_GET['uid']) || (isSet($_GET['uid']) && ($_GET['uid']==$_SESSION['uid'])) ) {
			/* Personal data */
			personal_data($db, $uida);
			/* wished list */
			desired_game($db, $uida);
			/* Played list */
			hadtried_game($db, $uida);
			/* Friends list */
			friends_mylist($db, $uida);
			/* Check pending friendship */
			$resource = $db->query("SELECT name, surname, uid_active FROM PendingFriendship WHERE uid_asked='$uida'");
			$row = pg_num_rows($resource);
			if ($row >= 1) {
				for ($i = 0; $i < $row; $i++) {
					$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);	
					print ("<br /><fieldset><table summary=\"request\" id=\"request\">");
						print ("<tr>");
							print ("<td>You've received a friendship request from <strong>". $result['name'] ." ". $result['surname'] ."</strong>. Do you want to be his friend?");
							print ("<form target=\"pendingreq_box\" class=\"padding-el\" action=\"accepted_friendship.php?uid={$result['uid_active']}\" method=\"post\">");
								print ("<input type=\"submit\" name=\"button\" value=\"Accept\" class=\"button\"/>");
								print ("<input type=\"submit\" name=\"button\" value=\"Decline\" class=\"button\"/>");
							print ("</form>");
							print ("</td>");
						print ("</tr>");
					print ("</table></fieldset><br />");
				}
				print("<iframe name=\"pendingreq_box\" id=\"pendingreq_box\" width=\"50%\" height=\"80\" align=\"right\" scrolling=\"auto\"></iframe>");
			}
			pg_free_result($resource);
		}
		/* Ih the user is watching another profile, the uid asked is in GET */
		else {
			$uidb = $_GET['uid'];
			/* User loggedo is the admin? so he can */
			if ($_SESSION['type'] == 2) {
				personal_data($db, $uidb);
				desired_game($db, $uidb);
				hadtried_game($db, $uidb);
				friends_list($db, $uidb);
				/* Are they friend? */
				$resource = $db->query("SELECT * FROM Friendship WHERE (uid_active='$uida' AND uid_asked='$uidb') OR (uid_active='$uidb' AND uid_asked='$uida')");
				$row = pg_num_rows($resource);
				if ($row != 1) {
					pg_free_result($resource);
					/* Ask friendship! */
					check_friendship($db,$uida,$uidb);
				}
				else pg_free_result($resource);
			}
			/* Or the user logged is a registered: can he watch the other profile? */
			else if ($_SESSION['type'] == 0) {
				/* Friend */
				$resource = $db->query("SELECT * FROM Friendship WHERE (uid_active='$uida' AND uid_asked='$uidb') OR (uid_active='$uidb' AND uid_asked='$uida')");
				$row = pg_num_rows($resource);
				if ($row == 1) {
					pg_free_result($resource);
					personal_data($db, $uidb);
					desired_game($db, $uidb);
					hadtried_game($db, $uidb);
					friends_list($db, $uidb);
				}
				/* Not Friend */
				else {
					pg_free_result($resource);
					/* So ask friendship */
					check_friendship($db,$uida,$uidb);
				}
			}	
		}
	}
	$db->disconnection();
	
	/* @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ functions @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ */

	function personal_data($db, $uid) {
		$resource = $db->query("SELECT email,name,surname,age,sex,country FROM Profiles WHERE uid='$uid'");
		$row = pg_num_rows($resource);
		if ($row == 1) {
			$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);	
			print ("<fieldset><legend><big><strong>Personal Data</strong></big></legend>");
			print ("<table border=\"1\">\r\n");
				print ("<tr>\r\n");
					print ("<th>E-mail</th>\r\n");
					print ("<th>Name</th>\r\n");
					print ("<th>Surname</th>\r\n");
					print ("<th>Age</th>\r\n");
					print ("<th>Sex</th>\r\n");
					print ("<th>Country</th>\r\n");
				print ("</tr>\r\n");
				print ("<tr>\r\n");
					print ("<td>". $result['email'] ."</td>\r\n");
					print ("<td>". $result['name'] ."</td>\r\n");
					print ("<td>". $result['surname'] ."</td>\r\n");
					print ("<td>". $result['age'] ."</td>\r\n");
					print ("<td>". $result['sex'] ."</td>\r\n");
					print ("<td>". $result['country'] ."</td>\r\n");
			print ("</table></fieldset>");
		}
		pg_free_result($resource);
	}
	

	function desired_game($db, $uid) {
		$resource = $db->query("SELECT gid, game, type FROM DesiredGame WHERE uid='$uid'");
		$row = pg_num_rows($resource);
		if ($row >= 1) {
			print ("<fieldset><legend><big><strong>Desired game</strong></big></legend>");
			print ("<table border=\"1\">\r\n");
				print ("<tr>\r\n");
					print ("<th>Game</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);	
				print ("<tr>\r\n");
					print ("<td><a href=\"profile_game.php?gid={$result['gid']}&type={$result['type']}\">". $result['game'] ."</a></td>\r\n");
				print ("</tr>\r\n");
			}
			print ("</table></fieldset>");
		}
		pg_free_result($resource);	
	}
	
	function hadtried_game($db, $uid) {
		$resource = $db->query("SELECT gid, game, type, review, vote FROM HadTriedGame WHERE uid='$uid'");
		$row = pg_num_rows($resource);
		if ($row >= 1) {
			print ("<fieldset><legend><big><strong>Had or Tried game</strong></big></legend>");
			print ("<table border=\"1\">\r\n");
				print ("<tr>\r\n");
					print ("<th>Game</th>\r\n");
					print ("<th>Review</th>\r\n");
					print ("<th>Vote</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);	
				print ("<tr>\r\n");
					print ("<td><a href=\"profile_game.php?gid={$result['gid']}&type={$result['type']}\">". $result['game'] ."</a></td>\r\n");
					print ("<td>". $result['review'] ."</td>\r\n");
					print ("<td>". $result['vote'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
			print ("</table></fieldset>");
		}
		pg_free_result($resource);
	}
	
	function friends_mylist($db, $uid) {
		$resource = $db->query("SELECT * FROM FriendsList WHERE uid_active='$uid' OR uid_asked='$uid'");
		$row = pg_num_rows($resource);
		if ($row >= 1) {
			print ("<fieldset><legend><big><strong>Friend List</strong></big></legend>");
			print ("<table border=\"1\">\r\n");
				print ("<tr>\r\n");
					print ("<th>Friend</th>\r\n");
					print ("<th>Get Profile</th>\r\n");
					print ("<th>Revoke Friendship</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
				/* Friendship asked for the user whose the logged user is watching the profile */
				if ($uid==$result['uid_active']) {
					print ("<td>". $result['name_asked'] ." ". $result['surname_asked'] ."</td>\r\n");
					print ("<td><a href=\"index.php?mod=profile&uid={$result['uid_asked']}\" target=\"_parent\" >Get profile</a></td>\r\n");
					print ("<td><a href=\"revoke_friendship.php?uida=$uid&uidb={$result['uid_asked']}\" target=\"_parent\" >Revoke</a></td>\r\n");
				}
				/* Friendship asked for the user logged */
				else {
					print ("<td>". $result['name_active'] ." ". $result['surname_active'] ."</td>\r\n");
					print ("<td><a href=\"index.php?mod=profile&uid={$result['uid_active']}\" target=\"_parent\" >Get profile</a></td>\r\n");
					print ("<td><a href=\"revoke_friendship.php?uida={$result['uid_active']}&uidb=$uid\" target=\"_parent\" >Revoke</a></td>\r\n");
				}
				print ("</tr>\r\n");
			}
			print ("</table></fieldset>");
		}
		pg_free_result($resource);
	}
	
	function friends_list($db, $uid) {
		$resource = $db->query("SELECT * FROM FriendsList WHERE uid_active='$uid' OR uid_asked='$uid'");
		$row = pg_num_rows($resource);
		if ($row >= 1) {
			print ("<fieldset><legend><big><strong>Friend List</strong></big></legend>");
			print ("<table border=\"1\">\r\n");
				print ("<tr>\r\n");
					print ("<th>Friend</th>\r\n");
					print ("<th>Get Profile</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
				/* Friendship asked for the user whose the logged user is watching the profile */
				if ($uid==$result['uid_active']) {
					print ("<td>". $result['name_asked'] ." ". $result['surname_asked'] ."</td>\r\n");
					print ("<td><a href=\"index.php?mod=profile&uid={$result['uid_asked']}\" target=\"_parent\" >Get profile</a></td>\r\n");
				}
				/* Friendship asked for the user logged */
				else {
					print ("<td>". $result['name_active'] ." ". $result['surname_active'] ."</td>\r\n");
					print ("<td><a href=\"index.php?mod=profile&uid={$result['uid_active']}\" target=\"_parent\" >Get profile</a></td>\r\n");
				}
				print ("</tr>\r\n");
			}
			print ("</table></fieldset>");
		}
		pg_free_result($resource);
	}
	
	/* function that check friendship, and in case of negative result, ask it for */
	function check_friendship($db,$uida,$uidb) {
		/* Logged user has already sent a request of freindship as this user */
		$resource = $db->query("SELECT * FROM PendingFriendship WHERE uid_active='$uida' AND uid_asked='$uidb'");
		$row = pg_num_rows($resource);
		if ($row == 1) {
			print("<p>You've already sent a request of friendship. Wait for it quietly!</p>\r\n");
			pg_free_result($resource);
		}
		else {
			/* Logged user has already received a request of freindship as this user */
			pg_free_result($resource);
			$resource = $db->query("SELECT * FROM PendingFriendship WHERE uid_active='$uidb' AND uid_asked='$uida'");
			$row = pg_num_rows($resource);
			if ($row == 1) print("<p>This user has already sent you a friendship request. Check it in your profile!</p>\r\n");
			/* Else ask the friendship */
			else {
				print ("<table border=\"1\">\r\n");
					print ("<tr>\r\n");
						print ("<td class=\"td-dx\">");
						print ("<div class=\"padding-el\">");
						print ("You are not friend oh this user! ");
						print ("<a href=\"offer_friendship.php?uid=$uidb\" target=\"friendship_box\">Request of Friendship</a>");
					print ("</td></tr>\r\n");
				print ("</table>");
				print("<iframe name=\"friendship_box\" id=\"friendship_box\" width=\"50%\" height=\"80\" align=\"right\" scrolling=\"auto\"></iframe>");		}
			pg_free_result($resource);
		}
	}
?>
