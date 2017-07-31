/************************************************
	Betting mart view for
	all division and teams currently playing
	
	
v1.0:
	- initial
		

*************************************************/


create or replace view betting_mart.football_cur_teams_per_division
as
select
	division.division,
	team.team
from
	betting_dv.football_team_division_l lnk
	join betting_dv.football_team_h team
		on (lnk.football_team_hid = team.football_team_hid)
	join betting_dv.football_division_h division
		on (lnk.football_division_hid = division.football_division_hid)
	join betting_dv.football_season_h season
		on (lnk.football_season_hid = season.football_season_hid)
where
	season.season = (select
						max(season)
					from
						betting_dv.football_season_h
					)
;