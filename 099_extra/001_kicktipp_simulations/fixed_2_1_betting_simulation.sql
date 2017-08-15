--single game list
select
	season.season,
	his.match_date,
	home.team home_team,
	away.team away_team,
	stat.full_time_home_goals,
	stat.full_time_away_goals,
	stat.full_time_result,
	round((1 / odd.bet365_home_odds) / ((1 / odd.bet365_home_odds) + (1 / odd.bet365_draw_odds) + (1 / odd.bet365_away_odds)), 4) bet365_home_prob,
	round((1 / odd.bet365_draw_odds) / ((1 / odd.bet365_home_odds) + (1 / odd.bet365_draw_odds) + (1 / odd.bet365_away_odds)), 4) bet365_draw_prob,
	round((1 / odd.bet365_away_odds) / ((1 / odd.bet365_home_odds) + (1 / odd.bet365_draw_odds) + (1 / odd.bet365_away_odds)), 4) bet365_away_prob,
	case
		when local.bet365_home_prob >= local.bet365_away_prob then 2
		else 1
	end bet_home_goals,
	case
		when local.bet365_home_prob >= local.bet365_away_prob then 1
		else 2
	end bet_away_goals,
	case
		when local.bet365_home_prob >= local.bet365_away_prob then 'H'
		else 'A'
	end bet_result,
	case
		--correct score
		when local.bet_home_goals = stat.full_time_home_goals and 
			local.bet_away_goals = stat.full_time_away_goals then 4
		--correct goal difference
		when (local.bet_home_goals - local.bet_away_goals) = 1 and
			(stat.full_time_home_goals - stat.full_time_away_goals) = 1 then 3
		when (local.bet_home_goals - local.bet_away_goals) = -1 and
			(stat.full_time_home_goals - stat.full_time_away_goals) = -1 then 3
		--correct trend
		when stat.full_time_result = local.bet_result then 2
		--wrong bet
		else 0
	end gained_points			
from
	betting_dv.football_match_his_l his
	join betting_dv.football_match_his_l_s_statistic stat
		on his.football_match_his_lid = stat.football_match_his_lid
	join betting_dv.football_match_his_l_s_odds odd
		on his.football_match_his_lid = odd.football_match_his_lid
	join betting_dv.football_division_h division
		on his.football_division_hid = division.football_division_hid
	join betting_dv.football_team_h home
		on his.football_team_home_hid = home.football_team_hid
	join betting_dv.football_team_h away
		on his.football_team_away_hid = away.football_team_hid
	join betting_dv.football_season_h season
		on his.football_season_hid = season.football_season_hid
where
	division = 'D1' and
	season in ('2016_2017','2015_2016','2014_2015','2013_2014')
order by
	1 desc,2,3
;


--aggregate per season
select
	season,
	sum(gained_points) points
from
	(
	select
		season.season,
		his.match_date,
		home.team home_team,
		away.team away_team,
		stat.full_time_home_goals,
		stat.full_time_away_goals,
		stat.full_time_result,
		round((1 / odd.bet365_home_odds) / ((1 / odd.bet365_home_odds) + (1 / odd.bet365_draw_odds) + (1 / odd.bet365_away_odds)), 4) bet365_home_prob,
		round((1 / odd.bet365_draw_odds) / ((1 / odd.bet365_home_odds) + (1 / odd.bet365_draw_odds) + (1 / odd.bet365_away_odds)), 4) bet365_draw_prob,
		round((1 / odd.bet365_away_odds) / ((1 / odd.bet365_home_odds) + (1 / odd.bet365_draw_odds) + (1 / odd.bet365_away_odds)), 4) bet365_away_prob,
		case
			when local.bet365_home_prob >= local.bet365_away_prob then 2
			else 1
		end bet_home_goals,
		case
			when local.bet365_home_prob >= local.bet365_away_prob then 1
			else 2
		end bet_away_goals,
		case
			when local.bet365_home_prob >= local.bet365_away_prob then 'H'
			else 'A'
		end bet_result,
		case
			--correct score
			when local.bet_home_goals = stat.full_time_home_goals and 
				local.bet_away_goals = stat.full_time_away_goals then 4
			--correct goal difference
			when (local.bet_home_goals - local.bet_away_goals) = 1 and
				(stat.full_time_home_goals - stat.full_time_away_goals) = 1 then 3
			when (local.bet_home_goals - local.bet_away_goals) = -1 and
				(stat.full_time_home_goals - stat.full_time_away_goals) = -1 then 3
			--correct trend
			when stat.full_time_result = local.bet_result then 2
			--wrong bet
			else 0
		end gained_points			
	from
		betting_dv.football_match_his_l his
		join betting_dv.football_match_his_l_s_statistic stat
			on his.football_match_his_lid = stat.football_match_his_lid
		join betting_dv.football_match_his_l_s_odds odd
			on his.football_match_his_lid = odd.football_match_his_lid
		join betting_dv.football_division_h division
			on his.football_division_hid = division.football_division_hid
		join betting_dv.football_team_h home
			on his.football_team_home_hid = home.football_team_hid
		join betting_dv.football_team_h away
			on his.football_team_away_hid = away.football_team_hid
		join betting_dv.football_season_h season
			on his.football_season_hid = season.football_season_hid
	where
		division = 'D1' and
		season in ('2016_2017','2015_2016','2014_2015','2013_2014')
	)
group by
	season
order by
	1 desc
;
