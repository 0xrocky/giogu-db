-- Funzione che impedisce che un gioco desiderato sia contemporaneamente provato dallo stesso utente, e viceversa.
CREATE OR REPLACE FUNCTION desired_or_hadtried() RETURNS TRIGGER AS $$
	DECLARE preex Desired%ROWTYPE;
	BEGIN
		-- controlla che l'inserimento sia su HadTried, e verifica quindi che lo stesso gioco non sia già desiderato
		IF (TG_NAME= 'consistence_poss_trig') THEN
			FOR preex IN SELECT * FROM Desired
	  			LOOP
            				IF (NEW.uid = preex.uid AND NEW.gid = preex.gid) THEN RETURN NULL;
					END IF;
        			END LOOP; 
		ELSE
			-- l'inserimento è su Desired, e verifica quindi che lo stesso gioco non sia già posseduto/provato
			FOR preex IN SELECT uid,gid FROM HadTried
	  			LOOP
            				IF (NEW.uid = preex.uid AND NEW.gid = preex.gid) THEN RETURN NULL;
					END IF;
        			END LOOP;
		END IF;
		RETURN NEW;
	END;
$$ language plpgsql;
CREATE TRIGGER consistence_des_trig BEFORE INSERT ON Desired FOR EACH ROW EXECUTE PROCEDURE desired_or_hadtried();
CREATE TRIGGER consistence_poss_trig BEFORE INSERT ON HadTried FOR EACH ROW EXECUTE PROCEDURE desired_or_hadtried();


-- Funzione che verifica che un gioco sia inserito nella corretta tabella di tipologia, prevenendo quindi che uno stesso gioco stia in più sottotabelle di tipologia
CREATE OR REPLACE FUNCTION check_game_type() RETURNS TRIGGER AS $$
	DECLARE type_new Game.type%TYPE;
	BEGIN
		SELECT type INTO type_new FROM Game WHERE gid = NEW.gid;
		IF (TG_NAME = 'consistence_videogame_trig') THEN
			IF (type_new <> 0) THEN RAISE EXCEPTION 'game already existing in other typology table';
			END IF;
		ELSIF (TG_NAME = 'consistence_tablegame_trig') THEN
			IF (type_new <> 1) THEN RAISE EXCEPTION 'game already existing in other typology table';
			END IF;
		ELSIF (TG_NAME = 'consistence_cardgame_trig') THEN
			IF (type_new <> 2) THEN RAISE EXCEPTION 'game already existing in other typology table';
			END IF;
		ELSE IF (type_new <> 3) THEN RAISE EXCEPTION 'game already existing in other typology table';
			END IF;
		END IF;
		RETURN NEW;
	END;
$$ language plpgsql;
CREATE TRIGGER consistence_videogame_trig BEFORE INSERT OR UPDATE ON Videogame FOR EACH ROW EXECUTE PROCEDURE check_game_type();
CREATE TRIGGER consistence_tablegame_trig BEFORE INSERT OR UPDATE ON Tablegame FOR EACH ROW EXECUTE PROCEDURE check_game_type();
CREATE TRIGGER consistence_cardgame_trig BEFORE INSERT OR UPDATE ON Cardgame FOR EACH ROW EXECUTE PROCEDURE check_game_type();
CREATE TRIGGER consistence_othergame_trig BEFORE INSERT OR UPDATE ON Other FOR EACH ROW EXECUTE PROCEDURE check_game_type();


-- Funzione che impedisce che un gioco sia cancellato da una sottotabella di tipologia specifica, senza prima essere stato cancellato dalla tabella Game (il comportamento inverso del vincolo di integrità referenziale per la chiave primaria delle sottotabelle, che è chiave esterna sulla chiave primaria di Game)
CREATE OR REPLACE FUNCTION specdel_game() RETURNS TRIGGER AS $$
	BEGIN
		PERFORM * FROM Game WHERE gid=OLD.gid;
		IF FOUND THEN RAISE EXCEPTION 'game not deleted in main table Game';
		END IF;
		RETURN OLD;
	END;
$$ language plpgsql;
CREATE TRIGGER consistence_specdel_video_trig BEFORE DELETE ON Videogame FOR EACH ROW EXECUTE PROCEDURE specdel_game();
CREATE TRIGGER consistence_specdel_table_trig BEFORE DELETE ON Tablegame FOR EACH ROW EXECUTE PROCEDURE specdel_game();
CREATE TRIGGER consistence_specdel_card_trig BEFORE DELETE ON Cardgame FOR EACH ROW EXECUTE PROCEDURE specdel_game();
CREATE TRIGGER consistence_specdel_other_trig BEFORE DELETE ON Other FOR EACH ROW EXECUTE PROCEDURE specdel_game();


-- Funzione che impedisce che sia modificata la tipologia di un gioco
CREATE OR REPLACE FUNCTION game_type_noupd() RETURNS TRIGGER AS $$
	BEGIN
		RAISE EXCEPTION 'cannot update type of Game';
		RETURN NEW;
	END;
$$ language plpgsql;
CREATE TRIGGER consistence_game_type_noupd_trig BEFORE UPDATE OF type ON Game FOR EACH ROW EXECUTE PROCEDURE game_type_noupd();


-- Funzione che evita duplicati di amicizia (A friend of B and B friend of A)
CREATE OR REPLACE FUNCTION check_friendship() RETURNS TRIGGER AS $$
	DECLARE temp Friend%ROWTYPE;
	BEGIN
		IF (NEW.accepted <> 'FALSE') THEN RAISE EXCEPTION 'first insert must be before accepted';
		ELSE
			FOR temp IN SELECT * FROM Friend
			LOOP
				IF (temp.uid_asked = NEW.uid_active AND temp.uid_active = NEW.uid_asked) THEN RAISE EXCEPTION 'friendship already existing';
				END IF;
			END LOOP;
		END IF;
		RETURN NEW;
	END;
$$ language plpgsql;
CREATE TRIGGER consistence_friendship_trig BEFORE INSERT ON Friend FOR EACH ROW EXECUTE PROCEDURE check_friendship();

-- Funzione che impedisce l'inserimento di due tag identici, e quindi previene l'errore di duplicate_key
CREATE OR REPLACE FUNCTION check_tag() RETURNS TRIGGER AS $$
	DECLARE cursore CURSOR FOR SELECT * FROM Tag;
	DECLARE tid Tag.tid%TYPE;
	BEGIN
		OPEN cursore;
		LOOP
			FETCH cursore INTO tid;
			EXIT WHEN NOT FOUND;
			IF (NEW.tid = tid) THEN RETURN NULL;
			END IF;
		END LOOP;
		CLOSE cursore;
		RETURN NEW;
	END;
$$ language plpgsql;
CREATE TRIGGER consistence_tag_trig BEFORE INSERT ON Tag FOR EACH ROW EXECUTE PROCEDURE check_tag();
