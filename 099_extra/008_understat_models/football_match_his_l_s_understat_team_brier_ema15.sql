
CREATE OR REPLACE view BETTING_DV.football_match_his_l_s_understat_team_brier_ema15
AS
SELECT
	his.FOOTBALL_MATCH_HIS_LID,
	pred.MODEL,
	his.HOME_GOALS, 
	his.AWAY_GOALS,
	CASE
		WHEN his.HOME_GOALS = his.AWAY_GOALS THEN 'X'
		WHEN his.HOME_GOALS > his.AWAY_GOALS THEN '1'
		ELSE '2'
	END match_result,
	pred.HOME_WIN_PROB,
	pred.DRAW_PROB,
	pred.AWAY_WIN_PROB,
	CASE
		WHEN LOCAL.match_result = '1' 
			THEN power(pred.HOME_WIN_PROB - 1,2) + power(pred.DRAW_PROB - 0,2) + power(pred.AWAY_WIN_PROB - 0,2)
		WHEN LOCAL.match_result = 'X'
			THEN power(pred.HOME_WIN_PROB - 0,2) + power(pred.DRAW_PROB - 1,2) + power(pred.AWAY_WIN_PROB - 0,2)
		WHEN LOCAL.match_result = '2'
			THEN power(pred.HOME_WIN_PROB - 0,2) + power(pred.DRAW_PROB - 0,2) + power(pred.AWAY_WIN_PROB - 1,2)
	END brier_score
FROM
	RAW_DV.FOOTBALL_MATCH_HIS_L_S_UNDERSTAT_TEAM_STATS his
	JOIN BETTING_DV.FOOTBALL_MATCH_HIS_L_S_UNDERSTAT_TEAM_PRED_EMA15 pred
		ON his.FOOTBALL_MATCH_HIS_LID = pred.FOOTBALL_MATCH_HIS_LID
union		
SELECT distinct
	odds.FOOTBALL_MATCH_HIS_LID,
	'Bet365 odds'	model_name,
	STATS.HOME_GOALS,
	STATS.AWAY_GOALS,
	CASE
		WHEN STATS.HOME_GOALS = STATS.AWAY_GOALS THEN 'X'
		WHEN STATS.HOME_GOALS > STATS.AWAY_GOALS THEN '1'
		ELSE '2'
	END match_result,
	1 / BET365_HOME_ODDS home_prob,
	1 / BET365_DRAW_ODDS draw_prob,
	1 / BET365_AWAY_ODDS away_prob,
	CASE
		WHEN local.match_result = '1' 
			THEN power(local.home_prob - 1,2) + power(local.draw_prob - 0,2) + power(local.away_prob - 0,2)
		WHEN local.match_result = 'X'
			THEN power(local.home_prob - 0,2) + power(local.draw_prob - 1,2) + power(local.away_prob - 0,2)
		WHEN local.match_result = '2'
			THEN power(local.home_prob - 0,2) + power(local.draw_prob - 0,2) + power(local.away_prob - 1,2)
	END brier_score
FROM
	BETTING_DV.FOOTBALL_MATCH_HIS_B his
	JOIN raw_dv.FOOTBALL_MATCH_HIS_L_S_ODDS odds
		ON his.FOOTBALL_MATCH_HIS_LID = ODDS.FOOTBALL_MATCH_HIS_LID 
	JOIN RAW_DV.FOOTBALL_MATCH_HIS_L_S_UNDERSTAT_TEAM_STATS stats
		ON odds.FOOTBALL_MATCH_HIS_LID = STATS.FOOTBALL_MATCH_HIS_LID
WHERE
	his.DIVISION IN ('D1','E0','I1','SP1','F1') AND
	his.SEASON IN ('2016_2017','2017_2018','2018_2019','2019_2020','2020_2021','2021_2022')
;