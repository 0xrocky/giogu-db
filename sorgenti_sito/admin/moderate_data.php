<?php
	ini_set('display_errors','off');
	if (!isSet($_SESSION)) session_start();
	if (!isSet($_SESSION['uid']) || ($_SESSION['type']!=2) ) header ("Location: ../index.php?mod=login");

	/* Delete User */
	if ($_POST['chosen']==0) {
		print("<fieldset>");
			print("<legend><strong><big>Please, insert the mail of the user you want to delete</big></strong></legend>");
			print("<form action=\"delete_user.php\" method=\"post\">");
				print("<table>");
					print("<tr>");
						print("<td>E-mail</td>");
						print("<td><input type=\"text\" name=\"email\" /></td>");
					print("</tr>");
				print("</table>");
				print("<input type=\"submit\" value=\"Submit\" />");
			print("</form>");
		print("</fieldset>");	
	}
	/* Delete Game */
	else if ($_POST['chosen']==1) {
		print("<fieldset>");
			print("<legend><strong><big></big>Please, insert the name of the game, with the type, you want to delete</strong></legend>");
			print("<form action=\"delete_game.php\" method=\"post\">");
				print("<table>");
					print("<tr>");
						print("<td>Game:</td>");
						print("<td><input type=\"text\" name=\"game\" /></td>");
					print("</tr>");
					print("<tr>");
						print("<td><select name=\"type\" >");
		  					print("<option value=\"0\"> Videogame </option>");
		  					print("<option value=\"1\"> Tablegame </option>");
		  					print("<option value=\"2\"> Cardgame </option>");
		  					print("<option value=\"3\"> Other </option>");
		 				print("</select></td>");
					print("</tr>");
				print("</table>");
				print("<input type=\"submit\" value=\"Submit\" />");
			print("</form>");
		print("</fieldset>");
	}
	/* Modify a User review */
	else if ($_POST['chosen']==2) {
		print("<fieldset>");
			print("<legend><strong><big></big>Please, insert the mail of the user who has used an inappropiate language</strong></legend>");
			print("<form action=\"moder_review.php\" method=\"post\">");
				print("<table>");
					print("<tr>");
						print("<td>Email:</td>");
						print("<td><input type=\"text\" name=\"email\" /></td>");
					print("</tr>");
					print("<tr>");
						print("<td>Game:</td>");
						print("<td><input type=\"text\" name=\"game\" /></td>");
					print("</tr>");
					print("<tr>");
						print("<td><select name=\"type\" >");
		  					print("<option value=\"0\"> Videogame </option>");
		  					print("<option value=\"1\"> Tablegame </option>");
		  					print("<option value=\"2\"> Cardgame </option>");
		  					print("<option value=\"3\"> Other </option>");
		 				print("</select></td>");
					print("</tr>");
				print("</table>");
				print("<input type=\"submit\" value=\"Submit\" />");
			print("</form>");
		print("</fieldset>");
	}
	/* Update Game Info */
	else if ($_POST['chosen']==3) {
		print("<fieldset>");
			print("<legend><strong><big></big>Please, insert the name of the game, with the type, you want to update</strong></legend>");
			print("<form action=\"update_game.php\" method=\"post\">");
				print("<table>");
					print("<tr>");
						print("<td>Game:</td>");
						print("<td><input type=\"text\" name=\"game\" /></td>");
					print("</tr>");
					print("<tr>");
						print("<td><select name=\"type\" >");
		  					print("<option value=\"0\"> Videogame </option>");
		  					print("<option value=\"1\"> Tablegame </option>");
		  					print("<option value=\"2\"> Cardgame </option>");
		  					print("<option value=\"3\"> Other </option>");
		 				print("</select></td>");
					print("</tr>");
				print("</table>");
				print("<input type=\"submit\" value=\"Submit\" />");
			print("</form>");
		print("</fieldset>");
	}
	/* Delete Tag */
	else if ($_POST['chosen']==4) {
		print("<fieldset>");
			print("<legend><strong><big></big>Please, insert the tag you want to delete from App</strong></legend>");
			print("<form action=\"delete_tag.php\" method=\"post\">");
				print("<table>");
					print("<tr>");
						print("<td>Tag:</td>");
						print("<td><input type=\"text\" name=\"tag\" /></td>");
					print("</tr>");
				print("</table>");
				print("<input type=\"submit\" value=\"Submit\" />");
			print("</form>");
		print("</fieldset>");
	}
	/* Free a game From a Specific Tag */
	else if ($_POST['chosen']==5) {
		print("<fieldset>");
			print("<legend><strong><big></big>Please, insert the tag and the game, with the type, you want to dissociate</strong></legend>");
			print("<form action=\"free_game_tag.php\" method=\"post\">");
				print("<table>");
					print("<tr>");
						print("<td>Tag:</td>");
						print("<td><input type=\"text\" name=\"tag\" /></td>");
					print("</tr>");
					print("<tr>");
						print("<td>Game:</td>");
						print("<td><input type=\"text\" name=\"game\" /></td>");
					print("</tr>");
					print("<tr>");
						print("<td><select name=\"type\" >");
		  					print("<option value=\"0\"> Videogame </option>");
		  					print("<option value=\"1\"> Tablegame </option>");
		  					print("<option value=\"2\"> Cardgame </option>");
		  					print("<option value=\"3\"> Other </option>");
		 				print("</select></td>");
					print("</tr>");
				print("</table>");
				print("<input type=\"submit\" value=\"Submit\" />");
			print("</form>");
		print("</fieldset>");
	}
	/* Free a game From all Tags */
	else {
		print("<fieldset>");
			print("<legend><strong><big></big>Please, insert the game you want to delete from all tags</strong></legend>");
			print("<form action=\"free_game_tags_all.php\" method=\"post\">");
				print("<table>");
						print("<td>Game:</td>");
						print("<td><input type=\"text\" name=\"game\" /></td>");
					print("</tr>");
					print("<tr>");
						print("<td><select name=\"type\" >");
		  					print("<option value=\"0\"> Videogame </option>");
		  					print("<option value=\"1\"> Tablegame </option>");
		  					print("<option value=\"2\"> Cardgame </option>");
		  					print("<option value=\"3\"> Other </option>");
		 				print("</select></td>");
					print("</tr>");
				print("</table>");
				print("<input type=\"submit\" value=\"Submit\" />");
			print("</form>");
		print("</fieldset>");
	}
?>
