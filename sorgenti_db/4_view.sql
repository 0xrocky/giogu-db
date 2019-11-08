/* View of Profiles # used in profile_user.inc.php */
CREATE VIEW Profiles AS
	SELECT uid, email, name, surname, age, sex, Expected_Zone.country
	FROM Users INNER JOIN Expected_Zone ON Users.country=Expected_Zone.abbr;
	
/* View of wished games # used in profile_user.inc.php, profile_game.php */
CREATE VIEW DesiredGame AS
	SELECT gid, Game.name AS game, type, uid
	FROM Game NATURAL JOIN Desired;
	
/* View of wished games # used in profile_user.inc.php, profile_game.php */
CREATE VIEW HadTriedGame AS
	SELECT gid, Game.name AS game, type, review, vote, uid
	FROM Game NATURAL JOIN HadTried;

/* View of wished games from a specific user # used in search_user.php */
CREATE VIEW UserDesired AS
	SELECT Users.uid, Users.name, Users.surname, Game.gid, Game.name AS game
	FROM Users INNER JOIN Desired ON Users.uid=Desired.uid INNER JOIN Game ON Desired.gid=Game.gid;

/* View of possessed or tried games from a specific user # used in search_user.php */
CREATE VIEW UserHadTried AS
	SELECT Users.uid, Users.name, Users.surname, Game.gid, Game.name AS game
	FROM Users INNER JOIN HadTried ON Users.uid=HadTried.uid INNER JOIN Game ON HadTried.gid=Game.gid;
	
/* Sure Friend # used in profile_user.inc.php */	
CREATE VIEW Friendship AS
	SELECT uid_active, uid_asked
	FROM Friend
	WHERE accepted=TRUE;
	
/* Pending request of Friendship # used in profile_user.inc.php */
CREATE VIEW PendingFriendship AS
	SELECT name, surname, uid_active, uid_asked
	FROM Users INNER JOIN Friend ON uid=uid_active
	WHERE accepted=FALSE;
	
/* Composing the list of Friend # used in profile_user.inc.php */
CREATE VIEW FriendsList AS
	SELECT X.name AS name_active, X.surname AS surname_active, Y.name AS name_asked, Y.surname AS surname_asked, uid_active, uid_asked
	FROM Users AS X, Users AS Y, Friendship
	WHERE X.uid=uid_active AND Y.uid=uid_asked;
	
/* View that, given a name, associates its ID and Type # used in search_game.php, tag.php */
CREATE VIEW GamesType AS
	SELECT gid, name AS game, type
	FROM Game;

/* View of Videogames # used in profile_game.php */
CREATE VIEW Videogm AS
	SELECT gid, Game.name AS game, sugg_age, n_player, mark, Console.name AS console
	FROM Game NATURAL JOIN VideoGame NATURAL JOIN Reference INNER JOIN Console ON Reference.console=Console.name;
	
/* View of Tablegames # used in profile_game.php */
CREATE VIEW Tablegm AS
	SELECT gid, Game.name AS game, sugg_age, n_player, sugg_num, duration 
	FROM Game NATURAL JOIN TableGame;
	
/* View of Cardgames # used in profile_game.php */
CREATE VIEW Cardgm AS
	SELECT gid, Game.name AS game, sugg_age, n_player, deck
	FROM Game NATURAL JOIN CardGame;
	
/* View of Other games # used in profile_game.php */
CREATE VIEW Othergm AS
	SELECT gid, Game.name AS game, sugg_age, n_player
	FROM Game NATURAL JOIN Other;

/* View of dinamic rankings of first videogames # used in charts.inc.php */
CREATE VIEW ChartVideo AS
	SELECT gid,name AS game,ROUND(AVG(vote),2) AS avgvote
	FROM Game NATURAL JOIN HadTried
	WHERE type=0 AND vote IS NOT NULL
	GROUP BY gid, name
	ORDER BY avgvote DESC;
	
/* View of dinamic rankings of first tablegames # used in charts.inc.php */
CREATE VIEW ChartTable AS
	SELECT gid,name AS game,ROUND(AVG(vote),2) AS avgvote
	FROM Game NATURAL JOIN HadTried
	WHERE type=1 AND vote IS NOT NULL
	GROUP BY gid, name
	ORDER BY avgvote DESC;

/* View of dinamic rankings of first cardgames # used in charts.inc.php */
CREATE VIEW ChartCard AS
	SELECT gid,name AS game,ROUND(AVG(vote),2) AS avgvote
	FROM Game NATURAL JOIN HadTried
	WHERE type=2 AND vote IS NOT NULL
	GROUP BY gid, name
	ORDER BY avgvote DESC;
	
/* View of dinamic rankings of first other games # used in charts.inc.php */
CREATE VIEW ChartOther AS
	SELECT gid,name AS game,ROUND(AVG(vote),2) AS avgvote
	FROM Game NATURAL JOIN HadTried
	WHERE type=3 AND vote IS NOT NULL
	GROUP BY gid, name
	ORDER BY avgvote DESC;
	
-- @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ Views specific for analysts and admins @@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@@ --
	
/* View of games not referenced from almost 3 people more than 5 days # used in autodelete.php */
CREATE VIEW Autodelete AS
	SELECT gid
	FROM Stat_Game NATURAL JOIN Game
	WHERE (n_desiring+n_playing)<3 AND CURRENT_DATE-add_date>5;
	
/* View of number of games desired for each user, serves for the average # used in 3_stat_user.sql */
CREATE VIEW StatDesGames AS
	SELECT COUNT(gid) AS num
	FROM Desired
	GROUP BY uid;
	
/* View of number of games had/tried for each user, serves for the average # used in 3_stat_user.sql */
CREATE VIEW StatPossGames AS
	SELECT COUNT(gid) AS num
	FROM HadTried
	GROUP BY uid;
	
/* View of stats_users # used in stat_user.inc.php */
CREATE VIEW StatsUsersRefer AS
	SELECT name, surname, n_desired, n_played 
	FROM Users NATURAL JOIN Stat_Users;
	
/* View of stats_games # used in stat_game.inc.php */
CREATE VIEW StatsGameRefer AS
	SELECT gid, name, type, n_desiring, n_playing
	FROM Game NATURAL JOIN Stat_Game;
	
/* View of stats_games_sex # used in stat_game.inc.php */
CREATE VIEW StatsGameSexRefer AS
	SELECT gid, name, type, sex, avg_vote
	FROM Game NATURAL JOIN Stat_Game_Sex;
	
/* View of stats_games_age # used in stat_game.inc.php */
CREATE VIEW StatsGameAgeRefer AS
	SELECT gid, name, type, age, avg_vote
	FROM Game NATURAL JOIN Stat_Game_Age;	
	
/* View of stats_games_country # used in stat_game.inc.php */
CREATE VIEW StatsGameCountryRefer AS
	SELECT gid, name, type, Expected_Zone.country, avg_vote
	FROM Game NATURAL JOIN Stat_Game_Country INNER JOIN Expected_Zone ON Stat_Game_Country.country=Expected_Zone.abbr;
