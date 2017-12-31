
/************************************************
	Stage table for mapping of team names
	for different data sources
	
v1.0:
	- initial

*************************************************/



drop table if exists stage.team_mapping;


create table stage.team_mapping
	(
	FOOTBALL_DATA		varchar(100),
	SQUAWKA 			varchar(100)
	)
;