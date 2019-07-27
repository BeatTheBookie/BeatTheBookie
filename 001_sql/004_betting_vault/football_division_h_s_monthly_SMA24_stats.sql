--window function does not work in 6.0
--avg(avg_home_goals_scored) over (order by match_year desc, match_month desc rows between 12 preceding and current row) home_goals_scores_SMA_12_month
--create or replace table betting_dv.football_division_h_s_monthly_SMA24_stats
create or replace view betting_dv.football_division_h_s_monthly_SMA24_stats
as
with
--aggregate stats and calculate avg value per month & division
avg_stats_per_month as
(
select distinct
  his.football_division_hid,
  year(match_date) match_year,
  month(match_date) match_month,
  avg(stat.full_time_home_goals) over (partition by his.football_division_hid, month(his.match_date), year(his.match_date)) avg_home_goals,
  avg(stat.full_time_away_goals) over (partition by his.football_division_hid, month(his.match_date), year(his.match_date)) avg_away_goals,
  avg(stat.home_shots) over (partition by his.football_division_hid, month(his.match_date), year(his.match_date)) avg_home_shots,
  avg(stat.away_shots) over (partition by his.football_division_hid, month(his.match_date), year(his.match_date)) avg_away_shots,
  avg(stat.home_shots_target) over (partition by his.football_division_hid, month(his.match_date), year(his.match_date)) avg_home_shots_target,
  avg(stat.away_shots_target) over (partition by his.football_division_hid, month(his.match_date), year(his.match_date)) avg_away_shots_target,
  avg(stat.home_corners) over (partition by his.football_division_hid, month(his.match_date), year(his.match_date)) avg_home_corners,
  avg(stat.away_corners) over (partition by his.football_division_hid, month(his.match_date), year(his.match_date)) avg_away_corners
from
  betting_dv.football_match_his_b his
  join betting_dv.football_match_his_l_s_statistic stat
    on his.football_match_his_lid = stat.football_match_his_lid
where
  his.division in ('D1','D2','E0','F2','I1','SP1')
)
select distinct
  football_division_hid,
  match_year,
  match_month,
  avg(avg_home_goals) over (partition by football_division_hid, match_year, match_month) home_goals_SMA24,
  avg(avg_away_goals) over (partition by football_division_hid, match_year, match_month) away_goals_SMA24,
  avg(avg_home_shots) over (partition by football_division_hid, match_year, match_month) home_shots_SMA24,
  avg(avg_away_shots) over (partition by football_division_hid, match_year, match_month) away_shots_SMA24,
  avg(avg_home_shots_target) over (partition by football_division_hid, match_year, match_month) home_shots_target_SMA24,
  avg(avg_away_shots_target) over (partition by football_division_hid, match_year, match_month) away_shots_target_SMA24,
  avg(avg_home_corners) over (partition by football_division_hid, match_year, match_month) home_corners_SMA24,
  avg(avg_away_corners) over (partition by football_division_hid, match_year, match_month) away_corners_SMA24
from
  (
  select
    org.football_division_hid,
    org.match_year,
    org.match_month,
    win.avg_home_goals,
    win.avg_away_goals,
    win.avg_home_shots,
    win.avg_away_shots,
    win.avg_home_shots_target,
    win.avg_away_shots_target,
    win.avg_home_corners,
    win.avg_away_corners,
    --row index to filter specific rows for window
    row_number() over (partition by org.football_division_hid, org.match_year, org.match_month order by win.match_year desc, win.match_month desc) win_index
  from
    --self join to calculate sliding window
    avg_stats_per_month org
    join avg_stats_per_month win
      on org.football_division_hid = win.football_division_hid and
        (org.match_year = win.match_year and org.match_month >= win.match_month or
        org.match_year > win.match_year)
  )
where
  win_index <= 24
  ;