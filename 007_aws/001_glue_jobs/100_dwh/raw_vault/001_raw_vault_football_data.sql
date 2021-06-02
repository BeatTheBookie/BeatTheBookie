

-------------------------------------
--load hub table FOOTBALL_DIVSION_H--
-------------------------------------

insert into raw_dv.football_division_h
	(
	division,
	country,
	audit_insert_date,
	audit_record_source,
	football_division_hid
	)
select DISTINCT
	"div" division,
	CASE
		WHEN "div" IN ('D1','D2') THEN 'GER'
		WHEN "div" IN ('E0') THEN 'ENG'
		WHEN "div" IN ('F1') THEN 'FRA'
		WHEN "div" IN ('SP1') THEN 'ESP'
		WHEN "div" IN ('I1') THEN 'ITA'
		ELSE 'n.a.'
	END country,
	--hash calculation
	hash_md5("div" || '#' || LOCAL.country) division_bk_hash,
	--meta
	current_timestamp,
	'load FOOTBALL_DIVSION_H'
from
	LANDING_FOOTBALL_DATA.FOOTBALL_DATA src
where
	--only load divisions, which not already exist
	not exists (
				select
					1
				from
					raw_dv.football_division_h tgt
				where
					local.division_bk_hash = tgt.football_division_hid
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
		hash_md5("hometeam") team_bk_hash,
		"hometeam" team
	from
		LANDING_FOOTBALL_DATA.FOOTBALL_DATA 
	UNION
	select
		hash_md5("awayteam") team_bk_hash,
		"awayteam" team
	from
		LANDING_FOOTBALL_DATA.FOOTBALL_DATA	
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
SELECT distinct
	hash_md5(REPLACE(src.SEASON,'_','_20')) 	football_season_hid,
	REPLACE(src.SEASON,'_','_20')				season,
	CURRENT_TIMESTAMP			audit_insert_date,
	'load FOOTBALL_SEASON_H'	audit_record_source
FROM 
	LANDING_FOOTBALL_DATA.FOOTBALL_DATA src
where
	--only load seasons, which not already exist
	not exists (
				select
					1
				from
	 					raw_dv.football_season_h tgt
				where
					local.football_season_hid = tgt.football_season_hid
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
SELECT
	football_team_division_lid,
	season_bk_hash,
	DIVISION_BK_HASH,
	TEAM_BK_HASH,
	current_timestamp,
	'load FOOTBALL_TEAM_DIVISION_L'
from
	(
	select
		CASE
			WHEN "div" IN ('D1','D2') THEN 'GER'
			WHEN "div" IN ('E0') THEN 'ENG'
			WHEN "div" IN ('F1') THEN 'FRA'
			WHEN "div" IN ('SP1') THEN 'ESP'
			WHEN "div" IN ('I1') THEN 'ITA'
			ELSE 'n.a.'
		END country,
		season,	
		"div",
		"hometeam" team,
		--hash calculation	
		hash_md5(REPLACE(season,'_','_20')) season_bk_hash,
		hash_md5("div" || '#' || LOCAL.country) DIVISION_BK_HASH,
		hash_md5("hometeam") TEAM_BK_HASH,
		hash_md5(LOCAL.SEASON_BK_HASH || '#' || LOCAL.DIVISION_BK_HASH || '#' || LOCAL.TEAM_BK_HASH) football_team_division_lid
	from
		LANDING_FOOTBALL_DATA.FOOTBALL_DATA 
	union
	SELECT
		CASE
			WHEN "div" IN ('D1','D2') THEN 'GER'
			WHEN "div" IN ('E0') THEN 'ENG'
			WHEN "div" IN ('F1') THEN 'FRA'
			WHEN "div" IN ('SP1') THEN 'ESP'
			WHEN "div" IN ('I1') THEN 'ITA'
			ELSE 'n.a.'
		END country,
		--hash calculation
		season,	
		"div",
		"awayteam" team,
		hash_md5(REPLACE(season,'_','_20')) season_bk_hash,
		hash_md5("div" || '#' || LOCAL.country) DIVISION_BK_HASH,
		hash_md5("awayteam") TEAM_BK_HASH,
		hash_md5(LOCAL.SEASON_BK_HASH || '#' || LOCAL.DIVISION_BK_HASH || '#' || LOCAL.TEAM_BK_HASH) football_team_division_lid
	from
		LANDING_FOOTBALL_DATA.FOOTBALL_DATA	
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
SELECT
	football_match_his_lid,
	division_bk_hash,
	hometeam_bk_hash,
	awayteam_bk_hash,
	season_bk_hash,
	match_date,
	audit_insert_date,
	audit_record_source
FROM 
	(
	SELECT
		CASE
			WHEN "div" IN ('D1','D2') THEN 'GER'
			WHEN "div" IN ('E0') THEN 'ENG'
			WHEN "div" IN ('F1') THEN 'FRA'
			WHEN "div" IN ('SP1') THEN 'ESP'
			WHEN "div" IN ('I1') THEN 'ITA'
			ELSE 'n.a.'
		END country,
		"div",
		"hometeam",
		"awayteam",
		season,
		hash_md5("div" || '#' || LOCAL.country) DIVISION_BK_HASH,
		hash_md5("hometeam") hometeam_bk_hash,
		hash_md5("awayteam") awayteam_bk_hash,
		hash_md5(REPLACE(season,'_','_20')) season_bk_hash,
		to_date("date",'dd/mm/yyyy') match_date,	
		hash_md5(LOCAL.division_bk_hash || '#' || LOCAL.hometeam_bk_hash || '#' || LOCAL.awayteam_bk_hash || '#' || LOCAL.season_bk_hash || '#' || to_char(LOCAL.match_date,'yyyymmdd')) football_match_his_lid,
		CURRENT_TIMESTAMP audit_insert_date,
		'load FOOTBALL_MATCH_HIS_L' audit_record_source
	from
		LANDING_FOOTBALL_DATA.FOOTBALL_DATA
	where
		--only load matches, which not already exist
		not exists (
					select
						1
					from
						raw_dv.football_match_his_l tgt
					where
						LOCAL.football_match_his_lid = tgt.football_match_his_lid
					)
	);


--------------------------------------------------------
--load link satellite FOOTBALL_MATCH_HIS_L_S_STATISTIC--
--------------------------------------------------------

--Load new and changed entries update existing if final result changed (no history)
merge into raw_dv.football_match_his_l_s_statistic tgt
using
	(
	SELECT
		CASE
			WHEN "div" IN ('D1','D2') THEN 'GER'
			WHEN "div" IN ('E0') THEN 'ENG'
			WHEN "div" IN ('F1') THEN 'FRA'
			WHEN "div" IN ('SP1') THEN 'ESP'
			WHEN "div" IN ('I1') THEN 'ITA'
			ELSE 'n.a.'
		END country,
		--build hashes
		hash_md5("div" || '#' || LOCAL.country) DIVISION_BK_HASH,
		hash_md5("hometeam") hometeam_bk_hash,
		hash_md5("awayteam") awayteam_bk_hash,
		hash_md5(REPLACE(season,'_','_20')) season_bk_hash,
		to_date("date",'dd/mm/yyyy') match_date,
		hash_md5(LOCAL.division_bk_hash || '#' || LOCAL.hometeam_bk_hash || '#' || LOCAL.awayteam_bk_hash || '#' || LOCAL.season_bk_hash || '#' || to_char(LOCAL.match_date,'yyyymmdd')) football_match_his_lid,
		current_timestamp load_dts,
		"fthg" 	FULL_TIME_HOME_GOALS,
		"ftag" 	FULL_TIME_AWAY_GOALS,
		"ftr" 	FULL_TIME_RESULT,
		"hthg" 	HALF_TIME_HOME_GOALS,
		"htag" 	HALF_TIME_AWAY_GOALS,
		"htr" 	HALF_TIME_RESULT,
		"hs"	HOME_SHOTS,
		"as"	AWAY_SHOTS,
		"hst"	HOME_SHOTS_TARGET,
		"ast"	AWAY_SHOTS_TARGET,
		"hf"	HOME_FOULS,
		"af"	AWAY_FOULS,
		"hc"	HOME_CORNERS,
		"ac"	AWAY_CORNERS,
		"hy"	HOME_YELLOW,
		"ay"	AWAY_YELLOW,
		"hr"	HOME_RED,
		"ar"	AWAY_RED,	
		current_timestamp audit_insert_date,
		'load FOOTBALL_MATCH_HIS_L_S_STATISTIC' audit_record_source
	from
		LANDING_FOOTBALL_DATA.FOOTBALL_DATA
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

--Load new and changed entries update existing (no history)
merge into raw_dv.football_match_his_l_s_odds tgt
using
	(
	select
		CASE
			WHEN "div" IN ('D1','D2') THEN 'GER'
			WHEN "div" IN ('E0') THEN 'ENG'
			WHEN "div" IN ('F1') THEN 'FRA'
			WHEN "div" IN ('SP1') THEN 'ESP'
			WHEN "div" IN ('I1') THEN 'ITA'
			ELSE 'n.a.'
		END country,
		--build hashes
		hash_md5("div" || '#' || LOCAL.country) DIVISION_BK_HASH,
		hash_md5("hometeam") hometeam_bk_hash,
		hash_md5("awayteam") awayteam_bk_hash,
		hash_md5(REPLACE(season,'_','_20')) season_bk_hash,
		to_date("date",'dd/mm/yyyy') match_date,
		hash_md5(LOCAL.division_bk_hash || '#' || LOCAL.hometeam_bk_hash || '#' || LOCAL.awayteam_bk_hash || '#' || LOCAL.season_bk_hash || '#' || to_char(LOCAL.match_date,'yyyymmdd')) football_match_his_lid,
		current_timestamp load_dts,
		"b365h"		BET365_HOME_ODDS,
		"b365d"		BET365_DRAW_ODDS,
		"b365a"	BET365_AWAY_ODDS,
		NUll		BLUE_SQUARE_HOME_ODDS,
		NUll		BLUE_SQUARE_DRAW_ODDS,
		NUll		BLUE_SQUARE_AWAY_ODDS,
		null		BET_WIN_HOME_ODDS,
		null		BET_WIN_DRAW_ODDS,
		null		BET_WIN_AWAY_ODDS,
		null		INTERWETTEN_HOME_ODDS,
		null		INTERWETTEN_DRAW_ODDS,
		null		INTERWETTEN_AWAY_ODDS,
		NUll		GAMEBOOKERS_HOME_ODDS,
		NUll		GAMEBOOKERS_DRAW_ODDS,
		NUll		GAMEBOOKERS_AWAY_ODDS,
		NUll		LADBROKES_HOME_ODDS,
		NUll		LADBROKES_DRAW_ODDS,
		NUll		LADBROKES_AWAY_ODDS,
		NUll		PINACLE_HOME_ODDS,
		NUll		PINACLE_DRAW_ODDS,
		NUll		PINALCE_AWAY_ODDS,
		null		WILLIAM_HILL_HOME_ODDS,
		null		WILLIAM_HILL_DRAW_ODDS,
		null		WILLIAM_HILL_AWAY_ODDS,
		NUll		SPORTING_BET_HOME_ODDS,
		NUll		SPORTING_BET_DRAW_ODDS,
		NUll		SPORTING_BET_AWAY_ODDS,
		NUll		VC_BET_HOME_ODDS,
		NUll		VC_BET_DRAW_ODDS,
		NUll		VC_BET_AWAY_ODDS,
		NUll		STAN_JAMES_HOME_ODDS,
		NUll		STAN_JAMES_DRAW_ODDS,
		NUll		STAN_JAMES_AWAY_ODDS,
		NUll		BETBRAIN_NUM_1X2,
		NUll		BETBRAIN_MAX_HOME_ODDS,
		NUll		BETBRAIN_AVG_HOME_ODDS,
		NUll		BETBRAIN_MAX_DRAW_ODDS,
		NUll		BETBREIN_AVG_DRAW_ODDS,
		NUll		BETBRAIN_MAX_AWAY_ODDS,
		NUll		BETBRAIN_AVG_AWAY_ODDS,
		NUll		BETBRAIN_NUM_OU,
		NUll		BETBRAIN_MAX_O25,
		NUll		BETBRAIN_AVG_O25,
		NUll		BETBRAIN_MAX_U25,
		NUll		BETBRAIN_AVG_U25,
		NUll		BETBRAIN_NUM_ASIAN_H,
		NUll		BETBRAIN_SIZE_ASIAN_H,
		NUll		BETBRAIN_MAX_ASIAN_H_HOME,
		NUll		BETBRAIN_AVG_ASIAN_H_HOME,
		NUll		BETBRAIN_MAX_ASIAN_H_AWAY,
		NUll		BETBRAIN_AVG_ASIAN_H_AWAY,	
		current_timestamp audit_insert_date,
		'load FOOTBALL_MATCH_HIS_L_S_ODDS' audit_record_source
	from
		LANDING_FOOTBALL_DATA.FOOTBALL_DATA
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
	tgt.BET365_HOME_ODDS <> src.BET365_HOME_ODDS
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
