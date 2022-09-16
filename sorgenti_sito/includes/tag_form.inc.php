<fieldset>
	<legend><strong><big>Here you can insert a new Tag only, insert a new tag and associate it with a game, or simply tag a game with a tag already existing</big></strong></legend>
	<form target="tag_box" class="padding-el" method="post" action="tag.php">
		<table>
			<tr>
				<td>Insert a new Tag</td>
				<td><input type="text" name="tid"/></td>
				<td>Associate it with a game</td>
				<td><input type="text" name="game"/></td>
				<td>Typology</td>
				<td><select name="type"/>
					<option value="0">Videogame</option>  <option value="1">Tablegame</option>  <option value="2">Cardgame</option>  <option value="3">Other</option> </select></td>
			</tr>
		</table>
		<input type="submit" value="send" class="button"/>
	</form>
</fieldset>

<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	require_once('Class_db.php');
	
	$db = new Classdb();
	$db->connection();
	/* Print all tags to avoid double insert */
	$resource = $db->query("SELECT * FROM Tag");
	$row = pg_num_rows($resource);
	print ("<fieldset>");
	if ($row >= 1) {
		print ("<legend><strong>Here a list of tag already existing, to avoid double inserts</strong></legend>\r\n");
		print ("<ul>\r\n");
		for ($i = 0; $i < $row; $i++) {
			$result = pg_fetch_array($resource,NULL,PGSQL_ASSOC);
			print ("<li>". $result['tid'] ."</li>\r\n");
		}
		print ("</ul>");
	}
	print("<iframe name=\"tag_box\" id=\"tag_box\" width=\"100%\" height=\"100\" scrolling=\"auto\"></iframe></fieldset>");
	pg_free_result($resource);
?>
