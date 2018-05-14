--comparison fix real margin
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
	coalesce(d1_fix.calendar_week, d1_real.calendar_week) calendar_week,
	d1_fix.profit_loose d1_fix_margin,
	d1_real.profit_loose d1_real_margin
from
	(
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
		case
			when local.betting_market = 'Back Home' then  round(1 / odds.bet365_home_odds, 2)
			when local.betting_market = 'Lay Home' then  1 - round(1 / odds.bet365_home_odds, 2)
			when local.betting_market = 'Back Draw' then  round(1 / odds.bet365_draw_odds, 2)
			when local.betting_market = 'Lay Draw' then  1 - round(1 / odds.bet365_draw_odds, 2)
			when local.betting_market = 'Back Away' then  round(1 / odds.bet365_away_odds, 2)
			when local.betting_market = 'Lay Away' then  1 - round(1 / odds.bet365_away_odds, 2)
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
			when local.betting_market = 'Back Home' then	round(zip.prob_home_win * 0.7 + event.his_prob_1 * 0.3 ,4)
			when local.betting_market = 'Lay Home' then 	1 - round(zip.prob_home_win * 0.7 + event.his_prob_1 * 0.3 ,4)
			when local.betting_market = 'Back Draw' then	round(zip.prob_draw * 0.7 + event.his_prob_x * 0.3 ,4)
			when local.betting_market = 'Lay Draw' then  	1 - round(zip.prob_draw * 0.7 + event.his_prob_x * 0.3 ,4)
			when local.betting_market = 'Back Away' then  	round(zip.prob_away_win * 0.7 + event.his_prob_2 * 0.3 ,4)
			when local.betting_market = 'Lay Away' then  	1 - round(zip.prob_away_win * 0.7 + event.his_prob_2 * 0.3 ,4)
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
		join betting_dv.football_match_his_l_s_zip_probs zip
			on (his.football_match_his_lid = zip.football_match_his_lid)
		join betting_dv.football_match_his_l_s_eventbased_probs event
			on (his.football_match_his_lid = event.football_match_his_lid)
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
		local.bet365_prob > 0.1 and
		local.bet_value > 0.2 and
		division.division = 'D1' and
		season.season in ('2017_2018','2016_2017','2015_2016','2014_2015','2013_2014','2012_2013')
		)
	group by
		division,
		to_char(match_date,'YYYY WW')
	)
	) d1_real
	full outer join
	( 
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
		case
			when local.betting_market = 'Back Home' then  round(1 / odds.bet365_home_odds, 2)
			when local.betting_market = 'Lay Home' then  1 - round(1 / odds.bet365_home_odds, 2)
			when local.betting_market = 'Back Draw' then  round(1 / odds.bet365_draw_odds, 2)
			when local.betting_market = 'Lay Draw' then  1 - round(1 / odds.bet365_draw_odds, 2)
			when local.betting_market = 'Back Away' then  round(1 / odds.bet365_away_odds, 2)
			when local.betting_market = 'Lay Away' then  1 - round(1 / odds.bet365_away_odds, 2)
		end bet365_prob,
		case
			when local.betting_market = 'Back Home' then  odds.bet365_home_odds
			when local.betting_market = 'Lay Home' then  round(1 / (1.04 - round(1 / odds.bet365_home_odds, 2)),2)
			when local.betting_market = 'Back Draw' then  odds.bet365_draw_odds
			when local.betting_market = 'Lay Draw' then  round(1 / (1.04 - round(1 / odds.bet365_draw_odds, 2)),2)
			when local.betting_market = 'Back Away' then  odds.bet365_away_odds
			when local.betting_market = 'Lay Away' then  round(1 / (1.04 - round(1 / odds.bet365_away_odds, 2)),2)
		end bet365_odds,
		case
			when local.betting_market = 'Back Home' then	round(zip.prob_home_win * 0.7 + event.his_prob_1 * 0.3 ,4)
			when local.betting_market = 'Lay Home' then 	1 - round(zip.prob_home_win * 0.7 + event.his_prob_1 * 0.3 ,4)
			when local.betting_market = 'Back Draw' then	round(zip.prob_draw * 0.7 + event.his_prob_x * 0.3 ,4)
			when local.betting_market = 'Lay Draw' then  	1 - round(zip.prob_draw * 0.7 + event.his_prob_x * 0.3 ,4)
			when local.betting_market = 'Back Away' then  	round(zip.prob_away_win * 0.7 + event.his_prob_2 * 0.3 ,4)
			when local.betting_market = 'Lay Away' then  	1 - round(zip.prob_away_win * 0.7 + event.his_prob_2 * 0.3 ,4)
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
		join betting_dv.football_match_his_l_s_zip_probs zip
			on (his.football_match_his_lid = zip.football_match_his_lid)
		join betting_dv.football_match_his_l_s_eventbased_probs event
			on (his.football_match_his_lid = event.football_match_his_lid)
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
		local.bet365_prob > 0.1 and
		local.bet_value > 0.2 and
		division.division = 'D1' and
		season.season in ('2017_2018','2016_2017','2015_2016','2014_2015','2013_2014','2012_2013')
		)
	group by
		division,
		to_char(match_date,'YYYY WW')
	)
	) d1_fix
	on (d1_real.calendar_week = d1_fix.calendar_week)
order by
	1,2;
	
	
--single match comparison
select
		division.division,
		season.season,
		his.match_date,
		home.team home_team,
		away.team away_team,
		--stat.full_time_home_goals,
		--stat.full_time_away_goals,
		--stat.full_time_result,
		round((1 / odds.bet365_home_odds) + (1 / odds.bet365_draw_odds) + (1 / odds.bet365_away_odds), 2) bet365_overall,
		odds.bet365_home_odds back_home,
		round(1 / (1.043 - (1 / odds.bet365_home_odds)),2) lay_home_fixed_margin,
		round(1 / (local.bet365_overall - round(1 / odds.bet365_home_odds, 2)),2) lay_home_match_margin,
		round(1 / (1 - round(zip.prob_home_win * 0.7 + event.his_prob_1 * 0.3 ,4)),2) lay_home_fair,
		case 
			when local.lay_home_fair = 1 then 100
			else round((local.lay_home_fixed_margin - 1)/(local.lay_home_fair - 1)-1,2) 
		end bet_value_fixed_margin,
		case 
			when local.lay_home_fair = 1 then 100
			else round((local.lay_home_match_margin - 1)/(local.lay_home_fair - 1)-1,2) 
		end bet_value_match_margin,
		case
			when stat.full_time_result <> 'H' then round(10 * local.lay_home_fixed_margin - 10,2)
			else -10
		end profit_loose_fixed_margin,
		case
			when stat.full_time_result <> 'H' then round(10 * local.lay_home_match_margin - 10,2)
			else -10
		end profit_loose_match_margin
	from
		betting_dv.football_match_his_l his
		join betting_dv.football_match_his_l_s_zip_probs zip
			on (his.football_match_his_lid = zip.football_match_his_lid)
		join betting_dv.football_match_his_l_s_eventbased_probs event
			on (his.football_match_his_lid = event.football_match_his_lid)
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
		round((1 / odds.bet365_home_odds),2) > 0.1 and
		local.bet_value_fixed_margin > 0.2 and
		division.division = 'D1' and 
		season.season in ('2017_2018') and
		local.profit_loose_fixed_margin > 0
order by
	1,2,3;