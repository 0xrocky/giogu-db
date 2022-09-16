<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once('../Class_db.php');
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: ../index.php?mod=login");
	$db = new Classdb();
	$db->connection();
	
	if (!empty($_POST['tag'])) {
		$tag = $_POST['tag'];
		$tag = pg_escape_string($tag);
		$resource = $db->query("SELECT * FROM Tag WHERE tid ILIKE '$tag'");
		$row = pg_num_rows($resource);
		if ($row == 1) {
			pg_free_result($resource);
			$resource = $db->query("DELETE FROM Tag WHERE tid='$tag'");
			print("<p>Tag deleted. Click <a href=\"../index.php?mod=moder\" target=\"_parent\">here</a> to continue to moderate.</p>");
		}
		else print("<p>This tag doesn't exist. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert e-mail and name of the tag.</p>");
		pg_free_result($resource);
	}
	else print("<p>All the values are necessaries for the activity of moderate. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert name of the tag.</p>");
	$db->disconnection();
?>
