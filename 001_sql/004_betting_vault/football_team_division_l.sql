

/************************************************
	betting vault team division link
	- link for all teams playing in divsion & season
	
v1.0:
	- initial

		
*************************************************/


create or replace view betting_dv.football_team_division_l as
select distinct
	hash_md5(football_season_hid || '#' || football_division_hid || '#' || football_team_home_hid) football_team_division_lid,
	football_season_hid,
	football_division_hid,
	football_team_home_hid football_team_hid
from
	raw_dv.football_match_his_l
union
select distinct
	hash_md5(football_season_hid || '#' || football_division_hid || '#' || football_team_away_hid) football_team_division_lid,
	football_season_hid,
	football_division_hid,
	football_team_away_hid
from
	raw_dv.football_match_his_l
;
