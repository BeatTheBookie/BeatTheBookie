--single game list
with zip_home_goals as
(
--num_home_goals
select
	football_match_his_lid,
	'0' num_home_goals,
	zip.prob_home_0 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'1' num_home_goals,
	zip.prob_home_1 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'2' num_home_goals,
	zip.prob_home_2 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'3' num_home_goals,
	zip.prob_home_3 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'4' num_home_goals,
	zip.prob_home_4 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'5' num_home_goals,
	zip.prob_home_5 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
), zip_away_goals as
(
--num_away_goals
select
	football_match_his_lid,
	'0' num_away_goals,
	zip.prob_away_0 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'1' num_away_goals,
	zip.prob_away_1 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'2' num_away_goals,
	zip.prob_away_2 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'3' num_away_goals,
	zip.prob_away_3 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'4' num_away_goals,
	zip.prob_away_4 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'5' num_away_goals,
	zip.prob_away_5 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
)
select
	season,
	match_date,
	home_team,
	away_team,
	full_time_home_goals,
	full_time_away_goals,
	full_time_result,
	bet_home_goals,
	bet_away_goals,
	bet_result,
	bet_prob,
	gained_points,
	rang
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
		zip_home_goals.num_home_goals bet_home_goals,
		zip_away_goals.num_away_goals bet_away_goals,
		case
			when local.bet_home_goals > local.bet_away_goals then 'H'
			when local.bet_home_goals = local.bet_away_goals then 'D'
			else 'A'
		end bet_result,
		round(zip_home_goals.zip_prob * zip_away_goals.zip_prob,4) bet_prob,
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
			end gained_points,
		rank() over (partition by his.football_match_his_lid order by local.bet_prob desc) rang
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
		join zip_home_goals
			on (his.football_match_his_lid = zip_home_goals.football_match_his_lid)
		join zip_away_goals
			on (his.football_match_his_lid = zip_away_goals.football_match_his_lid)
	where
		division = 'D1' and
		season in ('2016_2017','2015_2016','2014_2015','2013_2014') and
		--kein Unentschieden
		zip_home_goals.num_home_goals <> zip_away_goals.num_away_goals
	)
where
	rang = 1
order by
	1 desc,2,3
;


--aggregate per season
with zip_home_goals as
(
--num_home_goals
select
	football_match_his_lid,
	'0' num_home_goals,
	zip.prob_home_0 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'1' num_home_goals,
	zip.prob_home_1 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'2' num_home_goals,
	zip.prob_home_2 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'3' num_home_goals,
	zip.prob_home_3 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'4' num_home_goals,
	zip.prob_home_4 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'5' num_home_goals,
	zip.prob_home_5 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
), zip_away_goals as
(
--num_away_goals
select
	football_match_his_lid,
	'0' num_away_goals,
	zip.prob_away_0 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'1' num_away_goals,
	zip.prob_away_1 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'2' num_away_goals,
	zip.prob_away_2 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'3' num_away_goals,
	zip.prob_away_3 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'4' num_away_goals,
	zip.prob_away_4 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
union all
select
	football_match_his_lid,
	'5' num_away_goals,
	zip.prob_away_5 zip_prob
from
	betting_dv.football_match_his_l_s_zip_probs zip
)
select
	season,
	count(*) num_games,
	sum(gained_points) points
from
	(
	select
		season,
		match_date,
		home_team,
		away_team,
		full_time_home_goals,
		full_time_away_goals,
		full_time_result,
		bet_home_goals,
		bet_away_goals,
		bet_result,
		bet_prob,
		gained_points,
		rang
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
			zip_home_goals.num_home_goals bet_home_goals,
			zip_away_goals.num_away_goals bet_away_goals,
			case
				when local.bet_home_goals > local.bet_away_goals then 'H'
				when local.bet_home_goals = local.bet_away_goals then 'D'
				else 'A'
			end bet_result,
			round(zip_home_goals.zip_prob * zip_away_goals.zip_prob,4) bet_prob,
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
			end gained_points,
			rank() over (partition by his.football_match_his_lid order by local.bet_prob desc) rang
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
			join zip_home_goals
				on (his.football_match_his_lid = zip_home_goals.football_match_his_lid)
			join zip_away_goals
				on (his.football_match_his_lid = zip_away_goals.football_match_his_lid)
		where
			division = 'D1' and
			season in ('2016_2017','2015_2016','2014_2015','2013_2014') and
			--kein Unentschieden
			zip_home_goals.num_home_goals <> zip_away_goals.num_away_goals
		)
	where
		rang = 1
	)
group by
	season
order by
	1 desc
;
