


/**
 * 
 * Tables for understat data sources
 * 
 *  
***/



CREATE OR REPLACE TABLE LANDING_UNDERSTAT.current_fixtures
as
SELECT
	*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from "understat".v_current_fixtures'
	);


CREATE OR REPLACE TABLE LANDING_UNDERSTAT.divisions
as
SELECT
	*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from "understat".v_divisions'
	);



CREATE OR REPLACE TABLE LANDING_UNDERSTAT.fixtures
as
SELECT
	*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from "understat".v_fixtures'
	);



CREATE OR REPLACE TABLE LANDING_UNDERSTAT.MATCH_player_stats
as
SELECT
	*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from "understat".v_MATCH_player_stats'
	);



CREATE OR REPLACE TABLE LANDING_UNDERSTAT.match_shots
as
SELECT
	*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from "understat".v_match_shots'
	);
	



CREATE OR REPLACE TABLE LANDING_UNDERSTAT.players
as
SELECT
	*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from "understat".v_players'
	);
	



CREATE OR REPLACE TABLE LANDING_UNDERSTAT.seasons
as
SELECT
	*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from "understat".v_seasons'
	);
	


CREATE OR REPLACE TABLE LANDING_UNDERSTAT.team_stats
as
SELECT
	*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from "understat".v_team_stats where season_id = ''2020_21'''
	);
	


CREATE OR REPLACE TABLE LANDING_UNDERSTAT.teams
as
SELECT
	*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from "understat".v_teams'
	);