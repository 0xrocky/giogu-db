<legend><strong><big>Please, submit specific information of Cardgame</big></strong></legend>
<form action="update_game.php" method="post">
	<table>
		<tr>
			<td>Minimum number of player</td>
			<td><input type="text" name="nplayer" /></td>
		</tr>
		<tr>
			<td>Suggested Age</td>
			<td><input type="text" name="age" /></td>
		</tr>
	</table>
	<select name="deck" >
  		<optgroup label=italian>
  				<option value="bergamasche">bergamasche </option>
				<option value="bresciane">bresciane </option>
				<option value="genovesi">genovesi </option>
				<option value="lombarde">lombarde </option>
				<option value="nuoresi">nuoresi </option>
				<option value="piacentine">piacentine </option>
				<option value="piemontesi">piemontesi </option>
				<option value="romagnole">romagnole </option>
				<option value="romane">romane </option>
				<option value="sarde">sarde </option>
				<option value="siciliane">siciliane </option>
				<option value="toscane_fiorentine">toscane_fiorentine </option>
				<option value="trentine">trentine </option>
				<option value="trevisane">trevisane </option>
				<option value="triestine">triestine </option>
				<option value="viterbesi">viterbesi </option>
  		</optgroup>
  		<optgroup label="foreign">
  				<option value="francesi">francesi </option>
  				<option value="spagnole">spagnole </option>
  				<option value="svizzere">svizzere </option>
  				<option value="tedesche_austriache">tedesche_austriache </option>
		</optgroup>
		<optgroup label="special">
  				<option value="collezione">collezione </option>
  				<option value="tarocchi">tarocchi </option>
		</optgroup>
 	</select>
	<input type="submit" value="Submit" />
</form><br />
