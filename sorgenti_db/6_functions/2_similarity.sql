CREATE OR REPLACE FUNCTION similarity_calculate(uid_a integer, uid_b integer) RETURNS integer AS $$
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
$$ LANGUAGE plpgsql;

CREATE OR REPLACE FUNCTION similarity(uid_in integer) RETURNS SETOF RECORD AS $$
	BEGIN
	  	RETURN QUERY SELECT uid, name, surname, similarity_calculate(uid,uid_in) AS similarity FROM Users WHERE uid<>1 AND uid<>uid_in;
	RETURN; 
	END;
$$ LANGUAGE plpgsql;
