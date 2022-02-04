CREATE OR REPLACE TABLE betting_dv.FOOTBALL_MATCH_HIS_L_S_UNDERSTAT_TEAM_STRENGTH_FEATURES_EMA15
as
SELECT
	--general match_info
	ema.FOOTBALL_MATCH_HIS_LID,
	--calculate home strengths
	ema.HOME_GOALS_FOR_EMA15 / div_stats.HOME_GOALS_FOR_SMA500 			home_goals_for_strength,
	ema.HOME_GOALS_AGAINST_EMA15 / div_stats.HOME_GOALS_FOR_SMA500		home_goals_against_strength,
	ema.HOME_xg_FOR_EMA15 / div_stats.HOME_xg_FOR_SMA500 			home_xg_for_strength,
	ema.HOME_xg_AGAINST_EMA15 / div_stats.HOME_xg_FOR_SMA500		home_xg_against_strength,
	ema.HOME_shots_FOR_EMA15 / div_stats.HOME_shots_FOR_SMA500 			home_shots_for_strength,
	ema.HOME_shots_AGAINST_EMA15 / div_stats.HOME_shots_FOR_SMA500		home_shots_against_strength,
	ema.HOME_shots_target_FOR_EMA15 / div_stats.HOME_shots_on_target_FOR_SMA500 			home_shots_on_target_for_strength,
	ema.HOME_shots_target_AGAINST_EMA15 / div_stats.HOME_shots_on_target_FOR_SMA500		home_shots_on_target_against_strength,
	ema.HOME_ppda_FOR_EMA15 / div_stats.HOME_ppda_FOR_SMA500 			home_ppda_for_strength,
	ema.HOME_ppda_AGAINST_EMA15 / div_stats.HOME_ppda_FOR_SMA500		home_ppda_against_strength,
	ema.HOME_deep_FOR_EMA15 / div_stats.HOME_deep_FOR_SMA500 			home_deep_for_strength,
	ema.HOME_deep_AGAINST_EMA15 / div_stats.HOME_deep_FOR_SMA500		home_deep_against_strength,
	--calculate away strengths
	ema.away_GOALS_FOR_EMA15 / div_stats.away_GOALS_FOR_SMA500 			away_goals_for_strength,
	ema.away_GOALS_AGAINST_EMA15 / div_stats.away_GOALS_FOR_SMA500		away_goals_against_strength,
	ema.away_xg_FOR_EMA15 / div_stats.away_xg_FOR_SMA500 			away_xg_for_strength,
	ema.away_xg_AGAINST_EMA15 / div_stats.away_xg_FOR_SMA500		away_xg_against_strength,
	ema.away_shots_FOR_EMA15 / div_stats.away_shots_FOR_SMA500 			away_shots_for_strength,
	ema.away_shots_AGAINST_EMA15 / div_stats.away_shots_FOR_SMA500		away_shots_against_strength,
	ema.away_shots_target_FOR_EMA15 / div_stats.away_shots_on_target_FOR_SMA500 			away_shots_on_target_for_strength,
	ema.away_shots_target_AGAINST_EMA15 / div_stats.away_shots_on_target_FOR_SMA500		away_shots_on_target_against_strength,
	ema.away_ppda_FOR_EMA15 / div_stats.away_ppda_FOR_SMA500 			away_ppda_for_strength,
	ema.away_ppda_AGAINST_EMA15 / div_stats.away_ppda_FOR_SMA500		away_ppda_against_strength,
	ema.away_deep_FOR_EMA15 / div_stats.away_deep_FOR_SMA500 			away_deep_for_strength,
	ema.away_deep_AGAINST_EMA15 / div_stats.away_deep_FOR_SMA500		away_deep_against_strength	
FROM 
	BETTING_DV.FOOTBALL_MATCH_HIS_L_S_UNDERSTAT_TEAM_STATS_EMA15 ema
	JOIN BETTING_DV.FOOTBALL_MATCH_HIS_L_S_UNDERSTAT_LEAGUE_STATS_SMA div_stats
		ON ema.FOOTBALL_MATCH_HIS_LID = div_stats.FOOTBALL_MATCH_HIS_LID