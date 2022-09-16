<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	if (!isSet($_SESSION['uid'])) header ("Location: index.php");

	switch ($_POST['type']) {
		case 0:
			require_once ('includes/games_form/insert_videogm_form.inc.php');
			break;
		case 1:
			require_once ('includes/games_form/insert_tablegm_form.inc.php');
			break;
		case 2:
			require_once ('includes/games_form/insert_cardgm_form.inc.php');
			break;
		case 3:
			require_once ('includes/games_form/insert_othergm_form.inc.php');
	}

?>
