

/************************************************
	migration script to migrate SANDBOX data of
	Python script to scrap UNDERSTAT data
	
v1.0:
	- hub + link tables for
		- division
		- season
		- team
		- match
	- understat match stats satellite

*************************************************/


-------------------------------------
--load hub table FOOTBALL_DIVSION_H--
-------------------------------------


insert into raw_dv.football_division_h
SELECT
	hash_md5(dm."football_data" || '#' || dm."country") football_division_hid,
	dm."football_data"		division,
	dm."country"			country,
	CURRENT_TIMESTAMP		audit_insert_date,
	'Understat'				audit_record_source
FROM 
	LANDING_UNDERSTAT.DIVISIONS d
	JOIN LANDING_MANUAL.DIVISION_MAPPING dm
		ON d."division_id" = dm."understat"
where
	--only load divisions, which not already exist
	not exists (
				select
					1
				from
					raw_dv.football_division_h tgt
				where
					local.football_division_hid = tgt.football_division_hid
				);


----------------------------------
--load hub table FOOTBALL_TEAM_H--
----------------------------------

			
insert into raw_dv.football_team_h			
SELECT
	hash_md5(tm."football_data")  	football_team_hid,
	tm."football_data" 				team,
	CURRENT_TIMESTAMP				audit_insert_date,
	'Understat'						audit_record_source
FROM 
	LANDING_UNDERSTAT.TEAMS t
	JOIN LANDING_MANUAL.TEAM_MAPPING tm 
		ON t."team_name" = tm."understat"
where
	--only load teams, which not already exist
	not exists (
				select
					1
				from
					raw_dv.football_team_h tgt
				where
					local.football_team_hid = tgt.football_team_hid
				);

			
			
------------------------------------
--load hub table FOOTBALL_SEASON_H--
------------------------------------

insert into raw_dv.football_season_h
SELECT
	hash_md5(REPLACE(s."season_id",'_','_20')) 	football_season_hid,
	REPLACE(s."season_id",'_','_20')				season,
	CURRENT_TIMESTAMP			audit_insert_date,
	'Understat'					audit_record_source
FROM 
	LANDING_UNDERSTAT.SEASONS s
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
with src_base as
(
SELECT
	hash_md5(REPLACE(f."season_id",'_','_20')) 			football_season_hid,
	hash_md5(dm."football_data" || '#' || dm."country") football_division_hid,
	hash_md5(tm_home."football_data")  					football_home_team_hid,
	hash_md5(tm_away."football_data")  					football_away_team_hid
FROM 
	LANDING_UNDERSTAT.FIXTURES f
	--get division
	JOIN LANDING_MANUAL.DIVISION_MAPPING dm
		ON f."division_id" = dm."understat"
	--get home team
	JOIN LANDING_UNDERSTAT.TEAMS t_home
		ON f."home_team_id" = t_home."team_id" 
	JOIN LANDING_MANUAL.TEAM_MAPPING tm_home
		ON t_home."team_name" = tm_home."understat"
	--get away team
	JOIN LANDING_UNDERSTAT.TEAMS t_away
		ON f."away_team_id" = t_away."team_id" 
	JOIN LANDING_MANUAL.TEAM_MAPPING tm_away
		ON t_away."team_name" = tm_away."understat"
)
--select all team-division-season combinations from stage
select
	football_team_division_lid,
	football_season_hid,
	football_division_hid,
	football_team_hid,
	current_timestamp,
	'Understat'
from
	(
	select
		hash_md5(football_season_hid || '#' || football_division_hid || '#' || football_home_team_hid) football_team_division_lid,
		football_season_hid,
		football_division_hid,
		football_home_team_hid football_team_hid
	from
		src_base
	union
	select
		hash_md5(football_season_hid || '#' || football_division_hid || '#' || football_away_team_hid) football_team_division_lid,
		football_season_hid,
		football_division_hid,
		football_away_team_hid football_team_hid
	from
		src_base
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
with src_base as
(
SELECT
	hash_md5(REPLACE(f."season_id",'_','_20')) 			football_season_hid,
	hash_md5(dm."football_data" || '#' || dm."country") football_division_hid,
	hash_md5(tm_home."football_data")  					football_team_home_hid,
	hash_md5(tm_away."football_data")  					football_team_away_hid,
	f."match_datetime" match_date 
FROM 
	LANDING_UNDERSTAT.FIXTURES f
	--get division
	JOIN LANDING_MANUAL.DIVISION_MAPPING dm
		ON f."division_id" = dm."understat"
	--get home team
	JOIN LANDING_UNDERSTAT.TEAMS t_home
		ON f."home_team_id" = t_home."team_id" 
	JOIN LANDING_MANUAL.TEAM_MAPPING tm_home
		ON t_home."team_name" = tm_home."understat"
	--get away team
	JOIN LANDING_UNDERSTAT.TEAMS t_away
		ON f."away_team_id" = t_away."team_id" 
	JOIN LANDING_MANUAL.TEAM_MAPPING tm_away
		ON t_away."team_name" = tm_away."understat"
)
--select all matches from stage
select
	hash_md5(src_base.football_division_hid || '#' || src_base.football_team_home_hid || '#' || src_base.football_team_away_hid || '#' || src_base.football_season_hid || '#' || to_char(his.match_date,'yyyymmdd')) football_match_his_lid,
	src_base.football_division_hid,
	src_base.football_team_home_hid,
	src_base.football_team_away_hid,
	src_base.football_season_hid,
	his.match_date,	
	current_timestamp,
	'Understat'
from
	src_base
	--understat got the wrong match-date for fixtures
	--that were moved -> match_date is lookuped through football-data
	join betting_dv.football_match_his_b his on
	    src_base.football_division_hid = his.FOOTBALL_DIVISION_HID and
	    src_base.football_season_hid = his.FOOTBALL_SEASON_HID and
	    src_base.football_team_home_hid = his.FOOTBALL_TEAM_HOME_HID and
	    src_base.football_team_away_hid = his.FOOTBALL_TEAM_AWAY_HID
where
	--only load matches, which not already exist
	not exists (
				select
					1
				from
					raw_dv.football_match_his_l tgt
				where
					hash_md5(src_base.football_division_hid || '#' || src_base.football_team_home_hid || '#' || src_base.football_team_away_hid || '#' || src_base.football_season_hid || '#' || to_char(his.match_date,'yyyymmdd')) = tgt.football_match_his_lid
				)
;			
			

--------------------------------------------------------------------------
--load link satellite FOOTBALL_MATCH_HIS_L_S_UNDERSTAT_MATCH_TEAM_STATS--
-------------------------------------------------------------------------

--truncate table raw_dv.football_match_his_l_s_understat_team_stats;

--Load new and changed entries -  update existing if final result changed (no history)
merge into raw_dv.football_match_his_l_s_understat_team_stats tgt
using
  (
	with src_base as
	(
	select
		--BKs and Hash-Keys
		hash_md5(REPLACE(f."season_id",'_','_20')) 			football_season_hid,
		hash_md5(dm."football_data" || '#' || dm."country") football_division_hid,
		hash_md5(tm_home."football_data")  					football_team_home_hid,
		hash_md5(tm_away."football_data")  					football_team_away_hid,
		f."match_datetime" 									match_date ,
		--stats
		f."home_goals" 			HOME_GOALS,
		f."away_goals" 			AWAY_GOALS,
		f."home_xg" 			HOME_XGOALS,
		f."away_xg" 			AWAY_XGOALS,
		NULL					HOME_SHOTS,
		NULL					AWAY_SHOTS,
		NULL					HOME_SHOTS_ON_TARGET,
		NULL					AWAY_SHOTS_ON_TARGET,
		NULL					HOME_DEEP,
		NULL					AWAY_DEEP,
		NULL					HOME_PPDA,
		NULL					AWAY_PPDA,
		NULL					HOME_XPTS,
		NULL					AWAY_XPTS
	from
	  	LANDING_UNDERSTAT.FIXTURES f
		--get division
		JOIN LANDING_MANUAL.DIVISION_MAPPING dm
			ON f."division_id" = dm."understat"
		--get home team
		JOIN LANDING_UNDERSTAT.TEAMS t_home
			ON f."home_team_id" = t_home."team_id" 
		JOIN LANDING_MANUAL.TEAM_MAPPING tm_home
			ON t_home."team_name" = tm_home."understat"
		--get away team
		JOIN LANDING_UNDERSTAT.TEAMS t_away
			ON f."away_team_id" = t_away."team_id" 
		JOIN LANDING_MANUAL.TEAM_MAPPING tm_away
			ON t_away."team_name" = tm_away."understat"
	)
	select
		hash_md5(src_base.football_division_hid || '#' || src_base.football_team_home_hid || '#' || src_base.football_team_away_hid || '#' || src_base.football_season_hid || '#' || to_char(his.match_date,'yyyymmdd')) football_match_his_lid,
		current_timestamp load_dts,
		HOME_GOALS,
		AWAY_GOALS,
		HOME_XGOALS,
		AWAY_XGOALS,
		HOME_SHOTS,
		AWAY_SHOTS,
		HOME_SHOTS_ON_TARGET,
		AWAY_SHOTS_ON_TARGET,
		HOME_DEEP,
		AWAY_DEEP,
		HOME_PPDA,
		AWAY_PPDA,
		HOME_XPTS,
		AWAY_XPTS,	
		current_timestamp audit_insert_date,
		'Understat' audit_record_source
	from
		src_base
    --understat got the wrong match-date for fixtures
    --that were moved -> match_date is lookuped through football-data
    join betting_dv.football_match_his_b his on
      src_base.football_division_hid = his.football_division_hid and
      src_base.football_season_hid = his.football_season_hid and
      src_base.football_team_home_hid = his.football_team_home_hid and
      src_base.football_team_away_hid = his.football_team_away_hid
	) src
on (src.football_match_his_lid = tgt.football_match_his_lid)
when matched then update set
	tgt.HOME_GOALS = src.HOME_GOALS,
	tgt.AWAY_GOALS = src.AWAY_GOALS,
	tgt.HOME_XGOALS = src.HOME_XGOALS,
	tgt.AWAY_XGOALS = src.AWAY_XGOALS,
	tgt.HOME_SHOTS = src.HOME_SHOTS,
	tgt.AWAY_SHOTS = src.AWAY_SHOTS,
	tgt.HOME_SHOTS_ON_TARGET = src.HOME_SHOTS_ON_TARGET,
	tgt.AWAY_SHOTS_ON_TARGET = src.AWAY_SHOTS_ON_TARGET,
	tgt.HOME_DEEP = src.HOME_DEEP,
	tgt.AWAY_DEEP = src.AWAY_DEEP,
	tgt.HOME_PPDA = src.HOME_PPDA,
	tgt.AWAY_PPDA = src.AWAY_PPDA,
	tgt.HOME_XPTS = src.HOME_XPTS,
	tgt.AWAY_XPTS = src.AWAY_XPTS,
	tgt.audit_insert_date		= src.audit_insert_date,
	tgt.audit_record_source		= src.audit_record_source
where
	--Full-time result has changed
	--> sufficient check for changed records
	tgt.home_goals <> src.home_goals or
	tgt.away_goals <> src.away_goals
when not matched then insert values
	(
	src.football_match_his_lid,
	src.HOME_GOALS,
	src.AWAY_GOALS,
	src.HOME_XGOALS,
	src.AWAY_XGOALS,
	src.HOME_SHOTS,
	src.AWAY_SHOTS,
	src.HOME_SHOTS_ON_TARGET,
	src.AWAY_SHOTS_ON_TARGET,
	src.HOME_DEEP,
	src.AWAY_DEEP,
	src.HOME_PPDA,
	src.AWAY_PPDA,
	src.HOME_XPTS,
	src.AWAY_XPTS,
	src.audit_insert_date,
	src.audit_record_source
	)
;
	

