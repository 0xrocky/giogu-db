<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once('Class_db.php');
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: index.php?mod=login");
	
	$db = new Classdb();
	$db->connection();
	
	/* if is set email */
	if (isSet($_POST['email'])) {
		$email = $_POST['email'];
		$email = pg_escape_string($email);
		$resource = $db->query("SELECT uid, name, surname FROM Users WHERE email='$email'");
		$row = pg_num_rows($resource);
		if ($row == 1) {
			print ("<legend><strong>Find User:</strong></legend>");
			print ("<table border=\"1\">\r\n");
				print ("<tr>\r\n");
					print ("<th>Name</th>\r\n");
					print ("<th>Get profile</th>\r\n");
				print ("</tr>\r\n");
			$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
					print ("<td>". $result['name'] ." ". $result['surname'] ."</td>\r\n");
					print ("<td><a href=\"index.php?mod=profile&uid={$result['uid']}\" target=\"_parent\">Get profile</a></td>\r\n"); 
				print ("</tr>\r\n");
			print ("</table>");
		}
		else print ("<strong>Sorry but a user with this mail is not registered</strong>");
		pg_free_result($resource);
	}
	/* if is set name/surname */
	else if (isSet($_POST['name']) || isSet($_POST['surname']) || isSet($_POST['game'])) {
		/* Set all */
		if (!empty($_POST['name']) && !empty($_POST['surname']) && !empty($_POST['game'])) {
			$name = $_POST['name'];
			$name = pg_escape_string($name);
			$surname = $_POST['surname'];
			$surname = pg_escape_string($surname);
			$game = $_POST['game'];
			$game = pg_escape_string($game);
			$resource = $db->query("(SELECT uid, name, surname FROM UserDesired WHERE name ILIKE '$name' AND surname ILIKE '$surname' AND game ILIKE '$game') UNION (SELECT uid, name, surname FROM UserHadTried WHERE name ILIKE '$name' AND surname ILIKE '$surname' AND game ILIKE '$game')");
			if (searchu_result($resource)==0) print ("<strong>Sorry but a user with this name, surname and game isn't registered</strong>");
		}
		/* Set only name-surname */		
		else if (!empty($_POST['name']) && !empty($_POST['surname'])) {
			$name = $_POST['name'];
			$name = pg_escape_string($name);
			$surname = $_POST['surname'];
			$surname = pg_escape_string($surname);
			$resource = $db->query("SELECT uid, name, surname FROM Users WHERE name ILIKE '$name' AND surname ILIKE '$surname'");
			if (searchu_result($resource)==0) print ("<strong>Sorry but a user with this name and surname isn't registered</strong>");
		}
		/* Set only name-game */		
		else if (!empty($_POST['name']) && !empty($_POST['game'])) {
			$name = $_POST['name'];
			$name = pg_escape_string($name);
			$game = $_POST['game'];
			$game = pg_escape_string($game);
			$resource = $db->query("(SELECT uid, name, surname FROM UserDesired WHERE name ILIKE '$name' AND game ILIKE '$game') UNION (SELECT uid, name, surname FROM UserHadTried WHERE name ILIKE '$name' AND game ILIKE '$game')");
			if (searchu_result($resource)==0) print ("<strong>Sorry but a user with this name and game isn't registered</strong>");
		}
		/* Set only surname-game */		
		else if (!empty($_POST['surname']) && !empty($_POST['game'])) {
			$surname = $_POST['surname'];
			$surname = pg_escape_string($surname);
			$game = $_POST['game'];
			$game = pg_escape_string($game);
			$resource = $db->query("(SELECT uid, name, surname FROM UserDesired WHERE surname ILIKE '$surname' AND game ILIKE '$game') UNION (SELECT uid, name, surname FROM UserHadTried WHERE surname ILIKE '$surname' AND game ILIKE '$game')");
			if (searchu_result($resource)==0) print ("<strong>Sorry but a user with this surname and game isn't registered</strong>");
		}
		/* Set only name */
		else if (!empty($_POST['name'])) {
			$name = $_POST['name'];
			$name = pg_escape_string($name);
			$resource = $db->query("SELECT uid, name, surname FROM Users WHERE name ILIKE '$name'");
			if (searchu_result($resource)==0) print ("<strong>Sorry but a user with this name isn't registered</strong>");
		}
		/* Set only surname */
		else if (!empty($_POST['surname'])) {
			$surname = $_POST['surname'];
			$surname = pg_escape_string($surname);
			$resource = $db->query("SELECT uid, name, surname FROM Users WHERE surname ILIKE '$surname'");
			if (searchu_result($resource)==0) print ("<strong>Sorry but a user with this surname isn't registered</strong>");
		}
		/* Set only game */
		else {
			$game = $_POST['game'];
			$game = pg_escape_string($game);
			$resource = $db->query("(SELECT uid, name, surname FROM UserDesired WHERE game ILIKE '$game') UNION (SELECT uid, name, surname FROM UserHadTried WHERE game ILIKE '$game')");
			if (searchu_result($resource)==0) print ("<strong>Sorry but there isn't user registered with this game</strong>");
		}
	}
	$db->disconnection();
	
	/* searchu_result display any results if existing */
	function searchu_result($resource) {
		$row = pg_num_rows($resource);
		if ($row >= 1) {
			print ("<legend><strong>Find Users:</strong></legend>");
			print ("<table border=\"1\"\r\n");
				print ("<tr>\r\n");
					print ("<th>Name</th>\r\n");
					print ("<th>Get profile</th>\r\n");
				print ("</tr>\r\n");
			for($i = 0; $i < $row; $i++) {
				$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
				print ("<tr>\r\n");
					print ("<td>". $result['name'] ." ". $result['surname'] ."</td>\r\n");
					print ("<td><a href=\"index.php?mod=profile&uid={$result['uid']}\" target=\"_parent\">Get profile</a></td>\r\n");
				print ("</tr>\r\n");
			}
			print ("</table>");
			pg_free_result($resource); 
			return 1;
		}
		else {
			pg_free_result($resource); 
			return 0;
		}
	}
?>
