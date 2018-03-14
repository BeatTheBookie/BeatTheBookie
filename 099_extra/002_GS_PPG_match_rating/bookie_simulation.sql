--single games
with markets as
(
select 'Back Home' betting_market from dual
union all
select 'Lay Home' from dual
union all
select 'Back Draw' from dual
union all
select 'Lay Draw' from dual
union all
select 'Back Away' from dual
union all
select 'Lay Away' from dual
)
	select
		division.division,
		season.season,
		his.match_date,
		home.team home_team,
		away.team away_team,
		stat.full_time_home_goals,
		stat.full_time_away_goals,
		stat.full_time_result, 
		markets.betting_market betting_market,
		round(1 / odds.bet365_home_odds, 2) + round(1 / odds.bet365_draw_odds, 2) + round(1 / odds.bet365_away_odds, 2) bet365_overall,
		round(round(1 / odds.bet365_home_odds, 2) / local.bet365_overall,2) bet365_home_prob_clean,
		round(round(1 / odds.bet365_draw_odds, 2) / local.bet365_overall,2) bet365_draw_prob_clean,
		round(round(1 / odds.bet365_away_odds, 2) / local.bet365_overall,2) bet365_away_prob_clean,
		case
			when local.betting_market = 'Back Home' then  local.bet365_home_prob_clean
			when local.betting_market = 'Lay Home' then  1 - local.bet365_home_prob_clean
			when local.betting_market = 'Back Draw' then  local.bet365_draw_prob_clean
			when local.betting_market = 'Lay Draw' then  1 - local.bet365_draw_prob_clean
			when local.betting_market = 'Back Away' then  local.bet365_away_prob_clean
			when local.betting_market = 'Lay Away' then  1 - local.bet365_away_prob_clean
		end bet365_prob_clean,
		case
			when local.betting_market = 'Back Home' then  round(1 / odds.bet365_home_odds, 2)
			when local.betting_market = 'Lay Home' then  local.bet365_overall - round(1 / odds.bet365_home_odds, 2)
			when local.betting_market = 'Back Draw' then  round(1 / odds.bet365_draw_odds, 2)
			when local.betting_market = 'Lay Draw' then  local.bet365_overall - round(1 / odds.bet365_draw_odds, 2)
			when local.betting_market = 'Back Away' then  round(1 / odds.bet365_away_odds, 2)
			when local.betting_market = 'Lay Away' then  local.bet365_overall - round(1 / odds.bet365_away_odds, 2)
		end bet365_prob,
		case
			when local.betting_market = 'Back Home' then odds.bet365_home_odds
			when local.betting_market = 'Lay Home' then  round(1 / (local.bet365_overall - round(1 / odds.bet365_home_odds, 2)),2)
			when local.betting_market = 'Back Draw' then odds.bet365_draw_odds
			when local.betting_market = 'Lay Draw' then  round(1 / (local.bet365_overall - round(1 / odds.bet365_draw_odds, 2)),2)
			when local.betting_market = 'Back Away' then  odds.bet365_away_odds
			when local.betting_market = 'Lay Away' then  round(1 / (local.bet365_overall - round(1 / odds.bet365_away_odds, 2)),2)
		end bet365_odds,
		case
			when local.betting_market = 'Back Home' then	round(gs_prob.comb_regr_prob_home_win ,4)
			when local.betting_market = 'Lay Home' then 	1 - round(gs_prob.comb_regr_prob_home_win ,4)
			when local.betting_market = 'Back Draw' then	round(gs_prob.comb_regr_prob_draw ,4)
			when local.betting_market = 'Lay Draw' then  	1 - round(gs_prob.comb_regr_prob_draw ,4)
			when local.betting_market = 'Back Away' then  	round(gs_prob.comb_regr_prob_away_win ,4)
			when local.betting_market = 'Lay Away' then  	1 - round(gs_prob.comb_regr_prob_away_win ,4)
		end fair_prob,
		decode(local.fair_prob,0,100, round(1 / local.fair_prob,2)) fair_odd,
		case 
			when local.fair_odd = 1 then 100
			else round((local.bet365_odds - 1)/(local.fair_odd - 1)-1,2) 
		end bet_value,
		case
			when local.betting_market = 'Back Home' and stat.full_time_result = 'H' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Lay Home' and stat.full_time_result <> 'H' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Back Draw' and stat.full_time_result = 'D' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Lay Draw' and stat.full_time_result <> 'D' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Back Away' and stat.full_time_result = 'A' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Lay Away' and stat.full_time_result <> 'A' then 10 * local.bet365_odds - 10
			else -10
		end profit_loose, 
		rank() over (partition by division.division, season.season, his.match_date, home.team, away.team order by local.bet_value desc) rang
	from
		betting_dv.football_match_his_l his
		join markets
			on (1=1)
		join SANDBOX.FOOTBALL_MATCH_HIS_L_S_GS_comb_PROBS gs_prob
			on (his.football_match_his_lid = gs_prob.football_match_his_lid)
		join betting_dv.football_match_his_l_s_odds odds
			on (his.football_match_his_lid = odds.football_match_his_lid) 
		join betting_dv.FOOTBALL_MATCH_HIS_L_S_STATISTIC stat
			on (his.football_match_his_lid = stat.football_match_his_lid)
		join betting_dv.football_team_h home
			on (his.football_team_home_hid = home.football_team_hid)
		join betting_dv.football_team_h away
			on (his.football_team_away_hid = away.football_team_hid)
		join betting_dv.football_division_h division
			on (his.football_division_hid = division.football_division_hid)
		join betting_dv.football_season_h season
			on (his.football_season_hid = season.football_season_hid)
	where
		--local.bet365_prob > 0.1 and
		--local.bet_value > 0.2 and
		division.division = 'D1' and
		season.season in ('2016_2017')
order by
	1,2;
	
--season aggregate
with markets as
(
select 'Back Home' betting_market from dual
union all
select 'Lay Home' from dual
union all
select 'Back Draw' from dual
union all
select 'Lay Draw' from dual
union all
select 'Back Away' from dual
union all
select 'Lay Away' from dual
)
select
	division,
	season,
	count(*) num_bets,
	sum(case when profit_loose > 0 then 1 else 0 end) num_won_bets,
	round(avg(bet365_prob),2) exp_hitrate,
	round(local.num_won_bets / local.num_bets,2) real_hitrate,
	sum(profit_loose) profit_loose
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
		markets.betting_market betting_market,
		round(1 / odds.bet365_home_odds, 2) + round(1 / odds.bet365_draw_odds, 2) + round(1 / odds.bet365_away_odds, 2) bet365_overall,
		round(round(1 / odds.bet365_home_odds, 2) / local.bet365_overall,2) bet365_home_prob_clean,
		round(round(1 / odds.bet365_draw_odds, 2) / local.bet365_overall,2) bet365_draw_prob_clean,
		round(round(1 / odds.bet365_away_odds, 2) / local.bet365_overall,2) bet365_away_prob_clean,
		case
			when local.betting_market = 'Back Home' then  local.bet365_home_prob_clean
			when local.betting_market = 'Lay Home' then  1 - local.bet365_home_prob_clean
			when local.betting_market = 'Back Draw' then  local.bet365_draw_prob_clean
			when local.betting_market = 'Lay Draw' then  1 - local.bet365_draw_prob_clean
			when local.betting_market = 'Back Away' then  local.bet365_away_prob_clean
			when local.betting_market = 'Lay Away' then  1 - local.bet365_away_prob_clean
		end bet365_prob_clean,
		case
			when local.betting_market = 'Back Home' then  round(1 / odds.bet365_home_odds, 2)
			when local.betting_market = 'Lay Home' then  local.bet365_overall - round(1 / odds.bet365_home_odds, 2)
			when local.betting_market = 'Back Draw' then  round(1 / odds.bet365_draw_odds, 2)
			when local.betting_market = 'Lay Draw' then  local.bet365_overall - round(1 / odds.bet365_draw_odds, 2)
			when local.betting_market = 'Back Away' then  round(1 / odds.bet365_away_odds, 2)
			when local.betting_market = 'Lay Away' then  local.bet365_overall - round(1 / odds.bet365_away_odds, 2)
		end bet365_prob,
		case
			when local.betting_market = 'Back Home' then odds.bet365_home_odds
			when local.betting_market = 'Lay Home' then  round(1 / (local.bet365_overall - round(1 / odds.bet365_home_odds, 2)),2)
			when local.betting_market = 'Back Draw' then odds.bet365_draw_odds
			when local.betting_market = 'Lay Draw' then  round(1 / (local.bet365_overall - round(1 / odds.bet365_draw_odds, 2)),2)
			when local.betting_market = 'Back Away' then  odds.bet365_away_odds
			when local.betting_market = 'Lay Away' then  round(1 / (local.bet365_overall - round(1 / odds.bet365_away_odds, 2)),2)
		end bet365_odds,
		case
			when local.betting_market = 'Back Home' then	round(gs_prob.comb_regr_prob_home_win ,4)
			when local.betting_market = 'Lay Home' then 	1 - round(gs_prob.comb_regr_prob_home_win ,4)
			when local.betting_market = 'Back Draw' then	round(gs_prob.comb_regr_prob_draw ,4)
			when local.betting_market = 'Lay Draw' then  	1 - round(gs_prob.comb_regr_prob_draw ,4)
			when local.betting_market = 'Back Away' then  	round(gs_prob.comb_regr_prob_away_win ,4)
			when local.betting_market = 'Lay Away' then  	1 - round(gs_prob.comb_regr_prob_away_win ,4)
		end fair_prob,
		decode(local.fair_prob,0,100, round(1 / local.fair_prob,2)) fair_odd,
		case 
			when local.fair_odd = 1 then 100
			else round((local.bet365_odds - 1)/(local.fair_odd - 1)-1,2) 
		end bet_value,
		case
			when local.betting_market = 'Back Home' and stat.full_time_result = 'H' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Lay Home' and stat.full_time_result <> 'H' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Back Draw' and stat.full_time_result = 'D' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Lay Draw' and stat.full_time_result <> 'D' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Back Away' and stat.full_time_result = 'A' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Lay Away' and stat.full_time_result <> 'A' then 10 * local.bet365_odds - 10
			else -10
		end profit_loose, 
		rank() over (partition by division.division, season.season, his.match_date, home.team, away.team order by local.bet_value desc) rang
	from
		betting_dv.football_match_his_l his
		join markets
			on (1=1)
		join SANDBOX.FOOTBALL_MATCH_HIS_L_S_GS_comb_PROBS gs_prob
			on (his.football_match_his_lid = gs_prob.football_match_his_lid)
		join betting_dv.football_match_his_l_s_odds odds
			on (his.football_match_his_lid = odds.football_match_his_lid) 
		join betting_dv.FOOTBALL_MATCH_HIS_L_S_STATISTIC stat
			on (his.football_match_his_lid = stat.football_match_his_lid)
		join betting_dv.football_team_h home
			on (his.football_team_home_hid = home.football_team_hid)
		join betting_dv.football_team_h away
			on (his.football_team_away_hid = away.football_team_hid)
		join betting_dv.football_division_h division
			on (his.football_division_hid = division.football_division_hid)
		join betting_dv.football_season_h season
			on (his.football_season_hid = season.football_season_hid)
	where
		gs_prob.gs_match_rating between -2 and 13 and
		local.bet365_prob > 0.2 and
		local.bet_value > 0.2
		and division.division = 'D1'
		--and season.season in ('2016_2017')
	)
group by
	division,
	season
order by
	1,2;
	
--running sum per calendar week
with markets as
(
select 'Back Home' betting_market from dual
union all
select 'Lay Home' from dual
union all
select 'Back Draw' from dual
union all
select 'Lay Draw' from dual
union all
select 'Back Away' from dual
union all
select 'Lay Away' from dual
)
select
	division,
	calendar_week,
	sum(profit_loose) over (order by calendar_week) profit_loose
from
	(
	select
		division,
		to_char(match_date,'YYYY WW') calendar_week,
		round(sum(profit_loose),2) profit_loose
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
		markets.betting_market betting_market,
		round(1 / odds.bet365_home_odds, 2) + round(1 / odds.bet365_draw_odds, 2) + round(1 / odds.bet365_away_odds, 2) bet365_overall,
		round(round(1 / odds.bet365_home_odds, 2) / local.bet365_overall,2) bet365_home_prob_clean,
		round(round(1 / odds.bet365_draw_odds, 2) / local.bet365_overall,2) bet365_draw_prob_clean,
		round(round(1 / odds.bet365_away_odds, 2) / local.bet365_overall,2) bet365_away_prob_clean,
		case
			when local.betting_market = 'Back Home' then  local.bet365_home_prob_clean
			when local.betting_market = 'Lay Home' then  1 - local.bet365_home_prob_clean
			when local.betting_market = 'Back Draw' then  local.bet365_draw_prob_clean
			when local.betting_market = 'Lay Draw' then  1 - local.bet365_draw_prob_clean
			when local.betting_market = 'Back Away' then  local.bet365_away_prob_clean
			when local.betting_market = 'Lay Away' then  1 - local.bet365_away_prob_clean
		end bet365_prob_clean,
		case
			when local.betting_market = 'Back Home' then  round(1 / odds.bet365_home_odds, 2)
			when local.betting_market = 'Lay Home' then  local.bet365_overall - round(1 / odds.bet365_home_odds, 2)
			when local.betting_market = 'Back Draw' then  round(1 / odds.bet365_draw_odds, 2)
			when local.betting_market = 'Lay Draw' then  local.bet365_overall - round(1 / odds.bet365_draw_odds, 2)
			when local.betting_market = 'Back Away' then  round(1 / odds.bet365_away_odds, 2)
			when local.betting_market = 'Lay Away' then  local.bet365_overall - round(1 / odds.bet365_away_odds, 2)
		end bet365_prob,
		case
			when local.betting_market = 'Back Home' then odds.bet365_home_odds
			when local.betting_market = 'Lay Home' then  round(1 / (local.bet365_overall - round(1 / odds.bet365_home_odds, 2)),2)
			when local.betting_market = 'Back Draw' then odds.bet365_draw_odds
			when local.betting_market = 'Lay Draw' then  round(1 / (local.bet365_overall - round(1 / odds.bet365_draw_odds, 2)),2)
			when local.betting_market = 'Back Away' then  odds.bet365_away_odds
			when local.betting_market = 'Lay Away' then  round(1 / (local.bet365_overall - round(1 / odds.bet365_away_odds, 2)),2)
		end bet365_odds,
		case
			when local.betting_market = 'Back Home' then	round(gs_prob.comb_regr_prob_home_win ,4)
			when local.betting_market = 'Lay Home' then 	1 - round(gs_prob.comb_regr_prob_home_win ,4)
			when local.betting_market = 'Back Draw' then	round(gs_prob.comb_regr_prob_draw ,4)
			when local.betting_market = 'Lay Draw' then  	1 - round(gs_prob.comb_regr_prob_draw ,4)
			when local.betting_market = 'Back Away' then  	round(gs_prob.comb_regr_prob_away_win ,4)
			when local.betting_market = 'Lay Away' then  	1 - round(gs_prob.comb_regr_prob_away_win ,4)
		end fair_prob,
		decode(local.fair_prob,0,100, round(1 / local.fair_prob,2)) fair_odd,
		case 
			when local.fair_odd = 1 then 100
			else round((local.bet365_odds - 1)/(local.fair_odd - 1)-1,2) 
		end bet_value,
		case
			when local.betting_market = 'Back Home' and stat.full_time_result = 'H' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Lay Home' and stat.full_time_result <> 'H' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Back Draw' and stat.full_time_result = 'D' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Lay Draw' and stat.full_time_result <> 'D' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Back Away' and stat.full_time_result = 'A' then 10 * local.bet365_odds - 10
			when local.betting_market = 'Lay Away' and stat.full_time_result <> 'A' then 10 * local.bet365_odds - 10
			else -10
		end profit_loose, 
		rank() over (partition by division.division, season.season, his.match_date, home.team, away.team order by local.bet_value desc) rang
	from
		betting_dv.football_match_his_l his
		join markets
			on (1=1)
		join SANDBOX.FOOTBALL_MATCH_HIS_L_S_GS_comb_PROBS gs_prob
			on (his.football_match_his_lid = gs_prob.football_match_his_lid)
		join betting_dv.football_match_his_l_s_odds odds
			on (his.football_match_his_lid = odds.football_match_his_lid) 
		join betting_dv.FOOTBALL_MATCH_HIS_L_S_STATISTIC stat
			on (his.football_match_his_lid = stat.football_match_his_lid)
		join betting_dv.football_team_h home
			on (his.football_team_home_hid = home.football_team_hid)
		join betting_dv.football_team_h away
			on (his.football_team_away_hid = away.football_team_hid)
		join betting_dv.football_division_h division
			on (his.football_division_hid = division.football_division_hid)
		join betting_dv.football_season_h season
			on (his.football_season_hid = season.football_season_hid)
	where
		--gs_prob.gs_match_rating between -2 and 13 and
		local.bet365_prob > 0.2 and
		local.bet_value > 0.2
		and division.division = 'D1'
		--and season.season in ('2016_2017')
	)
	group by
		1,2
	)
order by
	1,2;