<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once ('Class_db.php');
	/* Se l'utente non è loggato, redirigilo al login */
	if (!isSet($_SESSION['uid'])) header ("Location: index.php?mod=login");
	else $uid = $_SESSION['uid'];
	$db = new Classdb();
	$db->connection();
	
	if ($_GET['mod']=='statsu' && $_SESSION['type']>=1) {
		$resource = $db->query("SELECT * FROM Stat_Users_Avg");
		$row = pg_num_rows($resource);
		print ("<fieldset><legend><strong>Statistics</strong></legend>\r\n");
		print ("<table border=\"1\">\r\n");
		if ($row == 1) {
			print ("<tr>\r\n");
				print ("<th><em>Globals Average</em></th>\r\n");
				print ("<th><em>Avg N. Desired Games</em></th>\r\n");
				print ("<th> </th>\r\n");
				print ("<th><em>Avg N. Possessed/Tried Games</em></th>\r\n");
				print ("<th> </th>\r\n");					
			print ("</tr>\r\n");
			$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
			$avg_desired = $result['avg_desired'];
			$avg_played = $result['avg_played'];
				print ("<tr>\r\n");
					print ("<td> </td>\r\n");
					print ("<td align=\"center\"> $avg_desired </td>\r\n");
					print ("<td> </td>\r\n");
					print ("<td align=\"center\"> $avg_played </td>\r\n");
					print ("<td> </td>\r\n");
				print ("</tr>\r\n");
		}
		pg_free_result($resource);
		$resource = $db->query("SELECT * FROM StatsUsersRefer");
		$row = pg_num_rows($resource);
		if ($row >= 1) {
				print ("<tr>\r\n");
					print ("<th>User</th>\r\n");
					print ("<th>Number Desired Games</th>\r\n");
					print ("<th>Deviation</th>\r\n");
					print ("<th>Number Possessed/Tried Games</th>\r\n");
					print ("<th>Deviation</th>\r\n");
				print ("</tr>\r\n");
			for ($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				$n_desired = $result['n_desired'];
				$n_played = $result['n_played'];
				print ("<tr>\r\n");
					print ("<td>". $result['name'] ." ". $result['surname'] ."</td>\r\n");
				$dev = $n_desired-$avg_desired;
					print ("<td align=\"center\"> $n_desired </td>\r\n");
					($dev >= 0) ? print ("<td align=\"center\"> +$dev </td>\r\n") : print ("<td align=\"center\"> $dev </td>\r\n");
				$dev = $n_played-$avg_played;
					print ("<td align=\"center\"> $n_played </td>\r\n");
					($dev >= 0) ? print ("<td align=\"center\"> +$dev </td>\r\n") : print ("<td align=\"center\"> $dev </td>\r\n");
				print ("</tr>\r\n");
			}
			print ("</table></fieldset>");
		}
		else {
			print ("</table></fieldset>");
			print ("<p><em>Sorry, not enough data to compute.</em></p>");
		}
		pg_free_result($resource);
	}
	$db->disconnection();
?>
