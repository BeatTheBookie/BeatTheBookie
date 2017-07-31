

/************************************************
	betting vault feature link-satellite
	- for link with current matches in division
	- for home / away attack strenght & defence weakness
	
v1:
	- initial
	- feature calcutlation
		- 30 match_history

		
*************************************************/


--create or replace view betting_dv.football_match_his_l_s_attack_defence_strength_30

--drop table betting_dv.football_match_his_l_s_attack_defence_strength_30;

create or replace view betting_dv.football_match_cur_l_s_attack_defence_strength_30
as
select
	fixtures.football_match_cur_lid,
	round(home_str.avg_team_goals_for,2) avg_home_team_goals_for,
	round(home_str.avg_team_goals_against,2) avg_home_team_goals_against,
	round(away_str.avg_team_goals_for,2)	avg_away_team_goals_for,
	round(away_str.avg_team_goals_against,2) avg_away_team_goals_against,
	round(home_str.avg_league_goals_for,2) avg_league_home_goals_for,
	round(home_str.avg_league_goals_against,2) avg_league_home_goals_against,
	round(away_str.avg_league_goals_for,2) avg_league_away_goals_for,
	round(away_str.avg_league_goals_against,2) avg_league_away_goals_against,
	round(home_str.home_attacking_strength,2) home_attacking_strength,
	round(home_str.home_defence_strength,2) home_defence_strength,
	round(away_str.away_attacking_strength,2) away_attacking_strength,
	round(away_str.away_defence_strength,2) away_defence_strength,
	(home_str.home_attacking_strength * away_str.away_defence_strength * home_str.avg_league_goals_for) home_expect_goals,
	(away_str.away_attacking_strength * home_str.home_defence_strength * away_str.avg_league_goals_for) away_expect_goals,
	home_str.num_games home_num_games,
	away_str.num_games away_num_games,
	home_str.league_num_games league_home_num_games,
	away_str.league_num_games league_away_num_games,
	home_str.league_num_zero_games league_home_num_zero_games,
	away_str.league_num_zero_games league_away_num_zero_games
from
	--match combinations
	betting_dv.football_match_cur_l fixtures
	--home strength weakness
	join
		(		
		select
			football_division_hid,
			football_season_hid,
			match_date,
			football_team_home_hid,
			league_num_games,
			num_games,
			league_num_zero_games,
			avg_team_goals_for,
			avg_team_goals_against,
			avg_league_goals_for,
			avg_league_goals_against,
			round(avg_team_goals_for / avg_league_goals_for, 2) home_attacking_strength,
			round(avg_team_goals_against / avg_league_goals_against, 2) home_defence_strength
		from
			(
			select distinct
				football_division_hid,
				football_season_hid,
				match_date,
				football_team_home_hid,
				count(match_date) over (partition by football_division_hid, football_season_hid, match_date) league_num_games,
				count(match_date) over (partition by football_division_hid, football_season_hid, match_date, football_team_home_hid) num_games,
				sum(case when goals_for = 0 then 1 else 0 end) over (partition by football_division_hid, football_season_hid, match_date) league_num_zero_games,
				avg(goals_for) over (partition by football_division_hid, football_season_hid, match_date, football_team_home_hid) avg_team_goals_for,
				avg(goals_against) over (partition by football_division_hid, football_season_hid, match_date, football_team_home_hid) avg_team_goals_against,
				avg(goals_for) over (partition by football_division_hid, football_season_hid, match_date) avg_league_goals_for,
				avg(goals_against) over (partition by football_division_hid, football_season_hid, match_date) avg_league_goals_against
			from
				(
				select
					dates.football_division_hid,
					dates.football_season_hid,
					dates.match_date,
					his.match_date his_match_date,
					his.football_team_home_hid,
					his.football_team_away_hid,
					stat.full_time_home_goals goals_for,
					stat.full_time_away_goals goals_against,
					dense_rank() over (partition by dates.football_division_hid, dates.football_season_hid, dates.match_date, his.football_team_home_hid order by his.match_date desc) rang_team
				from
					(
					select distinct
						football_division_hid,
						football_season_hid,
						match_date
					from
						betting_dv.football_match_cur_l
					) dates
					join betting_dv.football_team_division_l team_division
						on dates.football_season_hid = team_division.football_season_hid and
							dates.football_division_hid = team_division.football_division_hid
					join betting_dv.football_match_his_l his
						on 	dates.football_division_hid = his.football_division_hid and
							dates.match_date > his.match_date and
							team_division.football_team_hid = his.football_team_home_hid	
					join betting_dv.football_match_his_l_s_statistic stat
						on his.football_match_his_lid = stat.football_match_his_lid
				)
			where
				rang_team <= 30
			)
		) home_str
	on (
		fixtures.football_division_hid 	= home_str.football_division_hid and
		fixtures.football_season_hid 	= home_str.football_season_hid and
		fixtures.match_date				= home_str.match_date and
		fixtures.football_team_home_hid = home_str.football_team_home_hid
		)
	--away strength weakness
	join
		(
		select
			football_division_hid,
			football_season_hid,
			match_date,
			football_team_away_hid,
			league_num_games,
			num_games,
			league_num_zero_games,
			avg_team_goals_for,
			avg_team_goals_against,
			avg_league_goals_for,
			avg_league_goals_against,
			round(avg_team_goals_for / avg_league_goals_for, 2) away_attacking_strength,
			round(avg_team_goals_against / avg_league_goals_against, 2) away_defence_strength
		from
			(
			select distinct
				football_division_hid,
				football_season_hid,
				match_date,
				football_team_away_hid,
				count(match_date) over (partition by football_division_hid, football_season_hid, match_date) league_num_games,
				count(match_date) over (partition by football_division_hid, football_season_hid, match_date, football_team_away_hid) num_games,
				sum(case when goals_for = 0 then 1 else 0 end) over (partition by football_division_hid, football_season_hid, match_date) league_num_zero_games,
				avg(goals_for) over (partition by football_division_hid, football_season_hid, match_date, football_team_away_hid) avg_team_goals_for,
				avg(goals_against) over (partition by football_division_hid, football_season_hid, match_date, football_team_away_hid) avg_team_goals_against,
				avg(goals_for) over (partition by football_division_hid, football_season_hid, match_date) avg_league_goals_for,
				avg(goals_against) over (partition by football_division_hid, football_season_hid, match_date) avg_league_goals_against
			from
				(
				select
					dates.football_division_hid,
					dates.football_season_hid,
					dates.match_date,
					his.match_date his_match_date,
					his.football_team_home_hid,
					his.football_team_away_hid,
					stat.full_time_away_goals goals_for,
					stat.full_time_home_goals goals_against,
					dense_rank() over (partition by dates.football_division_hid, dates.football_season_hid, dates.match_date, his.football_team_away_hid order by his.match_date desc) rang_team
				from
					(
					select distinct
						football_division_hid,
						football_season_hid,
						match_date
					from
						betting_dv.football_match_cur_l
					) dates
					join betting_dv.football_team_division_l team_division
						on dates.football_season_hid = team_division.football_season_hid and
							dates.football_division_hid = team_division.football_division_hid
					join betting_dv.football_match_his_l his
						on 	dates.football_division_hid = his.football_division_hid and
							dates.match_date > his.match_date and
							team_division.football_team_hid = his.football_team_away_hid	
					join betting_dv.football_match_his_l_s_statistic stat
						on his.football_match_his_lid = stat.football_match_his_lid
				)
			where
				rang_team <= 30
			)
		) away_str
	on (
		fixtures.football_division_hid 	= away_str.football_division_hid and
		fixtures.football_season_hid 	= away_str.football_season_hid and
		fixtures.match_date				= away_str.match_date and
		fixtures.football_team_away_hid = away_str.football_team_away_hid
		)
;