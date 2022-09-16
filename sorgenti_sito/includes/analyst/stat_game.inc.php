<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once ('Class_db.php');
	if (!isSet($_SESSION['uid'])) header ("Location: index.php?mod=login");
	else $uid = $_SESSION['uid'];
	
	$db = new Classdb();
	$db->connection();
	
	if ($_GET['mod']=='statsg' && $_SESSION['type']>=1) {
		$resource = $db->query("SELECT * FROM StatsGameRefer ORDER BY name");
		$row = pg_num_rows($resource);
		print ("<table border=\"1\">\r\n");
		if ($row >= 1) {
				print ("<tr>\r\n");
					print ("<th>Game</th>\r\n");
					print ("<th>Typology</th>\r\n");
					print ("<th>Number Desiring it</th>\r\n");
					print ("<th>Number Possessing/Trying it</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
					print ("<td><a href=\"profile_game.php?gid={$result['gid']}&type={$result['type']}\">". $result['name'] ."</a></td>\r\n");
					switch_type($result['type']);
					print ("<td align=\"center\">". $result['n_desiring'] ."</td>\r\n");
					print ("<td align=\"center\">". $result['n_playing'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
		}
		else {
			print ("<p><em>Sorry, not enough data to compute.</em></p>");
		}
		pg_free_result($resource);
		
		$resource = $db->query("SELECT * FROM StatsGameSexRefer ORDER BY name,sex");
		$row = pg_num_rows($resource);
		if ($row >= 1) {
				print ("<tr>\r\n");
					print ("<th>Game</th>\r\n");
					print ("<th>Typology</th>\r\n");
					print ("<th>Sex</th>\r\n");
					print ("<th>Average Vote for Sex</th>\r\n");
				print ("</tr>\r\n");
				$name = NULL;
				$type = NULL;
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
					($name != $result['name']) ? print ("<td><a href=\"profile_game.php?gid={$result['gid']}&type={$result['type']}\">". $result['name'] ."</a></td>\r\n") : print ("<td> </td>\r\n");
					$name = $result['name'];
					($type != $result['type']) ? switch_type($result['type']) : print ("<td> </td>\r\n");
					$type = $result['type'];
					print ("<td align=\"center\">". $result['sex'] ."</td>\r\n");
					print ("<td align=\"center\">". $result['avg_vote'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
		}
		pg_free_result($resource);
		
		$resource = $db->query("SELECT * FROM StatsGameAgeRefer ORDER BY name,age");
		$row = pg_num_rows($resource);
		if ($row >= 1) {
				print ("<tr>\r\n");
					print ("<th>Game</th>\r\n");
					print ("<th>Typology</th>\r\n");
					print ("<th>Age</th>\r\n");
					print ("<th>Average Vote for Age</th>\r\n");
				print ("</tr>\r\n");
				$name = NULL;
				$type = NULL;
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
					($name != $result['name']) ? print ("<td><a href=\"profile_game.php?gid={$result['gid']}&type={$result['type']}\">". $result['name'] ."</a></td>\r\n") : print ("<td> </td>\r\n");
					$name = $result['name'];
					($type != $result['type']) ? switch_type($result['type']) : print ("<td> </td>\r\n");
					$type = $result['type'];
					print ("<td align=\"center\">". $result['age'] ."</td>\r\n");
					print ("<td align=\"center\">". $result['avg_vote'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
		}
		pg_free_result($resource);
		
		$resource = $db->query("SELECT * FROM StatsGameCountryRefer ORDER BY name,country");
		$row = pg_num_rows($resource);
		if ($row >= 1) {
				print ("<tr>\r\n");
					print ("<th>Game</th>\r\n");
					print ("<th>Typology</th>\r\n");
					print ("<th>Country</th>\r\n");
					print ("<th>Average Vote for Country</th>\r\n");
				print ("</tr>\r\n");
				$name = NULL;
				$type = NULL;
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
					($name != $result['name']) ? print ("<td><a href=\"profile_game.php?gid={$result['gid']}&type={$result['type']}\">". $result['name'] ."</a></td>\r\n") : print ("<td> </td>\r\n");
					$name = $result['name'];
					($type != $result['type']) ? switch_type($result['type']) : print ("<td> </td>\r\n");
					$type = $result['type'];
					print ("<td align=\"center\">". $result['country'] ."</td>\r\n");
					print ("<td align=\"center\">". $result['avg_vote'] ."</td>\r\n");
				print ("</tr>\r\n");
			}
		}
		pg_free_result($resource);
		
		print ("</table>");
	}
	$db->disconnection();
	
	function switch_type($type) {
		switch ($type) {
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
	}
?>
