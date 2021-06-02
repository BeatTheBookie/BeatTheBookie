


/**
 * 
 * load fixtures in current hub from Transfermarkt
 * - 2nd 
 *  
***/

truncate table raw_dv.football_match_cur_l
;


insert into raw_dv.football_match_cur_l
	(
	football_match_cur_lid,
	football_division_hid,
	football_team_home_hid,
	football_team_away_hid,
	football_season_hid,
	match_date,
	audit_insert_date,
	audit_record_source
	)
WITH bk_lookup AS
(
select
  division,
  to_date(match_date,'dd.mm.yyyy') match_date,
  home."football_data" team_home,
  away."football_data" team_away
from
  (
  SELECT
  	cf."home_team" home_team,
  	cf."away_team" away_team,
  	cf."division" division,
  	cf."match_date" match_date
  from
    LANDING_TRANSFERMARKT.CURRENT_FIXTURES cf 
  ) a 
  --lookup of bks from manual mapping file
  join LANDING_MANUAL.TEAM_MAPPING  home
    on a.home_team = home."transfermarkt"
  join LANDING_MANUAL.TEAM_MAPPING away
    on a.away_team = away."transfermarkt"   
)
select
	hash_md5(division.football_division_hid || '#' || team_home.football_team_hid || '#' || team_away.football_team_hid || '#' || season.football_season_hid || '#' || to_char(cur.match_date,'yyyymmdd')) football_match_cur_lid,
	division.football_division_hid,
	team_home.football_team_hid football_team_home_hid,
	team_away.football_team_hid football_team_away_hid,
	season.football_season_hid,
	cur.match_date,
	current_timestamp,
	'load FOOTBALL_MATCH_CUR_L'
from
	bk_lookup cur
	--lookup for hashkeys
	--should be replaced hash calculation or
	--stage vault views
	join raw_dv.football_team_h team_home
		on (cur.team_home = team_home.team)
	join raw_dv.football_team_h team_away
		on (cur.team_away = team_away.team)
	join raw_dv.football_division_h division
		on (cur.division = division.division)
	--just use max season, as we load only current fixtures
	join (
		select
			football_season_hid	
		from
			raw_dv.football_season_h
		where
			season = (
					select
						max(season)
					from
						raw_dv.football_season_h
					)
			) season
		on (1=1)
;