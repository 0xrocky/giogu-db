<fieldset>
	<legend><strong><big>Please, submit specific information of Videogames</big></strong></legend>
	<form action="update_game.php" method="post">
		<table>
			<tr>
				<td>Minimum number of player</td>
				<td><input type="text" name="nplayer" /></td>
			</tr>
				<td>Suggested Age</td>
				<td><input type="text" name="age" /></td>
			</tr>
		</table>
			<input type="checkbox" name="console[a]" value="Play Station" checked="checked"/> Sony Play Station <br />
	 		<input type="checkbox" name="console[b]" value="Play Station 2"/> Sony Play Station 2 <br />
			<input type="checkbox" name="console[c]" value="Play Station 3"/> Sony Play Station 3 <br />
			<input type="checkbox" name="console[d]" value="PSP"/> Sony PSP <br />
			<input type="checkbox" name="console[e]" value="XBox"/> Microsoft XBox <br />
			<input type="checkbox" name="console[f]" value="XBox 360"/> Microsoft XBox 360 <br />
			<input type="checkbox" name="console[g]" value="Wii"/> Nintendo Wii <br />
			<input type="checkbox" name="console[h]" value="GameBoy"/> Nintendo GameBoy <br />
			<input type="checkbox" name="console[i]" value="DS"/> Nintendo DS <br />
			<input type="checkbox" name="console[l]" value="Master System"/> Sega Master System <br />
			<input type="checkbox" name="console[m]" value="Mega Drive"/> Sega Mega Drive <br />
			<input type="checkbox" name="console[n]" value="PC"/> PC <br />
			<input type="checkbox" name="console[o]" value="Other"/> Other <br />
		<input type="submit" value="Submit" />
	</form><br />
</fieldset>
