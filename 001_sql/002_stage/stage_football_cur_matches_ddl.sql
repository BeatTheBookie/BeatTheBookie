
/************************************************
	Stage table for current matches of each
	division
	
v1.0:
	- initial

*************************************************/



drop table stage.football_cur_matches;


create table stage.football_cur_matches
	(
	DIVISION			varchar(5),
	MATCH_DATE 			date,
	TEAM_HOME			varchar(50),
	TEAM_AWAY			varchar(50)
	)
;