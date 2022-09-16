<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: ../index.php?mod=login");
	require_once('../Class_db.php');
	$db = new Classdb();
	$db->connection();

	if (!empty($_POST['email'])) {
		$email = $_POST['email'];
		$email = pg_escape_string($email);
		$resource = $db->query("SELECT uid FROM Users WHERE email='$email'");
		$row = pg_num_rows($resource);
		if ($row == 1) {
			$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
			$uid = $result['uid'];
			pg_free_result($resource);
			$resource = $db->query("DELETE FROM Users WHERE uid='$uid'");
			print("<p>User deleted. Click <a href=\"../index.php?mod=moder\" target=\"_parent\"> here </a> to continue to moderate.</p>");
		}
		else print("<p>This user doesn't exist. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert e-mail and name of the game.</p>");
		pg_free_result($resource);
	}
	else print("<p>All the values are necessaries for the activity of moderate. Please come <a href=\"../index.php?mod=moder\" target=\"_parent\"> back </a> and re-insert e-mail.</p>");
	$db->disconnection();
?>
