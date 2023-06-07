--drop view BETTING_DV.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_PROBS_ADAPT;

create or replace table BETTING_DV.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_PROBS_ADAPT as
with div_perc_adapt
as
(
SELECT 
	football_division_hid,
	division,
	match_date,
	feature_type,
	--current match date is ignored as everything before is just available
	avg(perc_home_0) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_home_0,
	avg(perc_home_1) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_home_1,
	avg(perc_home_2) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	perc_home_2,
	avg(perc_home_3) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_home_3,
	avg(perc_home_4) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_home_4,
	avg(perc_home_5) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_home_5,
	avg(perc_home_6) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_home_6,
	avg(perc_home_7) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_home_7,
	avg(perc_away_0) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_away_0,
	avg(perc_away_1) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_away_1,
	avg(perc_away_2) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_away_2,
	avg(perc_away_3) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_away_3,
	avg(perc_away_4) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_away_4,
	avg(perc_away_5) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_away_5,
	avg(perc_away_6) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_away_6,
	avg(perc_away_7) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING)  	perc_away_7,
	avg(PROB_HOME_0) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_HOME_0,
	avg(PROB_HOME_1) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_HOME_1,
	avg(PROB_HOME_2) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_HOME_2,
	avg(PROB_HOME_3) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_HOME_3,
	avg(PROB_HOME_4) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_HOME_4,
	avg(PROB_HOME_5) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_HOME_5,
	avg(PROB_HOME_6) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_HOME_6,
	avg(PROB_HOME_7) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_HOME_7,
	avg(PROB_away_0) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_away_0,
	avg(PROB_away_1) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_away_1,
	avg(PROB_away_2) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_away_2,
	avg(PROB_away_3) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_away_3,
	avg(PROB_away_4) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_away_4,
	avg(PROB_away_5) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_away_5,
	avg(PROB_away_6) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_away_6,
	avg(PROB_away_7) over (partition by FEATURE_TYPE, football_division_hid order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 	PROB_away_7,
	round(local.perc_home_0 / (case when local.PROB_HOME_0 = 0 THEN 0.0001 ELSE local.PROB_HOME_0 end),4) perc_diff_home_0,
	round(local.perc_home_1 / (case when local.PROB_HOME_1 = 0 THEN 0.0001 ELSE local.PROB_HOME_1 end),4) perc_diff_home_1,
	round(local.perc_home_2 / (case when local.PROB_HOME_2 = 0 THEN 0.0001 ELSE local.PROB_HOME_2 end),4) perc_diff_home_2,
	round(local.perc_home_3 / (case when local.PROB_HOME_3 = 0 THEN 0.0001 ELSE local.PROB_HOME_3 end),4) perc_diff_home_3,
	round(local.perc_home_4 / (case when local.PROB_HOME_4 = 0 THEN 0.0001 ELSE local.PROB_HOME_4 end),4) perc_diff_home_4,
	round(local.perc_home_5 / (case when local.PROB_HOME_5 = 0 THEN 0.0001 ELSE local.PROB_HOME_5 end),4) perc_diff_home_5,
	round(local.perc_home_6 / (case when local.PROB_HOME_6 = 0 THEN 0.0001 ELSE local.PROB_HOME_6 end),4) perc_diff_home_6,
	round(local.perc_home_7 / (case when local.PROB_HOME_7 = 0 THEN 0.0001 ELSE local.PROB_HOME_7 end),4) perc_diff_home_7,
	round(local.perc_away_0 / (case when local.PROB_away_0 = 0 THEN 0.0001 ELSE local.PROB_away_0 end),4) perc_diff_away_0,
	round(local.perc_away_1 / (case when local.PROB_away_1 = 0 THEN 0.0001 ELSE local.PROB_away_1 end),4) perc_diff_away_1,
	round(local.perc_away_2 / (case when local.PROB_away_2 = 0 THEN 0.0001 ELSE local.PROB_away_2 end),4) perc_diff_away_2,
	round(local.perc_away_3 / (case when local.PROB_away_3 = 0 THEN 0.0001 ELSE local.PROB_away_3 end),4) perc_diff_away_3,
	round(local.perc_away_4 / (case when local.PROB_away_4 = 0 THEN 0.0001 ELSE local.PROB_away_4 end),4) perc_diff_away_4,
	round(local.perc_away_5 / (case when local.PROB_away_5 = 0 THEN 0.0001 ELSE local.PROB_away_5 end),4) perc_diff_away_5,
	round(local.perc_away_6 / (case when local.PROB_away_6 = 0 THEN 0.0001 ELSE local.PROB_away_6 end),4) perc_diff_away_6,
	round(local.perc_away_7 / (case when local.PROB_away_7 = 0 THEN 0.0001 ELSE local.PROB_away_7 end),4) perc_diff_away_7
FROM 
	(
	SELECT
		his.football_division_hid,
		his.division,
		his.match_date,
		p.FEATURE_TYPE,
		avg(case when s.FULL_TIME_HOME_GOALS = 0 then 1 else 0 end) perc_home_0,
		avg(case when s.FULL_TIME_HOME_GOALS = 1 then 1 else 0 end) perc_home_1,
		avg(case when s.FULL_TIME_HOME_GOALS = 2 then 1 else 0 end) perc_home_2,
		avg(case when s.FULL_TIME_HOME_GOALS = 3 then 1 else 0 end) perc_home_3,
		avg(case when s.FULL_TIME_HOME_GOALS = 4 then 1 else 0 end) perc_home_4,
		avg(case when s.FULL_TIME_HOME_GOALS = 5 then 1 else 0 end) perc_home_5,
		avg(case when s.FULL_TIME_HOME_GOALS = 6 then 1 else 0 end) perc_home_6,
		avg(case when s.FULL_TIME_HOME_GOALS >= 7 then 1 else 0 end) perc_home_7,
		avg(case when s.FULL_TIME_AWAY_GOALS = 0 then 1 else 0 end) perc_away_0,
		avg(case when s.FULL_TIME_AWAY_GOALS = 1 then 1 else 0 end) perc_away_1,
		avg(case when s.FULL_TIME_AWAY_GOALS = 2 then 1 else 0 end) perc_away_2,
		avg(case when s.FULL_TIME_AWAY_GOALS = 3 then 1 else 0 end) perc_away_3,
		avg(case when s.FULL_TIME_AWAY_GOALS = 4 then 1 else 0 end) perc_away_4,
		avg(case when s.FULL_TIME_AWAY_GOALS = 5 then 1 else 0 end) perc_away_5,
		avg(case when s.FULL_TIME_AWAY_GOALS = 6 then 1 else 0 end) perc_away_6,
		avg(case when s.FULL_TIME_AWAY_GOALS >= 7 then 1 else 0 end) perc_away_7,
		avg(p.PROB_HOME_0)	PROB_HOME_0,
		avg(p.PROB_HOME_1)	PROB_HOME_1,
		avg(p.PROB_HOME_2) 	PROB_HOME_2,
		avg(p.PROB_HOME_3) 	PROB_HOME_3,
		avg(p.PROB_HOME_4) 	PROB_HOME_4,
		avg(p.PROB_HOME_5) 	PROB_HOME_5,
		avg(p.PROB_HOME_6) 	PROB_HOME_6,
		avg(p.PROB_HOME_7) 	PROB_HOME_7,
		avg(p.PROB_away_0)	PROB_away_0,
		avg(p.PROB_away_1)	PROB_away_1,
		avg(p.PROB_away_2) 	PROB_away_2,
		avg(p.PROB_away_3) 	PROB_away_3,
		avg(p.PROB_away_4) 	PROB_away_4,
		avg(p.PROB_away_5) 	PROB_away_5,
		avg(p.PROB_away_6) 	PROB_away_6,
		avg(p.PROB_away_7) 	PROB_away_7
	FROM
		BETTING_DV.FOOTBALL_MATCH_HIS_B his
		join RAW_DV.FOOTBALL_MATCH_HIS_L_S_STATISTIC s
			on his.football_match_his_lid = s.FOOTBALL_MATCH_HIS_LID
		join BETTING_DV.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_PROBS p
			on his.football_match_his_lid = p.FOOTBALL_MATCH_HIS_LID
	group by 
		1,2,3,4
	)
WHERE 
	division <> 'D2'
	AND prob_home_7 IS NOT NULL
),
probs_adapt AS
(
select
	p.FOOTBALL_MATCH_HIS_LID,
	p.feature_type || '/goal probs adapted' feature_type,
	cast(p.PROB_HOME_0 * div_perc_adapt.perc_diff_home_0 as decimal(30,10))	PROB_HOME_0,
	cast(p.PROB_HOME_1 * div_perc_adapt.perc_diff_home_1 as decimal(30,10))	PROB_HOME_1,
	cast(p.PROB_HOME_2 * div_perc_adapt.perc_diff_home_2 as decimal(30,10))	PROB_HOME_2,
	cast(p.PROB_HOME_3 * div_perc_adapt.perc_diff_home_3 as decimal(30,10))	PROB_HOME_3,
	cast(p.PROB_HOME_4 * div_perc_adapt.perc_diff_home_4 as decimal(30,10))	PROB_HOME_4,
	cast(p.PROB_HOME_5 * div_perc_adapt.perc_diff_home_5 as decimal(30,10))	PROB_HOME_5,
	cast(p.PROB_HOME_6 * div_perc_adapt.perc_diff_home_6 as decimal(30,10))	PROB_HOME_6,
	cast(p.PROB_HOME_7 * div_perc_adapt.perc_diff_home_7 as decimal(30,10))	PROB_HOME_7,
	cast(p.PROB_AWAY_0 * div_perc_adapt.perc_diff_away_0 as decimal(30,10))	PROB_AWAY_0,
	cast(p.PROB_AWAY_1 * div_perc_adapt.perc_diff_away_1 as decimal(30,10))	PROB_AWAY_1,
	cast(p.PROB_AWAY_2 * div_perc_adapt.perc_diff_away_2 as decimal(30,10))	PROB_AWAY_2,
	cast(p.PROB_AWAY_3 * div_perc_adapt.perc_diff_away_3 as decimal(30,10))	PROB_AWAY_3,
	cast(p.PROB_AWAY_4 * div_perc_adapt.perc_diff_away_4 as decimal(30,10))	PROB_AWAY_4,
	cast(p.PROB_AWAY_5 * div_perc_adapt.perc_diff_away_5 as decimal(30,10))	PROB_AWAY_5,
	cast(p.PROB_AWAY_6 * div_perc_adapt.perc_diff_away_6 as decimal(30,10))	PROB_AWAY_6,
	cast(p.PROB_AWAY_7 * div_perc_adapt.perc_diff_away_7 as decimal(30,10))	PROB_AWAY_7
from
	betting_dv.FOOTBALL_MATCH_HIS_B his
	join betting_dv.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_PROBS p
		on his.FOOTBALL_MATCH_HIS_LID = p.FOOTBALL_MATCH_HIS_LID
	join div_perc_adapt
		on his.FOOTBALL_DIVISION_HID = div_perc_adapt.FOOTBALL_DIVISION_HID
		 	and his.MATCH_DATE = div_perc_adapt.match_date
		 	and p.feature_type = div_perc_adapt.feature_type
where
	perc_diff_home_7 is not null
	and perc_diff_away_7 is not NULL
)
SELECT
	football_match_his_lid,
	feature_type,
	cast((prob_home_0 + prob_home_1 + prob_home_2 + prob_home_3 + prob_home_4 + 
	prob_home_5 + prob_home_6 + prob_home_7) as decimal(30,10)) prob_home_overall,
	cast(1 - LOCAL.prob_home_overall as decimal(30,10)) home_scale_diff,
	cast(prob_home_0 + (LOCAL.home_scale_diff * prob_home_0) as decimal(30,10)) prob_home_0,
	cast(prob_home_1 + (LOCAL.home_scale_diff * prob_home_1) as decimal(30,10)) prob_home_1,
	cast(prob_home_2 + (LOCAL.home_scale_diff * prob_home_2) as decimal(30,10)) prob_home_2,
	cast(prob_home_3 + (LOCAL.home_scale_diff * prob_home_3) as decimal(30,10)) prob_home_3,
	cast(prob_home_4 + (LOCAL.home_scale_diff * prob_home_4) as decimal(30,10)) prob_home_4,
	cast(prob_home_5 + (LOCAL.home_scale_diff * prob_home_5) as decimal(30,10)) prob_home_5,
	cast(prob_home_6 + (LOCAL.home_scale_diff * prob_home_6) as decimal(30,10)) prob_home_6,
	cast(prob_home_7 + (LOCAL.home_scale_diff * prob_home_7) as decimal(30,10)) prob_home_7,
	cast((LOCAL.prob_home_0 + LOCAL.prob_home_1 + LOCAL.prob_home_2 + LOCAL.prob_home_3 + LOCAL.prob_home_4 + 
	LOCAL.prob_home_5 + LOCAL.prob_home_6 + LOCAL.prob_home_7) as decimal(30,10)) prob_home_overall_scale,
	cast((prob_away_0 + prob_away_1 + prob_away_2 + prob_away_3 + prob_away_4 + 
	prob_away_5 + prob_away_6 + prob_away_7) as decimal(30,10)) prob_away_overall,
	cast(1 - LOCAL.prob_away_overall as decimal(30,10)) away_scale_diff,
	cast(prob_away_0 + (LOCAL.away_scale_diff * prob_away_0) as decimal(30,10)) prob_away_0,
	cast(prob_away_1 + (LOCAL.away_scale_diff * prob_away_1) as decimal(30,10)) prob_away_1,
	cast(prob_away_2 + (LOCAL.away_scale_diff * prob_away_2) as decimal(30,10)) prob_away_2,
	cast(prob_away_3 + (LOCAL.away_scale_diff * prob_away_3) as decimal(30,10)) prob_away_3,
	cast(prob_away_4 + (LOCAL.away_scale_diff * prob_away_4) as decimal(30,10)) prob_away_4,
	cast(prob_away_5 + (LOCAL.away_scale_diff * prob_away_5) as decimal(30,10)) prob_away_5,
	cast(prob_away_6 + (LOCAL.away_scale_diff * prob_away_6) as decimal(30,10)) prob_away_6,
	cast(prob_away_7 + (LOCAL.away_scale_diff * prob_away_7) as decimal(30,10)) prob_away_7,
	cast((LOCAL.prob_away_0 + LOCAL.prob_away_1 + LOCAL.prob_away_2 + LOCAL.prob_away_3 + LOCAL.prob_away_4 + 
	LOCAL.prob_away_5 + LOCAL.prob_away_6 + LOCAL.prob_away_7) as decimal(30,10)) prob_away_overall_scale
FROM 
	probs_adapt