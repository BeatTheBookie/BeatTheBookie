--drop view betting_dv.football_match_his_l_s_ml_poisson_expected_goals_adapt;

create or replace table betting_dv.football_match_his_l_s_ml_poisson_expected_goals_adapt as
with div_perc_adapt
as
(
select
	FEATURE_TYPE,
	FOOTBALL_DIVISION_HID,
	DIVISION,
	match_date,
	--current match date is ignored as everything before is just available
	avg(div_avg_home_exp_goals) over (partition by FEATURE_TYPE, DIVISION order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 		div_avg_home_exp_goals,
	avg(div_avg_away_exp_goals) over (partition by FEATURE_TYPE, DIVISION order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 		div_avg_away_exp_goals,
	avg(div_avg_home_goals) over (partition by FEATURE_TYPE, DIVISION order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 			div_avg_home_goals,
	avg(div_avg_away_goals) over (partition by FEATURE_TYPE, DIVISION order by MATCH_DATE ROWS BETWEEN 100 PRECEDING and 1 PRECEDING) 			div_avg_away_goals,
	round(local.div_avg_home_goals / local.div_avg_home_exp_goals,4) exp_perc_diff_home,
	round(local.div_avg_away_goals / local.div_avg_away_exp_goals,4) exp_perc_diff_away,
	local.div_avg_home_exp_goals * local.exp_perc_diff_home home_exp_cor
FROM 
	(
	SELECT
		eg.FEATURE_TYPE,
		his.FOOTBALL_DIVISION_HID,
		his.DIVISION,	
		his.MATCH_DATE,	
		avg(eg.home_exp_goals) 		div_avg_home_exp_goals,
		avg(eg.away_exp_goals) 		div_avg_away_exp_goals,
		avg(s.full_time_home_goals)	div_avg_home_goals,
		avg(s.full_time_away_goals)	div_avg_away_goals
	FROM 
		BETTING_DV.FOOTBALL_MATCH_HIS_B his
		--only matches with predicted expected goals
		join BETTING_DV.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_EXPECTED_GOALS eg
			on his.FOOTBALL_MATCH_HIS_LID = eg.FOOTBALL_MATCH_HIS_LID
		--stats for matches
		join RAW_DV.FOOTBALL_MATCH_HIS_L_S_STATISTIC s
			on his.FOOTBALL_MATCH_HIS_LID = s.FOOTBALL_MATCH_HIS_LID
	group BY 1,2,3,4
	)
)
select
	eg.FOOTBALL_MATCH_HIS_LID,
	eg.feature_type || '/expG goals adapted' feature_type,
	CAST(eg.HOME_EXP_GOALS * div_perc_adapt.exp_perc_diff_home AS decimal(30,10)) HOME_EXP_GOALS,
	CAST(eg.away_EXP_GOALS * div_perc_adapt.exp_perc_diff_away AS decimal(30,10)) away_EXP_GOALS
from
	betting_dv.FOOTBALL_MATCH_HIS_B his
	join betting_dv.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_EXPECTED_GOALS eg
		on his.FOOTBALL_MATCH_HIS_LID = eg.FOOTBALL_MATCH_HIS_LID
	join div_perc_adapt
		on his.FOOTBALL_DIVISION_HID = div_perc_adapt.FOOTBALL_DIVISION_HID
		 	and his.MATCH_DATE = div_perc_adapt.match_date
		 	and eg.feature_type = div_perc_adapt.feature_type
WHERE
	exp_perc_diff_home is not null;