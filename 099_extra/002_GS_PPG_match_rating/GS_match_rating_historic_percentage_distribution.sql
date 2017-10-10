select
	gs_match_rating,
	round(num_home_win / num_games, 4) home_win_perc,
	round(num_draw / num_games, 4) draw_perc,
	round(num_away_win / num_games, 4) away_win_perc
from
	(
	select distinct
		gs_match_rating,
		count(*) over (partition by gs_match_rating) num_games,
		sum(num_home_win) over (partition by gs_match_rating) num_home_win,
		sum(num_draw) over (partition by gs_match_rating) num_draw,
		sum(num_away_win) over (partition by gs_match_rating) num_away_win
	from
		(
		select
			his.match_date,
			home.team home_team,
			away.team away_team,
			stat.full_time_result,
			rating.gs_match_rating,
			decode(stat.full_time_result,'H',1,0) num_home_win,
			decode(stat.full_time_result,'D',1,0) num_draw,
			decode(stat.full_time_result,'A',1,0) num_away_win	
		from
			betting_dv.football_match_his_l his
			join betting_dv.football_match_his_l_s_statistic stat
				on (his.football_match_his_lid = stat.football_match_his_lid)
			join betting_dv.football_match_his_l_s_gs_match_rating rating
				on (his.football_match_his_lid = rating.football_match_his_lid)
			join betting_dv.football_season_h season
				on (his.football_season_hid = season.football_season_hid)
			join betting_dv.football_division_h division
				on (his.football_division_hid = division.football_division_hid)
			join betting_dv.football_team_h home
				on (his.football_team_home_hid = home.football_team_hid)
			join betting_dv.football_team_h away
				on (his.football_team_away_hid = away.football_team_hid)
		where
			division.division = 'D1' and
			season.season in ('2016_2017','2015_2016','2014_2015','2013_2014','2012_2013','2011_2012')
		)
	)
order by
	1
;
