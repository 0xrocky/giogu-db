<fieldset>
	<legend><strong><big>Please, select the type of the game you wish to insert</big></strong></legend>
	<form action="insert_game.php" method="post">
		<table>
			<tr><td>
				<input type="radio" name="type" value="0" /> Videogame<br />
				<input type="radio" name="type" value="1" /> Table game<br />
				<input type="radio" name="type" value="2" /> Card game<br />
				<input type="radio" name="type" value="3" checked="checked"/> Other game<br />
			</td></tr>
		</table>
			<input type="submit" value="Submit" />
	</form>
</fieldset>
