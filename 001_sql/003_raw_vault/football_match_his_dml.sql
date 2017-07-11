
/************************************************
	ETL processes for loading DV model for historic
	data of football
	
v1.0:
	- ELT for tables
		- football_team_h	
		- football_division_h
		- football_match_his_l
		- football_match_his_l_s_statistic
		
v2.0:
	- ELT for tables
		- football_match_his_l_s_odds
	- loading by MERGE

*************************************************/

-------------------------------------
--load hub table FOOTBALL_DIVSION_H--
-------------------------------------

insert into raw_dv.football_division_h
	(
	football_division_hid,
	division,
	country,
	audit_insert_date,
	audit_record_source
	)
--select all distinct divisions
select distinct
	division_bk_hash,
	division,
	country,
	current_timestamp,
	'load FOOTBALL_DIVSION_H'
from
	stage.football_his src
where
	--only load divisions, which not already exist
	not exists (
				select
					1
				from
					raw_dv.football_division_h tgt
				where
					src.division_bk_hash = tgt.football_division_hid
				);


----------------------------------
--load hub table FOOTBALL_TEAM_H--
----------------------------------

insert into raw_dv.football_team_h
	(
	football_team_hid,
	team,
	audit_insert_date,
	audit_record_source
	)
--select all distinct teams
select distinct
	team_bk_hash,
	team,
	current_timestamp,
	'load FOOTBALL_TEAM_H'
from
	(
	select
		hometeam_bk_hash team_bk_hash,
		hometeam team
	from
		stage.football_his
	UNION
	select
		awayteam_bk_hash,
		awayteam
	from
		stage.football_his
	) src
where
	--only load teams, which not already exist
	not exists (
				select
					1
				from
					raw_dv.football_team_h tgt
				where
					src.team_bk_hash = tgt.football_team_hid
				);


------------------------------------
--load hub table FOOTBALL_SEASON_H--
------------------------------------

insert into raw_dv.football_season_h
	(
	football_season_hid,
	season,
	audit_insert_date,
	audit_record_source
	)
--select all distinct seasons
select distinct
	SEASON_BK_HASH,
	SEASON,
	current_timestamp,
	'load FOOTBALL_SEASON_H'
from
	stage.football_his src
where
	--only load seasons, which not already exist
	not exists (
				select
					1
				from
					raw_dv.football_season_h tgt
				where
					src.SEASON_BK_HASH = tgt.football_season_hid
				);


--------------------------------------------
--load link table FOOTBALL_TEAM_DIVISION_L--
--------------------------------------------

insert into raw_dv.football_team_division_l
	(
	football_team_division_lid,
	football_season_hid,
	football_division_hid,
	football_team_hid,
	audit_insert_date,
	audit_record_source
	)
--select all team-division-season combinations from stage
select
	football_team_division_lid,
	SEASON_BK_HASH,
	DIVISION_BK_HASH,
	TEAM_BK_HASH,
	current_timestamp,
	'load FOOTBALL_TEAM_DIVISION_L'
from
	(
	select
		hash_md5(SEASON_BK_HASH || '#' || DIVISION_BK_HASH || '#' || HOMETEAM_BK_HASH) football_team_division_lid,
		SEASON_BK_HASH,
		DIVISION_BK_HASH,
		HOMETEAM_BK_HASH TEAM_BK_HASH
	from
		stage.football_his 
	union
	select
		hash_md5(SEASON_BK_HASH || '#' || DIVISION_BK_HASH || '#' || AWAYTEAM_BK_HASH) football_team_division_lid,
		SEASON_BK_HASH,
		DIVISION_BK_HASH,
		AWAYTEAM_BK_HASH TEAM_BK_HASH
	from
		stage.football_his	
	) src
where
	--load team-division-season combination which not already exist
	not exists (
				select
					1
				from
					raw_dv.football_team_division_l tgt
				where
					src.football_team_division_lid = tgt.football_team_division_lid
				);		
				
				
----------------------------------------
--load link table FOOTBALL_MATCH_HIS_L--
----------------------------------------

insert into raw_dv.football_match_his_l
	(
	football_match_his_lid,
	football_division_hid,
	football_team_home_hid,
	football_team_away_hid,
	football_season_hid,
	match_date,
	audit_insert_date,
	audit_record_source
	)
--select all matches from stage
select
	hash_md5(division_bk_hash || '#' || hometeam_bk_hash || '#' || awayteam_bk_hash || '#' || season_bk_hash || '#' || to_char(match_date,'yyyymmdd')) football_match_his_lid,
	division_bk_hash,
	hometeam_bk_hash,
	awayteam_bk_hash,
	season_bk_hash,
	match_date,	
	current_timestamp,
	'load FOOTBALL_MATCH_HIS_L'
from
	stage.football_his src
where
	--only load matches, which not already exist
	not exists (
				select
					1
				from
					raw_dv.football_match_his_l tgt
				where
					hash_md5(src.division_bk_hash || '#' || src.hometeam_bk_hash || '#' || src.awayteam_bk_hash || '#' || src.season_bk_hash || '#' || to_char(src.match_date,'yyyymmdd')) = tgt.football_match_his_lid
				);


--------------------------------------------------------
--load link satellite FOOTBALL_MATCH_HIS_L_S_STATISTIC--
--------------------------------------------------------

--Load new and changed entries; update existing if final result changed (no history)
merge into raw_dv.football_match_his_l_s_statistic tgt
using
	(
	select
		hash_md5(division_bk_hash || '#' || hometeam_bk_hash || '#' || awayteam_bk_hash || '#' || season_bk_hash || '#' || to_char(match_date,'yyyymmdd')) football_match_his_lid,
		current_timestamp load_dts,
		FULL_TIME_HOME_GOALS,
		FULL_TIME_AWAY_GOALS,
		FULL_TIME_RESULT,
		HALF_TIME_HOME_GOALS,
		HALF_TIME_AWAY_GOALS,
		HALF_TIME_RESULT,
		HOME_SHOTS,
		AWAY_SHOTS,
		HOME_SHOTS_TARGET,
		AWAY_SHOTS_TARGET,
		HOME_FOULS,
		AWAY_FOULS,
		HOME_CORNERS,
		AWAY_CORNERS,
		HOME_YELLOW,
		AWAY_YELLOW,
		HOME_RED,
		AWAY_RED,	
		current_timestamp audit_insert_date,
		'load FOOTBALL_MATCH_HIS_L_S_STATISTIC' audit_record_source
	from
		stage.football_his
	) src
on (src.football_match_his_lid = tgt.football_match_his_lid)
when matched then update set
	tgt.FULL_TIME_HOME_GOALS 	= src.FULL_TIME_HOME_GOALS,
	tgt.FULL_TIME_AWAY_GOALS 	= src.FULL_TIME_AWAY_GOALS,
	tgt.FULL_TIME_RESULT 		= src.FULL_TIME_RESULT,
	tgt.HALF_TIME_HOME_GOALS	= src.HALF_TIME_HOME_GOALS,
	tgt.HALF_TIME_AWAY_GOALS	= src.HALF_TIME_AWAY_GOALS,
	tgt.HALF_TIME_RESULT		= src.HALF_TIME_RESULT,
	tgt.HOME_SHOTS				= src.HOME_SHOTS,
	tgt.AWAY_SHOTS				= src.AWAY_SHOTS,
	tgt.HOME_SHOTS_TARGET		= src.HOME_SHOTS_TARGET,
	tgt.AWAY_SHOTS_TARGET		= src.AWAY_SHOTS_TARGET,
	tgt.HOME_FOULS				= src.HOME_FOULS,
	tgt.AWAY_FOULS				= src.AWAY_FOULS,
	tgt.HOME_CORNERS			= src.HOME_CORNERS,
	tgt.AWAY_CORNERS			= src.AWAY_CORNERS,
	tgt.HOME_YELLOW				= src.HOME_YELLOW,
	tgt.AWAY_YELLOW				= src.AWAY_YELLOW,
	tgt.HOME_RED				= src.HOME_RED,
	tgt.AWAY_RED				= src.AWAY_RED,
	tgt.audit_insert_date		= src.audit_insert_date,
	tgt.audit_record_source		= src.audit_record_source
where
	--Full-time result has changed
	--> sufficient check for changed records
	tgt.FULL_TIME_RESULT <> src.FULL_TIME_RESULT
when not matched then insert values
	(
	src.football_match_his_lid,
	src.load_dts,
	src.FULL_TIME_HOME_GOALS,
	src.FULL_TIME_AWAY_GOALS,
	src.FULL_TIME_RESULT,
	src.HALF_TIME_HOME_GOALS,
	src.HALF_TIME_AWAY_GOALS,
	src.HALF_TIME_RESULT,
	src.HOME_SHOTS,
	src.AWAY_SHOTS,
	src.HOME_SHOTS_TARGET,
	src.AWAY_SHOTS_TARGET,
	src.HOME_FOULS,
	src.AWAY_FOULS,
	src.HOME_CORNERS,
	src.AWAY_CORNERS,
	src.HOME_YELLOW,
	src.AWAY_YELLOW,
	src.HOME_RED,
	src.AWAY_RED,
	src.audit_insert_date,
	src.audit_record_source
	)
;
	


---------------------------------------------------
--load link satellite FOOTBALL_MATCH_HIS_L_S_ODDS--
---------------------------------------------------

--Load new and changed entries; update existing (no history)
merge into raw_dv.football_match_his_l_s_odds tgt
using
	(
	select
		hash_md5(division_bk_hash || '#' || hometeam_bk_hash || '#' || awayteam_bk_hash || '#' || season_bk_hash || '#' || to_char(match_date,'yyyymmdd')) football_match_his_lid,
		current_timestamp load_dts,
		BET365_HOME_ODDS,
		BET365_DRAW_ODDS,
		BET365_AWAY_ODDS,
		BLUE_SQUARE_HOME_ODDS,
		BLUE_SQUARE_DRAW_ODDS,
		BLUE_SQUARE_AWAY_ODDS,
		BET_WIN_HOME_ODDS,
		BET_WIN_DRAW_ODDS,
		BET_WIN_AWAY_ODDS,
		INTERWETTEN_HOME_ODDS,
		INTERWETTEN_DRAW_ODDS,
		INTERWETTEN_AWAY_ODDS,
		GAMEBOOKERS_HOME_ODDS,
		GAMEBOOKERS_DRAW_ODDS,
		GAMEBOOKERS_AWAY_ODDS,
		LADBROKES_HOME_ODDS,
		LADBROKES_DRAW_ODDS,
		LADBROKES_AWAY_ODDS,
		PINACLE_HOME_ODDS,
		PINACLE_DRAW_ODDS,
		PINALCE_AWAY_ODDS,
		WILLIAM_HILL_HOME_ODDS,
		WILLIAM_HILL_DRAW_ODDS,
		WILLIAM_HILL_AWAY_ODDS,
		SPORTING_BET_HOME_ODDS,
		SPORTING_BET_DRAW_ODDS,
		SPORTING_BET_AWAY_ODDS,
		VC_BET_HOME_ODDS,
		VC_BET_DRAW_ODDS,
		VC_BET_AWAY_ODDS,
		STAN_JAMES_HOME_ODDS,
		STAN_JAMES_DRAW_ODDS,
		STAN_JAMES_AWAY_ODDS,
		BETBRAIN_NUM_1X2,
		BETBRAIN_MAX_HOME_ODDS,
		BETBRAIN_AVG_HOME_ODDS,
		BETBRAIN_MAX_DRAW_ODDS,
		BETBREIN_AVG_DRAW_ODDS,
		BETBRAIN_MAX_AWAY_ODDS,
		BETBRAIN_AVG_AWAY_ODDS,
		BETBRAIN_NUM_OU,
		BETBRAIN_MAX_O25,
		BETBRAIN_AVG_O25,
		BETBRAIN_MAX_U25,
		BETBRAIN_AVG_U25,
		BETBRAIN_NUM_ASIAN_H,
		BETBRAIN_SIZE_ASIAN_H,
		BETBRAIN_MAX_ASIAN_H_HOME,
		BETBRAIN_AVG_ASIAN_H_HOME,
		BETBRAIN_MAX_ASIAN_H_AWAY,
		BETBRAIN_AVG_ASIAN_H_AWAY,	
		current_timestamp audit_insert_date,
		'load FOOTBALL_MATCH_HIS_L_S_ODDS' audit_record_source
	from
		stage.football_his
	) src
on (src.football_match_his_lid = tgt.football_match_his_lid)
when matched then update set
	tgt.BET365_HOME_ODDS = src.BET365_HOME_ODDS,
	tgt.BET365_DRAW_ODDS = src.BET365_DRAW_ODDS,
	tgt.BET365_AWAY_ODDS = src.BET365_AWAY_ODDS,
	tgt.BLUE_SQUARE_HOME_ODDS = src.BLUE_SQUARE_HOME_ODDS,
	tgt.BLUE_SQUARE_DRAW_ODDS = src.BLUE_SQUARE_DRAW_ODDS,
	tgt.BLUE_SQUARE_AWAY_ODDS = src.BLUE_SQUARE_AWAY_ODDS,
	tgt.BET_WIN_HOME_ODDS = src.BET_WIN_HOME_ODDS,
	tgt.BET_WIN_DRAW_ODDS = src.BET_WIN_DRAW_ODDS,
	tgt.BET_WIN_AWAY_ODDS = src.BET_WIN_AWAY_ODDS,
	tgt.INTERWETTEN_HOME_ODDS = src.INTERWETTEN_HOME_ODDS,
	tgt.INTERWETTEN_DRAW_ODDS = src.INTERWETTEN_DRAW_ODDS,
	tgt.INTERWETTEN_AWAY_ODDS = src.INTERWETTEN_AWAY_ODDS,
	tgt.GAMEBOOKERS_HOME_ODDS = src.GAMEBOOKERS_HOME_ODDS,
	tgt.GAMEBOOKERS_DRAW_ODDS = src.GAMEBOOKERS_DRAW_ODDS,
	tgt.GAMEBOOKERS_AWAY_ODDS = src.GAMEBOOKERS_AWAY_ODDS,
	tgt.LADBROKES_HOME_ODDS = src.LADBROKES_HOME_ODDS,
	tgt.LADBROKES_DRAW_ODDS = src.LADBROKES_DRAW_ODDS,
	tgt.LADBROKES_AWAY_ODDS = src.LADBROKES_AWAY_ODDS,
	tgt.PINACLE_HOME_ODDS = src.PINACLE_HOME_ODDS,
	tgt.PINACLE_DRAW_ODDS = src.PINACLE_DRAW_ODDS,
	tgt.PINALCE_AWAY_ODDS = src.PINALCE_AWAY_ODDS,
	tgt.WILLIAM_HILL_HOME_ODDS = src.WILLIAM_HILL_HOME_ODDS,
	tgt.WILLIAM_HILL_DRAW_ODDS = src.WILLIAM_HILL_DRAW_ODDS,
	tgt.WILLIAM_HILL_AWAY_ODDS = src.WILLIAM_HILL_AWAY_ODDS,
	tgt.SPORTING_BET_HOME_ODDS = src.SPORTING_BET_HOME_ODDS,
	tgt.SPORTING_BET_DRAW_ODDS = src.SPORTING_BET_DRAW_ODDS,
	tgt.SPORTING_BET_AWAY_ODDS = src.SPORTING_BET_AWAY_ODDS,
	tgt.VC_BET_HOME_ODDS = src.VC_BET_HOME_ODDS,
	tgt.VC_BET_DRAW_ODDS = src.VC_BET_DRAW_ODDS,
	tgt.VC_BET_AWAY_ODDS = src.VC_BET_AWAY_ODDS,
	tgt.STAN_JAMES_HOME_ODDS = src.STAN_JAMES_HOME_ODDS,
	tgt.STAN_JAMES_DRAW_ODDS = src.STAN_JAMES_DRAW_ODDS,
	tgt.STAN_JAMES_AWAY_ODDS = src.STAN_JAMES_AWAY_ODDS,
	tgt.BETBRAIN_NUM_1X2 = src.BETBRAIN_NUM_1X2,
	tgt.BETBRAIN_MAX_HOME_ODDS = src.BETBRAIN_MAX_HOME_ODDS,
	tgt.BETBRAIN_AVG_HOME_ODDS = src.BETBRAIN_AVG_HOME_ODDS,
	tgt.BETBRAIN_MAX_DRAW_ODDS = src.BETBRAIN_MAX_DRAW_ODDS,
	tgt.BETBREIN_AVG_DRAW_ODDS = src.BETBREIN_AVG_DRAW_ODDS,
	tgt.BETBRAIN_MAX_AWAY_ODDS = src.BETBRAIN_MAX_AWAY_ODDS,
	tgt.BETBRAIN_AVG_AWAY_ODDS = src.BETBRAIN_AVG_AWAY_ODDS,
	tgt.BETBRAIN_NUM_OU = src.BETBRAIN_NUM_OU,
	tgt.BETBRAIN_MAX_O25 = src.BETBRAIN_MAX_O25,
	tgt.BETBRAIN_AVG_O25 = src.BETBRAIN_AVG_O25,
	tgt.BETBRAIN_MAX_U25 = src.BETBRAIN_MAX_U25,
	tgt.BETBRAIN_AVG_U25 = src.BETBRAIN_AVG_U25,
	tgt.BETBRAIN_NUM_ASIAN_H = src.BETBRAIN_NUM_ASIAN_H,
	tgt.BETBRAIN_SIZE_ASIAN_H = src.BETBRAIN_SIZE_ASIAN_H,
	tgt.BETBRAIN_MAX_ASIAN_H_HOME = src.BETBRAIN_MAX_ASIAN_H_HOME,
	tgt.BETBRAIN_AVG_ASIAN_H_HOME = src.BETBRAIN_AVG_ASIAN_H_HOME,
	tgt.BETBRAIN_MAX_ASIAN_H_AWAY = src.BETBRAIN_MAX_ASIAN_H_AWAY,
	tgt.BETBRAIN_AVG_ASIAN_H_AWAY = src.BETBRAIN_AVG_ASIAN_H_AWAY,	
	tgt.audit_insert_date = src.audit_insert_date,
	tgt.audit_record_source = src.audit_record_source
where
	--Avg Home-Odds have changed
	--> sufficient check for changed records
	tgt.BETBRAIN_AVG_HOME_ODDS <> src.BETBRAIN_AVG_HOME_ODDS
when not matched then insert values
	(
	src.football_match_his_lid,
	src.load_dts,
	src.BET365_HOME_ODDS,
	src.BET365_DRAW_ODDS,
	src.BET365_AWAY_ODDS,
	src.BLUE_SQUARE_HOME_ODDS,
	src.BLUE_SQUARE_DRAW_ODDS,
	src.BLUE_SQUARE_AWAY_ODDS,
	src.BET_WIN_HOME_ODDS,
	src.BET_WIN_DRAW_ODDS,
	src.BET_WIN_AWAY_ODDS,
	src.INTERWETTEN_HOME_ODDS,
	src.INTERWETTEN_DRAW_ODDS,
	src.INTERWETTEN_AWAY_ODDS,
	src.GAMEBOOKERS_HOME_ODDS,
	src.GAMEBOOKERS_DRAW_ODDS,
	src.GAMEBOOKERS_AWAY_ODDS,
	src.LADBROKES_HOME_ODDS,
	src.LADBROKES_DRAW_ODDS,
	src.LADBROKES_AWAY_ODDS,
	src.PINACLE_HOME_ODDS,
	src.PINACLE_DRAW_ODDS,
	src.PINALCE_AWAY_ODDS,
	src.WILLIAM_HILL_HOME_ODDS,
	src.WILLIAM_HILL_DRAW_ODDS,
	src.WILLIAM_HILL_AWAY_ODDS,
	src.SPORTING_BET_HOME_ODDS,
	src.SPORTING_BET_DRAW_ODDS,
	src.SPORTING_BET_AWAY_ODDS,
	src.VC_BET_HOME_ODDS,
	src.VC_BET_DRAW_ODDS,
	src.VC_BET_AWAY_ODDS,
	src.STAN_JAMES_HOME_ODDS,
	src.STAN_JAMES_DRAW_ODDS,
	src.STAN_JAMES_AWAY_ODDS,
	src.BETBRAIN_NUM_1X2,
	src.BETBRAIN_MAX_HOME_ODDS,
	src.BETBRAIN_AVG_HOME_ODDS,
	src.BETBRAIN_MAX_DRAW_ODDS,
	src.BETBREIN_AVG_DRAW_ODDS,
	src.BETBRAIN_MAX_AWAY_ODDS,
	src.BETBRAIN_AVG_AWAY_ODDS,
	src.BETBRAIN_NUM_OU,
	src.BETBRAIN_MAX_O25,
	src.BETBRAIN_AVG_O25,
	src.BETBRAIN_MAX_U25,
	src.BETBRAIN_AVG_U25,
	src.BETBRAIN_NUM_ASIAN_H,
	src.BETBRAIN_SIZE_ASIAN_H,
	src.BETBRAIN_MAX_ASIAN_H_HOME,
	src.BETBRAIN_AVG_ASIAN_H_HOME,
	src.BETBRAIN_MAX_ASIAN_H_AWAY,
	src.BETBRAIN_AVG_ASIAN_H_AWAY,	
	src.audit_insert_date,
	src.audit_record_source
	)
;


		
commit;