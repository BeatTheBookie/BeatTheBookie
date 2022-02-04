create or replace table betting_dv.football_match_his_l_s_understat_league_stats_sma as
/*
 * 500 matches are take to calculate the avg goals for a division
 */
select
  his.football_match_his_lid,
  -----
  --normal goals
  --SMAs for home goals for
  round(avg(stats.home_goals) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) home_goals_for_sma500,
  --SMAs for home goals against
  round(avg(stats.away_goals) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) home_goals_against_sma500,
  --SMAs for away goals fo
  round(avg(stats.away_goals) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) away_goals_for_sma500,
  --SMAs for away goals against
  round(avg(stats.home_goals) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) away_goals_against_sma500,
  ------
  --expected goals
  --SMAs for home xgoals for
  round(avg(stats.home_xgoals) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) home_xg_for_sma500,
  --SMAs for home xgoals against
  round(avg(stats.away_xgoals) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) home_xg_against_sma500,
  --SMAs for away xgoals for
  round(avg(stats.away_xgoals) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) away_xg_for_sma500,
  --SMAs for away xgoals against
  round(avg(stats.home_xgoals) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) away_xg_against_sma500,
  --shots
  --SMAs for home shots for
  round(avg(stats2.home_shots) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) home_shots_for_sma500,
  --SMAs for home shots against
  round(avg(stats2.away_shots) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) home_shots_against_sma500,
  --SMAs for away shots for
  round(avg(stats2.away_shots) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) away_shots_for_sma500,
  --SMAs for away shots against
  round(avg(stats2.home_shots) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) away_shots_against_sma500,
  --shots_on_target
  --SMAs for home shots_on_target for
  round(avg(stats2.home_shots_target) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) home_shots_on_target_for_sma500,
  --SMAs for home shots_on_target against
  round(avg(stats2.away_shots_target) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) home_shots_on_target_against_sma500,
  --SMAs for away shots_on_target for
  round(avg(stats2.away_shots_target) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) away_shots_on_target_for_sma500,
  --SMAs for away shots_on_target against
  round(avg(stats2.home_shots_target) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) away_shots_on_target_against_sma500,
  --ppda
  --SMAs for home ppda for
  round(avg(stats.home_ppda) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) home_ppda_for_sma500,
  --SMAs for home ppda against
  round(avg(stats.away_ppda) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) home_ppda_against_sma500,
  --SMAs for away ppda for
  round(avg(stats.away_ppda) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) away_ppda_for_sma500,
  --SMAs for away ppda against
  round(avg(stats.home_ppda) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) away_ppda_against_sma500,
  --deep
  --SMAs for home deep for
  round(avg(stats.home_deep) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) home_deep_for_sma500,
  --SMAs for home deep against
  round(avg(stats.away_deep) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) home_deep_against_sma500,
  --SMAs for away deep for
  round(avg(stats.away_deep) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) away_deep_for_sma500,
  --SMAs for away deep against
  round(avg(stats.home_deep) over (partition by division order by match_date rows between 500 preceding and current row exclude current row),1) away_deep_against_sma500
from
  betting_dv.football_match_his_b his
  join raw_dv.football_match_his_l_s_understat_team_stats stats on
    his.football_match_his_lid = stats.football_match_his_lid
  JOIN RAW_DV.FOOTBALL_MATCH_HIS_L_S_STATISTIC stats2
		ON his.FOOTBALL_MATCH_HIS_LID = stats2.FOOTBALL_MATCH_HIS_LID
;