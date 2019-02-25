/*****************************

football teams per divsion

dq check for
Link football team division

number of teams per division and season:

-GER
	-D1: 18
	-D2: 18
- ENG
	-E0: 20

- ESP
	-SP1: 18
- ITA
	-I1: 20
	
- FRA:
	-F1:

*****************************/

create or replace view dq_mart.football_teams_per_division
as
select
	division.country,
	division.division,
	season.season,
	count(*) num_teams
from
	raw_dv.football_team_division_l lnk
	join raw_dv.FOOTBALL_SEASON_H season
		on (lnk.football_season_hid = season.football_season_hid)
	join raw_dv.football_division_h division
		on (lnk.football_division_hid = division.football_division_hid)
	join raw_dv.football_team_h team
		on (lnk.football_team_hid = team.football_team_hid)
group by
	division.country,
	division.division,
	season.season
;