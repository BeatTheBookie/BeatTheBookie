/************************************************
	bridge table for historic football matches
	which contains all BKs
	
v1.0:
	- initial

		
*************************************************/

--drop view betting_dv.football_match_his_b;


create or replace view betting_dv.football_match_his_b
as
select
  his.football_match_his_lid,
  his.football_division_hid,
  d.division, 
  his.football_team_home_hid,
  home.team home_team,
  his.football_team_away_hid,
  away.team away_team,
  his.football_season_hid,
  s.season,
  his.match_date  
from  
  betting_dv.football_match_his_l his
  join betting_dv.football_division_h d
    on his.football_division_hid = d.football_division_hid
  join betting_dv.football_team_h home
    on his.football_team_home_hid = home.football_team_hid
  join betting_dv.football_team_h away
    on his.football_team_away_hid = away.football_team_hid
  join betting_dv.football_season_h s
    on his.football_season_hid = s.football_season_hid
;