/* Privilegi totali all'amministratore */
GRANT ALL PRIVILEGES ON DATABASE giogu TO admin WITH GRANT OPTION;

/* Privilegi dell'utente analista, inerenti solo alle tabelle sulle statistiche (inutile la gestione amicizie) */
GRANT SELECT, UPDATE(passwd,name,surname,age,sex,country) ON TABLE Users TO analyst;
GRANT SELECT ON TABLE Game, Videogame, Tablegame, Cardgame, Other TO analyst;
GRANT SELECT ON TABLE Console, Reference TO analyst;
GRANT SELECT ON TABLE Desired, HadTried TO analyst;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Stat_Users, Stat_Users_Avg, Stat_Game, Stat_Game_Age, Stat_Game_Sex, Stat_Game_Country TO analyst;
GRANT SELECT ON TABLE Tag, Association TO analyst;
GRANT SELECT ON TABLE Expected_Zone, Expected_Card TO analyst;
GRANT USAGE ON SEQUENCE game_gid_seq, users_uid_seq TO analyst;
GRANT SELECT ON TABLE Profiles, DesiredGame, HadTriedGame, UserDesired, UserHadTried, GamesType, Videogm, Tablegm, Cardgm, Othergm, ChartVideo, ChartTable, ChartCard, ChartOther, StatDesGames, StatPossGames, StatsUsersRefer, StatsGameRefer, StatsGameSexRefer, StatsGameAgeRefer, StatsGameCountryRefer TO analyst;

/* Privilegi dell'utente normale */
GRANT SELECT, UPDATE(passwd,name,surname,age,sex,country) ON TABLE Users TO registered;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Friend TO registered;
GRANT SELECT, INSERT ON TABLE Game, Videogame, Tablegame, Cardgame, Other TO registered;
GRANT SELECT, INSERT ON TABLE Console, Reference TO registered;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Desired, HadTried TO registered;
GRANT SELECT, INSERT ON TABLE Tag, Association TO registered;
GRANT SELECT ON TABLE Expected_Zone, Expected_Card TO registered;
GRANT SELECT, INSERT, UPDATE, DELETE ON TABLE Stat_Users, Stat_Users_Avg, Stat_Game, Stat_Game_Age, Stat_Game_Sex, Stat_Game_Country TO registered;
GRANT USAGE ON SEQUENCE game_gid_seq, users_uid_seq TO registered;
GRANT SELECT ON TABLE Profiles, DesiredGame, HadTriedGame, UserDesired, UserHadTried, Friendship, PendingFriendship, FriendsList, GamesType, Videogm, Tablegm, Cardgm, Othergm, ChartVideo, ChartTable, ChartCard, ChartOther, StatDesGames, StatPossGames, StatsUsersRefer, StatsGameRefer, StatsGameSexRefer, StatsGameAgeRefer, StatsGameCountryRefer TO registered;

