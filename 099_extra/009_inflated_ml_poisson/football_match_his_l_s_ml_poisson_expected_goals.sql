

create or replace table betting_dv.football_match_his_l_s_ml_poisson_expected_goals
	(
	football_match_his_lid		char(32),
	feature_type				varchar(100),
	home_exp_goals				decimal(30,10),
	away_exp_goals				decimal(30,10),
	iterator_param				varchar(100)
	);
	




SELECT 	
	iterator_param,
	count(*) anz_datensaetze,
	count(distinct feature_type) anz_modelle
FROM 
betting_dv.football_match_his_l_s_ml_poisson_expected_goals
group by 1
order by 1;




create or replace view betting_mart.ml_poisson_expected_goals
as
select
	--match information
	his.FOOTBALL_DIVISION_HID				division_id,
	dm.DIVISION_ALIGNED 					division,
	his.FOOTBALL_SEASON_HID 				season_id,
	his.season								season,
	his.MATCH_DATE 							match_date,
	his.home_team || ' - ' || his.away_team match_teams,
	his.FOOTBALL_TEAM_HOME_HID				home_team_id, 
	his.home_team							home_team,
	his.FOOTBALL_TEAM_AWAY_HID 				away_team_id,
	his.away_team							away_team,
	--predictions
	eg.FEATURE_TYPE,
	eg.ITERATOR_PARAM,
	eg.HOME_EXP_GOALS,
	eg.AWAY_EXP_GOALS
from
	--historic matches
	betting_dv.football_match_his_b his
	--aligned division names
	JOIN RAW_DV.FOOTBALL_TEAM_H_S_DIVISION_MAPPING dm
		ON his.FOOTBALL_DIVISION_HID = dm.FOOTBALL_DIVISION_HID	
	--predicted expected goals 
	join BETTING_DV.FOOTBALL_MATCH_HIS_L_S_ML_POISSON_EXPECTED_GOALS eg
		on his.FOOTBALL_MATCH_HIS_LID = eg.FOOTBALL_MATCH_HIS_LID



