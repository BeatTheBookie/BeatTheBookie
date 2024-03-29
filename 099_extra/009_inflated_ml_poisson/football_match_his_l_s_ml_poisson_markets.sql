

/************************************************

market calculations for zip 30avg model
	
v1:
	- initial
	- 1x2

		
*************************************************/


--drop view betting_dv.football_match_his_l_s_understat_poisson_markets_sma;

create or replace table betting_dv.football_match_his_l_s_ml_poisson_markets
AS	
--1x2
select
	football_match_his_lid,
	feature_type,
	cast(round(
	prob_home_1 * prob_away_0 + --1:0
	prob_home_2 * prob_away_0 + --2:0
	prob_home_3 * prob_away_0 + --3:0
	prob_home_4 * prob_away_0 + --4:0
	prob_home_5 * prob_away_0 + --5:0
	prob_home_6 * prob_away_0 + --6:0
	prob_home_7 * prob_away_0 + --7:0
	prob_home_2 * prob_away_1 + --2:1
	prob_home_3 * prob_away_1 + --3:1
	prob_home_4 * prob_away_1 + --4:1
	prob_home_5 * prob_away_1 + --5:1
	prob_home_6 * prob_away_1 + --6:1
	prob_home_7 * prob_away_1 + --7:1
	prob_home_3 * prob_away_2 + --3:2
	prob_home_4 * prob_away_2 + --4:2
	prob_home_5 * prob_away_2 + --5:2
	prob_home_6 * prob_away_2 + --6:2
	prob_home_7 * prob_away_2 + --7:2
	prob_home_4 * prob_away_3 + --4:3
	prob_home_5 * prob_away_3 + --5:3
	prob_home_6 * prob_away_3 + --6:3
	prob_home_7 * prob_away_3 + --7:3
	prob_home_5 * prob_away_4 + --5:4
	prob_home_6 * prob_away_4 + --6:4
	prob_home_7 * prob_away_4 + --7:4
	prob_home_6 * prob_away_5 + --6:5
	prob_home_7 * prob_away_5 + --7:5
	prob_home_7 * prob_away_6 --7:6
	, 4) as decimal(30,10))  home_prob,
	cast(round(
	prob_home_0 * prob_away_0 + --0:0
	prob_home_1 * prob_away_1 + --1:1
	prob_home_2 * prob_away_2 + --2:2
	prob_home_3 * prob_away_3 + --3:3
	prob_home_4 * prob_away_4 + --4:4
	prob_home_5 * prob_away_5 + --5:5
	prob_home_6 * prob_away_6 + --6:6
	prob_home_7 * prob_away_7 --7:7
	, 4) as decimal(30,10)) draw_prob,
	cast(round(
	prob_home_0 * prob_away_1 + --0:1
	prob_home_0 * prob_away_2 + --0:2
	prob_home_0 * prob_away_3 + --0:3
	prob_home_0 * prob_away_4 + --0:4
	prob_home_0 * prob_away_5 + --0:5
	prob_home_0 * prob_away_6 + --0:6
	prob_home_0 * prob_away_7 + --0:7
	prob_home_1 * prob_away_2 + --1:2
	prob_home_1 * prob_away_3 + --1:3
	prob_home_1 * prob_away_4 + --1:4
	prob_home_1 * prob_away_5 + --1:5
	prob_home_1 * prob_away_6 + --1:6
	prob_home_1 * prob_away_7 + --1:7
	prob_home_2 * prob_away_3 + --2:3
	prob_home_2 * prob_away_4 + --2:4
	prob_home_2 * prob_away_5 + --2:5
	prob_home_2 * prob_away_6 + --2:6
	prob_home_2 * prob_away_7 + --2:7
	prob_home_3 * prob_away_4 + --3:4
	prob_home_3 * prob_away_5 + --3:5
	prob_home_3 * prob_away_6 + --3:6
	prob_home_3 * prob_away_7 + --3:7
	prob_home_4 * prob_away_5 + --4:5
	prob_home_4 * prob_away_6 + --4:6
	prob_home_4 * prob_away_7 + --4:7
	prob_home_5 * prob_away_6 + --5:6
	prob_home_5 * prob_away_7 + --5:7
	prob_home_6 * prob_away_7 --6:7
	, 4) as decimal(30,10)) away_prob
FROM
	BETTING_DV.football_match_his_l_s_ml_poisson_probs
union
select
	football_match_his_lid,
	feature_type,
	cast(round(
	prob_home_1 * prob_away_0 + --1:0
	prob_home_2 * prob_away_0 + --2:0
	prob_home_3 * prob_away_0 + --3:0
	prob_home_4 * prob_away_0 + --4:0
	prob_home_5 * prob_away_0 + --5:0
	prob_home_6 * prob_away_0 + --6:0
	prob_home_7 * prob_away_0 + --7:0
	prob_home_2 * prob_away_1 + --2:1
	prob_home_3 * prob_away_1 + --3:1
	prob_home_4 * prob_away_1 + --4:1
	prob_home_5 * prob_away_1 + --5:1
	prob_home_6 * prob_away_1 + --6:1
	prob_home_7 * prob_away_1 + --7:1
	prob_home_3 * prob_away_2 + --3:2
	prob_home_4 * prob_away_2 + --4:2
	prob_home_5 * prob_away_2 + --5:2
	prob_home_6 * prob_away_2 + --6:2
	prob_home_7 * prob_away_2 + --7:2
	prob_home_4 * prob_away_3 + --4:3
	prob_home_5 * prob_away_3 + --5:3
	prob_home_6 * prob_away_3 + --6:3
	prob_home_7 * prob_away_3 + --7:3
	prob_home_5 * prob_away_4 + --5:4
	prob_home_6 * prob_away_4 + --6:4
	prob_home_7 * prob_away_4 + --7:4
	prob_home_6 * prob_away_5 + --6:5
	prob_home_7 * prob_away_5 + --7:5
	prob_home_7 * prob_away_6 --7:6
	, 4) as decimal(30,10)) home_prob,
	cast(round(
	prob_home_0 * prob_away_0 + --0:0
	prob_home_1 * prob_away_1 + --1:1
	prob_home_2 * prob_away_2 + --2:2
	prob_home_3 * prob_away_3 + --3:3
	prob_home_4 * prob_away_4 + --4:4
	prob_home_5 * prob_away_5 + --5:5
	prob_home_6 * prob_away_6 + --6:6
	prob_home_7 * prob_away_7 --7:7
	, 4) as decimal(30,10)) draw_prob,
	cast(round(
	prob_home_0 * prob_away_1 + --0:1
	prob_home_0 * prob_away_2 + --0:2
	prob_home_0 * prob_away_3 + --0:3
	prob_home_0 * prob_away_4 + --0:4
	prob_home_0 * prob_away_5 + --0:5
	prob_home_0 * prob_away_6 + --0:6
	prob_home_0 * prob_away_7 + --0:7
	prob_home_1 * prob_away_2 + --1:2
	prob_home_1 * prob_away_3 + --1:3
	prob_home_1 * prob_away_4 + --1:4
	prob_home_1 * prob_away_5 + --1:5
	prob_home_1 * prob_away_6 + --1:6
	prob_home_1 * prob_away_7 + --1:7
	prob_home_2 * prob_away_3 + --2:3
	prob_home_2 * prob_away_4 + --2:4
	prob_home_2 * prob_away_5 + --2:5
	prob_home_2 * prob_away_6 + --2:6
	prob_home_2 * prob_away_7 + --2:7
	prob_home_3 * prob_away_4 + --3:4
	prob_home_3 * prob_away_5 + --3:5
	prob_home_3 * prob_away_6 + --3:6
	prob_home_3 * prob_away_7 + --3:7
	prob_home_4 * prob_away_5 + --4:5
	prob_home_4 * prob_away_6 + --4:6
	prob_home_4 * prob_away_7 + --4:7
	prob_home_5 * prob_away_6 + --5:6
	prob_home_5 * prob_away_7 + --5:7
	prob_home_6 * prob_away_7 --6:7
	, 4) as decimal(30,10)) away_prob
FROM
	BETTING_DV.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_PROBS_ADAPT
union
select
	football_match_his_lid,
	feature_type,
	cast(round(
	prob_home_1 * prob_away_0 + --1:0
	prob_home_2 * prob_away_0 + --2:0
	prob_home_3 * prob_away_0 + --3:0
	prob_home_4 * prob_away_0 + --4:0
	prob_home_5 * prob_away_0 + --5:0
	prob_home_6 * prob_away_0 + --6:0
	prob_home_7 * prob_away_0 + --7:0
	prob_home_2 * prob_away_1 + --2:1
	prob_home_3 * prob_away_1 + --3:1
	prob_home_4 * prob_away_1 + --4:1
	prob_home_5 * prob_away_1 + --5:1
	prob_home_6 * prob_away_1 + --6:1
	prob_home_7 * prob_away_1 + --7:1
	prob_home_3 * prob_away_2 + --3:2
	prob_home_4 * prob_away_2 + --4:2
	prob_home_5 * prob_away_2 + --5:2
	prob_home_6 * prob_away_2 + --6:2
	prob_home_7 * prob_away_2 + --7:2
	prob_home_4 * prob_away_3 + --4:3
	prob_home_5 * prob_away_3 + --5:3
	prob_home_6 * prob_away_3 + --6:3
	prob_home_7 * prob_away_3 + --7:3
	prob_home_5 * prob_away_4 + --5:4
	prob_home_6 * prob_away_4 + --6:4
	prob_home_7 * prob_away_4 + --7:4
	prob_home_6 * prob_away_5 + --6:5
	prob_home_7 * prob_away_5 + --7:5
	prob_home_7 * prob_away_6 --7:6
	, 4) as decimal(30,10)) home_prob,
	cast(round(
	prob_home_0 * prob_away_0 + --0:0
	prob_home_1 * prob_away_1 + --1:1
	prob_home_2 * prob_away_2 + --2:2
	prob_home_3 * prob_away_3 + --3:3
	prob_home_4 * prob_away_4 + --4:4
	prob_home_5 * prob_away_5 + --5:5
	prob_home_6 * prob_away_6 + --6:6
	prob_home_7 * prob_away_7 --7:7
	, 4) as decimal(30,10)) draw_prob,
	cast(round(
	prob_home_0 * prob_away_1 + --0:1
	prob_home_0 * prob_away_2 + --0:2
	prob_home_0 * prob_away_3 + --0:3
	prob_home_0 * prob_away_4 + --0:4
	prob_home_0 * prob_away_5 + --0:5
	prob_home_0 * prob_away_6 + --0:6
	prob_home_0 * prob_away_7 + --0:7
	prob_home_1 * prob_away_2 + --1:2
	prob_home_1 * prob_away_3 + --1:3
	prob_home_1 * prob_away_4 + --1:4
	prob_home_1 * prob_away_5 + --1:5
	prob_home_1 * prob_away_6 + --1:6
	prob_home_1 * prob_away_7 + --1:7
	prob_home_2 * prob_away_3 + --2:3
	prob_home_2 * prob_away_4 + --2:4
	prob_home_2 * prob_away_5 + --2:5
	prob_home_2 * prob_away_6 + --2:6
	prob_home_2 * prob_away_7 + --2:7
	prob_home_3 * prob_away_4 + --3:4
	prob_home_3 * prob_away_5 + --3:5
	prob_home_3 * prob_away_6 + --3:6
	prob_home_3 * prob_away_7 + --3:7
	prob_home_4 * prob_away_5 + --4:5
	prob_home_4 * prob_away_6 + --4:6
	prob_home_4 * prob_away_7 + --4:7
	prob_home_5 * prob_away_6 + --5:6
	prob_home_5 * prob_away_7 + --5:7
	prob_home_6 * prob_away_7 --6:7
	, 4) as decimal(30,10)) away_prob
FROM
	BETTING_DV.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_PROBS_ZIP