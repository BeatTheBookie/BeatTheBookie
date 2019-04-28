/************************************************
	DML statement to load market value satellite
	
v1.0:
	- initial 

	
*************************************************/

--Load market value satellite
insert into raw_dv.football_team_h_s_market_values_season tgt
SELECT 
  hash_md5(src.team) football_team_hid,
  --to_date('01.07.' || src.season,'dd.mm.yyyy') valid_from, --historic load 
  current_date valid_from, --for normal loading process
  src.num_players,
  src.team_market_value_num,
  current_timestamp LDTS   
FROM 
  stage.TRANSFERMARKT_MARKET_VALUES_SEASON src 
  left join betting_dv.football_team_h_s_market_values_season_cur tgt
    on hash_md5(src.team) = tgt.football_team_hid       
where
  --delta?
  src.num_players <> nvl(tgt.num_players,-1) or
  src.team_market_value_num <> nvl(tgt.team_market_value,-1)
;