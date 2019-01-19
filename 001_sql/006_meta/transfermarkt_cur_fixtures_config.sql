/************************************************
	configuration table for import of http://www.transfermarkt.de
	current fixtures data
	
v1.0:
	- initial

		
*************************************************/


drop table if exists meta.transfermarkt_cur_fixtures_config; 

create table meta.transfermarkt_cur_fixtures_config
	(
	division	varchar(50),
	url			varchar(200)
	);
	
insert into meta.transfermarkt_cur_fixtures_config values ('D1','http://www.transfermarkt.de/1-bundesliga/startseite/wettbewerb/L1');
--insert into meta.squawka_cur_fixtures_config values ('E0','http://www.squawka.com/match-fixtures?ctl=8_s2017',10);
	
	
