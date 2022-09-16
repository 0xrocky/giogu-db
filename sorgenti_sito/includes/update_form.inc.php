<fieldset>
	<legend><strong><big>Change what you want of your data</big></strong></legend>
	<form target="update_box" class="padding-el" method="post" action="update_personaldata.php">
		<table>
			<tr>
				<td>Name:</td>
				<td><input type="text" name="name"/></td>
			</tr>
			<tr>
				<td>Surname:</td>
				<td><input type="text" name="surname"/></td>
			</tr>
			<tr>
				<td>Password</td>
				<td><input type="password" name="pass"/></td>
			</tr>
		</table>
<?php
	$qta=99;
	echo"<select name=\"age\">";
	for($i=1;$i<=$qta;$i++) {
		echo"<option value=\"$i\">$i </option>";
	}
	echo"</select>"
?>
		<select name="sex" >
  			<option value="M">Maschio </option>
			<option value="F">Femmina </option>
 		</select>
		<select name="country" >
  			<option value="VDA">Valle d'Aosta </option>
			<option value="PIE">Piemonte </option>
			<option value="LOM">Lombardia </option>
			<option value="LIG">Liguria </option>
			<option value="TAD">Trentino Alto Adige </option>
			<option value="VEN">Veneto </option>
			<option value="FVG">Friuli Venezia Giulia </option>
			<option value="TOS">Toscana </option>
			<option value="EMR">Emilia Romagna </option>
			<option value="MAR">Marche </option>
			<option value="UMB">Umbria </option>
			<option value="LAZ">Lazio </option>
			<option value="CAM">Campania </option>
			<option value="MOL">Molise </option>
			<option value="BAS">Basilicata </option>
			<option value="ABR">Abruzzo </option>
			<option value="PUG">Puglia </option>
			<option value="CAL">Calabria </option>
			<option value="SIC">Sicilia </option>
			<option value="SAR">Sardegna </option>
			<option value="XXX">Estero </option>
 		</select>
		<input type="submit" value="send" class="button"/>
	</form>
	<iframe name="update_box" id="update_box" width="100%" height="100" scrolling="auto" align="right"></iframe>
</fieldset>
