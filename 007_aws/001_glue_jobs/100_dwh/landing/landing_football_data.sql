


/**
 * 
 * Tables for manual data sources
 * 
 *  
***/



CREATE OR REPLACE TABLE LANDING_football_data.football_data
AS
SELECT
	'2020_21' season,
	a.*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from "football-data"."v_2020_21"'
	) a;
	