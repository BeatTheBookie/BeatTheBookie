

/************************************************
	Raw data vault tables for historic data 
	of football
	
v1.0:
	- initial state for tables
		- football_team_h
		- football_division_h
		- football_match_his_l
		- football_match_his_l_s_statistic

*************************************************/


--drop Link for Match-History
drop table raw_dv.football_match_his_l_s_statistic;
drop table raw_dv.football_match_his_l_s_odds;
drop table raw_dv.football_match_his_l;

--drop link for team division connections
drop table raw_dv.football_team_division_l;

--hub for divisions
drop table raw_dv.football_division_h;
--drop table raw_dv.football_division_h_s;
	--> manuell später

--hub for teams
drop table raw_dv.football_team_h;
--drop table raw_dv.football_team_h_s;
	--> manuell später

--hub for season
drop table raw_dv.football_season_h;
--drop table raw_dv.football_season_h_s;
	--> manuell später
	
--Hub for divisions
create table raw_dv.football_division_h
	(
	football_division_hid	char(32),
	division				varchar(5),
	country					varchar(5),	
	audit_insert_date		timestamp,
	audit_record_source		varchar(100),
	constraint pk_football_division_h primary key (football_division_hid) disable,
	distribute by football_division_hid
	);

comment on table raw_dv.football_division_h 							is 'Hub-table for football divisions';
comment on column raw_dv.football_division_h.football_division_hid 	is 'Hash-key for hub football divisions';
comment on column raw_dv.football_division_h.division 					is 'Division code';
comment on column raw_dv.football_division_h.country 					is 'Country code';

--Hub for teams
create table raw_dv.football_team_h
	(
	football_team_hid	char(32),
	team				varchar(50),
	audit_insert_date	timestamp,
	audit_record_source	varchar(100),
	constraint pk_football_team_h primary key (football_team_hid) disable,
	distribute by football_team_hid
	);

comment on table raw_dv.football_team_h 								is 'Hub table for football teams';
comment on column raw_dv.football_team_h.football_team_hid 				is 'hash key for hub football teams';
comment on column raw_dv.football_team_h.team	 						is 'team code';

--hub for seasons
create table raw_dv.football_season_h
	(
	football_season_hid	char(32),
	season				varchar(10),
	audit_insert_date	timestamp,
	audit_record_source	varchar(100),
	constraint pk_football_season_h primary key (football_season_hid) disable,
	distribute by football_season_hid
	);
	
comment on table raw_dv.football_season_h 								is 'Hub table for football seasons';
comment on column raw_dv.football_season_h.football_season_hid 			is 'hash key for hub football seasons';
comment on column raw_dv.football_season_h.season 						is 'season code';

--Link for team division connections
create table raw_dv.football_team_division_l
	(
	football_team_division_lid	char(32),
	football_season_hid			char(32),
	football_division_hid		char(32),
	football_team_hid			char(32),
	audit_insert_date			timestamp,
	audit_record_source			varchar(100),
	constraint pk_football_team_division_l primary key (football_team_division_lid) disable,
	constraint fk_football_team_division_l_football_season_h foreign key (football_season_hid) references raw_dv.football_season_h (football_season_hid) disable,
	constraint fk_football_team_division_l_football_division_h foreign key (football_division_hid) references raw_dv.football_division_h (football_division_hid) disable,
	constraint fk_football_team_division_l_football_team_h	foreign key (football_team_hid) references raw_dv.football_team_h (football_team_hid) disable,
	distribute by football_team_division_lid
	);

comment on table raw_dv.football_team_division_l								is 'Link table for data which team plays during which season in which division';
comment on column raw_dv.football_team_division_l.football_team_division_lid 	is 'hash key for division team connection';
comment on column raw_dv.football_team_division_l.football_division_hid			is 'foreign key to division hub';
comment on column raw_dv.football_team_division_l.football_season_hid			is 'foreign key to season hub for season';
comment on column raw_dv.football_team_division_l.football_team_hid				is 'foreign key to team hub for team';

--Link for football match history
create table raw_dv.football_match_his_l
	(
	football_match_his_lid	char(32),
	football_division_hid	char(32),
	football_team_home_hid	char(32),
	football_team_away_hid	char(32),
	football_season_hid		char(32),
	match_date				date,
	audit_insert_date		timestamp,
	audit_record_source		varchar(100),
	constraint pk_football_match_his_l primary key (football_match_his_lid) disable,
	constraint fk_football_match_his_l_football_division_h foreign key (football_division_hid) references raw_dv.football_division_h (football_division_hid) disable,
	constraint fk_football_match_his_l_football_team_home_h	foreign key (football_team_home_hid) references raw_dv.football_team_h (football_team_hid) disable,
	constraint fk_football_match_his_l_football_team_away_h	foreign key (football_team_away_hid) references raw_dv.football_team_h (football_team_hid) disable,
	constraint fk_football_match_his_l_football_team_season_h foreign key (football_season_hid) references raw_dv.football_season_h (football_season_hid) disable,
	distribute by football_match_his_lid
	);

comment on table raw_dv.football_match_his_l							is 'Link table for historic football matches';
comment on column raw_dv.football_match_his_l.football_match_his_lid 	is 'hash key for historic football match';
comment on column raw_dv.football_match_his_l.football_division_hid		is 'foreign key to division hub';
comment on column raw_dv.football_match_his_l.football_team_home_hid	is 'foreign key to team hub for home team';
comment on column raw_dv.football_match_his_l.football_team_away_hid	is 'foreign key to team hub for away team';
comment on column raw_dv.football_match_his_l.football_season_hid		is 'foreign key to season hub';
comment on column raw_dv.football_match_his_l.match_date				is 'match date';

--Link satellite for historic match statistic
create table raw_dv.football_match_his_l_s_statistic
	(
	football_match_his_lid 		char(32),
	load_dts					timestamp,
	FULL_TIME_HOME_GOALS		decimal(3),
	FULL_TIME_AWAY_GOALS		decimal(3),
	FULL_TIME_RESULT			varchar(1),
	HALF_TIME_HOME_GOALS		decimal(3),
	HALF_TIME_AWAY_GOALS		decimal(3),
	HALF_TIME_RESULT			varchar(1),
	HOME_SHOTS					decimal(3),
	AWAY_SHOTS					decimal(3),
	HOME_SHOTS_TARGET			decimal(3),
	AWAY_SHOTS_TARGET			decimal(3),
	HOME_FOULS					decimal(3),
	AWAY_FOULS					decimal(3),
	HOME_CORNERS				decimal(3),
	AWAY_CORNERS				decimal(3),
	HOME_YELLOW					decimal(3),
	AWAY_YELLOW					decimal(3),
	HOME_RED					decimal(3),
	AWAY_RED					decimal(3),
	audit_insert_date	timestamp,
	audit_record_source	varchar(100),
	constraint pk_football_match_his_l_s_statistic primary key (football_match_his_lid, load_dts) disable,
	constraint fk_football_match_his_l_s_statistic foreign key (football_match_his_lid) references raw_dv.football_match_his_l (football_match_his_lid) disable,
	distribute by football_match_his_lid
	);
	
comment on table raw_dv.football_match_his_l_s_statistic 							is 'satellite with historic football match statistic';
comment on column raw_dv.football_match_his_l_s_statistic.football_match_his_lid 	is 'foreign key to historic football match link';
comment on column raw_dv.football_match_his_l_s_statistic.FULL_TIME_HOME_GOALS		is 'number of goals of home team at full time';
comment on column raw_dv.football_match_his_l_s_statistic.FULL_TIME_AWAY_GOALS		is 'number of goals of away team at full time';
comment on column raw_dv.football_match_his_l_s_statistic.FULL_TIME_RESULT			is 'result at full time: H-Home win; D-Draa; A-Away win';
comment on column raw_dv.football_match_his_l_s_statistic.HALF_TIME_HOME_GOALS		is 'number of goals of home team at half time';
comment on column raw_dv.football_match_his_l_s_statistic.HALF_TIME_AWAY_GOALS		is 'number of goals of away team at half time';
comment on column raw_dv.football_match_his_l_s_statistic.HALF_TIME_RESULT			is 'result at half time: H-Home win; D-Draa; A-Away win';
comment on column raw_dv.football_match_his_l_s_statistic.HOME_SHOTS				is 'number of shots of home team';
comment on column raw_dv.football_match_his_l_s_statistic.AWAY_SHOTS				is 'number of shots of away team';
comment on column raw_dv.football_match_his_l_s_statistic.HOME_SHOTS_TARGET			is 'number of shots on target of home team';
comment on column raw_dv.football_match_his_l_s_statistic.AWAY_SHOTS_TARGET			is 'number of shots on target of away team';
comment on column raw_dv.football_match_his_l_s_statistic.HOME_FOULS				is 'number of fouls commited by home team';
comment on column raw_dv.football_match_his_l_s_statistic.AWAY_FOULS				is 'number of fouls commited by away team';
comment on column raw_dv.football_match_his_l_s_statistic.HOME_CORNERS				is 'number of corners for home team';
comment on column raw_dv.football_match_his_l_s_statistic.AWAY_CORNERS				is 'number of corners for away team';
comment on column raw_dv.football_match_his_l_s_statistic.HOME_YELLOW				is 'number of yellow cards for home team';
comment on column raw_dv.football_match_his_l_s_statistic.AWAY_YELLOW				is 'number of yellow cards for away team';
comment on column raw_dv.football_match_his_l_s_statistic.HOME_RED					is 'number of red cards for home team';
comment on column raw_dv.football_match_his_l_s_statistic.AWAY_RED					is 'number of red cards for away team';


--Link satellite for historic match odds
create table raw_dv.football_match_his_l_s_odds
	(
	football_match_his_lid 		char(32),
	load_dts					timestamp,
	BET365_HOME_ODDS			decimal(6,3),
	BET365_DRAW_ODDS			decimal(6,3),
	BET365_AWAY_ODDS			decimal(6,3),
	BLUE_SQUARE_HOME_ODDS		decimal(6,3),
	BLUE_SQUARE_DRAW_ODDS		decimal(6,3),
	BLUE_SQUARE_AWAY_ODDS		decimal(6,3),
	BET_WIN_HOME_ODDS			decimal(6,3),
	BET_WIN_DRAW_ODDS			decimal(6,3),
	BET_WIN_AWAY_ODDS			decimal(6,3),
	INTERWETTEN_HOME_ODDS		decimal(6,3),
	INTERWETTEN_DRAW_ODDS		decimal(6,3),
	INTERWETTEN_AWAY_ODDS		decimal(6,3),
	GAMEBOOKERS_HOME_ODDS		decimal(6,3),
	GAMEBOOKERS_DRAW_ODDS		decimal(6,3),
	GAMEBOOKERS_AWAY_ODDS		decimal(6,3),
	LADBROKES_HOME_ODDS			decimal(6,3),
	LADBROKES_DRAW_ODDS			decimal(6,3),
	LADBROKES_AWAY_ODDS			decimal(6,3),
	PINACLE_HOME_ODDS			decimal(6,3),
	PINACLE_DRAW_ODDS			decimal(6,3),
	PINALCE_AWAY_ODDS			decimal(6,3),
	WILLIAM_HILL_HOME_ODDS		decimal(6,3),
	WILLIAM_HILL_DRAW_ODDS		decimal(6,3),
	WILLIAM_HILL_AWAY_ODDS		decimal(6,3),
	SPORTING_BET_HOME_ODDS		decimal(6,3),
	SPORTING_BET_DRAW_ODDS		decimal(6,3),
	SPORTING_BET_AWAY_ODDS		decimal(6,3),
	VC_BET_HOME_ODDS			decimal(6,3),
	VC_BET_DRAW_ODDS			decimal(6,3),
	VC_BET_AWAY_ODDS			decimal(6,3),
	STAN_JAMES_HOME_ODDS		decimal(6,3),
	STAN_JAMES_DRAW_ODDS		decimal(6,3),
	STAN_JAMES_AWAY_ODDS		decimal(6,3),
	BETBRAIN_NUM_1X2			decimal(3),
	BETBRAIN_MAX_HOME_ODDS		decimal(6,3),
	BETBRAIN_AVG_HOME_ODDS		decimal(6,3),
	BETBRAIN_MAX_DRAW_ODDS		decimal(6,3),
	BETBREIN_AVG_DRAW_ODDS		decimal(6,3),
	BETBRAIN_MAX_AWAY_ODDS		decimal(6,3),
	BETBRAIN_AVG_AWAY_ODDS		decimal(6,3),
	BETBRAIN_NUM_OU				decimal(3),
	BETBRAIN_MAX_O25			decimal(6,3),
	BETBRAIN_AVG_O25			decimal(6,3),
	BETBRAIN_MAX_U25			decimal(6,3),
	BETBRAIN_AVG_U25			decimal(6,3),
	BETBRAIN_NUM_ASIAN_H		decimal(3),
	BETBRAIN_SIZE_ASIAN_H		decimal(6,3),
	BETBRAIN_MAX_ASIAN_H_HOME	decimal(6,3),
	BETBRAIN_AVG_ASIAN_H_HOME	decimal(6,3),
	BETBRAIN_MAX_ASIAN_H_AWAY	decimal(6,3),
	BETBRAIN_AVG_ASIAN_H_AWAY	decimal(5,2),	
	audit_insert_date	timestamp,
	audit_record_source	varchar(100),
	constraint pk_football_match_his_l_s_odds primary key (football_match_his_lid, load_dts) disable,
	constraint fk_football_match_his_l_s_odds foreign key (football_match_his_lid) references raw_dv.football_match_his_l (football_match_his_lid) disable,
	distribute by football_match_his_lid
	);

comment on table raw_dv.football_match_his_l_s_odds								is 'satellite with historic football match odds of different bet agents';
comment on column raw_dv.football_match_his_l_s_odds.FOOTBALL_MATCH_HIS_LID		is 'foreign key to link table football_match_his_l';
comment on column raw_dv.football_match_his_l_s_odds.LOAD_DTS 					is 'load timestamp of record';
comment on column raw_dv.football_match_his_l_s_odds.BET365_HOME_ODDS 			is 'Bet365 home win odds';
comment on column raw_dv.football_match_his_l_s_odds.BET365_DRAW_ODDS 			is 'Bet365 draw odds';
comment on column raw_dv.football_match_his_l_s_odds.BET365_AWAY_ODDS 			is 'Bet365 away win odds';
comment on column raw_dv.football_match_his_l_s_odds.BLUE_SQUARE_HOME_ODDS 		is 'Blue Square home win odds';
comment on column raw_dv.football_match_his_l_s_odds.BLUE_SQUARE_DRAW_ODDS 		is 'Blue Square draw odds';
comment on column raw_dv.football_match_his_l_s_odds.BLUE_SQUARE_AWAY_ODDS 		is 'Blue Square away win odds';
comment on column raw_dv.football_match_his_l_s_odds.BET_WIN_HOME_ODDS 			is 'BetWin home win odds'
comment on column raw_dv.football_match_his_l_s_odds.BET_WIN_DRAW_ODDS 			is 'BetWin draw odds';
comment on column raw_dv.football_match_his_l_s_odds.BET_WIN_AWAY_ODDS 			is 'BetWin away win odds';
comment on column raw_dv.football_match_his_l_s_odds.INTERWETTEN_HOME_ODDS 		is 'Interwetten home win odds';
comment on column raw_dv.football_match_his_l_s_odds.INTERWETTEN_DRAW_ODDS 		is 'Interwetten draw odds';
comment on column raw_dv.football_match_his_l_s_odds.INTERWETTEN_AWAY_ODDS 		is 'Interwetten away win odds';
comment on column raw_dv.football_match_his_l_s_odds.GAMEBOOKERS_HOME_ODDS 		is 'Gamebookers home win odds';
comment on column raw_dv.football_match_his_l_s_odds.GAMEBOOKERS_DRAW_ODDS 		is 'Gamebookers draw odds';
comment on column raw_dv.football_match_his_l_s_odds.GAMEBOOKERS_AWAY_ODDS 		is 'Gamebookers away win odds';
comment on column raw_dv.football_match_his_l_s_odds.LADBROKES_HOME_ODDS 		is 'Ladbrokes home win odds';
comment on column raw_dv.football_match_his_l_s_odds.LADBROKES_DRAW_ODDS 		is 'Ladbrokes draw odds';
comment on column raw_dv.football_match_his_l_s_odds.LADBROKES_AWAY_ODDS 		is 'Ladbrokes away win odds';
comment on column raw_dv.football_match_his_l_s_odds.PINACLE_HOME_ODDS 			is 'Pinnacle Sports home win odds';
comment on column raw_dv.football_match_his_l_s_odds.PINACLE_DRAW_ODDS 			is 'Pinnacle Sports draw odds';
comment on column raw_dv.football_match_his_l_s_odds.PINALCE_AWAY_ODDS 			is 'Pinnacle Sports away win odds';
comment on column raw_dv.football_match_his_l_s_odds.WILLIAM_HILL_HOME_ODDS 	is 'William Hill home win odds';
comment on column raw_dv.football_match_his_l_s_odds.WILLIAM_HILL_DRAW_ODDS 	is 'William Hill draw odds';
comment on column raw_dv.football_match_his_l_s_odds.WILLIAM_HILL_AWAY_ODDS 	is 'William Hill away win odds';
comment on column raw_dv.football_match_his_l_s_odds.SPORTING_BET_HOME_ODDS 	is 'Sportingbet home win odds';
comment on column raw_dv.football_match_his_l_s_odds.SPORTING_BET_DRAW_ODDS 	is 'Sportingbet draw odds';
comment on column raw_dv.football_match_his_l_s_odds.SPORTING_BET_AWAY_ODDS 	is 'Sportingbet away win odds';
comment on column raw_dv.football_match_his_l_s_odds.VC_BET_HOME_ODDS 			is 'VC Bet home win odds';
comment on column raw_dv.football_match_his_l_s_odds.VC_BET_DRAW_ODDS 			is 'VC Bet draw odds';
comment on column raw_dv.football_match_his_l_s_odds.VC_BET_AWAY_ODDS 			is 'VC Bet away win odds';
comment on column raw_dv.football_match_his_l_s_odds.STAN_JAMES_HOME_ODDS 		is 'Stan James home win odds';
comment on column raw_dv.football_match_his_l_s_odds.STAN_JAMES_DRAW_ODDS 		is 'Stan James draw odds';
comment on column raw_dv.football_match_his_l_s_odds.STAN_JAMES_AWAY_ODDS 		is 'Stan James away win odds';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_NUM_1X2 			is 'Number of BetBrain bookmakers used to calculate match odds averages and maximums';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_MAX_HOME_ODDS 	is 'Betbrain maximum home win odds';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_AVG_HOME_ODDS 	is 'Betbrain average home win odds';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_MAX_DRAW_ODDS 	is 'Betbrain maximum draw odds';
comment on column raw_dv.football_match_his_l_s_odds.BETBREIN_AVG_DRAW_ODDS 	is 'Betbrain average draw win odds';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_MAX_AWAY_ODDS 	is 'Betbrain maximum away win odds';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_AVG_AWAY_ODDS 	is 'Betbrain average away win odds';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_NUM_OU 			is 'Number of BetBrain bookmakers used to calculate over/under 2.5 goals (total goals) averages and maximums';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_MAX_O25 			is 'Betbrain maximum over 2.5 goals';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_AVG_O25 			is 'Betbrain average over 2.5 goals';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_MAX_U25			is 'Betbrain maximum under 2.5 goals';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_AVG_U25 			is 'Betbrain average under 2.5 goals';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_NUM_ASIAN_H		is 'Number of BetBrain bookmakers used to Asian handicap averages and maximums';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_SIZE_ASIAN_H 		is 'Betbrain size of handicap (home team)';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_MAX_ASIAN_H_HOME 	is 'Betbrain maximum Asian handicap home team odds';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_AVG_ASIAN_H_HOME 	is 'Betbrain average Asian handicap home team odds';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_MAX_ASIAN_H_AWAY 	is 'Betbrain maximum Asian handicap away team odds';
comment on column raw_dv.football_match_his_l_s_odds.BETBRAIN_AVG_ASIAN_H_AWAY 	is 'Betbrain average Asian handicap away team odds';

commit;