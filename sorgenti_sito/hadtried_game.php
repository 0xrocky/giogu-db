<?php	
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: index.php");
	require_once ('Class_db.php');
	
	$db = new Classdb();
	$db->connection();

	$uid = $_SESSION['uid'];
	if (isSet($_GET['gid']) && is_numeric($_GET['gid'])) $gid = $_GET['gid'];
	else header ("index.php?mod=profile");
	if (isSet($_GET['type']) && is_numeric($_GET['type'])) $type = $_GET['type'];
	
	/* the user uid has already got the game gid? */
	$resource = $db->query("SELECT * FROM HadTried WHERE uid='$uid' AND gid='$gid'");
	$row = pg_num_rows($resource);
	if ($row == 1){
		/* Yes */
		print("<p><strong>You've already set this game as had or tried! </strong>\r\n");
		print ("<a href=\"profile_game.php?gid=$gid&type=$type\" target=\"_parent\">Click here to review and vote the game</a></p>"); 
	}
	else {
		/* No, so check if the game is already desired */
		pg_free_result($resource);
		$resource = $db->query("SELECT * FROM Desired WHERE uid='$uid' AND gid='$gid'");
		$row = pg_num_rows($resource);
		if ($row == 1){
			/* if Yes, flag as undesired and set has played */
			pg_free_result($resource);
			$resource = $db->query("DELETE FROM Desired WHERE uid='$uid' AND gid='$gid'");
			pg_free_result($resource);	
			$resource = $db->query("INSERT INTO HadTried VALUES('$uid','$gid')");
			print("<p><strong>At the moment you are desiring this game...\r\n");
			print("<p>Finally you have played it! Now it is in your games list of possessed-tried </strong>");
			print ("<a href=\"profile_game.php?gid=$gid&type=$type\" target=\"_parent\">Click here to review and vote the game</a></p>"); 
		}
		else {
			/* if no, set has played only */
			pg_free_result($resource);
			$resource = $db->query("INSERT INTO HadTried VALUES('$uid','$gid')");
			print("<p><strong>You've set this game as had or tried! </strong>");
			print ("<a href=\"profile_game.php?gid=$gid&type=$type\" target=\"_parent\">Click here to review and vote the game</a></p>"); 
		}
	}
	pg_free_result($resource);
	$db->disconnection();
?>
