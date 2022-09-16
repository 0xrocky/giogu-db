<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once ('Class_db.php');
	
	$db = new Classdb();
	$db->connection();
	
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: index.php?mod=login");
	
	print ("<p><big><strong>Chart of Games, for each typology, having average vote bigger than others </strong></big></p>");
	
	$resource = $db->query("SELECT * FROM ChartVideo");
	$row = pg_num_rows($resource);
	if ($row >= 1) {
			print ("<fieldset><legend><big><strong>Chart of Videogames</strong></big></legend>");
			print ("<table border=\"1\">\r\n");
				print ("<tr>\r\n");
					print ("<th>Game</th>\r\n");
					print ("<th>Average vote</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);	
				print ("<tr>\r\n");
					print ("<td><a href=\"profile_game.php?gid={$result['gid']}&type=0\">". $result['game'] ."</a></td>\r\n");
					print ("<td>". $result['avgvote'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
			print ("</table></fieldset>");
	}
	pg_free_result($resource);
	
	$resource = $db->query("SELECT * FROM ChartTable");
	$row = pg_num_rows($resource);
	if ($row >= 1) {
			print ("<fieldset><legend><big><strong>Chart of Tablegames</strong></big></legend>");
			print ("<table border=\"1\">\r\n");
				print ("<tr>\r\n");
					print ("<th>Game</th>\r\n");
					print ("<th>Average vote</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);	
				print ("<tr>\r\n");
					print ("<td><a href=\"profile_game.php?gid={$result['gid']}&type=1\">". $result['game'] ."</a></td>\r\n");
					print ("<td>". $result['avgvote'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
			print ("</table></fieldset>");
	}
	pg_free_result($resource);
	
	$resource = $db->query("SELECT * FROM ChartCard");
	$row = pg_num_rows($resource);
	if ($row >= 1) {
			print ("<fieldset><legend><big><strong>Chart of Cardgames</strong></big></legend>");
			print ("<table border=\"1\">\r\n");
				print ("<tr>\r\n");
					print ("<th>Game</th>\r\n");
					print ("<th>Average vote</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);	
				print ("<tr>\r\n");
					print ("<td><a href=\"profile_game.php?gid={$result['gid']}&type=2\">". $result['game'] ."</a></td>\r\n");
					print ("<td>". $result['avgvote'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
			print ("</table></fieldset>");
	}
	pg_free_result($resource);
	
	$resource = $db->query("SELECT * FROM ChartOther");
	$row = pg_num_rows($resource);
	if ($row >= 1) {
			print ("<fieldset><legend><big><strong>Chart of Other games</strong></big></legend>");
			print ("<table border=\"1\">\r\n");
				print ("<tr>\r\n");
					print ("<th>Game</th>\r\n");
					print ("<th>Average vote</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);	
				print ("<tr>\r\n");
					print ("<td><a href=\"profile_game.php?gid={$result['gid']}&type=3\">". $result['game'] ."</a></td>\r\n");
					print ("<td>". $result['avgvote'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
			print ("</table></fieldset>");
	}
	pg_free_result($resource);
	$db->disconnection();
?>
