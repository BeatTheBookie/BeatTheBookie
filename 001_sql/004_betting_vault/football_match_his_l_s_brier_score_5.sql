

/************************************************
	betting vault brier score link-satellite
	- for link with historic matches in division
	- for brier score for market odds
	
v1.0:
	- intial
	- views logic:
		- 5 match history
		- brier score for pinnacle odds
		
			
*************************************************/


--drop table betting_dv.football_match_his_l_s_gs_match_rating;

create or replace table betting_dv.football_match_his_l_s_market_brier_score
as
select
	fixtures.football_match_his_lid,
	home_his.class_3_brier home_class_3_brier,
	home_his.class_2_home_brier home_class_2_home_brier,
	home_his.class_2_draw_brier home_class_2_draw_brier,
	home_his.class_2_away_brier home_class_2_away_brier,
	away_his.class_3_brier away_class_3_brier,
	away_his.class_2_home_brier away_class_2_home_brier,
	away_his.class_2_draw_brier away_class_2_draw_brier,
	away_his.class_2_away_brier away_class_2_away_brier
from
	--match combinations
	betting_dv.football_match_his_l fixtures
	--home brier scores
	join
		(
		--aggregate brier scores
		select
			football_match_his_lid,
			avg(class_3_brier) class_3_brier,
			avg(class_2_home_brier) class_2_home_brier,
			avg(class_2_draw_brier) class_2_draw_brier,
			avg(class_2_away_brier) class_2_away_brier			
		from
			--historic home games + brier score for each match
			(
			select
				lnk.football_match_his_lid,
				round(1 / odds.pinacle_home_odds,4) home_prob,
				round(1 / odds.pinacle_draw_odds,4) draw_prob,
				round(1 / odds.pinalce_away_odds,4) away_prob,
				local.home_prob + local.draw_prob + local.away_prob all_probs,
				round(local.home_prob / (local.home_prob + local.draw_prob + local.away_prob),4) home_prob_wo_marg,
				round(local.draw_prob / (local.home_prob + local.draw_prob + local.away_prob),4) draw_prob_wo_marg,
				round(local.away_prob / (local.home_prob + local.draw_prob + local.away_prob),4) away_prob_wo_marg,
				case
					when stat.full_time_result = 'H' then power(local.home_prob_wo_marg - 1,2) + power(local.draw_prob_wo_marg - 0,2) + power(local.away_prob_wo_marg - 0,2)
					when stat.full_time_result = 'D' then power(local.home_prob_wo_marg - 0,2) + power(local.draw_prob_wo_marg - 1,2) + power(local.away_prob_wo_marg - 0,2)
					when stat.full_time_result = 'A' then power(local.home_prob_wo_marg - 0,2) + power(local.draw_prob_wo_marg - 0,2) + power(local.away_prob_wo_marg - 1,2)
				end class_3_brier,
				case
					when stat.full_time_result = 'H' then power(local.home_prob_wo_marg - 1,2)
					else power(local.home_prob_wo_marg - 0,2)
				end class_2_home_brier,
				case
					when stat.full_time_result = 'D' then power(local.draw_prob_wo_marg - 1,2)
					else power(local.draw_prob_wo_marg - 0,2)
				end class_2_draw_brier,
				case
					when stat.full_time_result = 'A' then power(local.away_prob_wo_marg - 1,2)
					else power(local.away_prob_wo_marg - 0,2)
				end class_2_away_brier,
				dense_rank() over (partition by lnk.football_match_his_lid order by his.match_date desc) match_rang
			from
				betting_dv.football_match_his_l lnk
				join betting_dv.football_match_his_l his
					on lnk.football_team_home_hid = his.football_team_home_hid
						and lnk.football_division_hid = his.football_division_hid
						and lnk.match_date > his.match_date
				join betting_dv.football_match_his_l_s_statistic stat
					on his.football_match_his_lid = stat.football_match_his_lid
				join betting_dv.football_match_his_l_s_odds odds
					on his.football_match_his_lid = odds.football_match_his_lid
			where
				--only finished matches
				stat.full_time_result is not null
			)
		where
			--last 5 home games
			match_rang <= 5
		group by
			football_match_his_lid
		having
			--5 home games must exist
			count(*) = 5	
		) home_his
	on (fixtures.football_match_his_lid = home_his.football_match_his_lid)
	--away brier score
	join
		(
		--aggregate brier score
		select
			football_match_his_lid,
			avg(class_3_brier) class_3_brier,
			avg(class_2_home_brier) class_2_home_brier,
			avg(class_2_draw_brier) class_2_draw_brier,
			avg(class_2_away_brier) class_2_away_brier		
		from
			--historic away games + brier score for each match
			(
			select
				lnk.football_match_his_lid,
				round(1 / odds.pinacle_home_odds,4) home_prob,
				round(1 / odds.pinacle_draw_odds,4) draw_prob,
				round(1 / odds.pinalce_away_odds,4) away_prob,
				local.home_prob + local.draw_prob + local.away_prob all_probs,
				round(local.home_prob / (local.home_prob + local.draw_prob + local.away_prob),4) home_prob_wo_marg,
				round(local.draw_prob / (local.home_prob + local.draw_prob + local.away_prob),4) draw_prob_wo_marg,
				round(local.away_prob / (local.home_prob + local.draw_prob + local.away_prob),4) away_prob_wo_marg,
				case
					when stat.full_time_result = 'H' then power(local.home_prob_wo_marg - 1,2) + power(local.draw_prob_wo_marg - 0,2) + power(local.away_prob_wo_marg - 0,2)
					when stat.full_time_result = 'D' then power(local.home_prob_wo_marg - 0,2) + power(local.draw_prob_wo_marg - 1,2) + power(local.away_prob_wo_marg - 0,2)
					when stat.full_time_result = 'A' then power(local.home_prob_wo_marg - 0,2) + power(local.draw_prob_wo_marg - 0,2) + power(local.away_prob_wo_marg - 1,2)
				end class_3_brier,
				case
					when stat.full_time_result = 'H' then power(local.home_prob_wo_marg - 1,2)
					else power(local.home_prob_wo_marg - 0,2)
				end class_2_home_brier,
				case
					when stat.full_time_result = 'D' then power(local.draw_prob_wo_marg - 1,2)
					else power(local.draw_prob_wo_marg - 0,2)
				end class_2_draw_brier,
				case
					when stat.full_time_result = 'A' then power(local.away_prob_wo_marg - 1,2)
					else power(local.away_prob_wo_marg - 0,2)
				end class_2_away_brier,
				dense_rank() over (partition by lnk.football_match_his_lid order by his.match_date desc) match_rang
			from
				betting_dv.football_match_his_l lnk
				join betting_dv.football_match_his_l his
					on lnk.football_team_away_hid = his.football_team_away_hid
						and lnk.football_division_hid = his.football_division_hid
						and lnk.match_date > his.match_date
				join betting_dv.football_match_his_l_s_statistic stat
					on his.football_match_his_lid = stat.football_match_his_lid
				join betting_dv.football_match_his_l_s_odds odds
					on his.football_match_his_lid = odds.football_match_his_lid
			where
				--only finished matches
				stat.full_time_result is not null
			)
		where
			--last 5 away games
			match_rang <= 5
		group by
			football_match_his_lid
		having
			--5 away games must exist
			count(*) = 5
		) away_his
	on (fixtures.football_match_his_lid = away_his.football_match_his_lid)
;
