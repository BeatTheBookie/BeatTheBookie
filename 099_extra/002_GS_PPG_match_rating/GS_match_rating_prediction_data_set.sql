select
	his.football_match_his_lid,
	rating.gs_match_rating,
	NULL prob_home_win,
	NULL prob_draw,
	NULL prob_away_win
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
	division.division = 'D1' 
	and season.season in ('2017_2018')
;
