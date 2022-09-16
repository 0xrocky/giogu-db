<?php	
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: index.php?mod=login");
	require_once ('Class_db.php');
	
	$db = new Classdb();
	$db->connection();

	if (isSet($_GET['gid']) && is_numeric($_GET['gid'])) $gid = $_GET['gid'];
	if (isSet($_GET['uid'])) $uid = $_GET['uid'];
	else $uid = $_SESSION['uid'];
	
	if ($_POST['review']=='') $review = NULL; else $review = pg_escape_string(htmlentities(ucfirst(strtolower($_POST['review']))));
	if ($_POST['grade']=='') $resource = $db->query("UPDATE HadTried SET vote=NULL,review='$review' WHERE uid='$uid' AND gid='$gid'");
	else {
		$grade = $_POST['grade'];
		$resource = $db->query("UPDATE HadTried SET vote='$grade',review='$review' WHERE uid='$uid' AND gid='$gid'");
	}
	pg_free_result($resource);

	print("<p>Your review and vote are set for this game! Click ");
	print ("<a href=\"index.php?mod=profile&uid=$uid\" target=\"_parent\"> here </a> to reload the page and make the changes take effect.</p>"); 

	$db->disconnection();
?>
