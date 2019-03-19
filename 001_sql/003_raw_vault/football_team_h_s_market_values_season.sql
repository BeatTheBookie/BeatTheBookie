/************************************************
	Raw data vault tables for team market values
	
v1.0:
	- initial 

	
*************************************************/

drop table if exists raw_dv.football_team_h_s_market_values_season;
drop view if exists raw_dv.football_team_h_s_market_values_season_cur;
drop view if exists raw_dv.football_team_h_s_market_values_season_his;

--satellite for market values
create table raw_dv.football_team_h_s_market_values_season
  (
  football_team_hid   char(32),
  valid_from          timestamp,
  num_players         decimal(10,2),
  team_market_value   decimal(20,0),
  ldts                timestamp,
  distribute by football_team_hid
  )
;

  

--current view
create or replace view raw_dv.football_team_h_s_market_values_season_cur
as
select
  FOOTBALL_TEAM_HID,
  VALID_FROM,
  to_date('31.12.9999','dd.mm.yyyy') VALID_TO,
  NUM_PLAYERS,
  TEAM_MARKET_VALUE,
  LDTS
from
  raw_dv.football_team_h_s_market_values_season
where
  (FOOTBALL_TEAM_HID, VALID_FROM) in (
                                  select
                                    football_team_hid,
                                    max(valid_from)
                                  from
                                    raw_dv.football_team_h_s_market_values_season
                                  group by
                                    football_team_hid
                                   )
;

--create historic view
create or replace view betting_dv.football_team_h_s_market_values_season_his
as
select
  FOOTBALL_TEAM_HID,
  VALID_FROM,
  nvl(lead(valid_from-1) over (partition by football_team_hid order by valid_from), to_date('31.12.9999','dd.mm.yyyy')) VALID_TO,
  NUM_PLAYERS,
  TEAM_MARKET_VALUE,
  LDTS
from
  raw_dv.football_team_h_s_market_values_season
;

