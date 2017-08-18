--single game list
select
	season.season,
	his.match_date,
	home.team home_team,
	away.team away_team,
	stat.full_time_home_goals,
	stat.full_time_away_goals,
	stat.full_time_result,
	round(strength.home_expect_goals,2) home_exp_goals,
	round(strength.away_expect_goals,2) away_exp_goals,
	case
		when round(strength.home_expect_goals,0) - round(strength.away_expect_goals,0) = 0 and
			round(strength.home_expect_goals,2) >= round(strength.away_expect_goals,2) then round(strength.home_expect_goals,0) + 1
		else
			round(strength.home_expect_goals,0)
	end bet_home_goals,
	case
		when round(strength.home_expect_goals,0) - round(strength.away_expect_goals,0) = 0 and
			round(strength.home_expect_goals,2) < round(strength.away_expect_goals,2) then round(strength.away_expect_goals,0) + 1
		else
			round(strength.away_expect_goals,0)
	end bet_away_goals,
	case
		when local.bet_home_goals > local.bet_away_goals then 'H'
		when local.bet_home_goals = local.bet_away_goals then 'D'
		else 'A'
	end bet_result,
	case
		--correct score
		when local.bet_home_goals = stat.full_time_home_goals and 
			local.bet_away_goals = stat.full_time_away_goals then 4
		--correct goal difference
		when (local.bet_home_goals - local.bet_away_goals) =	(stat.full_time_home_goals - stat.full_time_away_goals) and
			(local.bet_home_goals - local.bet_away_goals) <> 0	then 3
		--correct trend
		when stat.full_time_result = local.bet_result then 2
		--wrong bet
		else 0
	end gained_points			
from
	betting_dv.football_match_his_l his
	join betting_dv.football_match_his_l_s_statistic stat
		on his.football_match_his_lid = stat.football_match_his_lid
		on his.football_division_hid = division.football_division_hid
	join betting_dv.football_division_h division
		on his.football_division_hid = division.football_division_hid
	join betting_dv.football_team_h home
		on his.football_team_home_hid = home.football_team_hid
	join betting_dv.football_team_h away
		on his.football_team_away_hid = away.football_team_hid
	join betting_dv.football_season_h season
		on his.football_season_hid = season.football_season_hid
	join betting_dv.football_match_his_l_s_team_strength_30 strength
		on his.football_match_his_lid = strength.football_match_his_lid
where
	division = 'D1' and
	season in ('2016_2017','2015_2016','2014_2015','2013_2014')
order by
	1 desc,2,3
;


--aggregate per season
select
	season,
	count(*) num_games,
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
		round(strength.home_expect_goals,2) home_exp_goals,
		round(strength.away_expect_goals,2) away_exp_goals,
		case
			when round(strength.home_expect_goals,0) - round(strength.away_expect_goals,0) = 0 and
				round(strength.home_expect_goals,2) >= round(strength.away_expect_goals,2) then round(strength.home_expect_goals,0) + 1
			else
				round(strength.home_expect_goals,0)
		end bet_home_goals,
		case
			when round(strength.home_expect_goals,0) - round(strength.away_expect_goals,0) = 0 and
				round(strength.home_expect_goals,2) < round(strength.away_expect_goals,2) then round(strength.away_expect_goals,0) + 1
			else
				round(strength.away_expect_goals,0)
		end bet_away_goals,
		case
			when local.bet_home_goals > local.bet_away_goals then 'H'
			when local.bet_home_goals = local.bet_away_goals then 'D'
			else 'A'
		end bet_result,
		case
			--correct score
			when local.bet_home_goals = stat.full_time_home_goals and 
				local.bet_away_goals = stat.full_time_away_goals then 4
			--correct goal difference
			when (local.bet_home_goals - local.bet_away_goals) = (stat.full_time_home_goals - stat.full_time_away_goals) and
				(local.bet_home_goals - local.bet_away_goals) <> 0 	then 3
			--correct trend
			when stat.full_time_result = local.bet_result then 2
			--wrong bet
			else 0
		end gained_points			
	from
		betting_dv.football_match_his_l his
		join betting_dv.football_match_his_l_s_statistic stat
			on his.football_match_his_lid = stat.football_match_his_lid
		join betting_dv.football_division_h division
			on his.football_division_hid = division.football_division_hid
		join betting_dv.football_team_h home
			on his.football_team_home_hid = home.football_team_hid
		join betting_dv.football_team_h away
			on his.football_team_away_hid = away.football_team_hid
		join betting_dv.football_season_h season
			on his.football_season_hid = season.football_season_hid
		join betting_dv.football_match_his_l_s_team_strength_30 strength
			on his.football_match_his_lid = strength.football_match_his_lid
	where
		division = 'D1' and
		season in ('2016_2017','2015_2016','2014_2015','2013_2014')
	)
group by
	season
order by
	1 desc
;
