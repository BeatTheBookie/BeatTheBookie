

/************************************************
	betting vault division table link
	- link for all division tables at each possible date
	
v1.0:
	- initial
	
v1.1:
	- filter for focus divisions

		
*************************************************/


create or replace table betting_dv.football_division_table_l as
select
	hash_md5(dates.football_division_hid || '#' || dates.football_season_hid || '#' || teams.football_team_hid || '#' || dates.match_date) football_division_table_lid,
	dates.football_division_hid,
	dates.football_season_hid,
	teams.football_team_hid,
	dates.match_date
from
	(
	select
		his.football_division_hid,
		his.football_season_hid,
		his.football_team_home_hid football_team_hid	
	from
		raw_dv.football_match_his_l his
		join raw_dv.football_division_h division on
			his.football_division_hid = division.football_division_hid
	where
		division.division in ('D1','D2','E0','F2','I1','SP1')
	union
	select
		his.football_division_hid,
		his.football_season_hid,
		his.football_team_away_hid football_team_hid
	from
		raw_dv.football_match_his_l his
		join raw_dv.football_division_h division on
			his.football_division_hid = division.football_division_hid
	where
		division.division in ('D1','D2','E0','F1','I1','SP1')
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