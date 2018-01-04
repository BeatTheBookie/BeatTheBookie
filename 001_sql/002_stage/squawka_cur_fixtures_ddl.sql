
/************************************************
	Stage table for current matches from
	squawka.com
	
v1.0:
	- initial

*************************************************/



drop table stage.squawka_cur_fixtures;


create table stage.squawka_cur_fixtures
	(
	DIVISION			varchar(5),
	MATCH_DATE 			date,
	TEAM_HOME			varchar(50),
	TEAM_AWAY			varchar(50)
	)
;