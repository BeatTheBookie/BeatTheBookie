

/************************************************
	Stage table for historic data of bundesliga
	
Ermittlung der Spalten:

select
	*
from
(
select
	column_name,
	min(column_ordinal_position) column_ordinal_position 
from
	EXA_ALL_COLUMNS a
where
	column_schema = 'SOURCE_FILES'
group by
	column_name
)
order by
	column_ordinal_position
;

*************************************************/

drop table stage.football_his;

create table stage.football_his
	(
	DIVISION_BK_HASH			char(32),
	HOMETEAM_BK_HASH			char(32),
	AWAYTEAM_BK_HASH			char(32),
	SEASON_BK_HASH				char(32),
	DIVISION					varchar(5),
	COUNTRY						varchar(5),
	MATCH_DATE					date,
	SEASON						varchar(10),
	HOMETEAM					varchar(50),
	AWAYTEAM					varchar(50),
	FULL_TIME_HOME_GOALS		decimal(3),
	FULL_TIME_AWAY_GOALS		decimal(3),
	FULL_TIME_RESULT			varchar(1),
	HALF_TIME_HOME_GOALS		decimal(3),
	HALF_TIME_AWAY_GOALS		decimal(3),
	HALF_TIME_RESULT			varchar(1),
	REFEREE						varchar(50),
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
	audit_insert_date			timestamp,
	audit_record_source			varchar(100)
	);
	
commit;