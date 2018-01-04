
/************************************************
	ETL processes for loading DV model for current
	match data
	
v1.0:
	- ELT for tables
		- football_match_cur_ref
		
v2.0:
	- changes to Squawka current matches
		


*************************************************/


----------------------------------------
--load link table FOOTBALL_MATCH_CUR_L--
----------------------------------------

truncate table raw_dv.football_match_cur_l
;

insert into raw_dv.football_match_cur_l
	(
	football_match_cur_lid,
	football_division_hid,
	football_team_home_hid,
	football_team_away_hid,
	football_season_hid,
	match_date,
	audit_insert_date,
	audit_record_source
	)
select
	hash_md5(division.football_division_hid || '#' || team_home.football_team_hid || '#' || team_away.football_team_hid || '#' || season.football_season_hid || '#' || to_char(cur.match_date,'yyyymmdd')) football_match_cur_lid,
	division.football_division_hid,
	team_home.football_team_hid football_team_home_hid,
	team_away.football_team_hid football_team_away_hid,
	season.football_season_hid,
	cur.match_date,
	current_timestamp,
	'load FOOTBALL_MATCH_CUR_L'
from
	stage.squawka_cur_fixtures cur
	join raw_dv.football_team_h team_home
		on (cur.team_home = team_home.team)
	join raw_dv.football_team_h team_away
		on (cur.team_away = team_away.team)
	join raw_dv.football_division_h division
		on (cur.division = division.division)
	join (
		select
			football_season_hid	
		from
			raw_dv.football_season_h
		where
			season = (
					select
						max(season)
					from
						raw_dv.football_season_h
					)
			) season
		on (1=1)
;