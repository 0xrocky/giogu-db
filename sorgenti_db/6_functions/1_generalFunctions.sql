-- funziona che conta i giochi desiderati di uid_in
CREATE OR REPLACE FUNCTION count_game_des(uid_in integer) RETURNS integer AS $$
	DECLARE	a integer;
	BEGIN
		SELECT COUNT(gid) INTO a FROM Desired WHERE uid=uid_in;
	RETURN a;
	END;
$$ LANGUAGE plpgsql;

-- funziona che conta i giochi posseduti/provati di uid_in
CREATE OR REPLACE FUNCTION count_game_poss(uid_in integer) RETURNS integer AS $$
	DECLARE	a integer;
	BEGIN
		SELECT COUNT(gid) INTO a FROM HadTried WHERE uid=uid_in;
	RETURN a;
	END;
$$ LANGUAGE plpgsql;

-- funziona che conta gli utenti che desiderano il gioco gid_in
CREATE OR REPLACE FUNCTION count_user_des(gid_in integer) RETURNS integer AS $$
	DECLARE	a integer;
	BEGIN
		SELECT COUNT(uid) INTO a FROM Desired WHERE gid=gid_in;
	RETURN a;
	END;
$$ LANGUAGE plpgsql;

-- funziona che conta gli utenti che posseggono il gioco gid_in
CREATE OR REPLACE FUNCTION count_user_poss(gid_in integer) RETURNS integer AS $$
	DECLARE	a integer;
	BEGIN
		SELECT COUNT(uid) INTO a FROM HadTried WHERE gid=gid_in;
	RETURN a;
	END;
$$ LANGUAGE plpgsql;
