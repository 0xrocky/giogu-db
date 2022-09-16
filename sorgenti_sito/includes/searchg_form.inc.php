<fieldset>
	<legend><strong><big>Search a game by name</big></strong></legend>
	<form target="searchg_box" class="padding-el" method="post" action="search_game.php">
		<table>
			<tr>
				<td>Game Name:</td>
				<td><input type="text" name="game"/></td>
			</tr>
		</table>
		<input type="submit" value="search" class="button"/>
	</form>
	
<iframe name="searchg_box" id="searchg_box" width="100%" height="80" scrolling="auto"></iframe>

	<legend><strong><big>Search a game by tag</big></strong></legend>
	<form target="searchg_box" class="padding-el" method="post" action="search_game.php">
		<table>
			<tr>
				<td>Tag:</td>
				<td><input type="text" name="tag"/></td>
			</tr>
		</table>
		<input type="submit" value="search" class="button"/>
	</form>
</fieldset>
