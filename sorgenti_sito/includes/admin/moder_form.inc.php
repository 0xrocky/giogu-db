<fieldset>
	<legend><strong><big>Please, select what you want to do</big></strong></legend>
	<form target="moderate_box" action="admin/moderate_data.php" method="post">
		<table>
			<tr><td>
				<input type="radio" name="chosen" value="0" /> Delete User <br />	
				<input type="radio" name="chosen" value="1" /> Delete Game <br />
				<input type="radio" name="chosen" value="2" /> Modify an user review <br />
				<input type="radio" name="chosen" value="3" /> Update Game info<br />
				<input type="radio" name="chosen" value="4" /> Delete Tag <br />
				<input type="radio" name="chosen" value="5" /> Free a game From a Specific Tag <br />
				<input type="radio" name="chosen" value="6" /> Free a game From all Tags <br />
			</td></tr>
		</table>
			<input type="submit" value="Submit" />
	</form>
	<iframe name="moderate_box" id="moderate_box" width="100%" height="200" scrolling="auto"></iframe>
</fieldset>
