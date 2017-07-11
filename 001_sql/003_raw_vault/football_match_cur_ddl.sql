/************************************************
	Raw data vault tables for manual current
	matches
	
v1.0:
	- initial state for tables
		- football_match_cur_ref

v2.0:
	- changed ref table to link table
		
*************************************************/


drop table raw_dv.football_match_cur_l;

--link table for current matches
create table raw_dv.football_match_cur_l
	(
	football_match_cur_lid	char(32),
	football_division_hid	char(32),
	football_team_home_hid	char(32),
	football_team_away_hid	char(32),
	football_season_hid		char(32),
	match_date				date,
	audit_insert_date		timestamp,
	audit_record_source		varchar(100),
	constraint pk_football_match_cur_l primary key (football_match_cur_lid) disable,
	constraint fk_football_match_cur_l_football_division_h foreign key (football_division_hid) references raw_dv.football_division_h (football_division_hid) disable,
	constraint fk_football_match_cur_l_football_team_home_h	foreign key (football_team_home_hid) references raw_dv.football_team_h (football_team_hid) disable,
	constraint fk_football_match_cur_l_football_team_away_h	foreign key (football_team_away_hid) references raw_dv.football_team_h (football_team_hid) disable,
	constraint fk_football_match_cur_l_football_team_season_h foreign key (football_season_hid) references raw_dv.football_season_h (football_season_hid) disable,
	distribute by football_match_cur_lid	
	)
;

comment on table raw_dv.football_match_cur_l							is 'Link table for current football matches';
comment on column raw_dv.football_match_cur_l.football_match_cur_lid 	is 'hash key for current football match';
comment on column raw_dv.football_match_cur_l.football_division_hid		is 'foreign key to division hub';
comment on column raw_dv.football_match_cur_l.football_team_home_hid	is 'foreign key to team hub for home team';
comment on column raw_dv.football_match_cur_l.football_team_away_hid	is 'foreign key to team hub for away team';
comment on column raw_dv.football_match_cur_l.football_season_hid		is 'foreign key to season hub';
comment on column raw_dv.football_match_cur_l.match_date				is 'match date';
