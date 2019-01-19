
/************************************************
	View for transfermarkt.de current fixtures
	uses UDF stage.webscr_transfermarkt_cur_fixtures
	
v1.0:
	- initial
	
*************************************************/



drop view if exists stage.transfermarkt_cur_fixtures;

create or replace view stage.transfermarkt_cur_fixtures as
select
  division,
  to_date(match_date,'dd.mm.yyyy') match_date,
  home.football_data team_home,
  away.football_data team_away
from
  (
  select
    sandbox.test_webscraper(division, url)
  from
    meta.transfermarkt_cur_fixtures_config
  ) a
  join stage.team_mapping home
    on a.home_team = home.transfermarkt
  join stage.team_mapping away
    on a.away_team = away.transfermarkt   
;