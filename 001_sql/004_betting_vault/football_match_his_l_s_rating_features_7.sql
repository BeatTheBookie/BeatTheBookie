
/*********************************************
	betting vault historic rating features link-satellite
	- for link with historic matches in division
	- historic rating features
	
v1.0:
	- intial
	- features:
		- goal superioty rating
		- avg points per match rating
	- 7 match history
		
***************************************************/



--drop table betting_dv.football_match_his_l_s_rating_features_7;

create or replace table betting_dv.football_match_his_l_s_rating_features_7
as
select
	fixtures.football_match_his_lid,
	--home gs-rating
	home_his.goals_scored home_goals_scored,
	home_his.goals_conceded home_goals_conceded,
	(home_his.goals_scored - home_his.goals_conceded) home_gs_rating,
	--away gs-rating
	away_his.goals_scored away_goals_scored,
	away_his.goals_conceded away_goals_conceded,
	(away_his.goals_scored - away_his.goals_conceded) away_gs_rating,
	(local.home_gs_rating - local.away_gs_rating) gs_match_rating,
	--point per game
	home_his.avg_points home_avg_points,
	away_his.avg_points away_avg_points,
	(home_his.avg_points - away_his.avg_points) ppg_match_rating
from
	--match combinations
	betting_dv.football_match_his_l fixtures
	--last x home games
	join
		(
		--aggregate home goal statistic
		select
			football_match_his_lid,
			sum(goals_scored) goals_scored,
			sum(goals_conceded) goals_conceded,
			avg(points_owned) avg_points
		from
			--historic home games
			(
			select
				lnk.football_match_his_lid,
				--gs rating
				stat.full_time_home_goals goals_scored,
				stat.full_time_away_goals goals_conceded,
				--avg ppm calc
				decode(full_time_result,'H',3,'D',1,'A',0) points_owned,
				dense_rank() over (partition by lnk.football_match_his_lid order by his.match_date desc) match_rang
			from
				betting_dv.football_match_his_l lnk
				join betting_dv.football_match_his_l his
					on lnk.football_team_home_hid = his.football_team_home_hid
						and lnk.football_division_hid = his.football_division_hid
						and lnk.match_date > his.match_date
				join betting_dv.football_match_his_l_s_statistic stat
					on his.football_match_his_lid = stat.football_match_his_lid
			where
				--only finished matches
				stat.full_time_result is not null
			)
		where
			--last X home games
			match_rang <= 7
		group by
			football_match_his_lid
		having
			--X home games must exist
			count(*) = 7
		) home_his
	on (fixtures.football_match_his_lid = home_his.football_match_his_lid)
	--last x away games
	join
		(
		--aggregate away goal statistic
		select
			football_match_his_lid,
			sum(goals_scored) goals_scored,
			sum(goals_conceded) goals_conceded,
			avg(points_owned) avg_points
		from
			--historic away games
			(
			select
				lnk.football_match_his_lid,
				--gs rating
				stat.full_time_away_goals goals_scored,
				stat.full_time_home_goals goals_conceded,
				--avg ppm calc
				decode(full_time_result,'H',0,'D',1,'A',3) points_owned,
				dense_rank() over (partition by lnk.football_match_his_lid order by his.match_date desc) match_rang
			from
				betting_dv.football_match_his_l lnk
				join betting_dv.football_match_his_l his
					on lnk.football_team_away_hid = his.football_team_away_hid
						and lnk.football_division_hid = his.football_division_hid
						and lnk.match_date > his.match_date
				join betting_dv.football_match_his_l_s_statistic stat
					on his.football_match_his_lid = stat.football_match_his_lid
			where
				--only finished matches
				stat.full_time_result is not null
			)
		where
			--last X away games
			match_rang <= 7
		group by
			football_match_his_lid
		having
			--X away games must exist
			count(*) = 7
		) away_his
	on (fixtures.football_match_his_lid = away_his.football_match_his_lid)
;