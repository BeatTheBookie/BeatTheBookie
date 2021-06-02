


/**
 * 
 * Tables for manual data sources
 * 
 *  
***/



CREATE OR REPLACE TABLE LANDING_MANUAL.team_mapping
AS
SELECT
	*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from "manual-data".team_mapping'
	);



CREATE OR REPLACE TABLE LANDING_MANUAL.division_mapping
as
SELECT
	*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from "manual-data".division_mapping'
	);