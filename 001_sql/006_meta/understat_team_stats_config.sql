/************************************************
	configuration table for import of http://understat.com
	expected goals team data
	
v1.0:
	- initial

v2.0:
	- country and season added to get the correct BK for each Hub table
		
*************************************************/


drop table if exists meta.understat_team_stats_config; 

create table meta.understat_team_stats_config
	(
	division	varchar(50),
	country		varchar(10),
	season		varchar(10),
	url			varchar(200)
	);
	
insert into meta.understat_team_stats_config values ('D1','GER','2019_2020','https://understat.com/league/Bundesliga/2019');
--insert into meta.understat_team_stats_config values ('E0','ENG','2019_2020','https://understat.com/league/EPL/2019');
--insert into meta.understat_team_stats_config values ('I1','ITA','2019_2020','https://understat.com/league/Serie_A/2019');
--insert into meta.understat_team_stats_config values ('SP1','ESP','2019_2020','https://understat.com/league/La_liga/2019');
--insert into meta.understat_team_stats_config values ('F1','FRA','2019_2020','https://understat.com/league/Ligue_1/2019');

	
select
  *
from
  meta.understat_team_stats_config;
