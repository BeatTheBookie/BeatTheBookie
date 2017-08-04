/************************************************
	Betting mart view for Poisson value betting
	
	
v1.0:
	- initial
	- fair_prob = 0.7 * zip_prob + 0.3 * his_prob
	- betting markets:
		- 1/x/2

*************************************************/


create or replace view betting_mart.football_poisson_value_betting
as
select
	cur.match_date,
	division.division,
	home.team home_team,
	away.team away_team,
	'Back Home' betting_market,
	zip_probs.home_expect_goals,
	zip_probs.away_expect_goals,
	zip_probs.prob_home_win zip_prob,
	decode(local.zip_prob,0,100,round(1 / (local.zip_prob), 2)) zip_odd,
	event_probs.his_prob_1 his_prob,
	decode(local.his_prob,0,100,round(1 / (local.his_prob), 2)) his_odd,
	event_probs.direct_prob_1 direct_prob,
	decode(local.direct_prob,0,100,round(1 / (local.direct_prob), 2)) direct_odd,
	round(local.zip_prob * 0.7 + local.his_prob * 0.3, 4) fair_prob,
	decode(local.fair_prob,0,100,round(1 / (local.fair_prob), 2)) fair_odd,
	null market_prob,
	null market_odd,
	null bet_value
from
	betting_dv.football_match_cur_l cur
	join betting_dv.football_match_cur_l_s_eventbased_probs event_probs
		on (cur.football_match_cur_lid = event_probs.football_match_cur_lid)
	join betting_dv.football_match_cur_l_s_zip_probs zip_probs
		on (cur.football_match_cur_lid = zip_probs.football_match_cur_lid)
	join betting_dv.football_team_h home
		on cur.football_team_home_hid = home.football_team_hid
	join betting_dv.football_team_h away
		on cur.football_team_away_hid = away.football_team_hid
	join betting_dv.football_season_h season
		on cur.football_season_hid = season.football_season_hid
	join betting_dv.football_division_h division
		on cur.football_division_hid = division.football_division_hid
where
	division.division = 'D1'
union all
select
	cur.match_date,
	division.division,
	home.team home_team,
	away.team away_team,
	'Lay Home' betting_market,
	zip_probs.home_expect_goals,
	zip_probs.away_expect_goals,
	1 - zip_probs.prob_home_win zip_prob,
	decode(local.zip_prob,0,100,round(1 / (local.zip_prob), 2)) zip_odd,
	1 - event_probs.his_prob_1 his_prob,
	decode(local.his_prob,0,100,round(1 / (local.his_prob), 2)) his_odd,
	1 - event_probs.direct_prob_1 direct_prob,
	decode(local.direct_prob,0,100,round(1 / (local.direct_prob), 2)) direct_odd,
	round(local.zip_prob * 0.7 + local.his_prob * 0.3, 4) fair_prob,
	decode(local.fair_prob,0,100,round(1 / (local.fair_prob), 2)) fair_odd,
	null market_prob,
	null market_odd,
	null bet_value
from
	betting_dv.football_match_cur_l cur
	join betting_dv.football_match_cur_l_s_eventbased_probs event_probs
		on (cur.football_match_cur_lid = event_probs.football_match_cur_lid)
	join betting_dv.football_match_cur_l_s_zip_probs zip_probs
		on (cur.football_match_cur_lid = zip_probs.football_match_cur_lid)
	join betting_dv.football_team_h home
		on cur.football_team_home_hid = home.football_team_hid
	join betting_dv.football_team_h away
		on cur.football_team_away_hid = away.football_team_hid
	join betting_dv.football_season_h season
		on cur.football_season_hid = season.football_season_hid
	join betting_dv.football_division_h division
		on cur.football_division_hid = division.football_division_hid
where
	division.division = 'D1'
union all
select
	cur.match_date,
	division.division,
	home.team home_team,
	away.team away_team,
	'Back Draw' betting_market,
	zip_probs.home_expect_goals,
	zip_probs.away_expect_goals,
	zip_probs.prob_draw zip_prob,
	decode(local.zip_prob,0,100,round(1 / (local.zip_prob), 2)) zip_odd,
	event_probs.his_prob_x his_prob,
	decode(local.his_prob,0,100,round(1 / (local.his_prob), 2)) his_odd,
	event_probs.direct_prob_x direct_prob,
	decode(local.direct_prob,0,100,round(1 / (local.direct_prob), 2)) direct_odd,
	round(local.zip_prob * 0.7 + local.his_prob * 0.3, 4) fair_prob,
	decode(local.fair_prob,0,100,round(1 / (local.fair_prob), 2)) fair_odd,
	null market_prob,
	null market_odd,
	null bet_value
from
	betting_dv.football_match_cur_l cur
	join betting_dv.football_match_cur_l_s_eventbased_probs event_probs
		on (cur.football_match_cur_lid = event_probs.football_match_cur_lid)
	join betting_dv.football_match_cur_l_s_zip_probs zip_probs
		on (cur.football_match_cur_lid = zip_probs.football_match_cur_lid)
	join betting_dv.football_team_h home
		on cur.football_team_home_hid = home.football_team_hid
	join betting_dv.football_team_h away
		on cur.football_team_away_hid = away.football_team_hid
	join betting_dv.football_season_h season
		on cur.football_season_hid = season.football_season_hid
	join betting_dv.football_division_h division
		on cur.football_division_hid = division.football_division_hid
where
	division.division = 'D1'
union all
select
	cur.match_date,
	division.division,
	home.team home_team,
	away.team away_team,
	'Lay Draw' betting_market,
	zip_probs.home_expect_goals,
	zip_probs.away_expect_goals,
	1 - zip_probs.prob_draw zip_prob,
	decode(local.zip_prob,0,100,round(1 / (local.zip_prob), 2)) zip_odd,
	1 - event_probs.his_prob_x his_prob,
	decode(local.his_prob,0,100,round(1 / (local.his_prob), 2)) his_odd,
	1 - event_probs.direct_prob_x direct_prob,
	decode(local.direct_prob,0,100,round(1 / (local.direct_prob), 2)) direct_odd,
	round(local.zip_prob * 0.7 + local.his_prob * 0.3, 4) fair_prob,
	decode(local.fair_prob,0,100,round(1 / (local.fair_prob), 2)) fair_odd,
	null market_prob,
	null market_odd,
	null bet_value
from
	betting_dv.football_match_cur_l cur
	join betting_dv.football_match_cur_l_s_eventbased_probs event_probs
		on (cur.football_match_cur_lid = event_probs.football_match_cur_lid)
	join betting_dv.football_match_cur_l_s_zip_probs zip_probs
		on (cur.football_match_cur_lid = zip_probs.football_match_cur_lid)
	join betting_dv.football_team_h home
		on cur.football_team_home_hid = home.football_team_hid
	join betting_dv.football_team_h away
		on cur.football_team_away_hid = away.football_team_hid
	join betting_dv.football_season_h season
		on cur.football_season_hid = season.football_season_hid
	join betting_dv.football_division_h division
		on cur.football_division_hid = division.football_division_hid
where
	division.division = 'D1'
union all
select
	cur.match_date,
	division.division,
	home.team home_team,
	away.team away_team,
	'Back Away' betting_market,
	zip_probs.home_expect_goals,
	zip_probs.away_expect_goals,
	zip_probs.prob_away_win zip_prob,
	decode(local.zip_prob,0,100,round(1 / (local.zip_prob), 2)) zip_odd,
	event_probs.his_prob_2 his_prob,
	decode(local.his_prob,0,100,round(1 / (local.his_prob), 2)) his_odd,
	event_probs.direct_prob_2 direct_prob,
	decode(local.direct_prob,0,100,round(1 / (local.direct_prob), 2)) direct_odd,
	round(local.zip_prob * 0.7 + local.his_prob * 0.3, 4) fair_prob,
	decode(local.fair_prob,0,100,round(1 / (local.fair_prob), 2)) fair_odd,
	null market_prob,
	null market_odd,
	null bet_value
from
	betting_dv.football_match_cur_l cur
	join betting_dv.football_match_cur_l_s_eventbased_probs event_probs
		on (cur.football_match_cur_lid = event_probs.football_match_cur_lid)
	join betting_dv.football_match_cur_l_s_zip_probs zip_probs
		on (cur.football_match_cur_lid = zip_probs.football_match_cur_lid)
	join betting_dv.football_team_h home
		on cur.football_team_home_hid = home.football_team_hid
	join betting_dv.football_team_h away
		on cur.football_team_away_hid = away.football_team_hid
	join betting_dv.football_season_h season
		on cur.football_season_hid = season.football_season_hid
	join betting_dv.football_division_h division
		on cur.football_division_hid = division.football_division_hid
where
	division.division = 'D1'
union all
select
	cur.match_date,
	division.division,
	home.team home_team,
	away.team away_team,
	'Lay Away' betting_market,
	zip_probs.home_expect_goals,
	zip_probs.away_expect_goals,
	1 - zip_probs.prob_away_win zip_prob,
	decode(local.zip_prob,0,100,round(1 / (local.zip_prob), 2)) zip_odd,
	1 - event_probs.his_prob_2 his_prob,
	decode(local.his_prob,0,100,round(1 / (local.his_prob), 2)) his_odd,
	1 - event_probs.direct_prob_2 direct_prob,
	decode(local.direct_prob,0,100,round(1 / (local.direct_prob), 2)) direct_odd,
	round(local.zip_prob * 0.7 + local.his_prob * 0.3, 4) fair_prob,
	decode(local.fair_prob,0,100,round(1 / (local.fair_prob), 2)) fair_odd,
	null market_prob,
	null market_odd,
	null bet_value
from
	betting_dv.football_match_cur_l cur
	join betting_dv.football_match_cur_l_s_eventbased_probs event_probs
		on (cur.football_match_cur_lid = event_probs.football_match_cur_lid)
	join betting_dv.football_match_cur_l_s_zip_probs zip_probs
		on (cur.football_match_cur_lid = zip_probs.football_match_cur_lid)
	join betting_dv.football_team_h home
		on cur.football_team_home_hid = home.football_team_hid
	join betting_dv.football_team_h away
		on cur.football_team_away_hid = away.football_team_hid
	join betting_dv.football_season_h season
		on cur.football_season_hid = season.football_season_hid
	join betting_dv.football_division_h division
		on cur.football_division_hid = division.football_division_hid
where
	division.division = 'D1'
;	