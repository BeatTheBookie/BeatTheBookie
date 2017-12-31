/************************************************
	configuration table for import of http://www.squawka.com
	current fixtures data
	
v1.0:
	- initial

		
*************************************************/


drop table if exists meta.squawka_cur_fixtures_config; 

create table meta.squawka_cur_fixtures_config
	(
	division	varchar(50),
	url			varchar(200),
	num_matches decimal(5)
	);
	
insert into meta.squawka_cur_fixtures_config values ('D1','http://www.squawka.com/match-fixtures?ctl=22_s2017',9);
--insert into meta.squawka_cur_fixtures_config values ('E0','http://www.squawka.com/match-fixtures?ctl=8_s2017',10);
	
	
