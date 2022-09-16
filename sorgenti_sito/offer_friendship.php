<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	
	require_once ('Class_db.php');
	$db = new Classdb();
	$db->connection();
	if ( isSet($_SESSION['uid']) ) $uida = $_SESSION['uid'];
	else header ("Location: index.php?mod=login");
	if ( isSet($_GET['uid']) && is_numeric($_GET['uid']) ) $uidb = $_GET['uid'];
	
	$resource = $db->query("INSERT INTO Friend VALUES('$uida','$uidb',FALSE)");
	print("<p>Request of friendship sent with success! Wait for the result</p>");
	print ("<a href=\"index.php?mod=profile\" target=\"_parent\">Click here to return to your profile</a>");
	pg_free_result($resource);	
	$db->disconnection();
?>
