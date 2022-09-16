<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once ('Class_db.php');
	/* If user isn't logged, redirect him at the login */
	if ( !isSet($_SESSION['uid']) ) header ("Location: index.php?mod=login");
	if ( isSet($_GET['uida']) && is_numeric($_GET['uida']) ) $uida = $_GET['uida'];
	if ( isSet($_GET['uidb']) && is_numeric($_GET['uidb']) ) $uidb = $_GET['uidb'];
	
	$db = new Classdb();
	$db->connection();
	
	$resource = $db->query("DELETE FROM Friend WHERE uid_active='$uida' AND uid_asked='$uidb' AND accepted=TRUE");
	pg_free_result($resource);	
	header ("Location: index.php?mod=profile");
	$db->disconnection();
?>
