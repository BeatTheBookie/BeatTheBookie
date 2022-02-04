create or replace table betting_dv.football_match_his_l_s_understat_team_stats_ema15 as
WITH mvd_stats
AS
(
/**
get historic matches for teams
statistics are projected for 1 match in the past,
as the result of the current match should not be part of
the prediction features,
not difference between home and away
**/
SELECT 
	his.football_match_his_lid,
	his.MATCH_DATE,
	--get next match, to exclude stats for current one
	--stats are moved by one match
	lag(his.football_match_his_lid) over (partition by t.FOOTBALL_TEAM_HID order by his.match_date desc) next_football_match_his_lid,
	lag(his.MATCH_DATE) OVER (PARTITION BY t.FOOTBALL_TEAM_HID ORDER BY his.MATCH_DATE desc) next_match_date,
	lead(his.football_match_his_lid) over (partition by t.FOOTBALL_TEAM_HID order by his.match_date desc) prev_football_match_his_lid,
	lead(his.MATCH_DATE) OVER (PARTITION BY t.FOOTBALL_TEAM_HID ORDER BY his.MATCH_DATE desc) prev_match_date,
	--
	his.FOOTBALL_TEAM_HOME_HID, 
	his.HOME_TEAM,
	his.FOOTBALL_TEAM_AWAY_HID,
	his.AWAY_TEAM, 
	--
	t.FOOTBALL_TEAM_HID,
	t.TEAM ,
	CASE 
		WHEN t.FOOTBALL_TEAM_HID = his.FOOTBALL_TEAM_HOME_HID THEN 'h'
		WHEN t.FOOTBALL_TEAM_HID = his.FOOTBALL_TEAM_AWAY_HID THEN 'a'
		ELSE 'n.a.'
	END home_away,
	CASE WHEN LOCAL.home_away = 'h' THEN s1.home_goals else s1.away_goals END						goals_for,
	CASE WHEN LOCAL.home_away = 'h' THEN s1.away_goals else s1.home_goals END						goals_against,
	CASE WHEN LOCAL.home_away = 'h' THEN s1.home_xgoals else s1.away_xgoals END						xg_for,
	CASE WHEN LOCAL.home_away = 'h' THEN s1.away_xgoals else s1.home_xgoals END						xg_against,
	CASE WHEN LOCAL.home_away = 'h' THEN s1.home_npxg else s1.away_npxg END							npxg_for,
	CASE WHEN LOCAL.home_away = 'h' THEN s1.away_npxg else s1.home_npxg END							npxg_against,
	CASE WHEN LOCAL.home_away = 'h' THEN s2.home_shots else s2.away_shots END						shots_for,
	CASE WHEN LOCAL.home_away = 'h' THEN s2.away_shots else s2.home_shots END						shots_against,
	CASE WHEN LOCAL.home_away = 'h' THEN s2.home_shots_target else s2.away_shots_target END			shots_target_for,
	CASE WHEN LOCAL.home_away = 'h' THEN s2.away_shots_target else s2.home_shots_target END			shots_target_against,
	CASE WHEN LOCAL.home_away = 'h' THEN s1.home_deep else s1.away_deep END							deep_for,
	CASE WHEN LOCAL.home_away = 'h' THEN s1.away_deep else s1.home_deep END							deep_against,
	CASE WHEN LOCAL.home_away = 'h' THEN s1.home_ppda else s1.away_ppda END							ppda_for,
	CASE WHEN LOCAL.home_away = 'h' THEN s1.away_ppda else s1.home_ppda END							ppda_against
from
	betting_dv.football_match_his_b his
	JOIN RAW_DV.FOOTBALL_MATCH_HIS_L_S_UNDERSTAT_TEAM_STATS s1
		ON his.FOOTBALL_MATCH_HIS_LID = s1.FOOTBALL_MATCH_HIS_LID
	JOIN RAW_DV.FOOTBALL_MATCH_HIS_L_S_STATISTIC s2
		ON his.FOOTBALL_MATCH_HIS_LID = s2.FOOTBALL_MATCH_HIS_LID
	--join team for away and home to get
	--complete historic matches
	JOIN RAW_DV.FOOTBALL_TEAM_H t
		ON his.FOOTBALL_TEAM_HOME_HID = t.FOOTBALL_TEAM_HID 
		OR his.FOOTBALL_TEAM_AWAY_HID = t.FOOTBALL_TEAM_HID
),
/****
calculate EMA for stats
*****/
goals_for_ema15 AS
(
SELECT
  	betting_dv.ema(mvd_stats.football_team_hid, mvd_stats.match_date, mvd_stats.goals_for, 15)  
from
  	mvd_stats
GROUP BY
	mvd_stats.football_team_hid
),
goals_against_ema15 AS
(
SELECT
  	betting_dv.ema(mvd_stats.football_team_hid, mvd_stats.match_date, mvd_stats.goals_against, 15)  
from
  	mvd_stats
GROUP BY
	mvd_stats.football_team_hid
),
xg_for_ema15 AS
(
SELECT
  	betting_dv.ema(mvd_stats.football_team_hid, mvd_stats.match_date, mvd_stats.xg_for, 15)  
from
  	mvd_stats
GROUP BY
	mvd_stats.football_team_hid
),
xg_against_ema15 AS
(
SELECT
  	betting_dv.ema(mvd_stats.football_team_hid, mvd_stats.match_date, mvd_stats.xg_against, 15)  
from
  	mvd_stats
GROUP BY
	mvd_stats.football_team_hid
),
shots_for_ema15 AS
(
SELECT
  	betting_dv.ema(mvd_stats.football_team_hid, mvd_stats.match_date, mvd_stats.shots_for, 15)  
from
  	mvd_stats
GROUP BY
	mvd_stats.football_team_hid
),
shots_against_ema15 AS
(
SELECT
  	betting_dv.ema(mvd_stats.football_team_hid, mvd_stats.match_date, mvd_stats.shots_against, 15)  
from
  	mvd_stats
GROUP BY
	mvd_stats.football_team_hid
),
shots_target_for_ema15 AS
(
SELECT
  	betting_dv.ema(mvd_stats.football_team_hid, mvd_stats.match_date, mvd_stats.shots_target_for, 15)  
from
  	mvd_stats
GROUP BY
	mvd_stats.football_team_hid
),
shots_target_against_ema15 AS
(
SELECT
  	betting_dv.ema(mvd_stats.football_team_hid, mvd_stats.match_date, mvd_stats.shots_target_against, 15)  
from
  	mvd_stats
GROUP BY
	mvd_stats.football_team_hid
),
deep_for_ema15 AS
(
SELECT
  	betting_dv.ema(mvd_stats.football_team_hid, mvd_stats.match_date, mvd_stats.deep_for, 15)  
from
  	mvd_stats
GROUP BY
	mvd_stats.football_team_hid
),
deep_against_ema15 AS
(
SELECT
  	betting_dv.ema(mvd_stats.football_team_hid, mvd_stats.match_date, mvd_stats.deep_against, 15)  
from
  	mvd_stats
GROUP BY
	mvd_stats.football_team_hid
),
ppda_for_ema15 AS
(
SELECT
  	betting_dv.ema(mvd_stats.football_team_hid, mvd_stats.match_date, mvd_stats.ppda_for, 15)  
from
  	mvd_stats
GROUP BY
	mvd_stats.football_team_hid
),
ppda_against_ema15 AS
(
SELECT
  	betting_dv.ema(mvd_stats.football_team_hid, mvd_stats.match_date, mvd_stats.ppda_against, 15)  
from
  	mvd_stats
GROUP BY
	mvd_stats.football_team_hid
)
SELECT 
	m.football_match_his_lid football_match_his_lid,
	--home team stats
	max(CASE WHEN m.FOOTBALL_TEAM_HOME_HID = m.football_team_hid THEN goals_for_ema15.ema ELSE NULL END) home_goals_for_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_HOME_HID = m.football_team_hid THEN goals_against_ema15.ema ELSE NULL END) home_goals_against_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_HOME_HID = m.football_team_hid THEN xg_for_ema15.ema ELSE NULL END) home_xg_for_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_HOME_HID = m.football_team_hid THEN xg_against_ema15.ema ELSE NULL END) home_xg_against_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_HOME_HID = m.football_team_hid THEN shots_for_ema15.ema ELSE NULL END) home_shots_for_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_HOME_HID = m.football_team_hid THEN shots_against_ema15.ema ELSE NULL END) home_shots_against_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_HOME_HID = m.football_team_hid THEN shots_target_for_ema15.ema ELSE NULL END) home_shots_target_for_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_HOME_HID = m.football_team_hid THEN shots_target_against_ema15.ema ELSE NULL END) home_shots_target_against_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_HOME_HID = m.football_team_hid THEN deep_for_ema15.ema ELSE NULL END) home_deep_for_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_HOME_HID = m.football_team_hid THEN deep_against_ema15.ema ELSE NULL END) home_deep_against_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_HOME_HID = m.football_team_hid THEN ppda_for_ema15.ema ELSE NULL END) home_ppda_for_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_HOME_HID = m.football_team_hid THEN ppda_against_ema15.ema ELSE NULL END) home_ppda_against_ema15,
	--away team stats
	max(CASE WHEN m.FOOTBALL_TEAM_away_HID = m.football_team_hid THEN goals_for_ema15.ema ELSE NULL END) away_goals_for_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_away_HID = m.football_team_hid THEN goals_against_ema15.ema ELSE NULL END) away_goals_against_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_away_HID = m.football_team_hid THEN xg_for_ema15.ema ELSE NULL END) away_xg_for_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_away_HID = m.football_team_hid THEN xg_against_ema15.ema ELSE NULL END) away_xg_against_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_away_HID = m.football_team_hid THEN shots_for_ema15.ema ELSE NULL END) away_shots_for_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_away_HID = m.football_team_hid THEN shots_against_ema15.ema ELSE NULL END) away_shots_against_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_away_HID = m.football_team_hid THEN shots_target_for_ema15.ema ELSE NULL END) away_shots_target_for_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_away_HID = m.football_team_hid THEN shots_target_against_ema15.ema ELSE NULL END) away_shots_target_against_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_away_HID = m.football_team_hid THEN deep_for_ema15.ema ELSE NULL END) away_deep_for_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_away_HID = m.football_team_hid THEN deep_against_ema15.ema ELSE NULL END) away_deep_against_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_away_HID = m.football_team_hid THEN ppda_for_ema15.ema ELSE NULL END) away_ppda_for_ema15,
	max(CASE WHEN m.FOOTBALL_TEAM_away_HID = m.football_team_hid THEN ppda_against_ema15.ema ELSE NULL END) away_ppda_against_ema15
FROM
	mvd_stats m
	JOIN goals_for_ema15
		ON m.FOOTBALL_TEAM_HID = goals_for_ema15.GROUP_param
			AND m.prev_match_date = goals_for_ema15.order_param
	JOIN goals_against_ema15
		ON m.FOOTBALL_TEAM_HID = goals_against_ema15.GROUP_param
			AND m.prev_match_date = goals_against_ema15.order_param
	JOIN xg_for_ema15
		ON m.FOOTBALL_TEAM_HID = xg_for_ema15.GROUP_param
			AND m.prev_match_date = xg_for_ema15.order_param
	JOIN xg_against_ema15
		ON m.FOOTBALL_TEAM_HID = xg_against_ema15.GROUP_param
			AND m.prev_match_date = xg_against_ema15.order_param
	JOIN shots_for_ema15
		ON m.FOOTBALL_TEAM_HID = shots_for_ema15.GROUP_param
			AND m.prev_match_date = shots_for_ema15.order_param
	JOIN shots_against_ema15
		ON m.FOOTBALL_TEAM_HID = shots_against_ema15.GROUP_param
			AND m.prev_match_date = shots_against_ema15.order_param
	JOIN shots_target_for_ema15
		ON m.FOOTBALL_TEAM_HID = shots_target_for_ema15.GROUP_param
			AND m.prev_match_date = shots_target_for_ema15.order_param
	JOIN shots_target_against_ema15
		ON m.FOOTBALL_TEAM_HID = shots_target_against_ema15.GROUP_param
			AND m.prev_match_date = shots_target_against_ema15.order_param
	JOIN deep_for_ema15
		ON m.FOOTBALL_TEAM_HID = deep_for_ema15.GROUP_param
			AND m.prev_match_date = deep_for_ema15.order_param
	JOIN deep_against_ema15
		ON m.FOOTBALL_TEAM_HID = deep_against_ema15.GROUP_param
			AND m.prev_match_date = deep_against_ema15.order_param
	JOIN ppda_for_ema15
		ON m.FOOTBALL_TEAM_HID = ppda_for_ema15.GROUP_param
			AND m.prev_match_date = ppda_for_ema15.order_param
	JOIN ppda_against_ema15
		ON m.FOOTBALL_TEAM_HID = ppda_against_ema15.GROUP_param
			AND m.prev_match_date = ppda_against_ema15.order_param
GROUP BY
	1;