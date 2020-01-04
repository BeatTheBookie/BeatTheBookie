
/************************************************
	Stage table for mapping of team names
	for different data sources
	
v1.0:
	- initial
v2.0:
	- transfermarkt added

*************************************************/



drop table if exists stage.team_mapping;


create table stage.team_mapping
	(
	FOOTBALL_DATA			varchar(100),
	SQUAWKA 				varchar(100),
	TRANSFERMARKT			varchar(100),
	UNDERSTAT				varchar(100)
	)
;