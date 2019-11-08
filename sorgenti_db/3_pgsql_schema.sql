/* RELAZIONALE

   Users(uid, email, passwd, name, surname, age, sex, country, type(registered, analyst, admin))
   Friend(uid_active, uid_asked, accepted)
   Game(gid, name, sugg_age, n_player, add_date, type)
   Desired(uid, gid)
   HadTried(uid, gid, review*, vote*)
   Tag(tid)
   Association(tid, gid)
   VideoGame(gid)
   TableGame(gid, sugg_num*, duration*)
   CardGame(gid, deck*)
   Other(gid)
   Console(name, mark)
   Reference(gid, console)
   
   Tabelle di Supporto:
   Expected_Zone(abbr, country)
   Expected_Card(type)
   Stat_Users(uid, n_desired, n_played)
   Stat_Users_Avg(avg_desired, avg_played)
   Stat_Game(gid, n_desiring,n_playing)
   Stat_Game_Age(gid, avg_vote, age)
   Stat_Game_Sex(gid, avg_vote, sex)
   Stat_Game_Country(gid, avg_vote, country)

*/ 
CREATE TABLE Expected_Zone(
	abbr Initials PRIMARY KEY,
	country varchar(25) UNIQUE NOT NULL
);

CREATE TABLE Users(
	uid SERIAL PRIMARY KEY,
	email varchar(40) UNIQUE NOT NULL, 
	passwd varchar(25) NOT NULL,
	name varchar(20) NOT NULL, 
	surname varchar(20) NOT NULL, 
	age smallint NOT NULL CHECK (age > 0),
	sex Gender NOT NULL,
	country Initials NOT NULL REFERENCES Expected_Zone(abbr),
	type smallint NOT NULL CHECK (type IN (0,1,2)) /* 0=registered, 1=analyst, 2=admin */
);

CREATE TABLE Friend(
	uid_active integer REFERENCES Users(uid) ON UPDATE CASCADE ON DELETE CASCADE,
	uid_asked integer REFERENCES Users(uid) ON UPDATE CASCADE ON DELETE CASCADE,
	accepted boolean NOT NULL DEFAULT FALSE,
	CONSTRAINT self_friendship CHECK (uid_active <> uid_asked),
	PRIMARY KEY (uid_active,uid_asked)
);

CREATE TABLE Game(
	gid SERIAL PRIMARY KEY,
	name varchar(30) NOT NULL,
	sugg_age smallint NOT NULL CHECK (sugg_age > 0),
	n_player smallint NOT NULL default 1 CHECK (n_player > 0),
	add_date date NOT NULL DEFAULT CURRENT_DATE,
	type smallint NOT NULL CHECK (type IN (0,1,2,3)), /* 0=videogame, 1=tablegame, 2=cardgame , 3=other */
	UNIQUE (name,type)
);

CREATE TABLE Desired(
	uid integer REFERENCES Users(uid) ON UPDATE CASCADE ON DELETE CASCADE,
	gid integer REFERENCES Game(gid) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (uid,gid)
);

CREATE TABLE HadTried(
	uid integer REFERENCES Users(uid) ON UPDATE CASCADE ON DELETE CASCADE,
	gid integer REFERENCES Game(gid) ON UPDATE CASCADE ON DELETE CASCADE,
	review varchar(100),
	vote smallint CHECK (vote = NULL OR (vote > 0 AND vote <= 10)),
	PRIMARY KEY (uid,gid)
);

CREATE TABLE Tag(
	tid varchar(20) PRIMARY KEY
);

CREATE TABLE Association(
	tid varchar(20) REFERENCES Tag(tid) ON UPDATE CASCADE ON DELETE CASCADE,
	gid integer REFERENCES Game(gid) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY (tid,gid)
);

CREATE TABLE VideoGame(
	gid integer PRIMARY KEY REFERENCES Game(gid) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE TableGame(
	gid integer PRIMARY KEY REFERENCES Game(gid) ON UPDATE CASCADE ON DELETE CASCADE,
	sugg_num smallint default 2 CHECK (sugg_num > 0),
	duration smallint
);

CREATE TABLE Expected_Card(
	type TypeDeck PRIMARY KEY
);

CREATE TABLE CardGame(
	gid integer PRIMARY KEY REFERENCES Game(gid) ON UPDATE CASCADE ON DELETE CASCADE,
	deck TypeDeck NOT NULL REFERENCES Expected_Card(type)
);

CREATE TABLE Other(
	gid integer PRIMARY KEY REFERENCES Game(gid) ON UPDATE CASCADE ON DELETE CASCADE
);

CREATE TABLE Console(
	mark Console_mark NOT NULL,
	name Console_model PRIMARY KEY,
	CHECK ( (mark='Sony' AND name IN ('Play Station','Play Station 2','Play Station 3','PSP')) OR (mark='Microsoft' AND name IN ('XBox','XBox 360')) OR (mark='Nintendo' AND name IN ('Wii','GameBoy','DS')) OR (mark='Sega' AND name IN ('Master System','Mega Drive')) OR (mark='Other' AND name IN ('PC','Other')) )
);

CREATE TABLE Reference(
	gid integer REFERENCES Game(gid) ON UPDATE CASCADE ON DELETE CASCADE,
	console Console_model REFERENCES Console(name) ON UPDATE CASCADE ON DELETE CASCADE,
	PRIMARY KEY(gid, console)
);

CREATE TABLE Stat_Users(
	uid integer PRIMARY KEY REFERENCES Users(uid) ON UPDATE CASCADE ON DELETE CASCADE,
	n_desired integer NOT NULL CHECK (n_desired >= 0),
	n_played integer NOT NULL CHECK (n_played >= 0)
);

CREATE TABLE Stat_Users_Avg(
	avg_desired smallint CHECK (avg_desired >= 0 AND avg_desired <= 10),
	avg_played smallint CHECK (avg_played >= 0 AND avg_played <= 10),
	PRIMARY KEY(avg_desired,avg_played)
);

CREATE TABLE Stat_Game(
	gid integer PRIMARY KEY REFERENCES Game(gid) ON UPDATE CASCADE ON DELETE CASCADE,
	n_desiring integer NOT NULL CHECK (n_desiring >= 0),
	n_playing integer NOT NULL CHECK (n_playing >= 0)
);

CREATE TABLE Stat_Game_Age(
	gid integer REFERENCES Game(gid) ON UPDATE CASCADE ON DELETE CASCADE,
	avg_vote smallint NOT NULL CHECK (avg_vote >= 0 AND avg_vote <= 10),
	age smallint CHECK (age > 0),
	PRIMARY KEY(gid,age)
);

CREATE TABLE Stat_Game_Sex(
	gid integer REFERENCES Game(gid) ON UPDATE CASCADE ON DELETE CASCADE,
	avg_vote smallint NOT NULL CHECK (avg_vote >= 0 AND avg_vote <= 10),
	sex Gender,
	PRIMARY KEY(gid,sex)
);

CREATE TABLE Stat_Game_Country(
	gid integer REFERENCES Game(gid) ON UPDATE CASCADE ON DELETE CASCADE,
	avg_vote smallint NOT NULL CHECK (avg_vote >= 0 AND avg_vote <= 10),
	country Initials REFERENCES Expected_Zone(abbr),
	PRIMARY KEY(gid,country)
);
