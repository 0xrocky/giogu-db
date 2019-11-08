--
-- PostgreSQL database dump
--

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: giogu; Type: DATABASE; Schema: -; Owner: postgres
--

CREATE DATABASE giogu WITH TEMPLATE = template0 ENCODING = 'UTF8' LC_COLLATE = 'it_IT.UTF-8' LC_CTYPE = 'it_IT.UTF-8';


ALTER DATABASE giogu OWNER TO postgres;

\connect giogu

SET statement_timeout = 0;
SET client_encoding = 'UTF8';
SET standard_conforming_strings = off;
SET check_function_bodies = false;
SET client_min_messages = warning;
SET escape_string_warning = off;

--
-- Name: plpgsql; Type: PROCEDURAL LANGUAGE; Schema: -; Owner: postgres
--

CREATE OR REPLACE PROCEDURAL LANGUAGE plpgsql;


ALTER PROCEDURAL LANGUAGE plpgsql OWNER TO postgres;

SET search_path = public, pg_catalog;

--
-- Name: console_mark; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN console_mark AS character varying(15)
	CONSTRAINT console_mark_check CHECK (((VALUE)::text = ANY ((ARRAY['Sony'::character varying, 'Microsoft'::character varying, 'Nintendo'::character varying, 'Sega'::character varying, 'Other'::character varying])::text[])));


ALTER DOMAIN public.console_mark OWNER TO postgres;

--
-- Name: console_model; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN console_model AS character varying(15)
	CONSTRAINT console_model_check CHECK (((VALUE)::text = ANY ((ARRAY['Play Station'::character varying, 'Play Station 2'::character varying, 'Play Station 3'::character varying, 'PSP'::character varying, 'XBox'::character varying, 'XBox 360'::character varying, 'Wii'::character varying, 'GameBoy'::character varying, 'DS'::character varying, 'Master System'::character varying, 'Mega Drive'::character varying, 'PC'::character varying, 'Other'::character varying])::text[])));


ALTER DOMAIN public.console_model OWNER TO postgres;

--
-- Name: gender; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN gender AS character(1)
	CONSTRAINT gender_check CHECK ((VALUE = ANY (ARRAY['M'::bpchar, 'F'::bpchar])));


ALTER DOMAIN public.gender OWNER TO postgres;

--
-- Name: initials; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN initials AS character(3)
	CONSTRAINT initials_check CHECK ((VALUE = ANY (ARRAY['VDA'::bpchar, 'PIE'::bpchar, 'LOM'::bpchar, 'LIG'::bpchar, 'TAD'::bpchar, 'VEN'::bpchar, 'FVG'::bpchar, 'TOS'::bpchar, 'EMR'::bpchar, 'MAR'::bpchar, 'UMB'::bpchar, 'LAZ'::bpchar, 'CAM'::bpchar, 'MOL'::bpchar, 'BAS'::bpchar, 'ABR'::bpchar, 'PUG'::bpchar, 'CAL'::bpchar, 'SIC'::bpchar, 'SAR'::bpchar, 'XXX'::bpchar])));


ALTER DOMAIN public.initials OWNER TO postgres;

--
-- Name: typedeck; Type: DOMAIN; Schema: public; Owner: postgres
--

CREATE DOMAIN typedeck AS character varying(20) DEFAULT 'francesi'::character varying
	CONSTRAINT typedeck_check CHECK (((VALUE)::text = ANY ((ARRAY['francesi'::character varying, 'bergamasche'::character varying, 'bolognesi'::character varying, 'bresciane'::character varying, 'genovesi'::character varying, 'lombarde'::character varying, 'siciliane'::character varying, 'nuoresi'::character varying, 'piacentine'::character varying, 'piemontesi'::character varying, 'romagnole'::character varying, 'romane'::character varying, 'sarde'::character varying, 'toscane_fiorentine'::character varying, 'trentine'::character varying, 'trevisane'::character varying, 'triestine'::character varying, 'viterbesi'::character varying, 'spagnole'::character varying, 'tedesche_austriache'::character varying, 'svizzere'::character varying, 'tarocchi'::character varying, 'collezione'::character varying])::text[])));


ALTER DOMAIN public.typedeck OWNER TO postgres;

--
-- Name: avg_game_des(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION avg_game_des() RETURNS integer
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.avg_game_des() OWNER TO postgres;

--
-- Name: avg_game_poss(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION avg_game_poss() RETURNS integer
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.avg_game_poss() OWNER TO postgres;

--
-- Name: check_friendship(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION check_friendship() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.check_friendship() OWNER TO postgres;

--
-- Name: check_game_type(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION check_game_type() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.check_game_type() OWNER TO postgres;

--
-- Name: check_tag(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION check_tag() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.check_tag() OWNER TO postgres;

--
-- Name: count_game_des(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION count_game_des(uid_in integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$

	DECLARE	a integer;

	BEGIN

		SELECT COUNT(gid) INTO a FROM Desired WHERE uid=uid_in;

	RETURN a;

	END;

$$;


ALTER FUNCTION public.count_game_des(uid_in integer) OWNER TO postgres;

--
-- Name: count_game_poss(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION count_game_poss(uid_in integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$

	DECLARE	a integer;

	BEGIN

		SELECT COUNT(gid) INTO a FROM HadTried WHERE uid=uid_in;

	RETURN a;

	END;

$$;


ALTER FUNCTION public.count_game_poss(uid_in integer) OWNER TO postgres;

--
-- Name: count_user_des(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION count_user_des(gid_in integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$

	DECLARE	a integer;

	BEGIN

		SELECT COUNT(uid) INTO a FROM Desired WHERE gid=gid_in;

	RETURN a;

	END;

$$;


ALTER FUNCTION public.count_user_des(gid_in integer) OWNER TO postgres;

--
-- Name: count_user_poss(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION count_user_poss(gid_in integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$

	DECLARE	a integer;

	BEGIN

		SELECT COUNT(uid) INTO a FROM HadTried WHERE gid=gid_in;

	RETURN a;

	END;

$$;


ALTER FUNCTION public.count_user_poss(gid_in integer) OWNER TO postgres;

--
-- Name: desired_or_hadtried(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION desired_or_hadtried() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.desired_or_hadtried() OWNER TO postgres;

--
-- Name: game_type_noupd(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION game_type_noupd() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

	BEGIN

		RAISE EXCEPTION 'cannot update type of Game';

		RETURN NEW;

	END;

$$;


ALTER FUNCTION public.game_type_noupd() OWNER TO postgres;

--
-- Name: similarity(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION similarity(uid_in integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$

	BEGIN

	  	RETURN QUERY SELECT uid, name, surname, similarity_calculate(uid,uid_in) AS similarity FROM Users WHERE uid<>1 AND uid<>uid_in;

	RETURN; 

	END;

$$;


ALTER FUNCTION public.similarity(uid_in integer) OWNER TO postgres;

--
-- Name: similarity_calculate(integer, integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION similarity_calculate(uid_a integer, uid_b integer) RETURNS integer
    LANGUAGE plpgsql
    AS $$

	DECLARE a integer;

	DECLARE b integer;

	DECLARE num_giochi_a integer;

	DECLARE num_giochi_b integer;

	DECLARE num_giochi_comuni real;

	DECLARE x real;

	DECLARE y real;

	BEGIN

	-- giochi in comune

	SELECT * INTO a FROM count_game_des(uid_a);

	SELECT * INTO b FROM count_game_poss(uid_a);

	num_giochi_a := a+b;

	SELECT * INTO a FROM count_game_des(uid_b);

	SELECT * INTO b FROM count_game_poss(uid_b);

	num_giochi_b := a+b;

	SELECT COUNT(gid) INTO num_giochi_comuni FROM Game WHERE gid IN ((SELECT gid FROM Desired WHERE uid=uid_a UNION SELECT gid FROM HadTried WHERE uid=uid_a) INTERSECT (SELECT gid FROM Desired WHERE uid=uid_b UNION SELECT gid FROM HadTried WHERE uid=uid_b));

	x := 100*(2*num_giochi_comuni)/(num_giochi_a+num_giochi_b);

	-- media delle votazioni sui giochi in comune

        SELECT AVG(100-10*ABS(t1.vote-t2.vote)) INTO y FROM HadTried AS t1, HadTried AS t2 WHERE t1.uid=uid_a AND t2.uid=uid_b AND t1.gid=t2.gid;

        IF y IS NULL THEN

		y=0;

	END IF;

  	RETURN ROUND(x*0.7+y*0.3);

  	EXCEPTION

    	WHEN division_by_zero THEN RETURN 0;  -- ignorare l'errore

	END;

$$;


ALTER FUNCTION public.similarity_calculate(uid_a integer, uid_b integer) OWNER TO postgres;

--
-- Name: specdel_game(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION specdel_game() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

	BEGIN

		PERFORM * FROM Game WHERE gid=OLD.gid;

		IF FOUND THEN RAISE EXCEPTION 'game not deleted in main table Game';

		END IF;

		RETURN OLD;

	END;

$$;


ALTER FUNCTION public.specdel_game() OWNER TO postgres;

--
-- Name: stat_game_age(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_age(gid_in integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$

	BEGIN

            	RETURN QUERY SELECT ROUND(AVG(vote)),age FROM Users NATURAL JOIN HadTried WHERE vote IS NOT NULL AND gid=gid_in GROUP BY age;

	RETURN; 

	END;

$$;


ALTER FUNCTION public.stat_game_age(gid_in integer) OWNER TO postgres;

--
-- Name: stat_game_age_fill(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_age_fill() RETURNS void
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.stat_game_age_fill() OWNER TO postgres;

--
-- Name: stat_game_age_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_age_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.stat_game_age_update() OWNER TO postgres;

--
-- Name: stat_game_age_userupdate(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_age_userupdate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.stat_game_age_userupdate() OWNER TO postgres;

--
-- Name: stat_game_country(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_country(gid_in integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$

	BEGIN

            	RETURN QUERY SELECT ROUND(AVG(vote)),country FROM Users NATURAL JOIN HadTried WHERE vote IS NOT NULL AND gid=gid_in GROUP BY country;

	RETURN; 

	END;

$$;


ALTER FUNCTION public.stat_game_country(gid_in integer) OWNER TO postgres;

--
-- Name: stat_game_country_fill(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_country_fill() RETURNS void
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.stat_game_country_fill() OWNER TO postgres;

--
-- Name: stat_game_country_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_country_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.stat_game_country_update() OWNER TO postgres;

--
-- Name: stat_game_country_userupdate(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_country_userupdate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.stat_game_country_userupdate() OWNER TO postgres;

--
-- Name: stat_game_fill(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_fill() RETURNS void
    LANGUAGE plpgsql
    AS $$

	DECLARE a Game.gid%TYPE;

	BEGIN

	  	FOR a IN SELECT gid FROM Game

	  	LOOP

            		INSERT INTO Stat_Game VALUES(a,count_user_des(a),count_user_poss(a));

        	END LOOP; 

	RETURN; 

	END;

$$;


ALTER FUNCTION public.stat_game_fill() OWNER TO postgres;

--
-- Name: stat_game_sex(integer); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_sex(gid_in integer) RETURNS SETOF record
    LANGUAGE plpgsql
    AS $$

	BEGIN

            	RETURN QUERY SELECT ROUND(AVG(vote)),sex FROM Users NATURAL JOIN HadTried WHERE vote IS NOT NULL AND gid=gid_in GROUP BY sex;

	RETURN; 

	END;

$$;


ALTER FUNCTION public.stat_game_sex(gid_in integer) OWNER TO postgres;

--
-- Name: stat_game_sex_fill(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_sex_fill() RETURNS void
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.stat_game_sex_fill() OWNER TO postgres;

--
-- Name: stat_game_sex_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_sex_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.stat_game_sex_update() OWNER TO postgres;

--
-- Name: stat_game_sex_userupdate(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_sex_userupdate() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.stat_game_sex_userupdate() OWNER TO postgres;

--
-- Name: stat_game_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_game_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.stat_game_update() OWNER TO postgres;

--
-- Name: stat_user_avg_fill(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_user_avg_fill() RETURNS void
    LANGUAGE plpgsql
    AS $$

	BEGIN

            	INSERT INTO Stat_Users_Avg VALUES(avg_game_des(),avg_game_poss());

	RETURN; 

	END;

$$;


ALTER FUNCTION public.stat_user_avg_fill() OWNER TO postgres;

--
-- Name: stat_user_avg_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_user_avg_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

	BEGIN

		DELETE FROM Stat_Users_Avg;

            	PERFORM * FROM stat_user_avg_fill();

	RETURN NULL; 

	END;

$$;


ALTER FUNCTION public.stat_user_avg_update() OWNER TO postgres;

--
-- Name: stat_user_fill(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_user_fill() RETURNS void
    LANGUAGE plpgsql
    AS $$

	DECLARE a Users.uid%TYPE;

	BEGIN

	  	FOR a IN SELECT uid FROM Users

	  	LOOP

            		INSERT INTO Stat_Users VALUES(a,count_game_des(a),count_game_poss(a));

        	END LOOP; 

	RETURN; 

	END;

$$;


ALTER FUNCTION public.stat_user_fill() OWNER TO postgres;

--
-- Name: stat_user_update(); Type: FUNCTION; Schema: public; Owner: postgres
--

CREATE FUNCTION stat_user_update() RETURNS trigger
    LANGUAGE plpgsql
    AS $$

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

$$;


ALTER FUNCTION public.stat_user_update() OWNER TO postgres;

SET default_tablespace = '';

SET default_with_oids = false;

--
-- Name: association; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE association (
    tid character varying(20) NOT NULL,
    gid integer NOT NULL
);


ALTER TABLE public.association OWNER TO postgres;

--
-- Name: game; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE game (
    gid integer NOT NULL,
    name character varying(30) NOT NULL,
    sugg_age smallint NOT NULL,
    n_player smallint DEFAULT 1 NOT NULL,
    add_date date DEFAULT ('now'::text)::date NOT NULL,
    type smallint NOT NULL,
    CONSTRAINT game_n_player_check CHECK ((n_player > 0)),
    CONSTRAINT game_sugg_age_check CHECK ((sugg_age > 0)),
    CONSTRAINT game_type_check CHECK ((type = ANY (ARRAY[0, 1, 2, 3])))
);


ALTER TABLE public.game OWNER TO postgres;

--
-- Name: stat_game; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stat_game (
    gid integer NOT NULL,
    n_desiring integer NOT NULL,
    n_playing integer NOT NULL,
    CONSTRAINT stat_game_n_desiring_check CHECK ((n_desiring >= 0)),
    CONSTRAINT stat_game_n_playing_check CHECK ((n_playing >= 0))
);


ALTER TABLE public.stat_game OWNER TO postgres;

--
-- Name: autodelete; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW autodelete AS
    SELECT stat_game.gid FROM (stat_game NATURAL JOIN game) WHERE (((stat_game.n_desiring + stat_game.n_playing) < 3) AND ((('now'::text)::date - game.add_date) > 5));


ALTER TABLE public.autodelete OWNER TO postgres;

--
-- Name: cardgame; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE cardgame (
    gid integer NOT NULL,
    deck typedeck NOT NULL
);


ALTER TABLE public.cardgame OWNER TO postgres;

--
-- Name: cardgm; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW cardgm AS
    SELECT game.gid, game.name AS game, game.sugg_age, game.n_player, cardgame.deck FROM (game NATURAL JOIN cardgame);


ALTER TABLE public.cardgm OWNER TO postgres;

--
-- Name: hadtried; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE hadtried (
    uid integer NOT NULL,
    gid integer NOT NULL,
    review character varying(100),
    vote smallint,
    CONSTRAINT hadtried_vote_check CHECK (((vote = NULL::smallint) OR ((vote > 0) AND (vote <= 10))))
);


ALTER TABLE public.hadtried OWNER TO postgres;

--
-- Name: chartcard; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW chartcard AS
    SELECT game.gid, game.name AS game, round(avg(hadtried.vote), 2) AS avgvote FROM (game NATURAL JOIN hadtried) WHERE ((game.type = 2) AND (hadtried.vote IS NOT NULL)) GROUP BY game.gid, game.name ORDER BY round(avg(hadtried.vote), 2) DESC;


ALTER TABLE public.chartcard OWNER TO postgres;

--
-- Name: chartother; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW chartother AS
    SELECT game.gid, game.name AS game, round(avg(hadtried.vote), 2) AS avgvote FROM (game NATURAL JOIN hadtried) WHERE ((game.type = 3) AND (hadtried.vote IS NOT NULL)) GROUP BY game.gid, game.name ORDER BY round(avg(hadtried.vote), 2) DESC;


ALTER TABLE public.chartother OWNER TO postgres;

--
-- Name: charttable; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW charttable AS
    SELECT game.gid, game.name AS game, round(avg(hadtried.vote), 2) AS avgvote FROM (game NATURAL JOIN hadtried) WHERE ((game.type = 1) AND (hadtried.vote IS NOT NULL)) GROUP BY game.gid, game.name ORDER BY round(avg(hadtried.vote), 2) DESC;


ALTER TABLE public.charttable OWNER TO postgres;

--
-- Name: chartvideo; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW chartvideo AS
    SELECT game.gid, game.name AS game, round(avg(hadtried.vote), 2) AS avgvote FROM (game NATURAL JOIN hadtried) WHERE ((game.type = 0) AND (hadtried.vote IS NOT NULL)) GROUP BY game.gid, game.name ORDER BY round(avg(hadtried.vote), 2) DESC;


ALTER TABLE public.chartvideo OWNER TO postgres;

--
-- Name: console; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE console (
    mark console_mark NOT NULL,
    name console_model NOT NULL,
    CONSTRAINT console_check CHECK ((((((((mark)::text = 'Sony'::text) AND ((name)::text = ANY ((ARRAY['Play Station'::character varying, 'Play Station 2'::character varying, 'Play Station 3'::character varying, 'PSP'::character varying])::text[]))) OR (((mark)::text = 'Microsoft'::text) AND ((name)::text = ANY ((ARRAY['XBox'::character varying, 'XBox 360'::character varying])::text[])))) OR (((mark)::text = 'Nintendo'::text) AND ((name)::text = ANY ((ARRAY['Wii'::character varying, 'GameBoy'::character varying, 'DS'::character varying])::text[])))) OR (((mark)::text = 'Sega'::text) AND ((name)::text = ANY ((ARRAY['Master System'::character varying, 'Mega Drive'::character varying])::text[])))) OR (((mark)::text = 'Other'::text) AND ((name)::text = ANY ((ARRAY['PC'::character varying, 'Other'::character varying])::text[])))))
);


ALTER TABLE public.console OWNER TO postgres;

--
-- Name: desired; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE desired (
    uid integer NOT NULL,
    gid integer NOT NULL
);


ALTER TABLE public.desired OWNER TO postgres;

--
-- Name: desiredgame; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW desiredgame AS
    SELECT game.gid, game.name AS game, game.type, desired.uid FROM (game NATURAL JOIN desired);


ALTER TABLE public.desiredgame OWNER TO postgres;

--
-- Name: expected_card; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE expected_card (
    type typedeck NOT NULL
);


ALTER TABLE public.expected_card OWNER TO postgres;

--
-- Name: expected_zone; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE expected_zone (
    abbr initials NOT NULL,
    country character varying(25) NOT NULL
);


ALTER TABLE public.expected_zone OWNER TO postgres;

--
-- Name: friend; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE friend (
    uid_active integer NOT NULL,
    uid_asked integer NOT NULL,
    accepted boolean DEFAULT false NOT NULL,
    CONSTRAINT self_friendship CHECK ((uid_active <> uid_asked))
);


ALTER TABLE public.friend OWNER TO postgres;

--
-- Name: friendship; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW friendship AS
    SELECT friend.uid_active, friend.uid_asked FROM friend WHERE (friend.accepted = true);


ALTER TABLE public.friendship OWNER TO postgres;

--
-- Name: users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE users (
    uid integer NOT NULL,
    email character varying(40) NOT NULL,
    passwd character varying(25) NOT NULL,
    name character varying(20) NOT NULL,
    surname character varying(20) NOT NULL,
    age smallint NOT NULL,
    sex gender NOT NULL,
    country initials NOT NULL,
    type smallint NOT NULL,
    CONSTRAINT users_age_check CHECK ((age > 0)),
    CONSTRAINT users_type_check CHECK ((type = ANY (ARRAY[0, 1, 2])))
);


ALTER TABLE public.users OWNER TO postgres;

--
-- Name: friendslist; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW friendslist AS
    SELECT x.name AS name_active, x.surname AS surname_active, y.name AS name_asked, y.surname AS surname_asked, friendship.uid_active, friendship.uid_asked FROM users x, users y, friendship WHERE ((x.uid = friendship.uid_active) AND (y.uid = friendship.uid_asked));


ALTER TABLE public.friendslist OWNER TO postgres;

--
-- Name: game_gid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE game_gid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.game_gid_seq OWNER TO postgres;

--
-- Name: game_gid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE game_gid_seq OWNED BY game.gid;


--
-- Name: game_gid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('game_gid_seq', 12, true);


--
-- Name: gamestype; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW gamestype AS
    SELECT game.gid, game.name AS game, game.type FROM game;


ALTER TABLE public.gamestype OWNER TO postgres;

--
-- Name: hadtriedgame; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW hadtriedgame AS
    SELECT game.gid, game.name AS game, game.type, hadtried.review, hadtried.vote, hadtried.uid FROM (game NATURAL JOIN hadtried);


ALTER TABLE public.hadtriedgame OWNER TO postgres;

--
-- Name: other; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE other (
    gid integer NOT NULL
);


ALTER TABLE public.other OWNER TO postgres;

--
-- Name: othergm; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW othergm AS
    SELECT game.gid, game.name AS game, game.sugg_age, game.n_player FROM (game NATURAL JOIN other);


ALTER TABLE public.othergm OWNER TO postgres;

--
-- Name: pendingfriendship; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW pendingfriendship AS
    SELECT users.name, users.surname, friend.uid_active, friend.uid_asked FROM (users JOIN friend ON ((users.uid = friend.uid_active))) WHERE (friend.accepted = false);


ALTER TABLE public.pendingfriendship OWNER TO postgres;

--
-- Name: profiles; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW profiles AS
    SELECT users.uid, users.email, users.name, users.surname, users.age, users.sex, expected_zone.country FROM (users JOIN expected_zone ON (((users.country)::bpchar = (expected_zone.abbr)::bpchar)));


ALTER TABLE public.profiles OWNER TO postgres;

--
-- Name: reference; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE reference (
    gid integer NOT NULL,
    console console_model NOT NULL
);


ALTER TABLE public.reference OWNER TO postgres;

--
-- Name: stat_game_age; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stat_game_age (
    gid integer NOT NULL,
    avg_vote smallint NOT NULL,
    age smallint NOT NULL,
    CONSTRAINT stat_game_age_age_check CHECK ((age > 0)),
    CONSTRAINT stat_game_age_avg_vote_check CHECK (((avg_vote >= 0) AND (avg_vote <= 10)))
);


ALTER TABLE public.stat_game_age OWNER TO postgres;

--
-- Name: stat_game_country; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stat_game_country (
    gid integer NOT NULL,
    avg_vote smallint NOT NULL,
    country initials NOT NULL,
    CONSTRAINT stat_game_country_avg_vote_check CHECK (((avg_vote >= 0) AND (avg_vote <= 10)))
);


ALTER TABLE public.stat_game_country OWNER TO postgres;

--
-- Name: stat_game_sex; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stat_game_sex (
    gid integer NOT NULL,
    avg_vote smallint NOT NULL,
    sex gender NOT NULL,
    CONSTRAINT stat_game_sex_avg_vote_check CHECK (((avg_vote >= 0) AND (avg_vote <= 10)))
);


ALTER TABLE public.stat_game_sex OWNER TO postgres;

--
-- Name: stat_users; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stat_users (
    uid integer NOT NULL,
    n_desired integer NOT NULL,
    n_played integer NOT NULL,
    CONSTRAINT stat_users_n_desired_check CHECK ((n_desired >= 0)),
    CONSTRAINT stat_users_n_played_check CHECK ((n_played >= 0))
);


ALTER TABLE public.stat_users OWNER TO postgres;

--
-- Name: stat_users_avg; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE stat_users_avg (
    avg_desired smallint NOT NULL,
    avg_played smallint NOT NULL,
    CONSTRAINT stat_users_avg_avg_desired_check CHECK (((avg_desired >= 0) AND (avg_desired <= 10))),
    CONSTRAINT stat_users_avg_avg_played_check CHECK (((avg_played >= 0) AND (avg_played <= 10)))
);


ALTER TABLE public.stat_users_avg OWNER TO postgres;

--
-- Name: statdesgames; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW statdesgames AS
    SELECT count(desired.gid) AS num FROM desired GROUP BY desired.uid;


ALTER TABLE public.statdesgames OWNER TO postgres;

--
-- Name: statpossgames; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW statpossgames AS
    SELECT count(hadtried.gid) AS num FROM hadtried GROUP BY hadtried.uid;


ALTER TABLE public.statpossgames OWNER TO postgres;

--
-- Name: statsgameagerefer; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW statsgameagerefer AS
    SELECT game.gid, game.name, game.type, stat_game_age.age, stat_game_age.avg_vote FROM (game NATURAL JOIN stat_game_age);


ALTER TABLE public.statsgameagerefer OWNER TO postgres;

--
-- Name: statsgamecountryrefer; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW statsgamecountryrefer AS
    SELECT game.gid, game.name, game.type, expected_zone.country, stat_game_country.avg_vote FROM ((game NATURAL JOIN stat_game_country) JOIN expected_zone ON (((stat_game_country.country)::bpchar = (expected_zone.abbr)::bpchar)));


ALTER TABLE public.statsgamecountryrefer OWNER TO postgres;

--
-- Name: statsgamerefer; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW statsgamerefer AS
    SELECT game.gid, game.name, game.type, stat_game.n_desiring, stat_game.n_playing FROM (game NATURAL JOIN stat_game);


ALTER TABLE public.statsgamerefer OWNER TO postgres;

--
-- Name: statsgamesexrefer; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW statsgamesexrefer AS
    SELECT game.gid, game.name, game.type, stat_game_sex.sex, stat_game_sex.avg_vote FROM (game NATURAL JOIN stat_game_sex);


ALTER TABLE public.statsgamesexrefer OWNER TO postgres;

--
-- Name: statsusersrefer; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW statsusersrefer AS
    SELECT users.name, users.surname, stat_users.n_desired, stat_users.n_played FROM (users NATURAL JOIN stat_users);


ALTER TABLE public.statsusersrefer OWNER TO postgres;

--
-- Name: tablegame; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tablegame (
    gid integer NOT NULL,
    sugg_num smallint DEFAULT 2,
    duration smallint,
    CONSTRAINT tablegame_sugg_num_check CHECK ((sugg_num > 0))
);


ALTER TABLE public.tablegame OWNER TO postgres;

--
-- Name: tablegm; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW tablegm AS
    SELECT game.gid, game.name AS game, game.sugg_age, game.n_player, tablegame.sugg_num, tablegame.duration FROM (game NATURAL JOIN tablegame);


ALTER TABLE public.tablegm OWNER TO postgres;

--
-- Name: tag; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE tag (
    tid character varying(20) NOT NULL
);


ALTER TABLE public.tag OWNER TO postgres;

--
-- Name: userdesired; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW userdesired AS
    SELECT users.uid, users.name, users.surname, game.gid, game.name AS game FROM ((users JOIN desired ON ((users.uid = desired.uid))) JOIN game ON ((desired.gid = game.gid)));


ALTER TABLE public.userdesired OWNER TO postgres;

--
-- Name: userhadtried; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW userhadtried AS
    SELECT users.uid, users.name, users.surname, game.gid, game.name AS game FROM ((users JOIN hadtried ON ((users.uid = hadtried.uid))) JOIN game ON ((hadtried.gid = game.gid)));


ALTER TABLE public.userhadtried OWNER TO postgres;

--
-- Name: users_uid_seq; Type: SEQUENCE; Schema: public; Owner: postgres
--

CREATE SEQUENCE users_uid_seq
    START WITH 1
    INCREMENT BY 1
    NO MINVALUE
    NO MAXVALUE
    CACHE 1;


ALTER TABLE public.users_uid_seq OWNER TO postgres;

--
-- Name: users_uid_seq; Type: SEQUENCE OWNED BY; Schema: public; Owner: postgres
--

ALTER SEQUENCE users_uid_seq OWNED BY users.uid;


--
-- Name: users_uid_seq; Type: SEQUENCE SET; Schema: public; Owner: postgres
--

SELECT pg_catalog.setval('users_uid_seq', 17, true);


--
-- Name: videogame; Type: TABLE; Schema: public; Owner: postgres; Tablespace: 
--

CREATE TABLE videogame (
    gid integer NOT NULL
);


ALTER TABLE public.videogame OWNER TO postgres;

--
-- Name: videogm; Type: VIEW; Schema: public; Owner: postgres
--

CREATE VIEW videogm AS
    SELECT game.gid, game.name AS game, game.sugg_age, game.n_player, console.mark, console.name AS console FROM (((game NATURAL JOIN videogame) NATURAL JOIN reference) JOIN console ON (((reference.console)::text = (console.name)::text)));


ALTER TABLE public.videogm OWNER TO postgres;

--
-- Name: gid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE game ALTER COLUMN gid SET DEFAULT nextval('game_gid_seq'::regclass);


--
-- Name: uid; Type: DEFAULT; Schema: public; Owner: postgres
--

ALTER TABLE users ALTER COLUMN uid SET DEFAULT nextval('users_uid_seq'::regclass);


--
-- Data for Name: association; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO association VALUES ('sparatutto', 7);
INSERT INTO association VALUES ('di intelligenza', 2);
INSERT INTO association VALUES ('di pazienza', 8);
INSERT INTO association VALUES ('di avventura', 5);
INSERT INTO association VALUES ('di avventura', 4);
INSERT INTO association VALUES ('sparatutto', 6);
INSERT INTO association VALUES ('di intelligenza', 3);
INSERT INTO association VALUES ('di pazienza', 3);
INSERT INTO association VALUES ('di strategia', 3);
INSERT INTO association VALUES ('xxx', 11);
INSERT INTO association VALUES ('di intelligenza', 6);
INSERT INTO association VALUES ('di avventura', 6);
INSERT INTO association VALUES ('di strategia', 4);
INSERT INTO association VALUES ('di avventura', 12);
INSERT INTO association VALUES ('di strategia', 12);
INSERT INTO association VALUES ('di avventura', 7);
INSERT INTO association VALUES ('di strategia', 7);


--
-- Data for Name: cardgame; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO cardgame VALUES (2, 'francesi');
INSERT INTO cardgame VALUES (10, 'bergamasche');


--
-- Data for Name: console; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO console VALUES ('Sony', 'Play Station');
INSERT INTO console VALUES ('Sony', 'Play Station 2');
INSERT INTO console VALUES ('Sony', 'Play Station 3');
INSERT INTO console VALUES ('Sony', 'PSP');
INSERT INTO console VALUES ('Microsoft', 'XBox');
INSERT INTO console VALUES ('Microsoft', 'XBox 360');
INSERT INTO console VALUES ('Nintendo', 'Wii');
INSERT INTO console VALUES ('Nintendo', 'GameBoy');
INSERT INTO console VALUES ('Nintendo', 'DS');
INSERT INTO console VALUES ('Sega', 'Master System');
INSERT INTO console VALUES ('Sega', 'Mega Drive');
INSERT INTO console VALUES ('Other', 'PC');
INSERT INTO console VALUES ('Other', 'Other');


--
-- Data for Name: desired; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO desired VALUES (1, 1);
INSERT INTO desired VALUES (1, 2);
INSERT INTO desired VALUES (1, 4);
INSERT INTO desired VALUES (1, 5);
INSERT INTO desired VALUES (1, 6);
INSERT INTO desired VALUES (2, 1);
INSERT INTO desired VALUES (2, 4);
INSERT INTO desired VALUES (2, 5);
INSERT INTO desired VALUES (2, 6);
INSERT INTO desired VALUES (6, 6);
INSERT INTO desired VALUES (9, 4);
INSERT INTO desired VALUES (11, 3);
INSERT INTO desired VALUES (13, 6);
INSERT INTO desired VALUES (15, 1);
INSERT INTO desired VALUES (3, 8);
INSERT INTO desired VALUES (3, 10);
INSERT INTO desired VALUES (7, 4);
INSERT INTO desired VALUES (7, 5);
INSERT INTO desired VALUES (10, 11);
INSERT INTO desired VALUES (14, 11);
INSERT INTO desired VALUES (14, 7);
INSERT INTO desired VALUES (14, 12);
INSERT INTO desired VALUES (15, 12);
INSERT INTO desired VALUES (17, 3);
INSERT INTO desired VALUES (17, 7);
INSERT INTO desired VALUES (17, 6);
INSERT INTO desired VALUES (17, 10);
INSERT INTO desired VALUES (16, 1);


--
-- Data for Name: expected_card; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO expected_card VALUES ('francesi');
INSERT INTO expected_card VALUES ('bergamasche');
INSERT INTO expected_card VALUES ('bolognesi');
INSERT INTO expected_card VALUES ('bresciane');
INSERT INTO expected_card VALUES ('genovesi');
INSERT INTO expected_card VALUES ('lombarde');
INSERT INTO expected_card VALUES ('siciliane');
INSERT INTO expected_card VALUES ('nuoresi');
INSERT INTO expected_card VALUES ('piacentine');
INSERT INTO expected_card VALUES ('piemontesi');
INSERT INTO expected_card VALUES ('romagnole');
INSERT INTO expected_card VALUES ('romane');
INSERT INTO expected_card VALUES ('sarde');
INSERT INTO expected_card VALUES ('toscane_fiorentine');
INSERT INTO expected_card VALUES ('trentine');
INSERT INTO expected_card VALUES ('trevisane');
INSERT INTO expected_card VALUES ('triestine');
INSERT INTO expected_card VALUES ('viterbesi');
INSERT INTO expected_card VALUES ('spagnole');
INSERT INTO expected_card VALUES ('tedesche_austriache');
INSERT INTO expected_card VALUES ('svizzere');
INSERT INTO expected_card VALUES ('tarocchi');
INSERT INTO expected_card VALUES ('collezione');


--
-- Data for Name: expected_zone; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO expected_zone VALUES ('VDA', 'Valle Di Aosta');
INSERT INTO expected_zone VALUES ('PIE', 'Piemonte');
INSERT INTO expected_zone VALUES ('LOM', 'Lombardia');
INSERT INTO expected_zone VALUES ('LIG', 'Liguria');
INSERT INTO expected_zone VALUES ('TAD', 'Trentino Alto Adige');
INSERT INTO expected_zone VALUES ('VEN', 'Veneto');
INSERT INTO expected_zone VALUES ('FVG', 'Friuli Venezia Giulia');
INSERT INTO expected_zone VALUES ('TOS', 'Toscana');
INSERT INTO expected_zone VALUES ('EMR', 'Emilia Romagna');
INSERT INTO expected_zone VALUES ('MAR', 'Marche');
INSERT INTO expected_zone VALUES ('UMB', 'Umbria');
INSERT INTO expected_zone VALUES ('LAZ', 'Lazio');
INSERT INTO expected_zone VALUES ('CAM', 'Campania');
INSERT INTO expected_zone VALUES ('MOL', 'Molise');
INSERT INTO expected_zone VALUES ('BAS', 'Basilicata');
INSERT INTO expected_zone VALUES ('ABR', 'Abruzzo');
INSERT INTO expected_zone VALUES ('PUG', 'Puglia');
INSERT INTO expected_zone VALUES ('CAL', 'Calabria');
INSERT INTO expected_zone VALUES ('SIC', 'Sicilia');
INSERT INTO expected_zone VALUES ('SAR', 'Sardegna');
INSERT INTO expected_zone VALUES ('XXX', 'Estero');


--
-- Data for Name: friend; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO friend VALUES (1, 3, true);
INSERT INTO friend VALUES (3, 6, true);
INSERT INTO friend VALUES (6, 7, true);
INSERT INTO friend VALUES (3, 8, true);
INSERT INTO friend VALUES (6, 8, true);
INSERT INTO friend VALUES (1, 8, true);
INSERT INTO friend VALUES (1, 9, true);
INSERT INTO friend VALUES (2, 10, true);
INSERT INTO friend VALUES (1, 10, true);
INSERT INTO friend VALUES (2, 11, true);
INSERT INTO friend VALUES (1, 12, true);
INSERT INTO friend VALUES (6, 13, true);
INSERT INTO friend VALUES (1, 13, true);
INSERT INTO friend VALUES (13, 3, true);
INSERT INTO friend VALUES (3, 14, true);
INSERT INTO friend VALUES (14, 8, false);
INSERT INTO friend VALUES (1, 15, true);
INSERT INTO friend VALUES (12, 16, true);
INSERT INTO friend VALUES (1, 16, true);
INSERT INTO friend VALUES (12, 17, true);
INSERT INTO friend VALUES (17, 16, true);
INSERT INTO friend VALUES (14, 1, true);
INSERT INTO friend VALUES (6, 1, true);
INSERT INTO friend VALUES (2, 1, true);
INSERT INTO friend VALUES (16, 3, true);
INSERT INTO friend VALUES (17, 3, true);


--
-- Data for Name: game; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO game VALUES (1, 'Girotondo', 3, 5, '2011-04-01', 3);
INSERT INTO game VALUES (2, 'Briscola', 14, 3, '2011-01-21', 2);
INSERT INTO game VALUES (3, 'Monopoli', 8, 6, '2011-02-01', 1);
INSERT INTO game VALUES (4, 'Super Mario Bros.', 6, 1, '2011-03-01', 0);
INSERT INTO game VALUES (5, 'Alex Kid', 6, 1, '2011-04-04', 0);
INSERT INTO game VALUES (7, 'Halo', 7, 1, '2011-04-29', 0);
INSERT INTO game VALUES (8, 'Tombola', 20, 2, '2011-04-29', 1);
INSERT INTO game VALUES (6, 'Medal Of Honour', 14, 1, '2011-01-11', 0);
INSERT INTO game VALUES (10, 'Scopa', 17, 2, '2011-04-29', 2);
INSERT INTO game VALUES (11, 'Bunga Bunga', 18, 2, '2011-04-29', 3);
INSERT INTO game VALUES (12, 'Medievil', 8, 1, '2011-04-29', 0);


--
-- Data for Name: hadtried; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO hadtried VALUES (3, 4, 'admin', 10);
INSERT INTO hadtried VALUES (3, 6, 'admin', 7);
INSERT INTO hadtried VALUES (12, 5, 'gg', 9);
INSERT INTO hadtried VALUES (1, 7, 'It''s a great game!', 7);
INSERT INTO hadtried VALUES (3, 1, 'Giro giro tondo...', 6);
INSERT INTO hadtried VALUES (3, 2, 'Mi piace di pi&ugrave; la scopa!', 3);
INSERT INTO hadtried VALUES (3, 3, 'Il funghetto &egrave; fantastico!', 10);
INSERT INTO hadtried VALUES (3, 5, 'Rules! il gioco della mia infanzia!', 10);
INSERT INTO hadtried VALUES (8, 5, '[update by the admin] ahtatatatatauata!', 6);
INSERT INTO hadtried VALUES (2, 3, 'Ho comprato tutto! in faccia ai giudici e al fisco', 10);
INSERT INTO hadtried VALUES (2, 11, 'Modestamente sono un maestro! mi consenta...', 10);
INSERT INTO hadtried VALUES (6, 4, 'Per ovvi motivi mi piace', 10);
INSERT INTO hadtried VALUES (7, 12, 'Tuturutututu', 9);
INSERT INTO hadtried VALUES (7, 6, 'Me l''ha consigliato mio fratello mario, ma non mi piace!', 4);
INSERT INTO hadtried VALUES (8, 1, 'Hokuto non si spreca con certi giochetti da bambini', 1);
INSERT INTO hadtried VALUES (8, 4, 'Tu ormai sei gi&agrave; morto', 5);
INSERT INTO hadtried VALUES (8, 3, 'Se non mi vendi parco della vittoria tra tre secondi morirai.', 3);
INSERT INTO hadtried VALUES (8, 2, 'In un mondo devastato dalla catastrofe nucleare..una partita ci sta sempre!', 9);
INSERT INTO hadtried VALUES (8, 6, 'Aatatatatatatatatata...uattaaa!', 1);
INSERT INTO hadtried VALUES (9, 7, '', 6);
INSERT INTO hadtried VALUES (10, 1, 'Lalalalalalala', 7);
INSERT INTO hadtried VALUES (11, 11, 'Sono bravissima, ma mi ha insegnato tutto silvio!', 10);
INSERT INTO hadtried VALUES (13, 7, 'Batman si mangier&agrave; le mani quando lo vedr&agrave;!', 8);
INSERT INTO hadtried VALUES (14, 3, 'Adrianaa', 8);
INSERT INTO hadtried VALUES (15, 11, 'Belandi', 8);
INSERT INTO hadtried VALUES (17, 8, 'Ehehehhehehehe', 7);
INSERT INTO hadtried VALUES (17, 5, NULL, NULL);
INSERT INTO hadtried VALUES (16, 4, 'Deihihihiohuh', 9);
INSERT INTO hadtried VALUES (16, 8, 'Doh!', 8);


--
-- Data for Name: other; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO other VALUES (1);
INSERT INTO other VALUES (11);


--
-- Data for Name: reference; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO reference VALUES (4, 'DS');
INSERT INTO reference VALUES (4, 'GameBoy');
INSERT INTO reference VALUES (5, 'Master System');
INSERT INTO reference VALUES (7, 'Play Station 3');
INSERT INTO reference VALUES (7, 'XBox 360');
INSERT INTO reference VALUES (6, 'Play Station');
INSERT INTO reference VALUES (6, 'Play Station 2');
INSERT INTO reference VALUES (6, 'Play Station 3');
INSERT INTO reference VALUES (6, 'XBox');
INSERT INTO reference VALUES (6, 'XBox 360');
INSERT INTO reference VALUES (6, 'PC');
INSERT INTO reference VALUES (12, 'Play Station');
INSERT INTO reference VALUES (12, 'PC');
INSERT INTO reference VALUES (12, 'Other');


--
-- Data for Name: stat_game; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO stat_game VALUES (12, 2, 1);
INSERT INTO stat_game VALUES (11, 2, 3);
INSERT INTO stat_game VALUES (3, 2, 4);
INSERT INTO stat_game VALUES (7, 2, 3);
INSERT INTO stat_game VALUES (6, 5, 3);
INSERT INTO stat_game VALUES (10, 2, 0);
INSERT INTO stat_game VALUES (5, 3, 4);
INSERT INTO stat_game VALUES (1, 4, 3);
INSERT INTO stat_game VALUES (8, 1, 2);
INSERT INTO stat_game VALUES (2, 1, 2);
INSERT INTO stat_game VALUES (4, 4, 4);


--
-- Data for Name: stat_game_age; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO stat_game_age VALUES (2, 9, 45);
INSERT INTO stat_game_age VALUES (2, 3, 21);
INSERT INTO stat_game_age VALUES (6, 1, 45);
INSERT INTO stat_game_age VALUES (6, 7, 21);
INSERT INTO stat_game_age VALUES (6, 4, 30);
INSERT INTO stat_game_age VALUES (1, 7, 70);
INSERT INTO stat_game_age VALUES (1, 1, 45);
INSERT INTO stat_game_age VALUES (1, 6, 21);
INSERT INTO stat_game_age VALUES (7, 7, 1);
INSERT INTO stat_game_age VALUES (7, 6, 89);
INSERT INTO stat_game_age VALUES (7, 8, 71);
INSERT INTO stat_game_age VALUES (3, 8, 64);
INSERT INTO stat_game_age VALUES (3, 10, 75);
INSERT INTO stat_game_age VALUES (3, 3, 45);
INSERT INTO stat_game_age VALUES (3, 10, 21);
INSERT INTO stat_game_age VALUES (11, 8, 40);
INSERT INTO stat_game_age VALUES (11, 10, 75);
INSERT INTO stat_game_age VALUES (11, 10, 20);
INSERT INTO stat_game_age VALUES (5, 6, 45);
INSERT INTO stat_game_age VALUES (5, 10, 21);
INSERT INTO stat_game_age VALUES (5, 9, 10);
INSERT INTO stat_game_age VALUES (4, 9, 40);
INSERT INTO stat_game_age VALUES (4, 5, 45);
INSERT INTO stat_game_age VALUES (4, 10, 21);
INSERT INTO stat_game_age VALUES (4, 10, 30);
INSERT INTO stat_game_age VALUES (8, 8, 40);
INSERT INTO stat_game_age VALUES (12, 9, 30);


--
-- Data for Name: stat_game_country; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO stat_game_country VALUES (2, 3, 'SAR');
INSERT INTO stat_game_country VALUES (2, 9, 'XXX');
INSERT INTO stat_game_country VALUES (6, 7, 'SAR');
INSERT INTO stat_game_country VALUES (6, 1, 'XXX');
INSERT INTO stat_game_country VALUES (6, 4, 'CAM');
INSERT INTO stat_game_country VALUES (1, 6, 'SAR');
INSERT INTO stat_game_country VALUES (1, 1, 'XXX');
INSERT INTO stat_game_country VALUES (1, 7, 'VEN');
INSERT INTO stat_game_country VALUES (7, 8, 'SIC');
INSERT INTO stat_game_country VALUES (7, 6, 'FVG');
INSERT INTO stat_game_country VALUES (7, 7, 'VDA');
INSERT INTO stat_game_country VALUES (3, 10, 'SAR');
INSERT INTO stat_game_country VALUES (3, 7, 'XXX');
INSERT INTO stat_game_country VALUES (3, 8, 'CAL');
INSERT INTO stat_game_country VALUES (11, 10, 'PIE');
INSERT INTO stat_game_country VALUES (11, 10, 'XXX');
INSERT INTO stat_game_country VALUES (11, 8, 'LIG');
INSERT INTO stat_game_country VALUES (5, 10, 'SAR');
INSERT INTO stat_game_country VALUES (5, 6, 'XXX');
INSERT INTO stat_game_country VALUES (5, 9, 'TOS');
INSERT INTO stat_game_country VALUES (4, 10, 'SAR');
INSERT INTO stat_game_country VALUES (4, 5, 'XXX');
INSERT INTO stat_game_country VALUES (4, 9, 'PUG');
INSERT INTO stat_game_country VALUES (4, 10, 'CAM');
INSERT INTO stat_game_country VALUES (8, 7, 'ABR');
INSERT INTO stat_game_country VALUES (8, 8, 'PUG');
INSERT INTO stat_game_country VALUES (12, 9, 'CAM');


--
-- Data for Name: stat_game_sex; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO stat_game_sex VALUES (12, 9, 'M');
INSERT INTO stat_game_sex VALUES (2, 6, 'M');
INSERT INTO stat_game_sex VALUES (6, 4, 'M');
INSERT INTO stat_game_sex VALUES (1, 4, 'M');
INSERT INTO stat_game_sex VALUES (1, 7, 'F');
INSERT INTO stat_game_sex VALUES (7, 6, 'F');
INSERT INTO stat_game_sex VALUES (7, 8, 'M');
INSERT INTO stat_game_sex VALUES (3, 8, 'M');
INSERT INTO stat_game_sex VALUES (11, 9, 'M');
INSERT INTO stat_game_sex VALUES (11, 10, 'F');
INSERT INTO stat_game_sex VALUES (5, 8, 'M');
INSERT INTO stat_game_sex VALUES (5, 9, 'F');
INSERT INTO stat_game_sex VALUES (4, 9, 'M');
INSERT INTO stat_game_sex VALUES (8, 8, 'M');


--
-- Data for Name: stat_users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO stat_users VALUES (14, 3, 1);
INSERT INTO stat_users VALUES (15, 2, 1);
INSERT INTO stat_users VALUES (4, 0, 0);
INSERT INTO stat_users VALUES (5, 0, 0);
INSERT INTO stat_users VALUES (17, 4, 2);
INSERT INTO stat_users VALUES (16, 1, 2);
INSERT INTO stat_users VALUES (8, 0, 6);
INSERT INTO stat_users VALUES (12, 0, 1);
INSERT INTO stat_users VALUES (1, 5, 1);
INSERT INTO stat_users VALUES (3, 2, 6);
INSERT INTO stat_users VALUES (2, 4, 2);
INSERT INTO stat_users VALUES (6, 1, 1);
INSERT INTO stat_users VALUES (7, 2, 2);
INSERT INTO stat_users VALUES (9, 1, 1);
INSERT INTO stat_users VALUES (10, 1, 1);
INSERT INTO stat_users VALUES (11, 1, 1);
INSERT INTO stat_users VALUES (13, 1, 1);


--
-- Data for Name: stat_users_avg; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO stat_users_avg VALUES (2, 2);


--
-- Data for Name: tablegame; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tablegame VALUES (3, 4, 120);
INSERT INTO tablegame VALUES (8, 5, 120);


--
-- Data for Name: tag; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO tag VALUES ('sparatutto');
INSERT INTO tag VALUES ('di strategia');
INSERT INTO tag VALUES ('di intelligenza');
INSERT INTO tag VALUES ('di pazienza');
INSERT INTO tag VALUES ('di avventura');
INSERT INTO tag VALUES ('xxx');


--
-- Data for Name: users; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO users VALUES (2, 'berlusconi_s@camera.it', 'password', 'Silvio', 'Berlusconi', 75, 'M', 'XXX', 0);
INSERT INTO users VALUES (3, 'mhl.crr@gmail.com', 'password', 'Michele', 'Corrias', 21, 'M', 'SAR', 2);
INSERT INTO users VALUES (4, 'montanelli@dico.unimi.it', 'password', 'Stefano', 'Montanelli', 30, 'M', 'LOM', 1);
INSERT INTO users VALUES (5, 'ferrara@dico.unimi.it', 'password', 'Alfio', 'Ferrara', 30, 'M', 'LOM', 1);
INSERT INTO users VALUES (6, 'supermariobros@nintendo.org', 'password', 'Mario', 'Mario', 30, 'M', 'CAM', 0);
INSERT INTO users VALUES (8, 'ken.shiro@hokuto.net', 'password', 'Ken', 'Shiro', 45, 'M', 'XXX', 0);
INSERT INTO users VALUES (9, 'margherita.hack@fis.it', 'password', 'Margherita', 'Hack', 89, 'F', 'FVG', 0);
INSERT INTO users VALUES (10, 'biancaneve@settenani.org', 'password', 'Bianca', 'Neve', 70, 'F', 'VEN', 0);
INSERT INTO users VALUES (11, 'ruby@bungabunga.eu', 'password', 'Ruby', 'Rubacuori', 20, 'F', 'PIE', 0);
INSERT INTO users VALUES (12, 'spongebob@mediaset.com', 'password', 'Spongebob', 'Squarepants', 10, 'F', 'TOS', 0);
INSERT INTO users VALUES (13, 'joker@batman.uk', 'password', 'Joker', 'Unknown', 71, 'M', 'SIC', 0);
INSERT INTO users VALUES (14, 'rocky@boxe.it', 'password', 'Rocky', 'Balboa', 64, 'M', 'CAL', 0);
INSERT INTO users VALUES (15, 'gabibbo@mediaset.it', 'password', 'Gabibbo', 'di Striscia', 40, 'M', 'LIG', 0);
INSERT INTO users VALUES (16, 'homer@simpson.us', 'password', 'Homer', 'Simpson', 40, 'M', 'PUG', 0);
INSERT INTO users VALUES (17, 'peter@griffin.us', 'password', 'Peter', 'Griffin', 40, 'M', 'ABR', 0);
INSERT INTO users VALUES (1, 'test@test.com', 'password', 'test', 'tester', 1, 'M', 'VDA', 0);
INSERT INTO users VALUES (7, 'luigibros@nintendo.org', 'password', 'Luigi', 'Mario', 30, 'M', 'CAM', 0);


--
-- Data for Name: videogame; Type: TABLE DATA; Schema: public; Owner: postgres
--

INSERT INTO videogame VALUES (4);
INSERT INTO videogame VALUES (5);
INSERT INTO videogame VALUES (6);
INSERT INTO videogame VALUES (7);
INSERT INTO videogame VALUES (12);


--
-- Name: association_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY association
    ADD CONSTRAINT association_pkey PRIMARY KEY (tid, gid);


--
-- Name: cardgame_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY cardgame
    ADD CONSTRAINT cardgame_pkey PRIMARY KEY (gid);


--
-- Name: console_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY console
    ADD CONSTRAINT console_pkey PRIMARY KEY (name);


--
-- Name: desired_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY desired
    ADD CONSTRAINT desired_pkey PRIMARY KEY (uid, gid);


--
-- Name: expected_card_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY expected_card
    ADD CONSTRAINT expected_card_pkey PRIMARY KEY (type);


--
-- Name: expected_zone_country_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY expected_zone
    ADD CONSTRAINT expected_zone_country_key UNIQUE (country);


--
-- Name: expected_zone_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY expected_zone
    ADD CONSTRAINT expected_zone_pkey PRIMARY KEY (abbr);


--
-- Name: friend_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY friend
    ADD CONSTRAINT friend_pkey PRIMARY KEY (uid_active, uid_asked);


--
-- Name: game_name_type_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY game
    ADD CONSTRAINT game_name_type_key UNIQUE (name, type);


--
-- Name: game_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY game
    ADD CONSTRAINT game_pkey PRIMARY KEY (gid);


--
-- Name: hadtried_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY hadtried
    ADD CONSTRAINT hadtried_pkey PRIMARY KEY (uid, gid);


--
-- Name: other_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY other
    ADD CONSTRAINT other_pkey PRIMARY KEY (gid);


--
-- Name: reference_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY reference
    ADD CONSTRAINT reference_pkey PRIMARY KEY (gid, console);


--
-- Name: stat_game_age_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stat_game_age
    ADD CONSTRAINT stat_game_age_pkey PRIMARY KEY (gid, age);


--
-- Name: stat_game_country_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stat_game_country
    ADD CONSTRAINT stat_game_country_pkey PRIMARY KEY (gid, country);


--
-- Name: stat_game_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stat_game
    ADD CONSTRAINT stat_game_pkey PRIMARY KEY (gid);


--
-- Name: stat_game_sex_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stat_game_sex
    ADD CONSTRAINT stat_game_sex_pkey PRIMARY KEY (gid, sex);


--
-- Name: stat_users_avg_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stat_users_avg
    ADD CONSTRAINT stat_users_avg_pkey PRIMARY KEY (avg_desired, avg_played);


--
-- Name: stat_users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY stat_users
    ADD CONSTRAINT stat_users_pkey PRIMARY KEY (uid);


--
-- Name: tablegame_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tablegame
    ADD CONSTRAINT tablegame_pkey PRIMARY KEY (gid);


--
-- Name: tag_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY tag
    ADD CONSTRAINT tag_pkey PRIMARY KEY (tid);


--
-- Name: users_email_key; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_email_key UNIQUE (email);


--
-- Name: users_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_pkey PRIMARY KEY (uid);


--
-- Name: videogame_pkey; Type: CONSTRAINT; Schema: public; Owner: postgres; Tablespace: 
--

ALTER TABLE ONLY videogame
    ADD CONSTRAINT videogame_pkey PRIMARY KEY (gid);


--
-- Name: consistence_cardgame_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_cardgame_trig BEFORE INSERT OR UPDATE ON cardgame FOR EACH ROW EXECUTE PROCEDURE check_game_type();


--
-- Name: consistence_des_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_des_trig BEFORE INSERT ON desired FOR EACH ROW EXECUTE PROCEDURE desired_or_hadtried();


--
-- Name: consistence_friendship_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_friendship_trig BEFORE INSERT ON friend FOR EACH ROW EXECUTE PROCEDURE check_friendship();


--
-- Name: consistence_game_type_noupd_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_game_type_noupd_trig BEFORE UPDATE OF type ON game FOR EACH ROW EXECUTE PROCEDURE game_type_noupd();


--
-- Name: consistence_othergame_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_othergame_trig BEFORE INSERT OR UPDATE ON other FOR EACH ROW EXECUTE PROCEDURE check_game_type();


--
-- Name: consistence_poss_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_poss_trig BEFORE INSERT ON hadtried FOR EACH ROW EXECUTE PROCEDURE desired_or_hadtried();


--
-- Name: consistence_specdel_card_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_specdel_card_trig BEFORE DELETE ON cardgame FOR EACH ROW EXECUTE PROCEDURE specdel_game();


--
-- Name: consistence_specdel_other_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_specdel_other_trig BEFORE DELETE ON other FOR EACH ROW EXECUTE PROCEDURE specdel_game();


--
-- Name: consistence_specdel_table_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_specdel_table_trig BEFORE DELETE ON tablegame FOR EACH ROW EXECUTE PROCEDURE specdel_game();


--
-- Name: consistence_specdel_video_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_specdel_video_trig BEFORE DELETE ON videogame FOR EACH ROW EXECUTE PROCEDURE specdel_game();


--
-- Name: consistence_tablegame_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_tablegame_trig BEFORE INSERT OR UPDATE ON tablegame FOR EACH ROW EXECUTE PROCEDURE check_game_type();


--
-- Name: consistence_tag_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_tag_trig BEFORE INSERT ON tag FOR EACH ROW EXECUTE PROCEDURE check_tag();


--
-- Name: consistence_videogame_trig; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER consistence_videogame_trig BEFORE INSERT OR UPDATE ON videogame FOR EACH ROW EXECUTE PROCEDURE check_game_type();


--
-- Name: stat_game_age_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_game_age_t AFTER INSERT OR DELETE OR UPDATE OF vote ON hadtried FOR EACH ROW EXECUTE PROCEDURE stat_game_age_update();


--
-- Name: stat_game_age_userupd_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_game_age_userupd_t AFTER UPDATE OF age ON users FOR EACH ROW EXECUTE PROCEDURE stat_game_age_userupdate();


--
-- Name: stat_game_country_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_game_country_t AFTER INSERT OR DELETE OR UPDATE OF vote ON hadtried FOR EACH ROW EXECUTE PROCEDURE stat_game_country_update();


--
-- Name: stat_game_country_userupd_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_game_country_userupd_t AFTER UPDATE OF sex ON users FOR EACH ROW EXECUTE PROCEDURE stat_game_country_userupdate();


--
-- Name: stat_game_des_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_game_des_t AFTER INSERT OR DELETE ON desired FOR EACH ROW EXECUTE PROCEDURE stat_game_update();


--
-- Name: stat_game_insgm_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_game_insgm_t AFTER INSERT ON game FOR EACH ROW EXECUTE PROCEDURE stat_game_update();


--
-- Name: stat_game_poss_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_game_poss_t AFTER INSERT OR DELETE ON hadtried FOR EACH ROW EXECUTE PROCEDURE stat_game_update();


--
-- Name: stat_game_sex_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_game_sex_t AFTER INSERT OR DELETE OR UPDATE OF vote ON hadtried FOR EACH ROW EXECUTE PROCEDURE stat_game_sex_update();


--
-- Name: stat_game_sex_userupd_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_game_sex_userupd_t AFTER UPDATE OF sex ON users FOR EACH ROW EXECUTE PROCEDURE stat_game_sex_userupdate();


--
-- Name: stat_user_avg_des_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_user_avg_des_t AFTER INSERT OR DELETE ON desired FOR EACH ROW EXECUTE PROCEDURE stat_user_avg_update();


--
-- Name: stat_user_avg_poss_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_user_avg_poss_t AFTER INSERT OR DELETE ON hadtried FOR EACH ROW EXECUTE PROCEDURE stat_user_avg_update();


--
-- Name: stat_user_avg_users_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_user_avg_users_t AFTER INSERT OR DELETE ON users FOR EACH ROW EXECUTE PROCEDURE stat_user_avg_update();


--
-- Name: stat_user_des_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_user_des_t AFTER INSERT OR DELETE ON desired FOR EACH ROW EXECUTE PROCEDURE stat_user_update();


--
-- Name: stat_user_poss_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_user_poss_t AFTER INSERT OR DELETE ON hadtried FOR EACH ROW EXECUTE PROCEDURE stat_user_update();


--
-- Name: stat_user_users_t; Type: TRIGGER; Schema: public; Owner: postgres
--

CREATE TRIGGER stat_user_users_t AFTER INSERT ON users FOR EACH ROW EXECUTE PROCEDURE stat_user_update();


--
-- Name: association_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY association
    ADD CONSTRAINT association_gid_fkey FOREIGN KEY (gid) REFERENCES game(gid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: association_tid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY association
    ADD CONSTRAINT association_tid_fkey FOREIGN KEY (tid) REFERENCES tag(tid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: cardgame_deck_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cardgame
    ADD CONSTRAINT cardgame_deck_fkey FOREIGN KEY (deck) REFERENCES expected_card(type);


--
-- Name: cardgame_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY cardgame
    ADD CONSTRAINT cardgame_gid_fkey FOREIGN KEY (gid) REFERENCES game(gid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: desired_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY desired
    ADD CONSTRAINT desired_gid_fkey FOREIGN KEY (gid) REFERENCES game(gid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: desired_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY desired
    ADD CONSTRAINT desired_uid_fkey FOREIGN KEY (uid) REFERENCES users(uid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: friend_uid_active_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY friend
    ADD CONSTRAINT friend_uid_active_fkey FOREIGN KEY (uid_active) REFERENCES users(uid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: friend_uid_asked_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY friend
    ADD CONSTRAINT friend_uid_asked_fkey FOREIGN KEY (uid_asked) REFERENCES users(uid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hadtried_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hadtried
    ADD CONSTRAINT hadtried_gid_fkey FOREIGN KEY (gid) REFERENCES game(gid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: hadtried_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY hadtried
    ADD CONSTRAINT hadtried_uid_fkey FOREIGN KEY (uid) REFERENCES users(uid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: other_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY other
    ADD CONSTRAINT other_gid_fkey FOREIGN KEY (gid) REFERENCES game(gid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reference_console_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY reference
    ADD CONSTRAINT reference_console_fkey FOREIGN KEY (console) REFERENCES console(name) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: reference_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY reference
    ADD CONSTRAINT reference_gid_fkey FOREIGN KEY (gid) REFERENCES game(gid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: stat_game_age_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stat_game_age
    ADD CONSTRAINT stat_game_age_gid_fkey FOREIGN KEY (gid) REFERENCES game(gid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: stat_game_country_country_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stat_game_country
    ADD CONSTRAINT stat_game_country_country_fkey FOREIGN KEY (country) REFERENCES expected_zone(abbr);


--
-- Name: stat_game_country_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stat_game_country
    ADD CONSTRAINT stat_game_country_gid_fkey FOREIGN KEY (gid) REFERENCES game(gid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: stat_game_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stat_game
    ADD CONSTRAINT stat_game_gid_fkey FOREIGN KEY (gid) REFERENCES game(gid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: stat_game_sex_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stat_game_sex
    ADD CONSTRAINT stat_game_sex_gid_fkey FOREIGN KEY (gid) REFERENCES game(gid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: stat_users_uid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY stat_users
    ADD CONSTRAINT stat_users_uid_fkey FOREIGN KEY (uid) REFERENCES users(uid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: tablegame_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY tablegame
    ADD CONSTRAINT tablegame_gid_fkey FOREIGN KEY (gid) REFERENCES game(gid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: users_country_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY users
    ADD CONSTRAINT users_country_fkey FOREIGN KEY (country) REFERENCES expected_zone(abbr);


--
-- Name: videogame_gid_fkey; Type: FK CONSTRAINT; Schema: public; Owner: postgres
--

ALTER TABLE ONLY videogame
    ADD CONSTRAINT videogame_gid_fkey FOREIGN KEY (gid) REFERENCES game(gid) ON UPDATE CASCADE ON DELETE CASCADE;


--
-- Name: public; Type: ACL; Schema: -; Owner: postgres
--

REVOKE ALL ON SCHEMA public FROM PUBLIC;
REVOKE ALL ON SCHEMA public FROM postgres;
GRANT ALL ON SCHEMA public TO postgres;
GRANT ALL ON SCHEMA public TO PUBLIC;


--
-- Name: association; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE association FROM PUBLIC;
REVOKE ALL ON TABLE association FROM postgres;
GRANT ALL ON TABLE association TO postgres;
GRANT SELECT ON TABLE association TO analyst;
GRANT SELECT,INSERT ON TABLE association TO registered;


--
-- Name: game; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE game FROM PUBLIC;
REVOKE ALL ON TABLE game FROM postgres;
GRANT ALL ON TABLE game TO postgres;
GRANT SELECT ON TABLE game TO analyst;
GRANT SELECT,INSERT ON TABLE game TO registered;


--
-- Name: stat_game; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stat_game FROM PUBLIC;
REVOKE ALL ON TABLE stat_game FROM postgres;
GRANT ALL ON TABLE stat_game TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stat_game TO analyst;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stat_game TO registered;


--
-- Name: cardgame; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cardgame FROM PUBLIC;
REVOKE ALL ON TABLE cardgame FROM postgres;
GRANT ALL ON TABLE cardgame TO postgres;
GRANT SELECT ON TABLE cardgame TO analyst;
GRANT SELECT,INSERT ON TABLE cardgame TO registered;


--
-- Name: cardgm; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE cardgm FROM PUBLIC;
REVOKE ALL ON TABLE cardgm FROM postgres;
GRANT ALL ON TABLE cardgm TO postgres;
GRANT SELECT ON TABLE cardgm TO analyst;
GRANT SELECT ON TABLE cardgm TO registered;


--
-- Name: hadtried; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE hadtried FROM PUBLIC;
REVOKE ALL ON TABLE hadtried FROM postgres;
GRANT ALL ON TABLE hadtried TO postgres;
GRANT SELECT ON TABLE hadtried TO analyst;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE hadtried TO registered;


--
-- Name: chartcard; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE chartcard FROM PUBLIC;
REVOKE ALL ON TABLE chartcard FROM postgres;
GRANT ALL ON TABLE chartcard TO postgres;
GRANT SELECT ON TABLE chartcard TO analyst;
GRANT SELECT ON TABLE chartcard TO registered;


--
-- Name: chartother; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE chartother FROM PUBLIC;
REVOKE ALL ON TABLE chartother FROM postgres;
GRANT ALL ON TABLE chartother TO postgres;
GRANT SELECT ON TABLE chartother TO analyst;
GRANT SELECT ON TABLE chartother TO registered;


--
-- Name: charttable; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE charttable FROM PUBLIC;
REVOKE ALL ON TABLE charttable FROM postgres;
GRANT ALL ON TABLE charttable TO postgres;
GRANT SELECT ON TABLE charttable TO analyst;
GRANT SELECT ON TABLE charttable TO registered;


--
-- Name: chartvideo; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE chartvideo FROM PUBLIC;
REVOKE ALL ON TABLE chartvideo FROM postgres;
GRANT ALL ON TABLE chartvideo TO postgres;
GRANT SELECT ON TABLE chartvideo TO analyst;
GRANT SELECT ON TABLE chartvideo TO registered;


--
-- Name: console; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE console FROM PUBLIC;
REVOKE ALL ON TABLE console FROM postgres;
GRANT ALL ON TABLE console TO postgres;
GRANT SELECT ON TABLE console TO analyst;
GRANT SELECT,INSERT ON TABLE console TO registered;


--
-- Name: desired; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE desired FROM PUBLIC;
REVOKE ALL ON TABLE desired FROM postgres;
GRANT ALL ON TABLE desired TO postgres;
GRANT SELECT ON TABLE desired TO analyst;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE desired TO registered;


--
-- Name: desiredgame; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE desiredgame FROM PUBLIC;
REVOKE ALL ON TABLE desiredgame FROM postgres;
GRANT ALL ON TABLE desiredgame TO postgres;
GRANT SELECT ON TABLE desiredgame TO analyst;
GRANT SELECT ON TABLE desiredgame TO registered;


--
-- Name: expected_card; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE expected_card FROM PUBLIC;
REVOKE ALL ON TABLE expected_card FROM postgres;
GRANT ALL ON TABLE expected_card TO postgres;
GRANT SELECT ON TABLE expected_card TO analyst;
GRANT SELECT ON TABLE expected_card TO registered;


--
-- Name: expected_zone; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE expected_zone FROM PUBLIC;
REVOKE ALL ON TABLE expected_zone FROM postgres;
GRANT ALL ON TABLE expected_zone TO postgres;
GRANT SELECT ON TABLE expected_zone TO analyst;
GRANT SELECT ON TABLE expected_zone TO registered;


--
-- Name: friend; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE friend FROM PUBLIC;
REVOKE ALL ON TABLE friend FROM postgres;
GRANT ALL ON TABLE friend TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE friend TO registered;


--
-- Name: friendship; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE friendship FROM PUBLIC;
REVOKE ALL ON TABLE friendship FROM postgres;
GRANT ALL ON TABLE friendship TO postgres;
GRANT SELECT ON TABLE friendship TO registered;


--
-- Name: users; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE users FROM PUBLIC;
REVOKE ALL ON TABLE users FROM postgres;
GRANT ALL ON TABLE users TO postgres;
GRANT SELECT ON TABLE users TO analyst;
GRANT SELECT ON TABLE users TO registered;


--
-- Name: users.passwd; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL(passwd) ON TABLE users FROM PUBLIC;
REVOKE ALL(passwd) ON TABLE users FROM postgres;
GRANT UPDATE(passwd) ON TABLE users TO analyst;
GRANT UPDATE(passwd) ON TABLE users TO registered;


--
-- Name: users.name; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL(name) ON TABLE users FROM PUBLIC;
REVOKE ALL(name) ON TABLE users FROM postgres;
GRANT UPDATE(name) ON TABLE users TO analyst;
GRANT UPDATE(name) ON TABLE users TO registered;


--
-- Name: users.surname; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL(surname) ON TABLE users FROM PUBLIC;
REVOKE ALL(surname) ON TABLE users FROM postgres;
GRANT UPDATE(surname) ON TABLE users TO analyst;
GRANT UPDATE(surname) ON TABLE users TO registered;


--
-- Name: users.age; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL(age) ON TABLE users FROM PUBLIC;
REVOKE ALL(age) ON TABLE users FROM postgres;
GRANT UPDATE(age) ON TABLE users TO analyst;
GRANT UPDATE(age) ON TABLE users TO registered;


--
-- Name: users.sex; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL(sex) ON TABLE users FROM PUBLIC;
REVOKE ALL(sex) ON TABLE users FROM postgres;
GRANT UPDATE(sex) ON TABLE users TO analyst;
GRANT UPDATE(sex) ON TABLE users TO registered;


--
-- Name: users.country; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL(country) ON TABLE users FROM PUBLIC;
REVOKE ALL(country) ON TABLE users FROM postgres;
GRANT UPDATE(country) ON TABLE users TO analyst;
GRANT UPDATE(country) ON TABLE users TO registered;


--
-- Name: friendslist; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE friendslist FROM PUBLIC;
REVOKE ALL ON TABLE friendslist FROM postgres;
GRANT ALL ON TABLE friendslist TO postgres;
GRANT SELECT ON TABLE friendslist TO registered;


--
-- Name: game_gid_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE game_gid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE game_gid_seq FROM postgres;
GRANT ALL ON SEQUENCE game_gid_seq TO postgres;
GRANT USAGE ON SEQUENCE game_gid_seq TO analyst;
GRANT USAGE ON SEQUENCE game_gid_seq TO registered;


--
-- Name: gamestype; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE gamestype FROM PUBLIC;
REVOKE ALL ON TABLE gamestype FROM postgres;
GRANT ALL ON TABLE gamestype TO postgres;
GRANT SELECT ON TABLE gamestype TO analyst;
GRANT SELECT ON TABLE gamestype TO registered;


--
-- Name: hadtriedgame; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE hadtriedgame FROM PUBLIC;
REVOKE ALL ON TABLE hadtriedgame FROM postgres;
GRANT ALL ON TABLE hadtriedgame TO postgres;
GRANT SELECT ON TABLE hadtriedgame TO analyst;
GRANT SELECT ON TABLE hadtriedgame TO registered;


--
-- Name: other; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE other FROM PUBLIC;
REVOKE ALL ON TABLE other FROM postgres;
GRANT ALL ON TABLE other TO postgres;
GRANT SELECT ON TABLE other TO analyst;
GRANT SELECT,INSERT ON TABLE other TO registered;


--
-- Name: othergm; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE othergm FROM PUBLIC;
REVOKE ALL ON TABLE othergm FROM postgres;
GRANT ALL ON TABLE othergm TO postgres;
GRANT SELECT ON TABLE othergm TO analyst;
GRANT SELECT ON TABLE othergm TO registered;


--
-- Name: pendingfriendship; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE pendingfriendship FROM PUBLIC;
REVOKE ALL ON TABLE pendingfriendship FROM postgres;
GRANT ALL ON TABLE pendingfriendship TO postgres;
GRANT SELECT ON TABLE pendingfriendship TO registered;


--
-- Name: profiles; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE profiles FROM PUBLIC;
REVOKE ALL ON TABLE profiles FROM postgres;
GRANT ALL ON TABLE profiles TO postgres;
GRANT SELECT ON TABLE profiles TO analyst;
GRANT SELECT ON TABLE profiles TO registered;


--
-- Name: reference; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE reference FROM PUBLIC;
REVOKE ALL ON TABLE reference FROM postgres;
GRANT ALL ON TABLE reference TO postgres;
GRANT SELECT ON TABLE reference TO analyst;
GRANT SELECT,INSERT ON TABLE reference TO registered;


--
-- Name: stat_game_age; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stat_game_age FROM PUBLIC;
REVOKE ALL ON TABLE stat_game_age FROM postgres;
GRANT ALL ON TABLE stat_game_age TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stat_game_age TO analyst;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stat_game_age TO registered;


--
-- Name: stat_game_country; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stat_game_country FROM PUBLIC;
REVOKE ALL ON TABLE stat_game_country FROM postgres;
GRANT ALL ON TABLE stat_game_country TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stat_game_country TO analyst;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stat_game_country TO registered;


--
-- Name: stat_game_sex; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stat_game_sex FROM PUBLIC;
REVOKE ALL ON TABLE stat_game_sex FROM postgres;
GRANT ALL ON TABLE stat_game_sex TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stat_game_sex TO analyst;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stat_game_sex TO registered;


--
-- Name: stat_users; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stat_users FROM PUBLIC;
REVOKE ALL ON TABLE stat_users FROM postgres;
GRANT ALL ON TABLE stat_users TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stat_users TO analyst;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stat_users TO registered;


--
-- Name: stat_users_avg; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE stat_users_avg FROM PUBLIC;
REVOKE ALL ON TABLE stat_users_avg FROM postgres;
GRANT ALL ON TABLE stat_users_avg TO postgres;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stat_users_avg TO analyst;
GRANT SELECT,INSERT,DELETE,UPDATE ON TABLE stat_users_avg TO registered;


--
-- Name: statdesgames; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE statdesgames FROM PUBLIC;
REVOKE ALL ON TABLE statdesgames FROM postgres;
GRANT ALL ON TABLE statdesgames TO postgres;
GRANT SELECT ON TABLE statdesgames TO analyst;
GRANT SELECT ON TABLE statdesgames TO registered;


--
-- Name: statpossgames; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE statpossgames FROM PUBLIC;
REVOKE ALL ON TABLE statpossgames FROM postgres;
GRANT ALL ON TABLE statpossgames TO postgres;
GRANT SELECT ON TABLE statpossgames TO analyst;
GRANT SELECT ON TABLE statpossgames TO registered;


--
-- Name: statsgameagerefer; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE statsgameagerefer FROM PUBLIC;
REVOKE ALL ON TABLE statsgameagerefer FROM postgres;
GRANT ALL ON TABLE statsgameagerefer TO postgres;
GRANT SELECT ON TABLE statsgameagerefer TO analyst;
GRANT SELECT ON TABLE statsgameagerefer TO registered;


--
-- Name: statsgamecountryrefer; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE statsgamecountryrefer FROM PUBLIC;
REVOKE ALL ON TABLE statsgamecountryrefer FROM postgres;
GRANT ALL ON TABLE statsgamecountryrefer TO postgres;
GRANT SELECT ON TABLE statsgamecountryrefer TO analyst;
GRANT SELECT ON TABLE statsgamecountryrefer TO registered;


--
-- Name: statsgamerefer; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE statsgamerefer FROM PUBLIC;
REVOKE ALL ON TABLE statsgamerefer FROM postgres;
GRANT ALL ON TABLE statsgamerefer TO postgres;
GRANT SELECT ON TABLE statsgamerefer TO analyst;
GRANT SELECT ON TABLE statsgamerefer TO registered;


--
-- Name: statsgamesexrefer; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE statsgamesexrefer FROM PUBLIC;
REVOKE ALL ON TABLE statsgamesexrefer FROM postgres;
GRANT ALL ON TABLE statsgamesexrefer TO postgres;
GRANT SELECT ON TABLE statsgamesexrefer TO analyst;
GRANT SELECT ON TABLE statsgamesexrefer TO registered;


--
-- Name: statsusersrefer; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE statsusersrefer FROM PUBLIC;
REVOKE ALL ON TABLE statsusersrefer FROM postgres;
GRANT ALL ON TABLE statsusersrefer TO postgres;
GRANT SELECT ON TABLE statsusersrefer TO analyst;
GRANT SELECT ON TABLE statsusersrefer TO registered;


--
-- Name: tablegame; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tablegame FROM PUBLIC;
REVOKE ALL ON TABLE tablegame FROM postgres;
GRANT ALL ON TABLE tablegame TO postgres;
GRANT SELECT ON TABLE tablegame TO analyst;
GRANT SELECT,INSERT ON TABLE tablegame TO registered;


--
-- Name: tablegm; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tablegm FROM PUBLIC;
REVOKE ALL ON TABLE tablegm FROM postgres;
GRANT ALL ON TABLE tablegm TO postgres;
GRANT SELECT ON TABLE tablegm TO analyst;
GRANT SELECT ON TABLE tablegm TO registered;


--
-- Name: tag; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE tag FROM PUBLIC;
REVOKE ALL ON TABLE tag FROM postgres;
GRANT ALL ON TABLE tag TO postgres;
GRANT SELECT ON TABLE tag TO analyst;
GRANT SELECT,INSERT ON TABLE tag TO registered;


--
-- Name: userdesired; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE userdesired FROM PUBLIC;
REVOKE ALL ON TABLE userdesired FROM postgres;
GRANT ALL ON TABLE userdesired TO postgres;
GRANT SELECT ON TABLE userdesired TO analyst;
GRANT SELECT ON TABLE userdesired TO registered;


--
-- Name: userhadtried; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE userhadtried FROM PUBLIC;
REVOKE ALL ON TABLE userhadtried FROM postgres;
GRANT ALL ON TABLE userhadtried TO postgres;
GRANT SELECT ON TABLE userhadtried TO analyst;
GRANT SELECT ON TABLE userhadtried TO registered;


--
-- Name: users_uid_seq; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON SEQUENCE users_uid_seq FROM PUBLIC;
REVOKE ALL ON SEQUENCE users_uid_seq FROM postgres;
GRANT ALL ON SEQUENCE users_uid_seq TO postgres;
GRANT USAGE ON SEQUENCE users_uid_seq TO analyst;
GRANT USAGE ON SEQUENCE users_uid_seq TO registered;


--
-- Name: videogame; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE videogame FROM PUBLIC;
REVOKE ALL ON TABLE videogame FROM postgres;
GRANT ALL ON TABLE videogame TO postgres;
GRANT SELECT ON TABLE videogame TO analyst;
GRANT SELECT,INSERT ON TABLE videogame TO registered;


--
-- Name: videogm; Type: ACL; Schema: public; Owner: postgres
--

REVOKE ALL ON TABLE videogm FROM PUBLIC;
REVOKE ALL ON TABLE videogm FROM postgres;
GRANT ALL ON TABLE videogm TO postgres;
GRANT SELECT ON TABLE videogm TO analyst;
GRANT SELECT ON TABLE videogm TO registered;


--
-- PostgreSQL database dump complete
--

