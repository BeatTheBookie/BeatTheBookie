/************************************************
	bridge table for current football matches
	which contains all BKs
	
v1.0:
	- initial

		
*************************************************/

--drop view betting_dv.football_match_cur_b;

create or replace view betting_dv.football_match_cur_b
as
select
  cur.football_match_cur_lid,
  cur.football_division_hid,
  d.division, 
  cur.football_team_home_hid,
  home.team home_team,
  cur.football_team_away_hid,
  away.team away_team,
  cur.football_season_hid,
  s.season,
  cur.match_date  
from  
  betting_dv.football_match_cur_l cur
  join betting_dv.football_division_h d
    on cur.football_division_hid = d.football_division_hid
  join betting_dv.football_team_h home
    on cur.football_team_home_hid = home.football_team_hid
  join betting_dv.football_team_h away
    on cur.football_team_away_hid = away.football_team_hid
  join betting_dv.football_season_h s
    on cur.football_season_hid = s.football_season_hid
;