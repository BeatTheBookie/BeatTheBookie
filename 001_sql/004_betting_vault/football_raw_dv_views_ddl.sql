

/************************************************
	betting vault views for 1:1 historic football
	data of raw data vault 
	
v1.0:
	- views for following tables
		- football_team_h
		- football_division_h
		- football_match_his_l
		- football_match_his_l_s_statistic
		
v2.0:
	- new views
		- football_match_cur_l

*************************************************/


--football_match_cur_l
create or replace view betting_dv.football_match_cur_l
as
select
	football_match_cur_lid,
	football_division_hid,
	football_team_home_hid,
	football_team_away_hid,
	football_season_hid,
	match_date,
	audit_insert_date,
	audit_record_source
from
	raw_dv.football_match_cur_l
;


--football_team_h
create or replace view betting_dv.football_team_h as
select
	football_team_hid,
	team,
	audit_insert_date,
	audit_record_source
from
	raw_dv.football_team_h;
	
--football_division_h
create or replace view betting_dv.football_division_h as
select
	football_division_hid,
	division,
	country,	
	audit_insert_date,
	audit_record_source
from
	raw_dv.football_division_h;
	
--football_season_h
create or replace view betting_dv.football_season_h as
select
	football_season_hid,
	season,
	audit_insert_date,
	audit_record_source
from
	raw_dv.football_season_h;
	
--football_team_division_l
create or replace view betting_dv.football_team_division_l as
select
	football_team_division_lid,
	football_season_hid,
	football_division_hid,
	football_team_hid,
	audit_insert_date,
	audit_record_source
from
	raw_dv.football_team_division_l;
	
--football_match_his_l
create or replace view betting_dv.football_match_his_l as
select
	football_match_his_lid,
	football_division_hid,
	football_team_home_hid,
	football_team_away_hid,
	football_season_hid,
	match_date,
	audit_insert_date,
	audit_record_source
from
	raw_dv.football_match_his_l;
	
--football_match_his_l_s_statistic
create or replace view betting_dv.football_match_his_l_s_statistic as
select
	football_match_his_lid,
	load_dts,
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
	audit_insert_date,
	audit_record_source
from
	raw_dv.football_match_his_l_s_statistic;
	
--football_match_his_l_s_odds
create or replace view betting_dv.football_match_his_l_s_odds as
select
	football_match_his_lid,
	load_dts,
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
	BETBREIN_AVG_DRAW_ODDS BETBRAIN_AVG_DRAW_ODDS,
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
	audit_insert_date,
	audit_record_source
from
	raw_dv.football_match_his_l_s_odds;