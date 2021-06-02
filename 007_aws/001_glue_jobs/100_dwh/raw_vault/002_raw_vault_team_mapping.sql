
/*
 * Satellite for team-names of
 * different data providers
 * 
 */

CREATE OR REPLACE TABLE raw_dv.football_team_h_s_team_mapping
as
select
	hash_md5(tm."football_data") 	team_bk_hash,
	tm."football_data" 				team_football_data,
	tm."squawka" 					team_squawka,
	tm."transfermarkt" 				team_transfermarkt,
	tm."understat" 					team_understat,
	current_timestamp 				audit_insert_date,
	'load TEAM_MAPPING' 			audit_record_source
from
	LANDING_MANUAL.TEAM_MAPPING tm;