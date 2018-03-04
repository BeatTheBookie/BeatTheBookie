select
	division,
	season,
	avg(case
			when full_time_result = 'H' then bet365_prob_home
			when full_time_result = 'D' then bet365_prob_draw
			when full_time_result = 'A' then bet365_prob_away
		end) bet365_acc,
	avg(case
			when full_time_result = 'H' then poisson_prob_home
			when full_time_result = 'D' then poisson_prob_draw
			when full_time_result = 'A' then poisson_prob_away
		end) poisson_acc,
	avg(case
			when full_time_result = 'H' then gs_lin_prob_home
			when full_time_result = 'D' then gs_lin_prob_draw
			when full_time_result = 'A' then gs_lin_prob_away
		end) gs_lin_acc,
	avg(case
			when full_time_result = 'H' then gs_poly_prob_home
			when full_time_result = 'D' then gs_poly_prob_draw
			when full_time_result = 'A' then gs_poly_prob_away
		end) gs_poly_acc,
	avg(case
			when full_time_result = 'H' then gs_poly_woo_prob_home
			when full_time_result = 'D' then gs_poly_woo_prob_draw
			when full_time_result = 'A' then gs_poly_woo_prob_away
		end) gs_poly_woo_acc,
	avg(case
			when full_time_result = 'H' then ppg_lin_prob_home
			when full_time_result = 'D' then ppg_lin_prob_draw
			when full_time_result = 'A' then ppg_lin_prob_away
		end) ppg_lin_acc,
	avg(case
			when full_time_result = 'H' then ppg_poly_prob_home
			when full_time_result = 'D' then ppg_poly_prob_draw
			when full_time_result = 'A' then ppg_poly_prob_away
		end) ppg_poly_acc,
	avg(case
			when full_time_result = 'H' then ppg_poly_woo_prob_home
			when full_time_result = 'D' then ppg_poly_woo_prob_draw
			when full_time_result = 'A' then ppg_poly_woo_prob_away
		end) ppg_poly_woo_acc
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
		gs.gs_match_rating,
		ppg.ppg_match_rating,
		round((1 / odds.bet365_home_odds) / (1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds),3) bet365_prob_home,
		round((1 / odds.bet365_draw_odds) / (1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds),3) bet365_prob_draw,
		round((1 / odds.bet365_away_odds) / (1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds),3) bet365_prob_away,
		round(zip.prob_home_win * 0.7 + event.his_prob_1 * 0.3, 4) poisson_prob_home,
		round(zip.prob_draw * 0.7 + event.his_prob_X * 0.3, 4) poisson_prob_draw,
		round(zip.prob_away_win * 0.7 + event.his_prob_2 * 0.3, 4) poisson_prob_away,
		gs.lin_regr_prob_home_win gs_lin_prob_home,
		gs.lin_regr_prob_draw gs_lin_prob_draw,
		gs.lin_regr_prob_away_win gs_lin_prob_away,
		gs.poly_regr_prob_home_win gs_poly_prob_home,
		gs.poly_regr_prob_draw gs_poly_prob_draw,
		gs.poly_regr_prob_away_win gs_poly_prob_away,
		gs.poly_regr_woo_prob_home_win gs_poly_woo_prob_home,
		gs.poly_regr_woo_prob_draw gs_poly_woo_prob_draw,
		gs.poly_regr_woo_prob_away_win gs_poly_woo_prob_away,
		ppg.lin_regr_prob_home_win ppg_lin_prob_home,
		ppg.lin_regr_prob_draw ppg_lin_prob_draw,
		ppg.lin_regr_prob_away_win ppg_lin_prob_away,
		ppg.poly_regr_prob_home_win ppg_poly_prob_home,
		ppg.poly_regr_prob_draw ppg_poly_prob_draw,
		ppg.poly_regr_prob_away_win ppg_poly_prob_away,
		ppg.poly_regr_woo_prob_home_win ppg_poly_woo_prob_home,
		ppg.poly_regr_woo_prob_draw ppg_poly_woo_prob_draw,
		ppg.poly_regr_woo_prob_away_win ppg_poly_woo_prob_away
	from
		betting_dv.football_match_his_l his
	    join betting_dv.football_match_his_l_s_statistic stat
	    	on (his.football_match_his_lid = stat.football_match_his_lid)
	    join betting_dv.football_match_his_l_s_odds odds
			on (his.football_match_his_lid = odds.football_match_his_lid)
		join SANDBOX.FOOTBALL_MATCH_HIS_L_S_GS_RATING_PROBS gs
			on (his.football_match_his_lid = gs.football_match_his_lid)
		join SANDBOX.FOOTBALL_MATCH_HIS_L_S_PPG_RATING_PROBS ppg
			on (his.football_match_his_lid = ppg.football_match_his_lid)
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
	)
group by
	1,2
order by
	1,2;