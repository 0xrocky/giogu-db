-- funzione che riempie la tabella Stat_Game
CREATE OR REPLACE FUNCTION stat_game_fill() RETURNS VOID AS $$
	DECLARE a Game.gid%TYPE;
	BEGIN
	  	FOR a IN SELECT gid FROM Game
	  	LOOP
            		INSERT INTO Stat_Game VALUES(a,count_user_des(a),count_user_poss(a));
        	END LOOP; 
	RETURN; 
	END;
$$ LANGUAGE plpgsql;

-- funzione che svuota la tabella Stat_Game, e la riempie nuovamente. Chiamata dal trigger corrispondente
CREATE OR REPLACE FUNCTION stat_game_update() RETURNS TRIGGER AS $$
	DECLARE gid_upd Game.gid%TYPE;
	BEGIN
		IF (TG_OP = 'INSERT') THEN
			gid_upd := NEW.gid;
		ELSE	/* In caso di DELETE, prima controlla che non sia stata fatta una DELETE Game anche sulla tabella Game, magari dall'admin */
			SELECT gid INTO gid_upd FROM Game WHERE gid = OLD.gid;
			IF NOT FOUND THEN
				RETURN NULL; 	
			END IF;
		END IF;
		DELETE FROM Stat_Game WHERE gid=gid_upd;
		INSERT INTO Stat_Game VALUES(gid_upd,count_user_des(gid_upd),count_user_poss(gid_upd));
	RETURN NULL; 
	END;
$$ LANGUAGE plpgsql;

--*************************************************************************************************************************************************************--

-- funzione che, dato un gioco, calcola il voto medio per sesso
CREATE OR REPLACE FUNCTION stat_game_sex(gid_in integer) RETURNS SETOF RECORD AS $$
	BEGIN
            	RETURN QUERY SELECT ROUND(AVG(vote)),sex FROM Users NATURAL JOIN HadTried WHERE vote IS NOT NULL AND gid=gid_in GROUP BY sex;
	RETURN; 
	END;
$$ LANGUAGE plpgsql;

-- funzione che riempie la tabella Stat_Game_Sex
CREATE OR REPLACE FUNCTION stat_game_sex_fill() RETURNS VOID AS $$
	DECLARE a Game.gid%TYPE;
	DECLARE temp RECORD;
	BEGIN
	  	FOR a IN SELECT gid FROM Game
	  	LOOP
	  		FOR temp IN SELECT * FROM stat_game_sex(a) AS (avrg numeric,sex Gender)
	  		LOOP
            			INSERT INTO Stat_Game_Sex VALUES(a,temp.avrg,temp.sex);
            		END LOOP; 
        	END LOOP; 
	RETURN; 
	END;
$$ LANGUAGE plpgsql;

-- funzione che aggiorna selettivamente su un certo gioco la tabella Stat_Game_Sex. Chiamata dal trigger corrispondente
CREATE OR REPLACE FUNCTION stat_game_sex_update() RETURNS TRIGGER AS $$
	DECLARE temp RECORD;
	DECLARE gid_upd Game.gid%TYPE;
	BEGIN
		IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
			gid_upd := NEW.gid;
		ELSE	/* In caso di DELETE, prima controlla che non sia stata fatta una DELETE Game anche sulla tabella Game, magari dall'admin */
			SELECT gid INTO gid_upd FROM Game WHERE gid = OLD.gid;
			IF NOT FOUND THEN
				RETURN NULL; 	
			END IF;
		END IF;
		DELETE FROM Stat_Game_Sex WHERE gid=gid_upd;
            	FOR temp IN SELECT * FROM stat_game_sex(gid_upd) AS (avrg numeric,sex Gender)
	  	LOOP
            		INSERT INTO Stat_Game_Sex VALUES(gid_upd,temp.avrg,temp.sex);
            	END LOOP; 
	RETURN NULL;
	END;
$$ LANGUAGE plpgsql;

--*************************************************************************************************************************************************************--

-- funzione che, dato un gioco, calcola il voto medio per età
CREATE OR REPLACE FUNCTION stat_game_age(gid_in integer) RETURNS SETOF RECORD AS $$
	BEGIN
            	RETURN QUERY SELECT ROUND(AVG(vote)),age FROM Users NATURAL JOIN HadTried WHERE vote IS NOT NULL AND gid=gid_in GROUP BY age;
	RETURN; 
	END;
$$ LANGUAGE plpgsql;

-- funzione che riempie la tabella Stat_Game_Age
CREATE OR REPLACE FUNCTION stat_game_age_fill() RETURNS VOID AS $$
	DECLARE a Game.gid%TYPE;
	DECLARE temp RECORD;
	BEGIN
	  	FOR a IN SELECT gid FROM Game
	  	LOOP
	  		FOR temp IN SELECT * FROM stat_game_age(a) AS (avrg numeric,age smallint)
	  		LOOP
            			INSERT INTO Stat_Game_Age VALUES(a,temp.avrg,temp.age);
            		END LOOP; 
        	END LOOP; 
	RETURN; 
	END;
$$ LANGUAGE plpgsql;

-- funzione che aggiorna selettivamente su un certo gioco la tabella Stat_Game_Age. Chiamata dal trigger corrispondente
CREATE OR REPLACE FUNCTION stat_game_age_update() RETURNS TRIGGER AS $$
	DECLARE temp RECORD;
	DECLARE gid_upd Game.gid%TYPE;
	BEGIN
		IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
			gid_upd := NEW.gid;
		ELSE	/* In caso di DELETE, prima controlla che non sia stata fatta una DELETE Game anche sulla tabella Game, magari dall'admin */
			SELECT gid INTO gid_upd FROM Game WHERE gid = OLD.gid;
			IF NOT FOUND THEN
				RETURN NULL; 	
			END IF;
		END IF;
		DELETE FROM Stat_Game_Age WHERE gid=gid_upd;
            	FOR temp IN SELECT * FROM stat_game_age(gid_upd) AS (avrg numeric,age smallint)
	  	LOOP
            		INSERT INTO Stat_Game_Age VALUES(gid_upd,temp.avrg,temp.age);
            	END LOOP; 
	RETURN NULL; 
	END;
$$ LANGUAGE plpgsql;

--*************************************************************************************************************************************************************--

-- funzione che, dato un gioco, calcola il voto medio per regione
CREATE OR REPLACE FUNCTION stat_game_country(gid_in integer) RETURNS SETOF RECORD AS $$
	BEGIN
            	RETURN QUERY SELECT ROUND(AVG(vote)),country FROM Users NATURAL JOIN HadTried WHERE vote IS NOT NULL AND gid=gid_in GROUP BY country;
	RETURN; 
	END;
$$ LANGUAGE plpgsql;

-- funzione che riempie la tabella Stat_Game_Country
CREATE OR REPLACE FUNCTION stat_game_country_fill() RETURNS VOID AS $$
	DECLARE a Game.gid%TYPE;
	DECLARE temp RECORD;
	BEGIN
	  	FOR a IN SELECT gid FROM Game
	  	LOOP
	  		FOR temp IN SELECT * FROM stat_game_country(a) AS (avrg numeric,country Initials)
	  		LOOP
            			INSERT INTO Stat_Game_Country VALUES(a,temp.avrg,temp.country);
            		END LOOP; 
        	END LOOP; 
	RETURN; 
	END;
$$ LANGUAGE plpgsql;

-- funzione che aggiorna selettivamente su un certo gioco la tabella Stat_Game_Country. Chiamata dal trigger corrispondente
CREATE OR REPLACE FUNCTION stat_game_country_update() RETURNS TRIGGER AS $$
	DECLARE temp RECORD;
	DECLARE gid_upd Game.gid%TYPE;
	BEGIN
		IF (TG_OP = 'INSERT' OR TG_OP = 'UPDATE') THEN
			gid_upd := NEW.gid;
		ELSE	/* In caso di DELETE, prima controlla che non sia stata fatta una DELETE Game anche sulla tabella Game, magari dall'admin */
			SELECT gid INTO gid_upd FROM Game WHERE gid = OLD.gid;
			IF NOT FOUND THEN
				RETURN NULL; 	
			END IF;
		END IF;
		DELETE FROM Stat_Game_Country WHERE gid=gid_upd;
            	FOR temp IN SELECT * FROM stat_game_country(gid_upd) AS (avrg numeric,country Initials)
	  	LOOP
            		INSERT INTO Stat_Game_Country VALUES(gid_upd,temp.avrg,temp.country);
            	END LOOP; 
	RETURN NULL; 
	END;
$$ LANGUAGE plpgsql;
