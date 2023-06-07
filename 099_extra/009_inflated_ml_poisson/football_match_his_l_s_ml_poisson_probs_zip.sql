
alter session set query_timeout = 0;

create or replace table BETTING_DV.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_PROBS_ZIP
as
with division_zero_games as
(
SELECT
	FOOTBALL_DIVISION_HID,
	division,
	match_date,
	sum(division_home_num_zero_games) over (partition by football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) division_home_num_zero_games,
	sum(division_away_num_zero_games) over (partition by football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) division_away_num_zero_games,
	sum(division_num_games) over (partition by football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) division_num_games,
	avg(division_home_avg_goals) over (partition by football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) division_home_avg_goals,
	avg(division_away_avg_goals) over (partition by football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) division_away_avg_goals,
	local.division_home_num_zero_games / local.division_num_games division_home_perc_zero,
	betting_dv.poisson(0, local.division_home_avg_goals) divison_home_poisson_prob_zero,
	round(local.division_home_perc_zero - local.divison_home_poisson_prob_zero,4) division_home_prob_extra_zero,
	local.division_away_num_zero_games / local.division_num_games division_away_perc_zero,
	betting_dv.poisson(0, local.division_away_avg_goals) divison_away_poisson_prob_zero,	
	round(local.division_away_perc_zero - local.divison_away_poisson_prob_zero,4) division_away_prob_extra_zero
FROM
	(
	SELECT
		his.FOOTBALL_DIVISION_HID,
		his.DIVISION,
		his.MATCH_DATE,
		sum(case when s.FULL_TIME_HOME_GOALS = 0 then 1 else 0 end) division_home_num_zero_games,
		avg(s.FULL_TIME_HOME_GOALS) division_home_avg_goals,
		sum(case when s.FULL_TIME_AWAY_GOALS = 0 then 1 else 0 end) division_away_num_zero_games,
		avg(s.FULL_TIME_AWAY_GOALS) division_away_avg_goals,
		count(*) division_num_games
	FROM
		BETTING_DV.FOOTBALL_MATCH_HIS_B his
		join RAW_DV.FOOTBALL_MATCH_HIS_L_S_STATISTIC s
			on his.FOOTBALL_MATCH_HIS_LID = s.FOOTBALL_MATCH_HIS_LID
	group by 1,2,3
	)
)
select
	his.football_match_his_lid,
	feature_type || '/ZIP' feature_type,	
	round(betting_dv.zip(0, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_0,
	round(betting_dv.zip(1, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_1,
	round(betting_dv.zip(2, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_2,
	round(betting_dv.zip(3, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_3,
	round(betting_dv.zip(4, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_4,
	round(betting_dv.zip(5, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_5,
	round(betting_dv.zip(6, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_6,
	cast(1 - (local.prob_home_0 + local.prob_home_1 + local.prob_home_2 +
		local.prob_home_3 + local.prob_home_4 + local.prob_home_5 +
		local.prob_home_6) as decimal(30,10))  prob_home_7,
	round(betting_dv.zip(0, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_0,
	round(betting_dv.zip(1, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_1,
	round(betting_dv.zip(2, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_2,
	round(betting_dv.zip(3, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_3,
	round(betting_dv.zip(4, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_4,
	round(betting_dv.zip(5, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_5,
	round(betting_dv.zip(6, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_6,
	cast(1 - (local.prob_away_0 + local.prob_away_1 + local.prob_away_2 +
		local.prob_away_3 + local.prob_away_4 + local.prob_away_5 +
		local.prob_away_6) as decimal(30,10))  prob_away_7
from
	BETTING_DV.football_match_his_b his
	join BETTING_DV.football_match_his_l_s_ml_poisson_expected_goals exp_goals
		on his.FOOTBALL_MATCH_HIS_LID = exp_goals.FOOTBALL_MATCH_HIS_LID
	join division_zero_games div_zero
		on his.FOOTBALL_DIVISION_HID = div_zero.football_division_hid
			and his.match_date = div_zero.match_date
union
select
	his.football_match_his_lid,
	feature_type || '-ZIP' feature_type,	
	round(betting_dv.zip(0, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_0,
	round(betting_dv.zip(1, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_1,
	round(betting_dv.zip(2, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_2,
	round(betting_dv.zip(3, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_3,
	round(betting_dv.zip(4, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_4,
	round(betting_dv.zip(5, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_5,
	round(betting_dv.zip(6, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_6,
	cast(1 - (local.prob_home_0 + local.prob_home_1 + local.prob_home_2 +
		local.prob_home_3 + local.prob_home_4 + local.prob_home_5 +
		local.prob_home_6) as decimal(30,10))  prob_home_7,
	round(betting_dv.zip(0, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_0,
	round(betting_dv.zip(1, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_1,
	round(betting_dv.zip(2, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_2,
	round(betting_dv.zip(3, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_3,
	round(betting_dv.zip(4, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_4,
	round(betting_dv.zip(5, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_5,
	round(betting_dv.zip(6, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_6,
	cast(1 - (local.prob_away_0 + local.prob_away_1 + local.prob_away_2 +
		local.prob_away_3 + local.prob_away_4 + local.prob_away_5 +
		local.prob_away_6) as decimal(30,10))  prob_away_7
from
	BETTING_DV.football_match_his_b his
	join BETTING_DV.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_EXPECTED_GOALS_ADAPT exp_goals
		on his.FOOTBALL_MATCH_HIS_LID = exp_goals.FOOTBALL_MATCH_HIS_LID
	join division_zero_games div_zero
		on his.FOOTBALL_DIVISION_HID = div_zero.football_division_hid
			and his.match_date = div_zero.match_date
union
select
	his.football_match_his_lid,
	feature_type || '-ZIP' feature_type,	
	round(betting_dv.zip(0, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_0,
	round(betting_dv.zip(1, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_1,
	round(betting_dv.zip(2, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_2,
	round(betting_dv.zip(3, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_3,
	round(betting_dv.zip(4, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_4,
	round(betting_dv.zip(5, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_5,
	round(betting_dv.zip(6, exp_goals.home_exp_goals, div_zero.division_home_prob_extra_zero),4) prob_home_6,
	cast(1 - (local.prob_home_0 + local.prob_home_1 + local.prob_home_2 +
		local.prob_home_3 + local.prob_home_4 + local.prob_home_5 +
		local.prob_home_6) as decimal(30,10))  prob_home_7,
	round(betting_dv.zip(0, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_0,
	round(betting_dv.zip(1, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_1,
	round(betting_dv.zip(2, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_2,
	round(betting_dv.zip(3, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_3,
	round(betting_dv.zip(4, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_4,
	round(betting_dv.zip(5, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_5,
	round(betting_dv.zip(6, exp_goals.away_exp_goals, div_zero.division_away_prob_extra_zero),4) prob_away_6,
	cast(1 - (local.prob_away_0 + local.prob_away_1 + local.prob_away_2 +
		local.prob_away_3 + local.prob_away_4 + local.prob_away_5 +
		local.prob_away_6) as decimal(30,10))  prob_away_7
from
	BETTING_DV.football_match_his_b his
	join BETTING_DV.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_EXPECTED_XG_ADAPT exp_goals
		on his.FOOTBALL_MATCH_HIS_LID = exp_goals.FOOTBALL_MATCH_HIS_LID
	join division_zero_games div_zero
		on his.FOOTBALL_DIVISION_HID = div_zero.football_division_hid
			and his.match_date = div_zero.match_date

