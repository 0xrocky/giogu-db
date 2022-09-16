<?php	
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	if (!isSet($_SESSION['uid'])) header ("Location: index.php");
	require_once ('Class_db.php');
	
	$db = new Classdb();
	$db->connection();
	
	/* If user isn't logged, redirect him at the login */
	if (isSet($_SESSION['uid'])) $uid = $_SESSION['uid'];
	else header ("Location: index.php");	
	if (isSet($_GET['gid']) && is_numeric($_GET['gid'])) $gid = $_GET['gid'];
	else header ("index.php?mod=profile");
	
	/* Search the game gid of the user uid */
	$resource = $db->query("SELECT * FROM Desired WHERE uid='$uid' AND gid='$gid'");
	$row = pg_num_rows($resource);
	if ($row == 1){
			/* The user already desires the game: ask him to unflag it */
			pg_free_result($resource);
			$resource = $db->query("DELETE FROM Desired WHERE uid='$uid' AND gid='$gid'");
			print("<p><strong>You've unflaged this game as desired! </strong>\r\n");
			print ("<a href=\"index.php?mod=profile\" target=\"_parent\">Click here to return to your profile</a></p>"); 
	}
	else {
		/* The user already has got the game */
		pg_free_result($resource);
		$resource = $db->query("SELECT * FROM HadTried WHERE uid='$uid' AND gid='$gid'");
		$row = pg_num_rows($resource);
		if ($row == 1){
			print("<p><strong>You've already set this game as had or tried! </strong>\r\n");
			print ("<a href=\"index.php?mod=profile\" target=\"_parent\">Click here to return to your profile</a></p>"); 
		}
		else {
			/* The user now has flagged this game as desired */
			pg_free_result($resource);
			$resource = $db->query("INSERT INTO Desired VALUES('$uid','$gid')");
			print("<p><strong>Now you've set this game as desired! </strong>");
			print ("<a href=\"index.php?mod=profile\" target=\"_parent\">Click here to return to your profile</a></p>"); 
		}
	}
	pg_free_result($resource);
	$db->disconnection();
?>
