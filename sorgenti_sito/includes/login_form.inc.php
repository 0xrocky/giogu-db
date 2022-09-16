<fieldset>
<div id="content"> 
<p>Welcome to <strong>Giogu</strong>!</p>
<p>Giogu is a <em>Social Networking</em> web application that gets in touch people having common interests for <strong>gaming</strong>. 4 types of games are supported: Videogames, Table games, Card games and Other.</p>
<p>The registered limited user can:</p>
<p>
<ul>
	<li>Search games and insert new games</li>
	<li>Review, vote and tag games</li>
	<li>Get in touch with users that like the same games</li>
	<li>Build a network of friends</li>
</ul>
</p>
<hr />
<p>Giogu is a university-level lab project; test the sistem using these credentials:</p>
<p>
<ul>
	<li>Admin: mhl.crr@gmail.com - password: password</li>
	<li>Analyst: ferrara@dico.unimi.it || montanelli@dico.unimi.it - password: password</li>
	<li>Registered user: test@test.com - password: password</li>
</ul>
</p>
<p>All the users in the database share the same password ("password").</p>
</div> 
<form class="padding-el" method="post" action="check_login.php">
	<table>
	<tr>
		<td>Email:</td>
		<td><input type="text" name="email" /></td>
	</tr>
	<tr>
		<td>Password:</td>
		<td><input type="password" name="pass" /></td>
	</tr>
	</table>
	<input type="submit" value="Login" class="button"/>
</form>
</fieldset>
<?php
	if (isset($_GET['failed']))
		print ("<b class=\"padding-el\">Failed authentication. Retry login</b>\r\n");
?>
