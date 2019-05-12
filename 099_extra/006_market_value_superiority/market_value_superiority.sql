select
  market_value_superiority,
  count(*) num_matches,
  round(sum(num_home_win) / count(*),4) perc_home_win,
  round(sum(num_draw) / count(*),4) perc_draw,
  round(sum(num_away_win) / count(*),4) perc_away_win
from
  (
  select
    his.football_match_his_lid,
    his.match_date,
    his.home_team,
    val_home.team_market_value,
    his.away_team,
    val_away.team_market_value,
    round((val_home.team_market_value / 10000000),0) - round((val_away.team_market_value / 10000000),0) market_value_superiority,
    case when stat.full_time_result = 'H' then 1 else 0 end num_home_win,
    case when stat.full_time_result = 'D' then 1 else 0 end num_draw,
    case when stat.full_time_result = 'A' then 1 else 0 end num_away_win
  from
      BETTING_DV.FOOTBALL_MATCH_HIS_B his
      join BETTING_DV.FOOTBALL_MATCH_HIS_L_S_STATISTIC stat
        on his.football_match_his_lid = stat.football_match_his_lid
      join BETTING_DV.FOOTBALL_TEAM_H_S_MARKET_VALUES_SEASON_HIS val_home
        on his.football_team_home_hid = val_home.football_team_hid and
          his.match_date >= val_home.valid_from and
          his.match_date < val_home.valid_to
      join BETTING_DV.FOOTBALL_TEAM_H_S_MARKET_VALUES_SEASON_HIS val_away
        on his.football_team_away_hid = val_away.football_team_hid and
          his.match_date >= val_away.valid_from and
          his.match_date < val_away.valid_to
  )
group by
  1
;