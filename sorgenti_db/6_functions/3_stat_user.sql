-- funzione che riempie la tabella Stat_User
CREATE OR REPLACE FUNCTION stat_user_fill() RETURNS VOID AS $$
	DECLARE a Users.uid%TYPE;
	BEGIN
	  	FOR a IN SELECT uid FROM Users
	  	LOOP
            		INSERT INTO Stat_Users VALUES(a,count_game_des(a),count_game_poss(a));
        	END LOOP; 
	RETURN; 
	END;
$$ LANGUAGE plpgsql;

-- funzione che aggiorna la tabella Stat_Users su un utente specifico. Chiamata dal trigger corrispondente
CREATE OR REPLACE FUNCTION stat_user_update() RETURNS TRIGGER AS $$
	DECLARE uid_upd Users.uid%TYPE;
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			uid_upd := NEW.uid;
		ELSE	/* In caso di DELETE, prima controlla che non sia stata fatta una DELETE User anche sulla tabella Users, magari dall'admin */
			SELECT uid INTO uid_upd FROM Users WHERE uid = OLD.uid;
			IF NOT FOUND THEN
				RETURN NULL; 	
			END IF;
		END IF;
		DELETE FROM Stat_Users WHERE uid=uid_upd;
		INSERT INTO Stat_Users VALUES(uid_upd,count_game_des(uid_upd),count_game_poss(uid_upd));
	RETURN NULL; 
	END;
$$ LANGUAGE plpgsql;

--*************************************************************************************************************************************************************--

-- funzione che calcola il numero medio dei giochi desiderati
CREATE OR REPLACE FUNCTION avg_game_des() RETURNS integer AS $$
	DECLARE	a real;
	DECLARE	b integer;
	DECLARE	result integer;
	BEGIN
		SELECT SUM(num) INTO a FROM StatDesGames; -- a è la somma di tutti i giochi desiderati
		IF a IS NULL THEN
			result := 0;
		ELSE
			SELECT COUNT(uid) INTO b FROM Users WHERE type<>1; -- b è il numero di utenti che possono desiderare giochi (1=analyst)
			result := ROUND(a/b);
		END IF;
	RETURN result;
	EXCEPTION
    	WHEN division_by_zero THEN RETURN 0;  -- ignorare l'errore
	END;
$$ LANGUAGE plpgsql;

-- funzione che calcola il numero medio dei giochi posseduti/provati da un utente
CREATE OR REPLACE FUNCTION avg_game_poss() RETURNS integer AS $$
	DECLARE	a real;
	DECLARE	b integer;
	DECLARE	result integer;
	BEGIN
		SELECT SUM(num) INTO a FROM StatPossGames; -- a è la somma di tutti i giochi posseduti
		IF a IS NULL THEN
			result := 0;
		ELSE
			SELECT COUNT(uid) INTO b FROM Users WHERE type<>1; -- b è il numero di utenti che possono possedere giochi (1=analyst)
			result := ROUND(a/b);
		END IF;
	RETURN result;
	EXCEPTION
    	WHEN division_by_zero THEN RETURN 0;  -- ignorare l'errore
	END;
$$ LANGUAGE plpgsql;

-- funzione che riempie la tabella Stat_Users_Avg
CREATE OR REPLACE FUNCTION stat_user_avg_fill() RETURNS VOID AS $$
	BEGIN
            	INSERT INTO Stat_Users_Avg VALUES(avg_game_des(),avg_game_poss());
	RETURN; 
	END;
$$ LANGUAGE plpgsql;

-- funzione che svuota la tabella Stat_Users_Avg, e la riempie nuovamente. Chiamata dal trigger corrispondente
CREATE OR REPLACE FUNCTION stat_user_avg_update() RETURNS TRIGGER AS $$
	BEGIN
		DELETE FROM Stat_Users_Avg;
            	PERFORM * FROM stat_user_avg_fill();
	RETURN NULL; 
	END;
$$ LANGUAGE plpgsql;
