
/************************************************
	View for transfermarkt.de market values
	uses UDF stage.webscr_transfermarkt_market values
	
v1.0:
	- initial
	
*************************************************/



--drop view if exists stage.transfermarkt_market_values;

create or replace view stage.transfermarkt_market_values
as
select
  a.division,
  b.football_data team,
  to_char(a.season) || '_' || to_char(to_number(a.season)+1) season,
  a.num_players,
  a.team_market_value team_market_value_char,
  case
    when instr(a.team_market_value,'Mio') > 0 then
      to_number(replace(substr(a.team_market_value,1,instr(a.team_market_value,'Mio')-2),',','.')) * 1000000
    when instr(a.team_market_value,'Mrd') > 0 then
      to_number(replace(substr(a.team_market_value,1,instr(a.team_market_value,'Mrd')-2),',','.')) * 1000000000
    else a.team_market_value
  end team_market_value_num
from
  (SELECT
      stage.webscr_transfermarkt_market_values(DIVISION, URL, 1)
  FROM
      META.TRANSFERMARKT_MARKET_VALUE_CONFIG) a
  left join stage.team_mapping b
    on a.team = b.transfermarkt
;