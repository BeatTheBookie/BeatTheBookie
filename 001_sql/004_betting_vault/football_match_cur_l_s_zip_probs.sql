

/************************************************
	betting vault prediction link-satellite
	- for link with current matches in division
	- probs for Zero-inflated Poisson distribution
	
v1:
	- initial
	- views:
		- football_match_cur_l_s_zip_probs
	- calculation for following betting markets
		- 1 / X / 2
	- 30 match history
		
*************************************************/


--drop view betting_dv.football_match_his_l_s_zip_probs;

create or replace view betting_dv.football_match_cur_l_s_zip_probs
as
select
	football_match_cur_lid,	
	round(home_attacking_strength * away_defence_strength * avg_league_home_goals_for,2) home_expect_goals,
	round(away_attacking_strength * home_defence_strength * avg_league_away_goals_for,2) away_expect_goals,
	round((league_home_num_zero_games / league_home_num_games) - betting_dv.poisson(0, avg_league_home_goals_for),4) league_home_prob_extra_zero,
	round((league_away_num_zero_games / league_away_num_games) - betting_dv.poisson(0, avg_league_away_goals_for),4) league_away_prob_extra_zero,
	round(betting_dv.zip(0, local.home_expect_goals, local.league_home_prob_extra_zero),4) prob_home_0,
	round(betting_dv.zip(1, local.home_expect_goals, local.league_home_prob_extra_zero),4) prob_home_1,
	round(betting_dv.zip(2, local.home_expect_goals, local.league_home_prob_extra_zero),4) prob_home_2,
	round(betting_dv.zip(3, local.home_expect_goals, local.league_home_prob_extra_zero),4) prob_home_3,
	round(betting_dv.zip(4, local.home_expect_goals, local.league_home_prob_extra_zero),4) prob_home_4,
	round(betting_dv.zip(5, local.home_expect_goals, local.league_home_prob_extra_zero),4) prob_home_5,
	round(betting_dv.zip(6, local.home_expect_goals, local.league_home_prob_extra_zero),4) prob_home_6,
	1 - (local.prob_home_0 + local.prob_home_1 + local.prob_home_2 +
		local.prob_home_3 + local.prob_home_4 + local.prob_home_5 +
		local.prob_home_6)  prob_home_7,
	round(betting_dv.zip(0, local.away_expect_goals, local.league_away_prob_extra_zero),4) prob_away_0,
	round(betting_dv.zip(1, local.away_expect_goals, local.league_away_prob_extra_zero),4) prob_away_1,
	round(betting_dv.zip(2, local.away_expect_goals, local.league_away_prob_extra_zero),4) prob_away_2,
	round(betting_dv.zip(3, local.away_expect_goals, local.league_away_prob_extra_zero),4) prob_away_3,
	round(betting_dv.zip(4, local.away_expect_goals, local.league_away_prob_extra_zero),4) prob_away_4,
	round(betting_dv.zip(5, local.away_expect_goals, local.league_away_prob_extra_zero),4) prob_away_5,
	round(betting_dv.zip(6, local.away_expect_goals, local.league_away_prob_extra_zero),4) prob_away_6,
	1 - (local.prob_away_0 + local.prob_away_1 + local.prob_away_2 +
		local.prob_away_3 + local.prob_away_4 + local.prob_away_5 +
		local.prob_away_6)  prob_away_7,
	round(
	local.prob_home_1 * local.prob_away_0 + --1:0
	local.prob_home_2 * local.prob_away_0 + --2:0
	local.prob_home_3 * local.prob_away_0 + --3:0
	local.prob_home_4 * local.prob_away_0 + --4:0
	local.prob_home_5 * local.prob_away_0 + --5:0
	local.prob_home_6 * local.prob_away_0 + --6:0
	local.prob_home_7 * local.prob_away_0 + --7:0
	local.prob_home_2 * local.prob_away_1 + --2:1
	local.prob_home_3 * local.prob_away_1 + --3:1
	local.prob_home_4 * local.prob_away_1 + --4:1
	local.prob_home_5 * local.prob_away_1 + --5:1
	local.prob_home_6 * local.prob_away_1 + --6:1
	local.prob_home_7 * local.prob_away_1 + --7:1
	local.prob_home_3 * local.prob_away_2 + --3:2
	local.prob_home_4 * local.prob_away_2 + --4:2
	local.prob_home_5 * local.prob_away_2 + --5:2
	local.prob_home_6 * local.prob_away_2 + --6:2
	local.prob_home_7 * local.prob_away_2 + --7:2
	local.prob_home_4 * local.prob_away_3 + --4:3
	local.prob_home_5 * local.prob_away_3 + --5:3
	local.prob_home_6 * local.prob_away_3 + --6:3
	local.prob_home_7 * local.prob_away_3 + --7:3
	local.prob_home_5 * local.prob_away_4 + --5:4
	local.prob_home_6 * local.prob_away_4 + --6:4
	local.prob_home_7 * local.prob_away_4 + --7:4
	local.prob_home_6 * local.prob_away_5 + --6:5
	local.prob_home_7 * local.prob_away_5 + --7:5
	local.prob_home_7 * local.prob_away_6 --7:6
	, 4) prob_home_win,
	round(
	local.prob_home_0 * local.prob_away_0 + --0:0
	local.prob_home_1 * local.prob_away_1 + --1:1
	local.prob_home_2 * local.prob_away_2 + --2:2
	local.prob_home_3 * local.prob_away_3 + --3:3
	local.prob_home_4 * local.prob_away_4 + --4:4
	local.prob_home_5 * local.prob_away_5 + --5:5
	local.prob_home_6 * local.prob_away_6 + --6:6
	local.prob_home_7 * local.prob_away_7 --7:7
	, 4) prob_draw,
	round(
	local.prob_home_0 * local.prob_away_1 + --0:1
	local.prob_home_0 * local.prob_away_2 + --0:2
	local.prob_home_0 * local.prob_away_3 + --0:3
	local.prob_home_0 * local.prob_away_4 + --0:4
	local.prob_home_0 * local.prob_away_5 + --0:5
	local.prob_home_0 * local.prob_away_6 + --0:6
	local.prob_home_0 * local.prob_away_7 + --0:7
	local.prob_home_1 * local.prob_away_2 + --1:2
	local.prob_home_1 * local.prob_away_3 + --1:3
	local.prob_home_1 * local.prob_away_4 + --1:4
	local.prob_home_1 * local.prob_away_5 + --1:5
	local.prob_home_1 * local.prob_away_6 + --1:6
	local.prob_home_1 * local.prob_away_7 + --1:7
	local.prob_home_2 * local.prob_away_3 + --2:3
	local.prob_home_2 * local.prob_away_4 + --2:4
	local.prob_home_2 * local.prob_away_5 + --2:5
	local.prob_home_2 * local.prob_away_6 + --2:6
	local.prob_home_2 * local.prob_away_7 + --2:7
	local.prob_home_3 * local.prob_away_4 + --3:4
	local.prob_home_3 * local.prob_away_5 + --3:5
	local.prob_home_3 * local.prob_away_6 + --3:6
	local.prob_home_3 * local.prob_away_7 + --3:7
	local.prob_home_4 * local.prob_away_5 + --4:5
	local.prob_home_4 * local.prob_away_6 + --4:6
	local.prob_home_4 * local.prob_away_7 + --4:7
	local.prob_home_5 * local.prob_away_6 + --5:6
	local.prob_home_5 * local.prob_away_7 + --5:7
	local.prob_home_6 * local.prob_away_7 --6:7
	, 4) prob_away_win
from
	betting_dv.football_match_cur_l_s_attack_defence_strength_30
;