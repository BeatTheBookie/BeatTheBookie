

/************************************************
	betting vault prediction link-satellite
	- for link with historic matches in division
	- for eventbased probabilities
	
v1:
	- views:
		- football_match_l_s_eventbased_probs
	- probs for:
		- 1/X/2 home, away, direct
		
		
*************************************************/


--create or replace view betting_dv.football_match_his_l_s_eventbased_probs

--drop table betting_dv.football_match_his_l_s_eventbased_probs;

create or replace table betting_dv.football_match_his_l_s_eventbased_probs
as
select
	fixtures.football_match_his_lid,
	direct_num_matches,
	--1/x/2 probs
	home_prob_1,
	away_prob_1,
	round(home_prob_1 * 0.5 + away_prob_1 * 0.5, 4) his_prob_1,
	direct_prob_1,
	home_prob_x,
	away_prob_x,
	round(home_prob_x * 0.5 + away_prob_x * 0.5, 4) his_prob_x,
	direct_prob_x,
	home_prob_2,
	away_prob_2,
	round(home_prob_2 * 0.5 + away_prob_2 * 0.5, 4) his_prob_2,
	direct_prob_2
from
	--match combinations
	betting_dv.football_match_his_l fixtures	
	--base data for last 10 direct match
	join
		(
		--calculate direct event-probs
		select
			football_match_his_lid,
			count(*) direct_num_matches,
			--1/x/2
			round(sum(direct_1) / count(*), 4) direct_prob_1,
			round(sum(direct_x) / count(*), 4) direct_prob_x,
			round(sum(direct_2) / count(*), 4) direct_prob_2
		from
			(
			select
				lnk.football_match_his_lid,
				--1/x/2
				case when stat.full_time_result = 'H' then 1 else 0 end direct_1,
				case when stat.full_time_result = 'D' then 1 else 0 end direct_x,
				case when stat.full_time_result = 'A' then 1 else 0 end direct_2,
				--rank for number of games
				dense_rank() over (partition by lnk.football_match_his_lid order by his.match_date desc) direct_rang
			from
				betting_dv.football_match_his_l lnk
				join betting_dv.football_match_his_l his
					on lnk.football_team_home_hid = his.football_team_home_hid
						and lnk.football_team_away_hid = his.football_team_away_hid
						and lnk.match_date > his.match_date
				join betting_dv.football_match_his_l_s_statistic stat
					on his.football_match_his_lid = stat.football_match_his_lid
			where
				--only finished matches
				stat.full_time_result is not null
			)
		where
			direct_rang <= 10
		group by
			football_match_his_lid
		) direct_his
		on (fixtures.football_match_his_lid = direct_his.football_match_his_lid)
	--home-statistic of home team for last 25 games
	join
		(
		--aggregate statistics
		select
			football_match_his_lid,
			count(*) home_num_matches,
			--1/x/2
			round(sum(home_1) / count(*), 4) home_prob_1,
			round(sum(home_x) / count(*), 4) home_prob_x,
			round(sum(home_2) / count(*), 4) home_prob_2
		from
			(
			select
				lnk.football_match_his_lid,
				his.match_date,
				--1/x/2
				case when stat.full_time_result = 'H' then 1 else 0 end home_1,
				case when stat.full_time_result = 'D' then 1 else 0 end home_x,
				case when stat.full_time_result = 'A' then 1 else 0 end home_2,
				--rank for number of games
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
			--filter last 25 home games
			match_rang <= 25
		group by
			football_match_his_lid
		) home_his
		on (fixtures.football_match_his_lid = home_his.football_match_his_lid)
	--away-statistic of away team for last 25 games
	join
		(
		--aggregate statistics
		select
			football_match_his_lid,
			count(*) away_num_matches,
			--1/x/2
			round(sum(away_1) / count(*), 4) away_prob_1,
			round(sum(away_x) / count(*), 4) away_prob_x,
			round(sum(away_2) / count(*), 4) away_prob_2
		from
			(
			select
				lnk.football_match_his_lid,
				--1/x/2
				case when stat.full_time_result = 'H' then 1 else 0 end away_1,
				case when stat.full_time_result = 'D' then 1 else 0 end away_x,
				case when stat.full_time_result = 'A' then 1 else 0 end away_2,
				--rank for number of games
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
			--last 25 away games
			match_rang <= 25
		group by
			football_match_his_lid
		) away_his
		on (fixtures.football_match_his_lid = away_his.football_match_his_lid)
;