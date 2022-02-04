

/************************************************

brier calculation for poisson models
	
v1:
	- initial
	- 1x2

		
*************************************************/


--drop view betting_dv.football_match_his_l_s_understat_poisson_betting;


CREATE OR REPLACE VIEW betting_dv.football_match_his_l_s_understat_betting
AS
WITH models AS
(
SELECT
	FOOTBALL_MATCH_HIS_LID ,
	model_name,
	HOME_GOALS,
	HOME_XGOALS, 
	AWAY_GOALS,
	AWAY_XGOALS,
	match_result,
	home_prob,
	draw_prob,
	away_prob
FROM
	betting_dv.football_match_his_l_s_understat_poisson_brier_sma
UNION
SELECT
	FOOTBALL_MATCH_HIS_LID ,
	model_name,
	HOME_GOALS,
	HOME_XGOALS, 
	AWAY_GOALS,
	AWAY_XGOALS,
	match_result,
	home_prob,
	draw_prob,
	away_prob
FROM
	betting_dv.football_match_his_l_s_understat_poisson_brier_ema
)
SELECT
	models.FOOTBALL_MATCH_HIS_LID ,
	models.model_name,
	models.HOME_GOALS,
	models.HOME_XGOALS, 
	models.AWAY_GOALS,
	models.AWAY_XGOALS,
	models.match_result,
	models.home_prob,
	models.draw_prob,
	models.away_prob,
	BET365_HOME_ODDS,
	1 / BET365_HOME_ODDS bet365_home_prob,
	BET365_DRAW_ODDS,
	1 / BET365_DRAW_ODDS bet365_draw_prob,
	BET365_AWAY_ODDS,
	1 / BET365_AWAY_ODDS bet365_away_prob
FROM
	models
	JOIN RAW_DV.FOOTBALL_MATCH_HIS_L_S_ODDS odds
		ON models.football_match_his_lid = odds.football_match_his_lid
WHERE
	1=1
	;