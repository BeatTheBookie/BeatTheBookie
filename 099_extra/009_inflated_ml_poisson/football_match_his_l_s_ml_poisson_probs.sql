
alter session set query_timeout = 0;

create or replace table betting_dv.football_match_his_l_s_ml_poisson_probs as
select
	football_match_his_lid,
	feature_type,
	cast(round(betting_dv.poisson(0, home_exp_goals),4) as decimal(30,10)) prob_home_0,
	cast(round(betting_dv.poisson(1, home_exp_goals),4) as decimal(30,10)) prob_home_1,
	cast(round(betting_dv.poisson(2, home_exp_goals),4) as decimal(30,10)) prob_home_2,
	cast(round(betting_dv.poisson(3, home_exp_goals),4) as decimal(30,10)) prob_home_3,
	cast(round(betting_dv.poisson(4, home_exp_goals),4) as decimal(30,10)) prob_home_4,
	cast(round(betting_dv.poisson(5, home_exp_goals),4) as decimal(30,10)) prob_home_5,
	cast(round(betting_dv.poisson(6, home_exp_goals),4) as decimal(30,10)) prob_home_6,
	cast(1 - (local.prob_home_0 + local.prob_home_1 + local.prob_home_2 +
		local.prob_home_3 + local.prob_home_4 + local.prob_home_5 +
		local.prob_home_6) as decimal(30,10))  prob_home_7,
	cast(round(betting_dv.poisson(0, away_exp_goals),4) as decimal(30,10)) prob_away_0,
	cast(round(betting_dv.poisson(1, away_exp_goals),4) as decimal(30,10)) prob_away_1,
	cast(round(betting_dv.poisson(2, away_exp_goals),4) as decimal(30,10)) prob_away_2,
	cast(round(betting_dv.poisson(3, away_exp_goals),4) as decimal(30,10)) prob_away_3,
	cast(round(betting_dv.poisson(4, away_exp_goals),4) as decimal(30,10)) prob_away_4,
	cast(round(betting_dv.poisson(5, away_exp_goals),4) as decimal(30,10)) prob_away_5,
	cast(round(betting_dv.poisson(6, away_exp_goals),4) as decimal(30,10)) prob_away_6,
	cast(1 - (local.prob_away_0 + local.prob_away_1 + local.prob_away_2 +
		local.prob_away_3 + local.prob_away_4 + local.prob_away_5 +
		local.prob_away_6) as decimal(30,10))  prob_away_7
from
	BETTING_DV.football_match_his_l_s_ml_poisson_expected_goals
union
select
	football_match_his_lid,
	feature_type,
	cast(round(betting_dv.poisson(0, home_exp_goals),4) as decimal(30,10)) prob_home_0,
	cast(round(betting_dv.poisson(1, home_exp_goals),4) as decimal(30,10)) prob_home_1,
	cast(round(betting_dv.poisson(2, home_exp_goals),4) as decimal(30,10)) prob_home_2,
	cast(round(betting_dv.poisson(3, home_exp_goals),4) as decimal(30,10)) prob_home_3,
	cast(round(betting_dv.poisson(4, home_exp_goals),4) as decimal(30,10)) prob_home_4,
	cast(round(betting_dv.poisson(5, home_exp_goals),4) as decimal(30,10)) prob_home_5,
	cast(round(betting_dv.poisson(6, home_exp_goals),4) as decimal(30,10)) prob_home_6,
	cast(1 - (local.prob_home_0 + local.prob_home_1 + local.prob_home_2 +
		local.prob_home_3 + local.prob_home_4 + local.prob_home_5 +
		local.prob_home_6) as decimal(30,10))  prob_home_7,
	cast(round(betting_dv.poisson(0, away_exp_goals),4) as decimal(30,10)) prob_away_0,
	cast(round(betting_dv.poisson(1, away_exp_goals),4) as decimal(30,10)) prob_away_1,
	cast(round(betting_dv.poisson(2, away_exp_goals),4) as decimal(30,10)) prob_away_2,
	cast(round(betting_dv.poisson(3, away_exp_goals),4) as decimal(30,10)) prob_away_3,
	cast(round(betting_dv.poisson(4, away_exp_goals),4) as decimal(30,10)) prob_away_4,
	cast(round(betting_dv.poisson(5, away_exp_goals),4) as decimal(30,10)) prob_away_5,
	cast(round(betting_dv.poisson(6, away_exp_goals),4) as decimal(30,10)) prob_away_6,
	cast(1 - (local.prob_away_0 + local.prob_away_1 + local.prob_away_2 +
		local.prob_away_3 + local.prob_away_4 + local.prob_away_5 +
		local.prob_away_6) as decimal(30,10))  prob_away_7
from
	BETTING_DV.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_EXPECTED_GOALS_ADAPT 
union
select
	football_match_his_lid,
	feature_type,
	cast(round(betting_dv.poisson(0, home_exp_goals),4) as decimal(30,10)) prob_home_0,
	cast(round(betting_dv.poisson(1, home_exp_goals),4) as decimal(30,10)) prob_home_1,
	cast(round(betting_dv.poisson(2, home_exp_goals),4) as decimal(30,10)) prob_home_2,
	cast(round(betting_dv.poisson(3, home_exp_goals),4) as decimal(30,10)) prob_home_3,
	cast(round(betting_dv.poisson(4, home_exp_goals),4) as decimal(30,10)) prob_home_4,
	cast(round(betting_dv.poisson(5, home_exp_goals),4) as decimal(30,10)) prob_home_5,
	cast(round(betting_dv.poisson(6, home_exp_goals),4) as decimal(30,10)) prob_home_6,
	cast(1 - (local.prob_home_0 + local.prob_home_1 + local.prob_home_2 +
		local.prob_home_3 + local.prob_home_4 + local.prob_home_5 +
		local.prob_home_6) as decimal(30,10))  prob_home_7,
	cast(round(betting_dv.poisson(0, away_exp_goals),4) as decimal(30,10)) prob_away_0,
	cast(round(betting_dv.poisson(1, away_exp_goals),4) as decimal(30,10)) prob_away_1,
	cast(round(betting_dv.poisson(2, away_exp_goals),4) as decimal(30,10)) prob_away_2,
	cast(round(betting_dv.poisson(3, away_exp_goals),4) as decimal(30,10)) prob_away_3,
	cast(round(betting_dv.poisson(4, away_exp_goals),4) as decimal(30,10)) prob_away_4,
	cast(round(betting_dv.poisson(5, away_exp_goals),4) as decimal(30,10)) prob_away_5,
	cast(round(betting_dv.poisson(6, away_exp_goals),4) as decimal(30,10)) prob_away_6,
	cast(1 - (local.prob_away_0 + local.prob_away_1 + local.prob_away_2 +
		local.prob_away_3 + local.prob_away_4 + local.prob_away_5 +
		local.prob_away_6) as decimal(30,10))  prob_away_7
from
	BETTING_DV.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_EXPECTED_XG_ADAPT 

