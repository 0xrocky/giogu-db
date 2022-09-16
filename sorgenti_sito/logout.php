<?php
	ini_set('display_errors','Off');
	if (!isSet($_SESSION)) session_start();

	unset($_SESSION['uid']);
	unset($_SESSION['type']);
	session_unset();

	header ("Location: index.php");

?>
