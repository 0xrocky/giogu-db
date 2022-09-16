<?php
	/* Classe PHP che gestisce tutte le attività in cui è coinvolto il database */
	class Classdb {
	
		private $id_connection;
		
		function connection() {
			/* Richiedi il file di configurazione degli utenti del databse */
			require_once ('file_config_db.php');
			
			/* Se la variabile ruolo in sessione è già settata, recupera le credenziali dell'utente */
			if (isSet($_SESSION['type'])) {
				/* 2 è l'identificativo del tipo utente admin */
				if($_SESSION['type'] == 2)
					$this->id_connection = pg_connect("host=$dbhost port=$dbport dbname=$dbname user=$dbadmin password=$dbadmin_pass");
				/* Altrimenti è : 0 un utente iscritto, 1 un utente analista */
				else if($_SESSION['type'] == 1)
					$this->id_connection = pg_connect("host=$dbhost port=$dbport dbname=$dbname user=$dbanal password=$dbanal_pass");
				else
					$this->id_connection = pg_connect("host=$dbhost port=$dbport dbname=$dbname user=$dbuser password=$dbuser_pass");
			}
			/* Altrimenti identifica l'utente come un utente generico */
			else 
				$this->id_connection = pg_connect("host=$dbhost port=$dbport dbname=$dbname user=$dbuser password=$dbuser_pass");
			if (!$this->id_connection) {
   				print pg_last_error($this->id_connection);
        			exit;
    			}
		}
		function disconnection() {
			if(!pg_close($this->id_connection))
				print ("Failed to close connection to ".pg_host($this->id_connection).": ".pg_last_error($this->id_connection)."<br/>\n");
		}
		function query($sql) {
			return pg_query($this->id_connection, $sql);
		}
	}

?>
