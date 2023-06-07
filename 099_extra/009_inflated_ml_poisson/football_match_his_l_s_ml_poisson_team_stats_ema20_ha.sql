create or replace table betting_dv.football_match_his_l_s_ml_poisson_team_stats_ema20_ha AS
with
home_his as
(
/**
get historic matches for home team
statistics are projected for 1 match in the past,
as the result of the current match should not be part of
the prediction features
**/
select
  his.football_match_his_lid,
  his.home_team,
  his.match_date,
  stats.home_goals 			home_goals_for,
  stats.away_goals 			home_goals_against,
  stats.home_xgoals 		home_xg_for,
  stats.away_xgoals 		home_xg_against,
  stats2.HOME_SHOTS 		home_shots_for,
  stats2.AWAY_SHOTS 		home_shots_against,
  stats2.HOME_SHOTS_TARGET 	home_sot_for,
  stats2.AWAY_SHOTS_TARGET 	home_sot_against,
  stats2.HOME_CORNERS 		home_corners_for,
  stats2.AWAY_CORNERS 		home_corners_against,
  stats.HOME_DEEP 			home_deep_for,
  stats.AWAY_DEEP 			home_deep_against,
  stats.HOME_PPDA 			home_ppda_for,
  stats.AWAY_PPDA 			home_ppda_against
from
  (
  select
    his.football_match_his_lid,
    his.match_date,
    his.home_team,
    his.away_team,
    lead(football_match_his_lid) over (partition by his.home_team order by his.match_date desc) prev_football_match_his_lid
  from
    betting_dv.football_match_his_b his
  ) his
  join raw_dv.football_match_his_l_s_understat_team_stats stats
    on his.prev_football_match_his_lid = stats.football_match_his_lid
  JOIN RAW_DV.FOOTBALL_MATCH_HIS_L_S_STATISTIC stats2
  	ON his.prev_football_match_his_lid = stats2.FOOTBALL_MATCH_HIS_LID
),
away_his as
(  
/**
get historic matches for away team
statistics are projected for 1 match in the past,
as the result of the current match should not be part of
the prediction features
**/
select
  his.football_match_his_lid,
  his.away_team,
  his.match_date,
  stats.away_goals 			away_goals_for,
  stats.home_goals 			away_goals_against,
  stats.away_xgoals 		away_xg_for,
  stats.home_xgoals 		away_xg_against,
  stats2.away_SHOTS 		away_shots_for,
  stats2.home_SHOTS 		away_shots_against,
  stats2.away_SHOTS_TARGET 	away_sot_for,
  stats2.home_SHOTS_TARGET 	away_sot_against,
  stats2.away_CORNERS 		away_corners_for,
  stats2.home_CORNERS 		away_corners_against,
  stats.away_DEEP 			away_deep_for,
  stats.home_DEEP 			away_deep_against,
  stats.away_PPDA 			away_ppda_for,
  stats.home_PPDA 			away_ppda_against
from
  (
  select
    his.football_match_his_lid,
    his.match_date,
    his.home_team,
    his.away_team,
    lead(football_match_his_lid) over (partition by his.away_team order by his.match_date desc) prev_football_match_his_lid
  from
    betting_dv.football_match_his_b his
  ) his
  join raw_dv.football_match_his_l_s_understat_team_stats stats
    on his.prev_football_match_his_lid = stats.football_match_his_lid
  JOIN RAW_DV.FOOTBALL_MATCH_HIS_L_S_STATISTIC stats2
  	ON his.prev_football_match_his_lid = stats2.FOOTBALL_MATCH_HIS_LID
),
/****
calculate EMA for home goals
*****/
home_goals_for_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_goals_for, 20)  
from
  home_his
group by
  home_team
),
home_goals_against_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_goals_against, 20)  
from
  home_his
group by
  home_team
),
/****
calculate EMA for away goals
*****/
away_goals_for_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_goals_for, 20)  
from
  away_his
group by
  away_team
),
away_goals_against_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_goals_against, 20)  
from
  away_his
group by
  away_team
),
/****
calculate EMA for home xg
*****/
home_xg_for_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_xg_for, 20)  
from
  home_his
group by
  home_team
),
home_xg_against_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_xg_against, 20)  
from
  home_his
group by
  home_team
),
/****
calculate EMA for away xg
*****/
away_xg_for_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_xg_for, 20)  
from
  away_his
group by
  away_team
),
away_xg_against_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_xg_against, 20)  
from
  away_his
group by
  away_team
),
/****
calculate EMA for home shots
*****/
home_shots_for_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_shots_for, 20)  
from
  home_his
group by
  home_team
),
home_shots_against_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_shots_against, 20)  
from
  home_his
group by
  home_team
),
/****
calculate EMA for away shots
*****/
away_shots_for_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_shots_for, 20)  
from
  away_his
group by
  away_team
),
away_shots_against_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_shots_against, 20)  
from
  away_his
group by
  away_team
),
/****
calculate EMA for home shots on target
*****/
home_sot_for_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_sot_for, 20)  
from
  home_his
group by
  home_team
),
home_sot_against_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_sot_against, 20)  
from
  home_his
group by
  home_team
),
/****
calculate EMA for away shots on target
*****/
away_sot_for_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_sot_for, 20)  
from
  away_his
group by
  away_team
),
away_sot_against_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_sot_against, 20)  
from
  away_his
group by
  away_team
),
/****
calculate EMA for home corners
*****/
home_corners_for_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_corners_for, 20)  
from
  home_his
group by
  home_team
),
home_corners_against_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_corners_against, 20)  
from
  home_his
group by
  home_team
),
/****
calculate EMA for away xg
*****/
away_corners_for_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_corners_for, 20)  
from
  away_his
group by
  away_team
),
away_corners_against_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_corners_against, 20)  
from
  away_his
group by
  away_team
),
/****
calculate EMA for home deep
*****/
home_deep_for_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_deep_for, 20)  
from
  home_his
group by
  home_team
),
home_deep_against_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_deep_against, 20)  
from
  home_his
group by
  home_team
),
/****
calculate EMA for away deep
*****/
away_deep_for_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_deep_for, 20)  
from
  away_his
group by
  away_team
),
away_deep_against_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_deep_against, 20)  
from
  away_his
group by
  away_team
),
/****
calculate EMA for home ppda
*****/
home_ppda_for_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_ppda_for, 20)  
from
  home_his
group by
  home_team
),
home_ppda_against_ema20 as
(
select
  betting_dv.ema(home_team, match_date, home_ppda_against, 20)  
from
  home_his
group by
  home_team
),
/****
calculate EMA for away ppda
*****/
away_ppda_for_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_ppda_for, 20)  
from
  away_his
group by
  away_team
),
away_ppda_against_ema20 as
(
select
  betting_dv.ema(away_team, match_date, away_ppda_against, 20)  
from
  away_his
group by
  away_team
)
--*****
--Join all the ema calculations
select
  his.football_match_his_lid,
  --home ema stats
  --goals
  home_goals_for_ema20.ema home_goals_for_ema,
  home_goals_against_ema20.ema home_goals_against_ema,
  --xg
  home_xg_for_ema20.ema home_xg_for_ema,
  home_xg_against_ema20.ema home_xg_against_ema,
  --shots
  home_shots_for_ema20.ema home_shots_for_ema,
  home_shots_against_ema20.ema home_shots_against_ema,
  --shots on target
  home_sot_for_ema20.ema home_sot_for_ema,
  home_sot_against_ema20.ema home_sot_against_ema,
  --corners
  home_corners_for_ema20.ema home_corners_for_ema,
  home_corners_against_ema20.ema home_corners_against_ema,
  --deep
  home_deep_for_ema20.ema home_deep_for_ema,
  home_deep_against_ema20.ema home_deep_against_ema,
  --ppda
  home_ppda_for_ema20.ema home_ppda_for_ema,
  home_ppda_against_ema20.ema home_ppda_against_ema,
  --away ema stats
  --goals
  away_goals_for_ema20.ema away_goals_for_ema,
  away_goals_against_ema20.ema away_goals_against_ema,
  --xg
  away_xg_for_ema20.ema away_xg_for_ema,
  away_xg_against_ema20.ema away_xg_against_ema,
  --shots
  away_shots_for_ema20.ema away_shots_for_ema,
  away_shots_against_ema20.ema away_shots_against_ema,
  --shots on target
  away_sot_for_ema20.ema away_sot_for_ema,
  away_sot_against_ema20.ema away_sot_against_ema,
  --corners
  away_corners_for_ema20.ema away_corners_for_ema,
  away_corners_against_ema20.ema away_corners_against_ema,
  --deep
  away_deep_for_ema20.ema away_deep_for_ema,
  away_deep_against_ema20.ema away_deep_against_ema,
  --ppda
  away_ppda_for_ema20.ema away_ppda_for_ema,
  away_ppda_against_ema20.ema away_ppda_against_ema
from
  --original historic matches
  betting_dv.football_match_his_b his
  --home ema stats
  --join ema calcs for home team goals
  join home_goals_for_ema20 on 
    his.home_team = home_goals_for_ema20.group_param and
    his.match_date = home_goals_for_ema20.order_param
  join home_goals_against_ema20 on 
    his.home_team = home_goals_against_ema20.group_param and
    his.match_date = home_goals_against_ema20.order_param
  --join ema calcs for home team xg
  join home_xg_for_ema20 on 
    his.home_team = home_xg_for_ema20.group_param and
    his.match_date = home_xg_for_ema20.order_param
  join home_xg_against_ema20 on 
    his.home_team = home_xg_against_ema20.group_param and
    his.match_date = home_xg_against_ema20.order_param
  --join ema calcs for home team shots
  join home_shots_for_ema20 on 
    his.home_team = home_shots_for_ema20.group_param and
    his.match_date = home_shots_for_ema20.order_param
  join home_shots_against_ema20 on 
    his.home_team = home_shots_against_ema20.group_param and
    his.match_date = home_shots_against_ema20.order_param
  --join ema calcs for home team sot
  join home_sot_for_ema20 on 
    his.home_team = home_sot_for_ema20.group_param and
    his.match_date = home_sot_for_ema20.order_param
  join home_sot_against_ema20 on 
    his.home_team = home_sot_against_ema20.group_param and
    his.match_date = home_sot_against_ema20.order_param
  --join ema calcs for home team corners
  join home_corners_for_ema20 on 
    his.home_team = home_corners_for_ema20.group_param and
    his.match_date = home_corners_for_ema20.order_param
  join home_corners_against_ema20 on 
    his.home_team = home_corners_against_ema20.group_param and
    his.match_date = home_corners_against_ema20.order_param
  --join ema calcs for home team deep
  join home_deep_for_ema20 on 
    his.home_team = home_deep_for_ema20.group_param and
    his.match_date = home_deep_for_ema20.order_param
  join home_deep_against_ema20 on 
    his.home_team = home_deep_against_ema20.group_param and
    his.match_date = home_deep_against_ema20.order_param
  --join ema calcs for home team ppda
  join home_ppda_for_ema20 on 
    his.home_team = home_ppda_for_ema20.group_param and
    his.match_date = home_ppda_for_ema20.order_param
  join home_ppda_against_ema20 on 
    his.home_team = home_ppda_against_ema20.group_param and
    his.match_date = home_ppda_against_ema20.order_param
  --away ema stats
  --join ema calcs for away team goals
  join away_goals_for_ema20 on 
    his.away_team = away_goals_for_ema20.group_param and
    his.match_date = away_goals_for_ema20.order_param  
  join away_goals_against_ema20 on 
    his.away_team = away_goals_against_ema20.group_param and
    his.match_date = away_goals_against_ema20.order_param
  --join ema calcs for away team xg
  join away_xg_for_ema20 on 
    his.away_team = away_xg_for_ema20.group_param and
    his.match_date = away_xg_for_ema20.order_param
  join away_xg_against_ema20 on 
    his.away_team = away_xg_against_ema20.group_param and
    his.match_date = away_xg_against_ema20.order_param
  --join ema calcs for away team shots
  join away_shots_for_ema20 on 
    his.away_team = away_shots_for_ema20.group_param and
    his.match_date = away_shots_for_ema20.order_param
  join away_shots_against_ema20 on 
    his.away_team = away_shots_against_ema20.group_param and
    his.match_date = away_shots_against_ema20.order_param
  --join ema calcs for away team sot
  join away_sot_for_ema20 on 
    his.away_team = away_sot_for_ema20.group_param and
    his.match_date = away_sot_for_ema20.order_param
  join away_sot_against_ema20 on 
    his.away_team = away_sot_against_ema20.group_param and
    his.match_date = away_sot_against_ema20.order_param
  --join ema calcs for away team corners
  join away_corners_for_ema20 on 
    his.away_team = away_corners_for_ema20.group_param and
    his.match_date = away_corners_for_ema20.order_param
  join away_corners_against_ema20 on 
    his.away_team = away_corners_against_ema20.group_param and
    his.match_date = away_corners_against_ema20.order_param
  --join ema calcs for away team deep
  join away_deep_for_ema20 on 
    his.away_team = away_deep_for_ema20.group_param and
    his.match_date = away_deep_for_ema20.order_param
  join away_deep_against_ema20 on 
    his.away_team = away_deep_against_ema20.group_param and
    his.match_date = away_deep_against_ema20.order_param
  --join ema calcs for away team ppda
  join away_ppda_for_ema20 on 
    his.away_team = away_ppda_for_ema20.group_param and
    his.match_date = away_ppda_for_ema20.order_param
  join away_ppda_against_ema20 on 
    his.away_team = away_ppda_against_ema20.group_param and
    his.match_date = away_ppda_against_ema20.order_param
;