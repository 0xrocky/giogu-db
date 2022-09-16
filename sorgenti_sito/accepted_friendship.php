<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once ('Class_db.php');
	
	$db = new Classdb();
	$db->connection();
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: index.php?mod=login");
	else $uidb = $_SESSION['uid']; //l'utente loggato stavolta è quello che ha ricevuto la richiesta
	if (isSet($_GET['uid'])) $uida = $_GET['uid'];
	
	if(isSet($_POST['button'])) {
		if ($_POST['button']=='Accept') {
			/* Set Friendship if Accept */
			$resource = $db->query("UPDATE Friend SET accepted=TRUE WHERE uid_active='$uida' AND uid_asked='$uidb'");
			print("<p>Request of friendship accepted</p>\r\n");
			print ("<a href=\"index.php?mod=profile\" target=\"_parent\">Click here to return to your profile</a>");
			pg_free_result($resource);	
		}
		else if ($_POST['button']=='Decline') {
			/* Delete Request if Decline */
			$resource = $db->query("DELETE FROM Friend WHERE uid_active='$uida' AND uid_asked='$uidb'");
			print("<p>Request of friendship declined</p>\r\n");
			print ("<a href=\"index.php?mod=profile\" target=\"_parent\">Click here to return to your profile</a>"); 
			pg_free_result($resource);	
		}
	}
	$db->disconnection();
?>
