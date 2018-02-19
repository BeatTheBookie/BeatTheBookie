

/************************************************
	betting vault division table link
	- link for all division tables at each possible date
	
v1.0:
	- initial

		
*************************************************/


create or replace view betting_dv.football_division_table_l as
select
	hash_md5(dates.football_division_hid || '#' || dates.football_season_hid || '#' || teams.football_team_hid || '#' || dates.match_date) football_division_table_lid,
	dates.football_division_hid,
	dates.football_season_hid,
	teams.football_team_hid,
	dates.match_date
from
	(
	select
		football_division_hid,
		football_season_hid,
		football_team_home_hid football_team_hid	
	from
		raw_dv.football_match_his_l
	union
	select
		football_division_hid,
		football_season_hid,
		football_team_away_hid football_team_hid
	from
		raw_dv.football_match_his_l
	) teams
	join
	(
	select distinct
		football_division_hid,
		football_season_hid,
		match_date
	from
		raw_dv.football_match_his_l
	) dates
	on (teams.football_division_hid = dates.football_division_hid and
		teams.football_season_hid = dates.football_season_hid)
;