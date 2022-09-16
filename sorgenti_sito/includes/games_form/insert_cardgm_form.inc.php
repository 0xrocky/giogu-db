<?php
	ini_set('display_errors','off');
	/* Se non è ancora partita una sessione, falla partire */
	if (!isSet($_SESSION)) session_start();
?>
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Frameset//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-frameset.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="content-type" content="text/html; charset=ISO-8859-1" />
<link href="style.css" rel="stylesheet" type="text/css" />
<title>Insert Game</title>
</head>
<body>
<div class="div-title">GIOGU: the Gaming Social Network</div>
<table class="main">
  <tr>
    <td class="td-sx">
	<?php require_once('menu.php'); ?>
    </td>
    <td class="td-dx">
        <div class="padding-el">
	<fieldset>
	<legend><strong><big>Please, submit specific information of Cardgame</big></strong></legend>
	<form target="cardgm_box" action="insert_cardgm.php" method="post">
		<table>
 			<tr>
				<td>Name</td>
				<td><input type="text" name="game" /></td>
			</tr>
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
	<iframe name="cardgm_box" id="cardgm_box" width="100%" height="100" scrolling="auto"></iframe>
	</fieldset>
	</div>
    </td>
  </tr>
  <tr>
      <td class="div-footer"> Responsable <a href="mailto:michele.corrias@studenti.unimi.it"> Michele Corrias </a> <br /> Copyright (c) 2011 Giogu inc. </td>
      <td class="div-footer" align="right"> <a target="_blank" href="http://validator.w3.org/check?uri=referer"> <img class="w3c-ref" src="valid-html.png" alt="Valid XHTML 1.1" /></a></td>
  </tr>
</body>
</html>
</body>
</html>
