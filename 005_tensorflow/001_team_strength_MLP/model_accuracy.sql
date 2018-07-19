--single games
select
	division.division,
	season.season,
	his.match_date,
	home.team home_team,
	away.team away_team,
	stat.full_time_home_goals,
	stat.full_time_away_goals,
	stat.full_time_result,
	round((1 / odds.bet365_home_odds) - (((1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds) -1 ) / 3),3) bet365_prob_home,
	round((1 / odds.bet365_draw_odds) - (((1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds) -1 ) / 3),3) bet365_prob_draw,
	round((1 / odds.bet365_away_odds) - (((1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds) -1 ) / 3),3) bet365_prob_away,
	round(zip.prob_home_win * 0.7 + event.his_prob_1 * 0.3, 4) poisson_prob_home,
	round(zip.prob_draw * 0.7 + event.his_prob_X * 0.3, 4) poisson_prob_draw,
	round(zip.prob_away_win * 0.7 + event.his_prob_2 * 0.3, 4) poisson_prob_away,
	mlp.prob_home_win mlp_prob_home,
	mlp.prob_draw mlp_prob_draw,
	mlp.prob_away_win mlp_prob_away
from
	betting_dv.football_match_his_l his
	join betting_dv.football_match_his_l_s_statistic stat
		on (his.football_match_his_lid = stat.football_match_his_lid)
	join betting_dv.football_match_his_l_s_odds odds
		on (his.football_match_his_lid = odds.football_match_his_lid)
	join betting_dv.football_match_his_l_s_eventbased_probs event
		on (his.football_match_his_lid = event.football_match_his_lid)
	join betting_dv.football_match_his_l_s_zip_probs zip
		on (his.football_match_his_lid = zip.football_match_his_lid)
	join betting_dv.football_season_h season
		on (his.football_season_hid = season.football_season_hid)
	join betting_dv.football_division_h division
		on (his.football_division_hid = division.football_division_hid)
	join betting_dv.football_team_h home
		on (his.football_team_home_hid = home.football_team_hid)
	join betting_dv.football_team_h away
		on (his.football_team_away_hid = away.football_team_hid)
	join sandbox.team_strength_mlp mlp
		on (his.football_match_his_lid = mlp.football_match_his_lid)
order by
	1,2,3;
	
	
--geometric mean
select
	division,
	season,
	betting_dv.geo_mean(case
			when full_time_result = 'H' then bet365_prob_home
			when full_time_result = 'D' then bet365_prob_draw
			when full_time_result = 'A' then bet365_prob_away
		end) bet365_acc,
	betting_dv.geo_mean(case
			when full_time_result = 'H' then poisson_prob_home
			when full_time_result = 'D' then poisson_prob_draw
			when full_time_result = 'A' then poisson_prob_away
		end) poisson_acc,
	betting_dv.geo_mean(case
			when full_time_result = 'H' then mlp_prob_home
			when full_time_result = 'D' then mlp_prob_draw
			when full_time_result = 'A' then mlp_prob_away
		end) mlp_acc
from
(
select
	division.division,
	season.season,
	his.match_date,
	home.team home_team,
	away.team away_team,
	stat.full_time_home_goals,
	stat.full_time_away_goals,
	stat.full_time_result,
	round((1 / odds.bet365_home_odds) - (((1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds) -1 ) / 3),3) bet365_prob_home,
	round((1 / odds.bet365_draw_odds) - (((1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds) -1 ) / 3),3) bet365_prob_draw,
	round((1 / odds.bet365_away_odds) - (((1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds) -1 ) / 3),3) bet365_prob_away,
	round(zip.prob_home_win * 0.7 + event.his_prob_1 * 0.3, 4) poisson_prob_home,
	round(zip.prob_draw * 0.7 + event.his_prob_X * 0.3, 4) poisson_prob_draw,
	round(zip.prob_away_win * 0.7 + event.his_prob_2 * 0.3, 4) poisson_prob_away,
	mlp.prob_home_win mlp_prob_home,
	mlp.prob_draw mlp_prob_draw,
	mlp.prob_away_win mlp_prob_away
from
	betting_dv.football_match_his_l his
	join betting_dv.football_match_his_l_s_statistic stat
		on (his.football_match_his_lid = stat.football_match_his_lid)
	join betting_dv.football_match_his_l_s_odds odds
		on (his.football_match_his_lid = odds.football_match_his_lid)
	join betting_dv.football_match_his_l_s_eventbased_probs event
		on (his.football_match_his_lid = event.football_match_his_lid)
	join betting_dv.football_match_his_l_s_zip_probs zip
		on (his.football_match_his_lid = zip.football_match_his_lid)
	join betting_dv.football_season_h season
		on (his.football_season_hid = season.football_season_hid)
	join betting_dv.football_division_h division
		on (his.football_division_hid = division.football_division_hid)
	join betting_dv.football_team_h home
		on (his.football_team_home_hid = home.football_team_hid)
	join betting_dv.football_team_h away
		on (his.football_team_away_hid = away.football_team_hid)
	join sandbox.team_strength_mlp mlp
		on (his.football_match_his_lid = mlp.football_match_his_lid)
)
group by
	1,2
order by
	1,2;
	
--brier score
select
	division,
	season,
	avg(case
			when full_time_result = 'H' then power(1-bet365_prob_home,2) + power(bet365_prob_draw,2) + power(bet365_prob_away,2)
			when full_time_result = 'D' then power(bet365_prob_home,2) + power(1-bet365_prob_draw,2) + power(bet365_prob_away,2)
			when full_time_result = 'A' then power(bet365_prob_home,2) + power(bet365_prob_draw,2) + power(1-bet365_prob_away,2)
		end) bet365_brier,
	avg(case
			when full_time_result = 'H' then power(1-poisson_prob_home,2) + power(poisson_prob_draw,2) + power(poisson_prob_away,2)
			when full_time_result = 'D' then power(poisson_prob_home,2) + power(1-poisson_prob_draw,2) + power(poisson_prob_away,2)
			when full_time_result = 'A' then power(poisson_prob_home,2) + power(poisson_prob_draw,2) + power(1-poisson_prob_away,2)
		end) poisson_brier,
	avg(case
			when full_time_result = 'H' then power(1-mlp_prob_home,2) + power(mlp_prob_draw,2) + power(mlp_prob_away,2)
			when full_time_result = 'D' then power(mlp_prob_home,2) + power(1-mlp_prob_draw,2) + power(mlp_prob_away,2)
			when full_time_result = 'A' then power(mlp_prob_home,2) + power(mlp_prob_draw,2) + power(1-mlp_prob_away,2)
		end) mlp_brier
from
(
select
	division.division,
	season.season,
	his.match_date,
	home.team home_team,
	away.team away_team,
	stat.full_time_home_goals,
	stat.full_time_away_goals,
	stat.full_time_result,
	round((1 / odds.bet365_home_odds) - (((1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds) -1 ) / 3),3) bet365_prob_home,
	round((1 / odds.bet365_draw_odds) - (((1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds) -1 ) / 3),3) bet365_prob_draw,
	round((1 / odds.bet365_away_odds) - (((1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds) -1 ) / 3),3) bet365_prob_away,
	round(zip.prob_home_win * 0.7 + event.his_prob_1 * 0.3, 4) poisson_prob_home,
	round(zip.prob_draw * 0.7 + event.his_prob_X * 0.3, 4) poisson_prob_draw,
	round(zip.prob_away_win * 0.7 + event.his_prob_2 * 0.3, 4) poisson_prob_away,
	mlp.prob_home_win mlp_prob_home,
	mlp.prob_draw mlp_prob_draw,
	mlp.prob_away_win mlp_prob_away
from
	betting_dv.football_match_his_l his
	join betting_dv.football_match_his_l_s_statistic stat
		on (his.football_match_his_lid = stat.football_match_his_lid)
	join betting_dv.football_match_his_l_s_odds odds
		on (his.football_match_his_lid = odds.football_match_his_lid)
	join betting_dv.football_match_his_l_s_eventbased_probs event
		on (his.football_match_his_lid = event.football_match_his_lid)
	join betting_dv.football_match_his_l_s_zip_probs zip
		on (his.football_match_his_lid = zip.football_match_his_lid)
	join betting_dv.football_season_h season
		on (his.football_season_hid = season.football_season_hid)
	join betting_dv.football_division_h division
		on (his.football_division_hid = division.football_division_hid)
	join betting_dv.football_team_h home
		on (his.football_team_home_hid = home.football_team_hid)
	join betting_dv.football_team_h away
		on (his.football_team_away_hid = away.football_team_hid)
	join sandbox.team_strength_mlp mlp
		on (his.football_match_his_lid = mlp.football_match_his_lid)
)
group by
	1,2
order by
	1,2;
