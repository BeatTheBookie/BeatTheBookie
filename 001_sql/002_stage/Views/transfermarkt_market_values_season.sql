
/************************************************
	View for transfermarkt.de market values
	uses UDF stage.webscr_transfermarkt_market_values_season
	
v1.0:
	- initial
	
*************************************************/



--drop view if exists stage.transfermarkt_market_values_season;

create or replace view stage.transfermarkt_market_values_season
as
select
  a.division,
  b.football_data team,
  a.season,
  a.num_players,
  a.team_market_value team_market_value_char,
  case
    when instr(a.team_market_value,'Mio') > 0 then
      cast((replace(substr(a.team_market_value,1,instr(a.team_market_value,'Mio')-2),',','.') * 1000000) as decimal(20,0))
    when instr(a.team_market_value,'Mrd') > 0 then
      cast((replace(substr(a.team_market_value,1,instr(a.team_market_value,'Mrd')-2),',','.') * 1000000000) as decimal(20,0))
    else cast(a.team_market_value as decimal(20,0))
  end team_market_value_num
from
  (SELECT
      stage.webscr_transfermarkt_market_values_season(DIVISION, URL, 1)
  FROM
      META.TRANSFERMARKT_MARKET_VALUE_SEASON_CONFIG) a
  left join stage.team_mapping b
    on a.team = b.transfermarkt
;