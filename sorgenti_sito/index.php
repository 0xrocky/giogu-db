<?php
	ini_set('display_errors','off');
	/* if a session isn't already started, then started it */
	if (!isSet($_SESSION)) session_start();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
<link href="style.css" rel="stylesheet" type="text/css" />
<title>Home Page</title>
</head>
<body>
<div class="div-title">GIOGU: the Gaming Social Network</div>
<table class="main">
  <tr><td class="td-sx"> <?php require_once('menu.php'); ?> </td>
    <td class="td-dx">
        <div class="padding-el">
	<?php    
		if (isset($_SESSION['uid']) && !isset($_GET['mod']))
			print ("<p><big><strong>Welcome! You are the user <em>". $_SESSION['uid']. "</em>. Enjoy you!</big></strong></p>");
		else {
			$mod = isset($_GET['mod']) ? $_GET['mod'] : '';
			switch ($mod) {
				case 'profile':
					require ('includes/profile_user.inc.php');
					break;
				case 'searchu':
					require ('includes/searchu_form.inc.php');
					break;
				case 'simil':
					require ('includes/similarity.inc.php');
					break;	
				case 'searchg':
					require ('includes/searchg_form.inc.php');
					break;
				case 'insert':
					require ('includes/insert_game_form.inc.php');
					break;
				case 'charts':
					require ('includes/charts.inc.php');
					break;
				case 'tag':
					require ('includes/tag_form.inc.php');
					break;	
				case 'update':
					require ('includes/update_form.inc.php');
					break;
				case 'statsu':
					require ('includes/analyst/stat_user.inc.php');
					break;
				case 'statsg':
					require ('includes/analyst/stat_game.inc.php');
					break;
				case 'moder':
					require ('includes/admin/moder_form.inc.php');
					break;	
				case 'login':
				default:
					require ('includes/login_form.inc.php');
			} 
		}
	?>
        </div>
    </td>
  </tr>
  <tr>
      <td class="div-footer"> Responsable <a href="mailto:michele.corrias@studenti.unimi.it"> Michele Corrias </a> <br /> Copyright (c) 2011 Giogu inc. </td>
      <td class="div-footer" align="right"> <a target="_blank" href="http://validator.w3.org/check?uri=referer"> <img class="w3c-ref" src="valid-html.png" alt="Valid XHTML 1.1" /></a></td>
  </tr>
</body>
</html>
</body>
</html>
