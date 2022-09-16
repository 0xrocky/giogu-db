<?php
	$menu_gen = Array(
		'Login' => 'index.php?mod=login',
	);
	$menu_admin = Array(
		'View Profile' => 'index.php?mod=profile',
		'Search User' => 'index.php?mod=searchu',
		'Simil Users' => 'index.php?mod=simil',
		'Search Game' => 'index.php?mod=searchg',
		'Insert Game' => 'index.php?mod=insert',
		'Charts for game typology' => 'index.php?mod=charts',
		'Tags' => 'index.php?mod=tag',
		'Update profile' => 'index.php?mod=update',
		'Stats Users' => 'index.php?mod=statsu',
		'Stats Games' => 'index.php?mod=statsg',
		'Moderate' => 'index.php?mod=moder',
		'Logout' => 'logout.php',
	);
	$menu_analyst = Array(
		'Stats Users' => 'index.php?mod=statsu',
		'Stats Games' => 'index.php?mod=statsg',
		'Search Game' => 'index.php?mod=searchg',
		'Charts for game typology' => 'index.php?mod=charts',
		'Update profile' => 'index.php?mod=update',
		'Logout' => 'logout.php',
	);
	$menu_user = Array(
		'View Profile' => 'index.php?mod=profile',
		'Search User' => 'index.php?mod=searchu',
		'Simil Users' => 'index.php?mod=simil',
		'Search Game' => 'index.php?mod=searchg',
		'Insert Game' => 'index.php?mod=insert',
		'Charts for game typology' => 'index.php?mod=charts',
		'Tags' => 'index.php?mod=tag',
		'Update profile' => 'index.php?mod=update',
		'Logout' => 'logout.php'
	);
	if (isSet($_SESSION['type'])) {
		switch ($_SESSION['type']) {
			case 0: /*'registered'*/
			$menu = $menu_user;
			$keys = array_keys($menu_user);
			break;
	                case 1: /*'analyst'*/
			$menu = $menu_analyst;
			$keys = array_keys($menu_analyst);
			break;
			case 2: /*'admin'*/
			$menu = $menu_admin;
			$keys = array_keys($menu_admin);
			break;
		}
	}
	else {
		$menu = $menu_gen;
		$keys = array_keys($menu_gen);
	}
	foreach ($keys as $key){
		print("<p><a href=\"".$menu[$key]."\">");
		print($key);
		print("</a></p>");
	}
?>
