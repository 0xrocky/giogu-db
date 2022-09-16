<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
<link href="style.css" rel="stylesheet" type="text/css" />
<title>Profile Game</title>
</head>
<body>
<div class="div-title">GIOGU: the Gaming Social Network</div>
<table class="main">
  <tr>
    <td class="td-sx"><?php if (!isSet($_SESSION)) session_start(); require_once('menu.php'); ?></td>
    <td class="td-dx">
        <div class="padding-el">

<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once ('Class_db.php');
	
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: index.php");
	else $uid = $_SESSION['uid'];
	
	$db = new Classdb();
	$db->connection();
	
	if (isSet($_GET['gid']) && is_numeric($_GET['gid'])) $gid = $_GET['gid'];
	else header ("index.php?mod=profile");
	if (isSet($_GET['type']) && is_numeric($_GET['type'])) $type = $_GET['type'];
	else header ("index.php?mod=profile");
	
	switch ($type) {
		case 0:
			$resource = $db->query("SELECT game, sugg_age, n_player, mark, console FROM Videogm WHERE gid='$gid'");
			$row = pg_num_rows($resource);
			if ($row >= 1) {
				print("<fieldset><legend><strong><big>Game info</big></strong></legend>");
				print ("<table border=\"1\">\r\n");
					print ("<tr>\r\n");
						print ("<th>Videogame</th>\r\n");
						print ("<th>Suggested Age</th>\r\n");
						print ("<th>Mimimum N. Player</th>\r\n");
						print ("<th>Console Mark</th>\r\n");
						print ("<th>Console Model</th>\r\n");
					print ("</tr>\r\n");
					for ($i = 0; $i < $row; $i++) {
						$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
						print ("<tr>\r\n");
							print ("<td>". $result['game'] ."</td>\r\n");
							print ("<td>". $result['sugg_age'] ."</td>\r\n");
							print ("<td>". $result['n_player'] ."</td>\r\n");
							print ("<td>". $result['mark'] ."</td>\r\n");
							print ("<td>". $result['console'] ."</td>\r\n");
						print ("</tr>\r\n");
					}
				print ("</table></fieldset>");
			}
			pg_free_result($resource);
			break;
		case 1:
			$resource = $db->query("SELECT game, sugg_age, n_player, sugg_num, duration FROM Tablegm WHERE gid='$gid'");
			$row = pg_num_rows($resource);
			if ($row >= 1) {
				print("<fieldset><legend><strong><big>Game info</big></strong></legend>");
				print ("<table border=\"1\">\r\n");
					print ("<tr>\r\n");
						print ("<th>Tablegame</th>\r\n");
						print ("<th>Suggested Age</th>\r\n");
						print ("<th>Mimimum N. Player</th>\r\n");
						print ("<th>Suggested N. Player</th>\r\n");
						print ("<th>Duration (min)</th>\r\n");
					print ("</tr>\r\n");
					for ($i = 0; $i < $row; $i++) {
						$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);	
						print ("<tr>\r\n");
							print ("<td>". $result['game'] ."</td>\r\n");
							print ("<td>". $result['sugg_age'] ."</td>\r\n");
							print ("<td>". $result['n_player'] ."</td>\r\n");
							print ("<td>". $result['sugg_num'] ."</td>\r\n");
							print ("<td>". $result['duration'] ."</td>\r\n");
						print ("</tr>\r\n");
					}
				print ("</table></fieldset>");
			}
			pg_free_result($resource);
			break;
		case 2:
			$resource = $db->query("SELECT game, sugg_age, n_player, deck FROM Cardgm WHERE gid='$gid'");
			$row = pg_num_rows($resource);
			if ($row >= 1) {
				print("<fieldset><legend><strong><big>Game info</big></strong></legend>");
				print ("<table border=\"1\">\r\n");
					print ("<tr>\r\n");
						print ("<th>Cardgame</th>\r\n");
						print ("<th>Suggested Age</th>\r\n");
						print ("<th>Mimimum N. Player</th>\r\n");
						print ("<th>Deck Type</th>\r\n");
					print ("</tr>\r\n");
					for ($i = 0; $i < $row; $i++) {
						$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
						print ("<tr>\r\n");
							print ("<td>". $result['game'] ."</td>\r\n");
							print ("<td>". $result['sugg_age'] ."</td>\r\n");
							print ("<td>". $result['n_player'] ."</td>\r\n");
							print ("<td>". $result['deck'] ."</td>\r\n");
						print ("</tr>\r\n");
					}
				print ("</table></fieldset>");
			}
			pg_free_result($resource);
			break;
		case 3:
		default:
			$resource = $db->query("SELECT game, sugg_age, n_player FROM Othergm WHERE gid='$gid'");
			$row = pg_num_rows($resource);
			if ($row >= 1) {
				print("<fieldset><legend><strong><big>Game info</big></strong></legend>");
				print ("<table border=\"1\">\r\n");
					print ("<tr>\r\n");
						print ("<th>Other game</th>\r\n");
						print ("<th>Suggested Age</th>\r\n");
						print ("<th>Mimimum N. Player</th>\r\n");
					print ("</tr>\r\n");
					for ($i = 0; $i < $row; $i++) {
						$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
						print ("<tr>\r\n");
							print ("<td>". $result['game'] ."</td>\r\n");
							print ("<td>". $result['sugg_age'] ."</td>\r\n");
							print ("<td>". $result['n_player'] ."</td>\r\n");
						print ("</tr>\r\n");
					}
				print ("</table></fieldset>");
			}
			pg_free_result($resource);
	}
	
	/* Tags of the game */
	$resource = $db->query("SELECT * FROM Association WHERE gid='$gid'");
	$row = pg_num_rows($resource);
	if ($row >= 1) {
		print ("<fieldset><legend><strong>Tags of this game</strong></legend><table border=\"1\">\r\n");
			print ("<tr>\r\n");
				print ("<th>Tag</th>\r\n");
			print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
					print ("<td>". $result['tid'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
		print ("</table></fieldset>");
	}
	pg_free_result($resource);	
	
	/* Info visible only at registered and admin users */
	if($_SESSION['type']==0 || $_SESSION['type']==2) {
		/* If the user logged has got this game... */
		$resource = $db->query("SELECT game, review, vote FROM HadTriedGame WHERE uid='$uid' AND gid='$gid'");
		$row = pg_num_rows($resource);
		if ($row == 1) {
			print("<fieldset><legend><strong><big>You have played this game! These are your judges</big></strong></legend>");
			/* ...select his vote and review */
			print ("<table border=\"1\">\r\n");
				print ("<tr>\r\n");
					print ("<th>Game</th>\r\n");
					print ("<th>Review</th>\r\n");
					print ("<th>Vote</th>\r\n");
				print ("</tr>\r\n");
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);	
				print ("<tr>\r\n");
					print ("<td>". $result['game'] ."</td>\r\n");
					print ("<td>". $result['review'] ."</td>\r\n");
					print ("<td>". $result['vote'] ."</td>\r\n");
				print ("</tr>\r\n");
			print ("</table></fieldset>");
			/* Grant the possibility of update vote and review */
			print("<fieldset><legend><strong><big>As you have flagged this game as played, you can review it: use the form below to insert a new review or update an old one</big></strong></legend>");
			print("<form target=\"review_vote_box\" id=\"reviewform\" class=\"padding-el\" method=\"post\" action=\"review_vote.php?gid=$gid\">");
				print("<table>");
	 				print("<tr><td>Grade</td><td><select name=\"grade\"/>");
						print("<option value=\"\">n.d.</option>  <option value=\"1\">1</option>  <option value=\"2\">2</option>  <option value=\"3\">3</option>  <option value=\"4\">4</option>  <option value=\"5\">5</option>  <option value=\"6\">6</option>  <option value=\"7\">7</option>  <option value=\"8\">8</option>  <option value=\"9\">9</option>  <option value=\"10\">10</option> </select></td></tr>");
					print("<tr><td>Review</td><td><textarea name=\"review\" style=\"width:25em; height:5em;\"/></textarea></td></tr>");
				print("</table>");
				print("<input type=\"submit\" value=\"send\" class=\"button\"/>");
			print("</form>");
			print("<iframe name=\"review_vote_box\" id=\"review_vote_box\" width=\"50%\" height=\"80\" align=\"right\" scrolling=\"auto\"></iframe></fieldset>");
		}
		else {
			/* Check if is not already desired */
			pg_free_result($resource);
			$resource = $db->query("SELECT game FROM DesiredGame WHERE uid='$uid' AND gid='$gid'");
			$row = pg_num_rows($resource);
			print ("<fieldset>");
			if ($row == 1) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<p>You are desiring <em>". $result['game'] ."</em> at the moment! Perhaps have you played it? <br />");
				print ("<a target=\"desire_hadtried_box\" href=\"hadtried_game.php?gid=$gid&type=$type\">So, flag it as had-tried</a></p>\r\n");
				print ("<p>Or you are no longer interested at it? <br />");
				print ("<a target=\"desire_hadtried_box\" href=\"desire_game.php?gid=$gid\">So unflag it as undesired</a></p>\r\n");
			}
			else {	
				print ("<p><a target=\"desire_hadtried_box\" href=\"desire_game.php?gid=$gid\">You haven't already desired this game, desire it!</a></p>\r\n");
				print ("<p><a target=\"desire_hadtried_box\" href=\"hadtried_game.php?gid=$gid&type=$type\">You haven't already played this game, flag it as had-tried</a></p>\r\n");
			}
			print("<iframe name=\"desire_hadtried_box\" id=\"desire_hadtried_box\" width=\"50%\" height=\"80\" align=\"right\" scrolling=\"auto\"></iframe></fieldset>");
		}
		pg_free_result($resource);
	}
	/* Info visible only at the analyst and admin users */
	if( $_SESSION['type']>=1 ) {
		$resource = $db->query("SELECT n_desiring,n_playing FROM StatsGameRefer WHERE gid=$gid");
		$row = pg_num_rows($resource);
		print("<fieldset><legend><strong><big>Statistcs</big></strong></legend>");
		print ("<table border=\"1\">\r\n");
		if ($row >= 1) {
				print ("<tr>\r\n");
					print ("<th>Number Desiring it</th>\r\n");
					print ("<th>Number Possessing/Trying it</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
					print ("<td align=\"center\">". $result['n_desiring'] ."</td>\r\n");
					print ("<td align=\"center\">". $result['n_playing'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
		}
		else {
			print ("<p><em>Sorry, not enough data to compute.</em></p>");
		}
		pg_free_result($resource);
		/* Stast on sex */
		$resource = $db->query("SELECT sex,avg_vote FROM StatsGameSexRefer WHERE gid=$gid ORDER BY sex");
		$row = pg_num_rows($resource);
		if ($row >= 1) {
				print ("<tr>\r\n");
					print ("<th>Sex</th>\r\n");
					print ("<th>Average Vote for Sex</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
					print ("<td align=\"center\">". $result['sex'] ."</td>\r\n");
					print ("<td align=\"center\">". $result['avg_vote'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
		}
		pg_free_result($resource);
		/* Stast on age */
		$resource = $db->query("SELECT age,avg_vote FROM StatsGameAgeRefer WHERE gid=$gid ORDER BY age");
		$row = pg_num_rows($resource);
		if ($row >= 1) {
				print ("<tr>\r\n");
					print ("<th>Age</th>\r\n");
					print ("<th>Average Vote for Age</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
					print ("<td align=\"center\">". $result['age'] ."</td>\r\n");
					print ("<td align=\"center\">". $result['avg_vote'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
		}
		pg_free_result($resource);
		/* Stast on area */
		$resource = $db->query("SELECT country,avg_vote FROM StatsGameCountryRefer WHERE gid=$gid ORDER BY country");
		$row = pg_num_rows($resource);
		if ($row >= 1) {
				print ("<tr>\r\n");
					print ("<th>Country</th>\r\n");
					print ("<th>Average Vote for Country</th>\r\n");
				print ("</tr>\r\n");
				$name = NULL;
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
					print ("<td align=\"center\">". $result['country'] ."</td>\r\n");
					print ("<td align=\"center\">". $result['avg_vote'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
		}
		pg_free_result($resource);
		print ("</table></fieldset>");
	}
	$db->disconnection();
?> 
	</div>
    </td>
  </tr>
  <tr>
      <td class="div-footer"> Responsable <a href="mailto:michele.corrias@studenti.unimi.it"> Michele Corrias </a> <br /> Copyright (c) 2011 Giogu inc. </td>
      <td class="div-footer" align="right"> <a target="_blank" href="http://validator.w3.org/check?uri=referer"> <img class="w3c-ref" src="valid-html.png" alt="Valid XHTML 1.1" /></a></td>
  </tr>
</body>
</html>
</body>
</html>
