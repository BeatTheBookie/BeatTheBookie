/*****************************

football_games_per_divsion.

dq check for
Link football match history

- number of games per division and season
- check for number of games
- number of distinct home teams
- number of distinct away teams

-GER
	-D1: 306 / 306 / 18 / 18
	-D2: 306 / 306 / 18 / 18
-ENG
	-E0: 380 / 380 / 20 / 20
-ESP
	-SP1: 380 / 380 / 20 / 20
	
-ITA
	-I1: 380 / 380 / 20 / 20
	
-FRA

*****************************/	

create or replace view dq_mart.football_teams_games_per_division
as
select
	division.country,
	division.division,
	season.season,
	count(*) num_matches,
	count(distinct lnk.football_team_home_hid) / 2 * (count(distinct lnk.football_team_home_hid)-1) * 2 num_matches_check,
	count(distinct lnk.football_team_home_hid) num_distinct_home_teams,
	count(distinct lnk.football_team_away_hid) num_distinct_away_teams
from
	raw_dv.football_match_his_l lnk
	join raw_dv.FOOTBALL_SEASON_H season
		on (lnk.football_season_hid = season.football_season_hid)
	join raw_dv.football_division_h division
		on (lnk.football_division_hid = division.football_division_hid)
	join raw_dv.FOOTBALL_MATCH_HIS_L_S_STATISTIC stat
		on (lnk.FOOTBALL_MATCH_HIS_LID = stat.FOOTBALL_MATCH_HIS_LID)
	join raw_dv.FOOTBALL_MATCH_HIS_L_S_ODDS odds
		on (lnk.FOOTBALL_MATCH_HIS_LID = odds.FOOTBALL_MATCH_HIS_LID)
	join raw_dv.football_team_h home
		on (lnk.football_team_home_hid = home.football_team_hid)
	join raw_dv.football_team_h away
		on (lnk.football_team_away_hid = away.football_team_hid)
group by
	division.country,
	division.division,
	season.season;