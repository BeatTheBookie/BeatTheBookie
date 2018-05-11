/************************************************
	Betting mart view for Poisson model probabilities
	for every current match
	
	
v1.0:
	- initial
	
*************************************************/


drop view betting_mart.football_poisson_probs;

create or replace view betting_mart.football_poisson_probs 
as
select
	division.division,
	season.season,
	cur.match_date,
	home.team home_team,
	away.team away_team,
	round(zip.prob_home_win * 0.7 + event.his_prob_1 * 0.3 ,4) home_win,
	round(zip.prob_draw * 0.7 + event.his_prob_x * 0.3 ,4) draw,
	round(zip.prob_away_win * 0.7 + event.his_prob_2 * 0.3 ,4) home_away
from
	betting_dv.football_match_cur_l cur
	join betting_dv.football_match_cur_l_s_zip_probs zip
		on (cur.football_match_cur_lid = zip.football_match_cur_lid)
	join betting_dv.football_match_cur_l_s_eventbased_probs event
		on (cur.football_match_cur_lid = event.football_match_cur_lid)
	join betting_dv.football_team_h home
		on (cur.football_team_home_hid = home.football_team_hid)
	join betting_dv.football_team_h away
		on (cur.football_team_away_hid = away.football_team_hid)
	join betting_dv.football_division_h division
		on (cur.football_division_hid = division.football_division_hid)
	join betting_dv.football_season_h season
		on (cur.football_season_hid = season.football_season_hid)
;