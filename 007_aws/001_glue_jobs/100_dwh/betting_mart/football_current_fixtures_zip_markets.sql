/************************************************
	Betting mart view for markets of 
	ZIP model
	
v1.0:
	- initial
	
*************************************************/



create or replace view betting_mart.football_current_fixtures_zip_markets
as
select
	division,
	season,
	match_date,
	home_team || ' - ' || away_team match_teams,
	home_team,
	away_team,
	zip.market,
	zip.market_prob
from
	betting_dv.football_match_cur_b cur
	join betting_dv.football_match_cur_l_s_zip_markets zip
		on (cur.football_match_cur_lid = zip.football_match_cur_lid)
;