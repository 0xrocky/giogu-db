<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once('Class_db.php');
	/* If user isn't logged, redirect him at the login */
	if (!isSet($_SESSION['uid'])) header ("Location: index.php?mod=login");
	
	$db = new Classdb();
	$db->connection();
	
	/* if is set name/surname */
	if (isSet($_POST['name']) || isSet($_POST['surname']) || isSet($_POST['pass'])) {
		/* Set all */
		if (!empty($_POST['name']) && !empty($_POST['surname']) && !empty($_POST['pass'])) {
			$name = $_POST['name'];
			$name = pg_escape_string($name);
			$surname = $_POST['surname'];
			$surname = pg_escape_string($surname);
			$pass = $_POST['pass'];
			$pass = pg_escape_string($pass);
			$resource = $db->query("UPDATE Users SET name='$name',surname='$surname',passwd='$pass' WHERE uid='{$_SESSION['uid']}'");
			pg_free_result($resource); 
			print ("<strong>Name, Surname and Password have been changed</strong>");
		}
		/* Set only name-surname */		
		else if (!empty($_POST['name']) && !empty($_POST['surname'])) {
			$name = $_POST['name'];
			$name = pg_escape_string($name);
			$surname = $_POST['surname'];
			$surname = pg_escape_string($surname);
			$resource = $db->query("UPDATE Users SET name='$name',surname='$surname' WHERE uid='{$_SESSION['uid']}'");
			pg_free_result($resource); 
			print ("<strong>Name and Surname have been changed</strong>");
		}
		/* Set only name-pass */		
		else if (!empty($_POST['name']) && !empty($_POST['pass'])) {
			$name = $_POST['name'];
			$name = pg_escape_string($name);
			$pass = $_POST['pass'];
			$pass = pg_escape_string($pass);
			$resource = $db->query("UPDATE Users SET name='$name',passwd='$pass' WHERE uid='{$_SESSION['uid']}'");
			pg_free_result($resource); 
			print ("<strong>Name and Password have been changed</strong>");
		}
		/* Set only surname-pass */		
		else if (!empty($_POST['surname']) && !empty($_POST['pass'])) {
			$surname = $_POST['surname'];
			$surname = pg_escape_string($surname);
			$pass = $_POST['pass'];
			$pass = pg_escape_string($pass);
			$resource = $db->query("UPDATE Users SET surname='$surname',passwd='$pass' WHERE uid='{$_SESSION['uid']}'");
			pg_free_result($resource);
			print ("<strong>Surname and Password have been changed</strong>");
		}
		/* Set only name */
		else if (!empty($_POST['name'])) {
			$name = $_POST['name'];
			$name = pg_escape_string($name);
			$resource = $db->query("UPDATE Users SET name='$name' WHERE uid='{$_SESSION['uid']}'");
			pg_free_result($resource); 
			print ("<strong>Name has been changed</strong>");
		}
		/* Set only surname */
		else if (!empty($_POST['surname'])) {
			$surname = $_POST['surname'];
			$surname = pg_escape_string($surname);
			$resource = $db->query("UPDATE Users SET surname='$surname' WHERE uid='{$_SESSION['uid']}'");
			pg_free_result($resource);
			print ("<strong>Surname has been changed</strong>");
		}
		/* Set only pass */
		else {
			$pass = $_POST['pass'];
			$pass = pg_escape_string($pass);
			$resource = $db->query("UPDATE Users SET passwd='$pass' WHERE uid='{$_SESSION['uid']}'");
			pg_free_result($resource); 
			print ("<strong>Password has been changed</strong>");
		}
		$resource = $db->query("UPDATE Users SET age='{$_POST['age']}',sex='{$_POST['sex']}',country='{$_POST['country']}' WHERE uid='{$_SESSION['uid']}'");
		print ("<br /><strong>Age, sex and country have been changed</strong>");
		pg_free_result($resource);
	}
	$db->disconnection();
?>
