
with matches as
(
select
	season.season,
	his.match_date,
	table_s.played,
	home.team home_team,
	away.team away_team,
	stat.full_time_home_goals,
	str.avg_home_team_goals_for	
from
	betting_dv.football_match_his_l his
	join betting_dv.football_match_his_l_s_statistic stat
		on his.football_match_his_lid = stat.football_match_his_lid
	join betting_dv.football_match_his_l_s_attack_defence_strength_30 str
		on his.football_match_his_lid = str.football_match_his_lid
	join betting_dv.football_team_h home
		on his.football_team_home_hid = home.football_team_hid
	join betting_dv.football_team_h away
		on his.football_team_away_hid = away.football_team_hid
	join betting_dv.football_season_h season
		on his.football_season_hid = season.football_season_hid
	join betting_dv.football_division_h division
		on his.football_division_hid = division.football_division_hid
	join betting_dv.football_division_table_l table_l
		on his.football_division_hid = table_l.football_division_hid and
			his.football_season_hid = table_l.football_season_hid and
			his.football_team_home_hid = table_l.football_team_hid and
			his.match_date = table_l.match_date
	join betting_dv.football_division_table_l_s table_s
		on table_l.football_division_table_lid = table_s.football_division_table_lid
where
	division.division = 'D1' and
	home.team = 'FC Koln' and
	season.season >= '2014_2015'
order by
	2
),
ema_26 as
(
select
	group_param team,
	to_date(order_param, 'yyyymmdd') match_date,
	ema
from
	(
	select
		betting_dv.ema(home_team, to_char(match_date,'yyyymmdd'), full_time_home_goals, 26)
	from
		matches
	group by
		home_team
	)
),
ema_12 as
(
select
	group_param team,
	to_date(order_param, 'yyyymmdd') match_date,
	ema
from
	(
	select
		betting_dv.ema(home_team, to_char(match_date,'yyyymmdd'), full_time_home_goals, 12)
	from
		matches
	group by
		home_team
	)
),
signal as 
(
select
	group_param team,
	to_date(order_param, 'yyyymmdd') match_date,
	ema
from
	(
	select
		betting_dv.ema(team, to_char(match_date,'yyyymmdd'), macd_line, 9)
	from
		(
		select
			ema_26.team,
			ema_26.match_date,
			ema_12.ema - ema_26.ema macd_line
		from
			ema_26
			join ema_12
				on ema_26.team = ema_12.team and
					ema_26.match_date = ema_12.match_date
		)
	group by
		team
	)
)
select
	matches.home_team,
	matches.match_date,
	matches.full_time_home_goals num_goals,
	ema_26.ema ema_26,
	ema_12.ema ema_12,
	ema_12.ema - ema_26.ema macd_line,
	signal.ema signal_line,
	local.macd_line - local.signal_line macd_histogramm
from
	matches
	join ema_26
		on matches.home_team = ema_26.team and
			matches.match_date = ema_26.match_date 
	join ema_12
		on matches.home_team = ema_12.team and
			matches.match_date = ema_12.match_date
	join signal
		on matches.home_team = signal.team and
			matches.match_date = signal.match_date
;
