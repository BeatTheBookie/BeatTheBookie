

/************************************************

brier calculation for poisson models
	
v1:
	- initial
	- 1x2

		
*************************************************/


--drop view betting_dv.football_match_his_l_s_understat_poisson_betting;


CREATE OR REPLACE VIEW betting_dv.football_match_his_l_s_understat_team_betting_ema15
AS
SELECT
	models.FOOTBALL_MATCH_HIS_LID ,
	models.model,
	STATS.HOME_GOALS,
	STATS.AWAY_GOALS,
	CASE
		WHEN STATS.HOME_GOALS = STATS.AWAY_GOALS THEN 'X'
		WHEN STATS.HOME_GOALS > STATS.AWAY_GOALS THEN '1'
		ELSE '2'
	END match_result,
	models.home_win_prob,
	models.draw_prob,
	models.away_win_prob,
	BET365_HOME_ODDS,
	1 / BET365_HOME_ODDS bet365_home_prob,
	BET365_DRAW_ODDS,
	1 / BET365_DRAW_ODDS bet365_draw_prob,
	BET365_AWAY_ODDS,
	1 / BET365_AWAY_ODDS bet365_away_prob,
	(models.home_win_prob * BET365_HOME_ODDS) - 1 home_win_value,
	(models.draw_prob * BET365_DRAW_ODDS) - 1 draw_value,
	(models.away_win_prob * BET365_AWAY_ODDS) - 1 away_win_value
FROM
	BETTING_DV.FOOTBALL_MATCH_HIS_L_S_UNDERSTAT_TEAM_PRED_EMA15 models
	JOIN RAW_DV.FOOTBALL_MATCH_HIS_L_S_UNDERSTAT_TEAM_STATS stats
		ON models.FOOTBALL_MATCH_HIS_LID = STATS.FOOTBALL_MATCH_HIS_LID
	JOIN RAW_DV.FOOTBALL_MATCH_HIS_L_S_ODDS odds
		ON models.football_match_his_lid = odds.football_match_his_lid
WHERE
	1=1
	;