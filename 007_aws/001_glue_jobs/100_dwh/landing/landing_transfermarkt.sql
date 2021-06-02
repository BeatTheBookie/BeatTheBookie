


/**
 * 
 * Tables for transfermarkt data
 * 
 *  
***/


CREATE OR REPLACE TABLE LANDING_TRANSFERMARKT.CURRENT_FIXTURES
as
SELECT
	*
FROM
	(
	import from JDBC at con_athena
	statement 'select * from transfermarkt.current_fixtures'
	);
	
