<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once('Class_db.php');

	if (login($_POST['email'],$_POST['pass']))
		header ("Location: index.php");
	else
		header ("Location: index.php?failed=true");
	
	function login($email,$pass) {
		/* validUser is a flag: TRUE if all it's ok, FALSE else */
		$validUser = false;
		$db = new Classdb();
		
		$email = pg_escape_string($email);
		$pass = pg_escape_string($pass);
		$db->connection();
		$resource = $db->query("SELECT * FROM Users WHERE email='$email' AND passwd='$pass'");
		if (!$resource) {
  			echo "<p>An error occured connecting '$email'</p>\n";
  			exit;
		}
		$row = pg_num_rows($resource);
		if ($row == 1) {
			$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
			/* Set $_SESSION with credentials of the user */
			$_SESSION['uid'] = $result['uid'];
			$_SESSION['type'] = $result['type'];
			$validUser = true;
			$db->disconnection();
		}
		else {
			echo "<p>ahi ahi</p>\n";
			$error= error_get_last(); 
			print($error['message']);
		}
		pg_free_result($resource);
		return $validUser;	
	}	                  
?>
