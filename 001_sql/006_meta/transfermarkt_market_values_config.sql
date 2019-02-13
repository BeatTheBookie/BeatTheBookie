/************************************************
	configuration table for import of http://www.transfermarkt.de
	yearly market value data
	
v1.0:
	- initial

		
*************************************************/


drop table if exists meta.transfermarkt_market_value_config; 

create table meta.transfermarkt_market_value_config
	(
	division	varchar(50),
	url			varchar(200)
	);
	
insert into 
	meta.transfermarkt_market_value_config 
values 
	('D1','http://www.transfermarkt.de/1-bundesliga/startseite/wettbewerb/L1/');

insert into 
	meta.transfermarkt_market_value_config 
values
	('D2','http://www.transfermarkt.de/2-bundesliga/startseite/wettbewerb/L2/');

insert into 
	meta.transfermarkt_market_value_config 
values 
	('E0','https://www.transfermarkt.de/premier-league/startseite/wettbewerb/GB1');
	
insert into 
	meta.transfermarkt_market_value_config 
values 
	('F1','https://www.transfermarkt.de/ligue-1/startseite/wettbewerb/FR1');


insert into 
	meta.transfermarkt_market_value_config 
values 
	('I1','https://www.transfermarkt.de/serie-a/startseite/wettbewerb/IT1');	

insert into 
	meta.transfermarkt_market_value_config 
values 
	('SP1','https://www.transfermarkt.de/primera-division/startseite/wettbewerb/ES1');