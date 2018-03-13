--fixed 2:1
select
	season,
	count(*) num_games,
	sum(gained_points) points
from
	(
select
	division,
	season,
	match_date,
	home_team,
	away_team,
	full_time_home_goals,
	full_time_away_goals,
	full_time_result,
	case
		when gs_comb_prob_home >= gs_comb_prob_away then 2
		else 1
	end bet_home_goals,
	case
		when gs_comb_prob_home < gs_comb_prob_away then 2
		else 1
	end bet_away_goals,
	case
		when local.bet_home_goals > local.bet_away_goals then 'H'
		when local.bet_home_goals = local.bet_away_goals then 'D'
		else 'A'
	end bet_result,
	case
		--correct score
		when local.bet_home_goals = full_time_home_goals and 
			local.bet_away_goals = full_time_away_goals then 4
		--correct goal difference
		when (local.bet_home_goals - local.bet_away_goals) =	(full_time_home_goals - full_time_away_goals) and
			(local.bet_home_goals - local.bet_away_goals) <> 0	then 3
		--correct trend
		when full_time_result = local.bet_result then 2
		--wrong bet
		else 0
	end gained_points
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
		round((1 / odds.bet365_home_odds) / (1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds),3) bet365_prob_home,
		round((1 / odds.bet365_draw_odds) / (1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds),3) bet365_prob_draw,
		round((1 / odds.bet365_away_odds) / (1/odds.bet365_home_odds + 1/odds.bet365_draw_odds + 1/odds.bet365_away_odds),3) bet365_prob_away,
		gs.comb_regr_prob_home_win gs_comb_prob_home,
		gs.comb_regr_prob_draw gs_comb_prob_draw,
		gs.comb_regr_prob_away_win gs_comb_prob_away
	from
		betting_dv.football_match_his_l his
	    join betting_dv.football_match_his_l_s_statistic stat
	    	on (his.football_match_his_lid = stat.football_match_his_lid)
	    join betting_dv.football_match_his_l_s_odds odds
			on (his.football_match_his_lid = odds.football_match_his_lid)
		join SANDBOX.FOOTBALL_MATCH_HIS_L_S_GS_comb_PROBS gs
			on (his.football_match_his_lid = gs.football_match_his_lid)	
		join betting_dv.football_season_h season
	    	on (his.football_season_hid = season.football_season_hid)
	    join betting_dv.football_division_h division
	    	on (his.football_division_hid = division.football_division_hid)
	    join betting_dv.football_team_h home
	    	on (his.football_team_home_hid = home.football_team_hid)
	    join betting_dv.football_team_h away
	    	on (his.football_team_away_hid = away.football_team_hid)
	where
		season in ('2013_2014','2014_2015','2015_2016','2016_2017') and
		division = 'D1'
	)
)
group by
	1
order by
	1 desc;

	
--variable
select
	season,
	count(*) num_games,
	sum(gained_points) points
from
	(
select
	division,
	season,
	match_date,
	home_team,
	away_team,
	full_time_home_goals,
	full_time_away_goals,
	full_time_result,
	home_goals,
	away_goals,
	case
		--heim sieg
		when gs_comb_prob_home >= gs_comb_prob_away then 
			case 
				when home_goals = away_goals then home_goals + 1
				when home_goals < away_goals then away_goals + 1
				when home_goals > away_goals then home_goals
			end				
		--auswärtssieg
		when gs_comb_prob_home < gs_comb_prob_away then
			case 
				when home_goals = away_goals then home_goals
				when home_goals < away_goals then home_goals
				when home_goals > away_goals then home_goals
			end
	end bet_home_goals,
	case
		--heim sieg
		when gs_comb_prob_home >= gs_comb_prob_away then 
			case 
				when home_goals = away_goals then away_goals
				when home_goals < away_goals then away_goals
				when home_goals > away_goals then away_goals
			end
		--auswärtssieg 	
		when gs_comb_prob_home < gs_comb_prob_away then
			case
				when home_goals = away_goals then away_goals + 1
				when home_goals < away_goals then away_goals
				when home_goals > away_goals then home_goals + 1
			end
	end bet_away_goals,
	case
		when local.bet_home_goals > local.bet_away_goals then 'H'
		when local.bet_home_goals = local.bet_away_goals then 'D'
		else 'A'
	end bet_result,
	case
		--correct score
		when local.bet_home_goals = full_time_home_goals and 
			local.bet_away_goals = full_time_away_goals then 4
		--correct goal difference
		when (local.bet_home_goals - local.bet_away_goals) =	(full_time_home_goals - full_time_away_goals) and
			(local.bet_home_goals - local.bet_away_goals) <> 0	then 3
		--correct trend
		when full_time_result = local.bet_result then 2
		--wrong bet
		else 0
	end gained_points
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
		gs_stat.gs_match_rating,
		gs_prob.comb_regr_prob_home_win gs_comb_prob_home,
		gs_prob.comb_regr_prob_draw gs_comb_prob_draw,
		gs_prob.comb_regr_prob_away_win gs_comb_prob_away,
		round(gs_stat.home_goals_scored / 7,0) home_goals,
		round(gs_stat.away_goals_scored / 7,0) away_goals,
		local.home_goals - local.away_goals goal_diff
	from
		betting_dv.football_match_his_l his
	    join betting_dv.football_match_his_l_s_statistic stat
	    	on (his.football_match_his_lid = stat.football_match_his_lid)
		join BETTING_DV.FOOTBALL_MATCH_HIS_L_S_RATING_FEATURES_7 gs_stat
			on (his.football_match_his_lid = gs_stat.football_match_his_lid)	
		join SANDBOX.FOOTBALL_MATCH_HIS_L_S_GS_comb_PROBS gs_prob
			on (his.football_match_his_lid = gs_prob.football_match_his_lid)	
		join betting_dv.football_season_h season
	    	on (his.football_season_hid = season.football_season_hid)
	    join betting_dv.football_division_h division
	    	on (his.football_division_hid = division.football_division_hid)
	    join betting_dv.football_team_h home
	    	on (his.football_team_home_hid = home.football_team_hid)
	    join betting_dv.football_team_h away
	    	on (his.football_team_away_hid = away.football_team_hid)
	where
		season in ('2013_2014','2014_2015','2015_2016','2016_2017') and
		--season = '2016_2017' and
		division = 'D1'
	)
)
group by
	1
order by
	1 desc
;
	