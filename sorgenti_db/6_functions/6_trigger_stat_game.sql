CREATE TRIGGER stat_game_insgm_t AFTER INSERT ON Game FOR EACH ROW EXECUTE PROCEDURE stat_game_update();
--ricalcola il numero di giochi desiderati e posseduti/provati dopo l'inserimento/la cancellazione di un gioco dalla lista dei desiderati
CREATE TRIGGER stat_game_des_t AFTER INSERT OR DELETE ON Desired FOR EACH ROW EXECUTE PROCEDURE stat_game_update();
--ricalcola il numero di giochi desiderati e posseduti/provati dopo l'inserimento/la cancellazione di un gioco dalla lista dei poss/provati
CREATE TRIGGER stat_game_poss_t AFTER INSERT OR DELETE ON HadTried FOR EACH ROW EXECUTE PROCEDURE stat_game_update();

CREATE TRIGGER stat_game_sex_t AFTER INSERT OR DELETE OR UPDATE OF vote ON HadTried FOR EACH ROW EXECUTE PROCEDURE stat_game_sex_update();
CREATE TRIGGER stat_game_age_t AFTER INSERT OR DELETE OR UPDATE OF vote ON HadTried FOR EACH ROW EXECUTE PROCEDURE stat_game_age_update();
CREATE TRIGGER stat_game_country_t AFTER INSERT OR DELETE OR UPDATE OF vote ON HadTried FOR EACH ROW EXECUTE PROCEDURE stat_game_country_update();

-- funzione che aggiorna selettivamente su un certo gioco la tabella Stat_Game_Sex quando un utente modifica i dati persnali del suo profilo. Chiamata dal trigger
CREATE OR REPLACE FUNCTION stat_game_sex_userupdate() RETURNS TRIGGER AS $$
	DECLARE temp RECORD;
	DECLARE gid_upd Game.gid%TYPE;
	BEGIN
		FOR gid_upd IN SELECT gid FROM Hadtried WHERE uid=NEW.uid
		LOOP
			DELETE FROM Stat_Game_Sex WHERE gid=gid_upd;
		    	FOR temp IN SELECT * FROM stat_game_sex(gid_upd) AS (avrg numeric,sex Gender)
		  	LOOP
		    		INSERT INTO Stat_Game_Sex VALUES(gid_upd,temp.avrg,temp.sex);
		    	END LOOP; 
		END LOOP;    
	RETURN NULL;
	END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER stat_game_sex_userupd_t AFTER UPDATE OF sex ON Users FOR EACH ROW EXECUTE PROCEDURE stat_game_sex_userupdate();

-- funzione che aggiorna selettivamente su un certo gioco la tabella Stat_Game_Age quando un utente modifica i dati persnali del suo profilo. Chiamata dal trigger
CREATE OR REPLACE FUNCTION stat_game_age_userupdate() RETURNS TRIGGER AS $$
	DECLARE temp RECORD;
	DECLARE gid_upd Game.gid%TYPE;
	BEGIN
		FOR gid_upd IN SELECT gid FROM Hadtried WHERE uid=NEW.uid
		LOOP
			DELETE FROM Stat_Game_Age WHERE gid=gid_upd;
		    	FOR temp IN SELECT * FROM stat_game_age(gid_upd) AS (avrg numeric,age smallint)
		  	LOOP
		    		INSERT INTO Stat_Game_Age VALUES(gid_upd,temp.avrg,temp.age);
		    	END LOOP; 
		END LOOP;    
	RETURN NULL;
	END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER stat_game_age_userupd_t AFTER UPDATE OF age ON Users FOR EACH ROW EXECUTE PROCEDURE stat_game_age_userupdate();

-- funzione che aggiorna selettivamente su un certo gioco la tabella Stat_Game_Country quando un utente modifica i dati persnali del suo profilo. Chiamata dal trigger
CREATE OR REPLACE FUNCTION stat_game_country_userupdate() RETURNS TRIGGER AS $$
	DECLARE temp RECORD;
	DECLARE gid_upd Game.gid%TYPE;
	BEGIN
		FOR gid_upd IN SELECT gid FROM Hadtried WHERE uid=NEW.uid
		LOOP
			DELETE FROM Stat_Game_Country WHERE gid=gid_upd;
		    	FOR temp IN SELECT * FROM stat_game_country(gid_upd) AS (avrg numeric,country Initials)
		  	LOOP
		    		INSERT INTO Stat_Game_Country VALUES(gid_upd,temp.avrg,temp.country);
		    	END LOOP; 
		END LOOP;    
	RETURN NULL;
	END;
$$ LANGUAGE plpgsql;
CREATE TRIGGER stat_game_country_userupd_t AFTER UPDATE OF sex ON Users FOR EACH ROW EXECUTE PROCEDURE stat_game_country_userupdate();
