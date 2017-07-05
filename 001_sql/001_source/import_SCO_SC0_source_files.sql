
/***********************************
	Schott. Premier League Historie 2015/16
************************************/

drop table source_files.SCO_SC0_2015_16;

create table source_files.SCO_SC0_2015_16
	(
	Division					varchar(20),
	Match_Date					varchar(20),
	HomeTeam 					varchar(20),
	AwayTeam					varchar(20),
	full_time_home_goals		varchar(20),
	full_time_away_goals		varchar(20),
	full_time_result			varchar(20),
	half_time_home_goals		varchar(20),
	half_time_away_goals		varchar(20),
	half_time_result			varchar(20),
	referee						varchar(50),
	home_shots					varchar(20),
	away_shots					varchar(20),
	home_shots_target			varchar(20),
	away_shots_target			varchar(20),
	home_fouls					varchar(20),
	away_fouls					varchar(20),
	home_corners				varchar(20),
	away_corners				varchar(20),
	home_yellow					varchar(20),
	away_yellow					varchar(20),
	home_red					varchar(20),
	away_red					varchar(20),
	bet365_home_odds			varchar(20),
	bet365_draw_odds			varchar(20),
	bet365_away_odds			varchar(20),
	bet_win_home_odds			varchar(20),
	bet_win_draw_odds			varchar(20),
	bet_win_away_odds			varchar(20),
	interwetten_home_odds		varchar(20),
	interwetten_draw_odds		varchar(20),
	interwetten_away_odds		varchar(20),
	ladbrokes_home_odds			varchar(20),
	ladbrokes_draw_odds			varchar(20),
	ladbrokes_away_odds			varchar(20),
	pinacle_home_odds			varchar(20),
	pinacle_draw_odds			varchar(20),
	pinalce_away_odds			varchar(20),
	william_hill_home_odds		varchar(20),
	william_hill_draw_odds		varchar(20),
	william_hill_away_odds		varchar(20),
	vc_bet_home_odds			varchar(20),
	vc_bet_draw_odds			varchar(20),
	vc_bet_away_odds			varchar(20),
	betbrain_num_1X2			varchar(20),
	betbrain_max_home_odds		varchar(20),
	betbrain_avg_home_odds		varchar(20),
	betbrain_max_draw_odds		varchar(20),
	betbrein_avg_draw_odds		varchar(20),
	betbrain_max_away_odds		varchar(20),
	betbrain_avg_away_odds		varchar(20),
	betbrain_num_ou				varchar(20),
	betbrain_max_o25			varchar(20),
	betbrain_avg_o25			varchar(20),
	betbrain_max_u25			varchar(20),
	betbrain_avg_u25			varchar(20),
	betbrain_num_asian_h		varchar(20),
	betbrain_size_asian_h		varchar(20),
	betbrain_max_asian_h_home	varchar(20),
	betbrain_avg_asian_h_home	varchar(20),
	betbrain_max_asian_h_away	varchar(20),
	betbrain_avg_asian_h_away	varchar(20),
	empty_1						varchar(20),
	empty_2						varchar(20),
	empty_3						varchar(20)
	);



import into source_files.SCO_SC0_2015_16
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2015_16.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;	

	


/************************************
	Schott. Premier League Historie 2014/15
*************************************/


drop table source_files.SCO_SC0_2014_15;

create table source_files.SCO_SC0_2014_15
	(
	Division					varchar(20),
	Match_Date					varchar(20),
	HomeTeam 					varchar(20),
	AwayTeam					varchar(20),
	full_time_home_goals		varchar(20),
	full_time_away_goals		varchar(20),
	full_time_result			varchar(20),
	half_time_home_goals		varchar(20),
	half_time_away_goals		varchar(20),
	half_time_result			varchar(20),
	referee						varchar(50),
	home_shots					varchar(20),
	away_shots					varchar(20),
	home_shots_target			varchar(20),
	away_shots_target			varchar(20),
	home_fouls					varchar(20),
	away_fouls					varchar(20),
	home_corners				varchar(20),
	away_corners				varchar(20),
	home_yellow					varchar(20),
	away_yellow					varchar(20),
	home_red					varchar(20),
	away_red					varchar(20),
	bet365_home_odds			varchar(20),
	bet365_draw_odds			varchar(20),
	bet365_away_odds			varchar(20),
	bet_win_home_odds			varchar(20),
	bet_win_draw_odds			varchar(20),
	bet_win_away_odds			varchar(20),
	interwetten_home_odds		varchar(20),
	interwetten_draw_odds		varchar(20),
	interwetten_away_odds		varchar(20),
	ladbrokes_home_odds			varchar(20),
	ladbrokes_draw_odds			varchar(20),
	ladbrokes_away_odds			varchar(20),
	pinacle_home_odds			varchar(20),
	pinacle_draw_odds			varchar(20),
	pinalce_away_odds			varchar(20),
	william_hill_home_odds		varchar(20),
	william_hill_draw_odds		varchar(20),
	william_hill_away_odds		varchar(20),
	stan_james_home_odds		varchar(20),
	stan_james_draw_odds		varchar(20),
	stan_james_away_odds		varchar(20),
	vc_bet_home_odds			varchar(20),
	vc_bet_draw_odds			varchar(20),
	vc_bet_away_odds			varchar(20),
	betbrain_num_1X2			varchar(20),
	betbrain_max_home_odds		varchar(20),
	betbrain_avg_home_odds		varchar(20),
	betbrain_max_draw_odds		varchar(20),
	betbrein_avg_draw_odds		varchar(20),
	betbrain_max_away_odds		varchar(20),
	betbrain_avg_away_odds		varchar(20),
	betbrain_num_ou				varchar(20),
	betbrain_max_o25			varchar(20),
	betbrain_avg_o25			varchar(20),
	betbrain_max_u25			varchar(20),
	betbrain_avg_u25			varchar(20),
	betbrain_num_asian_h		varchar(20),
	betbrain_size_asian_h		varchar(20),
	betbrain_max_asian_h_home	varchar(20),
	betbrain_avg_asian_h_home	varchar(20),
	betbrain_max_asian_h_away	varchar(20),
	betbrain_avg_asian_h_away	varchar(20),
	empty_1						varchar(20),
	empty_2						varchar(20),
	empty_3						varchar(20)
	);



import into source_files.SCO_SC0_2014_15
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2014_15.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;

/************************************
	Schott. Premier League Historie 2013/14
*************************************/


drop table source_files.SCO_SC0_2013_14;

create table source_files.SCO_SC0_2013_14
	(
	Division					varchar(20),
	Match_Date					varchar(20),
	HomeTeam 					varchar(20),
	AwayTeam					varchar(20),
	full_time_home_goals		varchar(20),
	full_time_away_goals		varchar(20),
	full_time_result			varchar(20),
	half_time_home_goals		varchar(20),
	half_time_away_goals		varchar(20),
	half_time_result			varchar(20),
	referee						varchar(50),
	home_shots					varchar(20),
	away_shots					varchar(20),
	home_shots_target			varchar(20),
	away_shots_target			varchar(20),
	home_fouls					varchar(20),
	away_fouls					varchar(20),
	home_corners				varchar(20),
	away_corners				varchar(20),
	home_yellow					varchar(20),
	away_yellow					varchar(20),
	home_red					varchar(20),
	away_red					varchar(20),
	bet365_home_odds			varchar(20),
	bet365_draw_odds			varchar(20),
	bet365_away_odds			varchar(20),
	bet_win_home_odds			varchar(20),
	bet_win_draw_odds			varchar(20),
	bet_win_away_odds			varchar(20),
	interwetten_home_odds		varchar(20),
	interwetten_draw_odds		varchar(20),
	interwetten_away_odds		varchar(20),
	ladbrokes_home_odds			varchar(20),
	ladbrokes_draw_odds			varchar(20),
	ladbrokes_away_odds			varchar(20),
	pinacle_home_odds			varchar(20),
	pinacle_draw_odds			varchar(20),
	pinalce_away_odds			varchar(20),
	william_hill_home_odds		varchar(20),
	william_hill_draw_odds		varchar(20),
	william_hill_away_odds		varchar(20),
	stan_james_home_odds		varchar(20),
	stan_james_draw_odds		varchar(20),
	stan_james_away_odds		varchar(20),
	vc_bet_home_odds			varchar(20),
	vc_bet_draw_odds			varchar(20),
	vc_bet_away_odds			varchar(20),
	betbrain_num_1X2			varchar(20),
	betbrain_max_home_odds		varchar(20),
	betbrain_avg_home_odds		varchar(20),
	betbrain_max_draw_odds		varchar(20),
	betbrein_avg_draw_odds		varchar(20),
	betbrain_max_away_odds		varchar(20),
	betbrain_avg_away_odds		varchar(20),
	betbrain_num_ou				varchar(20),
	betbrain_max_o25			varchar(20),
	betbrain_avg_o25			varchar(20),
	betbrain_max_u25			varchar(20),
	betbrain_avg_u25			varchar(20),
	betbrain_num_asian_h		varchar(20),
	betbrain_size_asian_h		varchar(20),
	betbrain_max_asian_h_home	varchar(20),
	betbrain_avg_asian_h_home	varchar(20),
	betbrain_max_asian_h_away	varchar(20),
	betbrain_avg_asian_h_away	varchar(20),
	empty_1						varchar(20),
	empty_2						varchar(20),
	empty_3						varchar(20)
	);



import into source_files.SCO_SC0_2013_14
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2013_14.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;



/************************************
	Schott. Premier League Historie 2012/13
*************************************/


drop table source_files.SCO_SC0_2012_13;

create table source_files.SCO_SC0_2012_13
	(
	Division					varchar(20),
	Match_Date					varchar(20),
	HomeTeam 					varchar(20),
	AwayTeam					varchar(20),
	full_time_home_goals		varchar(20),
	full_time_away_goals		varchar(20),
	full_time_result			varchar(20),
	half_time_home_goals		varchar(20),
	half_time_away_goals		varchar(20),
	half_time_result			varchar(20),
	home_shots					varchar(20),
	away_shots					varchar(20),
	home_shots_target			varchar(20),
	away_shots_target			varchar(20),
	home_fouls					varchar(20),
	away_fouls					varchar(20),
	home_corners				varchar(20),
	away_corners				varchar(20),
	home_yellow					varchar(20),
	away_yellow					varchar(20),
	home_red					varchar(20),
	away_red					varchar(20),
	bet365_home_odds			varchar(20),
	bet365_draw_odds			varchar(20),
	bet365_away_odds			varchar(20),
	bet_win_home_odds			varchar(20),
	bet_win_draw_odds			varchar(20),
	bet_win_away_odds			varchar(20),
	gamebookers_home_odds		varchar(20),
	gamebookers_draw_odds		varchar(20),
	gamebookers_away_odds		varchar(20),
	interwetten_home_odds		varchar(20),
	interwetten_draw_odds		varchar(20),
	interwetten_away_odds		varchar(20),
	ladbrokes_home_odds			varchar(20),
	ladbrokes_draw_odds			varchar(20),
	ladbrokes_away_odds			varchar(20),
	pinacle_home_odds			varchar(20),
	pinacle_draw_odds			varchar(20),
	pinalce_away_odds			varchar(20),
	william_hill_home_odds		varchar(20),
	william_hill_draw_odds		varchar(20),
	william_hill_away_odds		varchar(20),
	stan_james_home_odds		varchar(20),
	stan_james_draw_odds		varchar(20),
	stan_james_away_odds		varchar(20),
	vc_bet_home_odds			varchar(20),
	vc_bet_draw_odds			varchar(20),
	vc_bet_away_odds			varchar(20),
	blue_square_home_odds		varchar(20),
	blue_square_draw_odds		varchar(20),
	blue_square_away_odds		varchar(20),
	betbrain_num_1X2			varchar(20),
	betbrain_max_home_odds		varchar(20),
	betbrain_avg_home_odds		varchar(20),
	betbrain_max_draw_odds		varchar(20),
	betbrein_avg_draw_odds		varchar(20),
	betbrain_max_away_odds		varchar(20),
	betbrain_avg_away_odds		varchar(20),
	betbrain_num_ou				varchar(20),
	betbrain_max_o25			varchar(20),
	betbrain_avg_o25			varchar(20),
	betbrain_max_u25			varchar(20),
	betbrain_avg_u25			varchar(20),
	betbrain_num_asian_h		varchar(20),
	betbrain_size_asian_h		varchar(20),
	betbrain_max_asian_h_home	varchar(20),
	betbrain_avg_asian_h_home	varchar(20),
	betbrain_max_asian_h_away	varchar(20),
	betbrain_avg_asian_h_away	varchar(20),
	empty_1						varchar(20),
	empty_2						varchar(20),
	empty_3						varchar(20)
	);




import into source_files.SCO_SC0_2012_13
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2012_13.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;



/************************************
	Schott. Premier League Historie 2011/12
*************************************/


drop table source_files.SCO_SC0_2011_12;

create table source_files.SCO_SC0_2011_12
	(
	Division					varchar(20),
	Match_Date					varchar(20),
	HomeTeam 					varchar(20),
	AwayTeam					varchar(20),
	full_time_home_goals		varchar(20),
	full_time_away_goals		varchar(20),
	full_time_result			varchar(20),
	half_time_home_goals		varchar(20),
	half_time_away_goals		varchar(20),
	half_time_result			varchar(20),
	referee						varchar(50),
	home_shots					varchar(20),
	away_shots					varchar(20),
	home_shots_target			varchar(20),
	away_shots_target			varchar(20),
	home_fouls					varchar(20),
	away_fouls					varchar(20),
	home_corners				varchar(20),
	away_corners				varchar(20),
	home_yellow					varchar(20),
	away_yellow					varchar(20),
	home_red					varchar(20),
	away_red					varchar(20),
	bet365_home_odds			varchar(20),
	bet365_draw_odds			varchar(20),
	bet365_away_odds			varchar(20),
	bet_win_home_odds			varchar(20),
	bet_win_draw_odds			varchar(20),
	bet_win_away_odds			varchar(20),
	gamebookers_home_odds		varchar(20),
	gamebookers_draw_odds		varchar(20),
	gamebookers_away_odds		varchar(20),
	interwetten_home_odds		varchar(20),
	interwetten_draw_odds		varchar(20),
	interwetten_away_odds		varchar(20),
	ladbrokes_home_odds			varchar(20),
	ladbrokes_draw_odds			varchar(20),
	ladbrokes_away_odds			varchar(20),
	sporting_bet_home_odds		varchar(20),
	sporting_bet_draw_odds		varchar(20),
	sporting_bet_away_odds		varchar(20),
	william_hill_home_odds		varchar(20),
	william_hill_draw_odds		varchar(20),
	william_hill_away_odds		varchar(20),
	stan_james_home_odds		varchar(20),
	stan_james_draw_odds		varchar(20),
	stan_james_away_odds		varchar(20),
	vc_bet_home_odds			varchar(20),
	vc_bet_draw_odds			varchar(20),
	vc_bet_away_odds			varchar(20),
	blue_square_home_odds		varchar(20),
	blue_square_draw_odds		varchar(20),
	blue_square_away_odds		varchar(20),
	betbrain_num_1X2			varchar(20),
	betbrain_max_home_odds		varchar(20),
	betbrain_avg_home_odds		varchar(20),
	betbrain_max_draw_odds		varchar(20),
	betbrein_avg_draw_odds		varchar(20),
	betbrain_max_away_odds		varchar(20),
	betbrain_avg_away_odds		varchar(20),
	betbrain_num_ou				varchar(20),
	betbrain_max_o25			varchar(20),
	betbrain_avg_o25			varchar(20),
	betbrain_max_u25			varchar(20),
	betbrain_avg_u25			varchar(20),
	betbrain_num_asian_h		varchar(20),
	betbrain_size_asian_h		varchar(20),
	betbrain_max_asian_h_home	varchar(20),
	betbrain_avg_asian_h_home	varchar(20),
	betbrain_max_asian_h_away	varchar(20),
	betbrain_avg_asian_h_away	varchar(20)
	);



import into source_files.SCO_SC0_2011_12
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2011_12.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;

	


/************************************
	Schott. Premier League Historie 2010/11
*************************************/


drop table source_files.SCO_SC0_2010_11;

create table source_files.SCO_SC0_2010_11
	(
	Division					varchar(20),
	Match_Date					varchar(20),
	HomeTeam 					varchar(20),
	AwayTeam					varchar(20),
	full_time_home_goals		varchar(20),
	full_time_away_goals		varchar(20),
	full_time_result			varchar(20),
	half_time_home_goals		varchar(20),
	half_time_away_goals		varchar(20),
	half_time_result			varchar(20),
	referee						varchar(50),
	home_shots					varchar(20),
	away_shots					varchar(20),
	home_shots_target			varchar(20),
	away_shots_target			varchar(20),
	home_fouls					varchar(20),
	away_fouls					varchar(20),
	home_corners				varchar(20),
	away_corners				varchar(20),
	home_yellow					varchar(20),
	away_yellow					varchar(20),
	home_red					varchar(20),
	away_red					varchar(20),
	bet365_home_odds			varchar(20),
	bet365_draw_odds			varchar(20),
	bet365_away_odds			varchar(20),
	bet_win_home_odds			varchar(20),
	bet_win_draw_odds			varchar(20),
	bet_win_away_odds			varchar(20),
	gamebookers_home_odds		varchar(20),
	gamebookers_draw_odds		varchar(20),
	gamebookers_away_odds		varchar(20),
	interwetten_home_odds		varchar(20),
	interwetten_draw_odds		varchar(20),
	interwetten_away_odds		varchar(20),
	ladbrokes_home_odds			varchar(20),
	ladbrokes_draw_odds			varchar(20),
	ladbrokes_away_odds			varchar(20),
	sporting_bet_home_odds		varchar(20),
	sporting_bet_draw_odds		varchar(20),
	sporting_bet_away_odds		varchar(20),
	william_hill_home_odds		varchar(20),
	william_hill_draw_odds		varchar(20),
	william_hill_away_odds		varchar(20),
	stan_james_home_odds		varchar(20),
	stan_james_draw_odds		varchar(20),
	stan_james_away_odds		varchar(20),
	vc_bet_home_odds			varchar(20),
	vc_bet_draw_odds			varchar(20),
	vc_bet_away_odds			varchar(20),
	blue_square_home_odds		varchar(20),
	blue_square_draw_odds		varchar(20),
	blue_square_away_odds		varchar(20),
	betbrain_num_1X2			varchar(20),
	betbrain_max_home_odds		varchar(20),
	betbrain_avg_home_odds		varchar(20),
	betbrain_max_draw_odds		varchar(20),
	betbrein_avg_draw_odds		varchar(20),
	betbrain_max_away_odds		varchar(20),
	betbrain_avg_away_odds		varchar(20),
	betbrain_num_ou				varchar(20),
	betbrain_max_o25			varchar(20),
	betbrain_avg_o25			varchar(20),
	betbrain_max_u25			varchar(20),
	betbrain_avg_u25			varchar(20),
	betbrain_num_asian_h		varchar(20),
	betbrain_size_asian_h		varchar(20),
	betbrain_max_asian_h_home	varchar(20),
	betbrain_avg_asian_h_home	varchar(20),
	betbrain_max_asian_h_away	varchar(20),
	betbrain_avg_asian_h_away	varchar(20)
	);



import into source_files.SCO_SC0_2010_11
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2010_11.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;	
	
	


/***********************************
	Schott. Premier League Historie 2009/10
*************************************/


drop table source_files.SCO_SC0_2009_10;

create table source_files.SCO_SC0_2009_10
	(
	Division					varchar(20),
	Match_Date					varchar(20),
	HomeTeam 					varchar(20),
	AwayTeam					varchar(20),
	full_time_home_goals		varchar(20),
	full_time_away_goals		varchar(20),
	full_time_result			varchar(20),
	half_time_home_goals		varchar(20),
	half_time_away_goals		varchar(20),
	half_time_result			varchar(20),
	referee						varchar(50),
	home_shots					varchar(20),
	away_shots					varchar(20),
	home_shots_target			varchar(20),
	away_shots_target			varchar(20),
	home_fouls					varchar(20),
	away_fouls					varchar(20),
	home_corners				varchar(20),
	away_corners				varchar(20),
	home_yellow					varchar(20),
	away_yellow					varchar(20),
	home_red					varchar(20),
	away_red					varchar(20),
	bet365_home_odds			varchar(20),
	bet365_draw_odds			varchar(20),
	bet365_away_odds			varchar(20),
	bet_win_home_odds			varchar(20),
	bet_win_draw_odds			varchar(20),
	bet_win_away_odds			varchar(20),
	gamebookers_home_odds		varchar(20),
	gamebookers_draw_odds		varchar(20),
	gamebookers_away_odds		varchar(20),
	interwetten_home_odds		varchar(20),
	interwetten_draw_odds		varchar(20),
	interwetten_away_odds		varchar(20),
	ladbrokes_home_odds			varchar(20),
	ladbrokes_draw_odds			varchar(20),
	ladbrokes_away_odds			varchar(20),
	sporting_bet_home_odds		varchar(20),
	sporting_bet_draw_odds		varchar(20),
	sporting_bet_away_odds		varchar(20),
	william_hill_home_odds		varchar(20),
	william_hill_draw_odds		varchar(20),
	william_hill_away_odds		varchar(20),
	stan_james_home_odds		varchar(20),
	stan_james_draw_odds		varchar(20),
	stan_james_away_odds		varchar(20),
	vc_bet_home_odds			varchar(20),
	vc_bet_draw_odds			varchar(20),
	vc_bet_away_odds			varchar(20),
	blue_square_home_odds		varchar(20),
	blue_square_draw_odds		varchar(20),
	blue_square_away_odds		varchar(20),
	betbrain_num_1X2			varchar(20),
	betbrain_max_home_odds		varchar(20),
	betbrain_avg_home_odds		varchar(20),
	betbrain_max_draw_odds		varchar(20),
	betbrein_avg_draw_odds		varchar(20),
	betbrain_max_away_odds		varchar(20),
	betbrain_avg_away_odds		varchar(20),
	betbrain_num_ou				varchar(20),
	betbrain_max_o25			varchar(20),
	betbrain_avg_o25			varchar(20),
	betbrain_max_u25			varchar(20),
	betbrain_avg_u25			varchar(20),
	betbrain_num_asian_h		varchar(20),
	betbrain_size_asian_h		varchar(20),
	betbrain_max_asian_h_home	varchar(20),
	betbrain_avg_asian_h_home	varchar(20),
	betbrain_max_asian_h_away	varchar(20),
	betbrain_avg_asian_h_away	varchar(20)
	);



import into source_files.SCO_SC0_2009_10
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2009_10.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;



/***********************************
	Schott. Premier League Historie 2008/09
*************************************/


drop table source_files.SCO_SC0_2008_09;

create table source_files.SCO_SC0_2008_09
	(
	Division					varchar(20),
	Match_Date					varchar(20),
	HomeTeam 					varchar(20),
	AwayTeam					varchar(20),
	full_time_home_goals		varchar(20),
	full_time_away_goals		varchar(20),
	full_time_result			varchar(20),
	half_time_home_goals		varchar(20),
	half_time_away_goals		varchar(20),
	half_time_result			varchar(20),
	referee						varchar(50),
	home_shots					varchar(20),
	away_shots					varchar(20),
	home_shots_target			varchar(20),
	away_shots_target			varchar(20),
	home_fouls					varchar(20),
	away_fouls					varchar(20),
	home_corners				varchar(20),
	away_corners				varchar(20),
	home_yellow					varchar(20),
	away_yellow					varchar(20),
	home_red					varchar(20),
	away_red					varchar(20),
	bet365_home_odds			varchar(20),
	bet365_draw_odds			varchar(20),
	bet365_away_odds			varchar(20),
	bet_win_home_odds			varchar(20),
	bet_win_draw_odds			varchar(20),
	bet_win_away_odds			varchar(20),
	gamebookers_home_odds		varchar(20),
	gamebookers_draw_odds		varchar(20),
	gamebookers_away_odds		varchar(20),
	interwetten_home_odds		varchar(20),
	interwetten_draw_odds		varchar(20),
	interwetten_away_odds		varchar(20),
	ladbrokes_home_odds			varchar(20),
	ladbrokes_draw_odds			varchar(20),
	ladbrokes_away_odds			varchar(20),
	sporting_bet_home_odds		varchar(20),
	sporting_bet_draw_odds		varchar(20),
	sporting_bet_away_odds		varchar(20),
	william_hill_home_odds		varchar(20),
	william_hill_draw_odds		varchar(20),
	william_hill_away_odds		varchar(20),
	stan_james_home_odds		varchar(20),
	stan_james_draw_odds		varchar(20),
	stan_james_away_odds		varchar(20),
	vc_bet_home_odds			varchar(20),
	vc_bet_draw_odds			varchar(20),
	vc_bet_away_odds			varchar(20),
	blue_square_home_odds		varchar(20),
	blue_square_draw_odds		varchar(20),
	blue_square_away_odds		varchar(20),
	betbrain_num_1X2			varchar(20),
	betbrain_max_home_odds		varchar(20),
	betbrain_avg_home_odds		varchar(20),
	betbrain_max_draw_odds		varchar(20),
	betbrein_avg_draw_odds		varchar(20),
	betbrain_max_away_odds		varchar(20),
	betbrain_avg_away_odds		varchar(20),
	betbrain_num_ou				varchar(20),
	betbrain_max_o25			varchar(20),
	betbrain_avg_o25			varchar(20),
	betbrain_max_u25			varchar(20),
	betbrain_avg_u25			varchar(20),
	betbrain_num_asian_h		varchar(20),
	betbrain_size_asian_h		varchar(20),
	betbrain_max_asian_h_home	varchar(20),
	betbrain_avg_asian_h_home	varchar(20),
	betbrain_max_asian_h_away	varchar(20),
	betbrain_avg_asian_h_away	varchar(20)
	);



import into source_files.SCO_SC0_2008_09
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2008_09.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;

	


/***********************************
	Schott. Premier League Historie 2007/08
*************************************/


drop table source_files.SCO_SC0_2007_08;

create table source_files.SCO_SC0_2007_08
	(
	Division					varchar(20),
	Match_Date					varchar(20),
	HomeTeam 					varchar(20),
	AwayTeam					varchar(20),
	full_time_home_goals		varchar(20),
	full_time_away_goals		varchar(20),
	full_time_result			varchar(20),
	half_time_home_goals		varchar(20),
	half_time_away_goals		varchar(20),
	half_time_result			varchar(20),
	referee						varchar(50),
	home_shots					varchar(20),
	away_shots					varchar(20),
	home_shots_target			varchar(20),
	away_shots_target			varchar(20),
	home_fouls					varchar(20),
	away_fouls					varchar(20),
	home_corners				varchar(20),
	away_corners				varchar(20),
	home_yellow					varchar(20),
	away_yellow					varchar(20),
	home_red					varchar(20),
	away_red					varchar(20),
	bet365_home_odds			varchar(20),
	bet365_draw_odds			varchar(20),
	bet365_away_odds			varchar(20),
	bet_win_home_odds			varchar(20),
	bet_win_draw_odds			varchar(20),
	bet_win_away_odds			varchar(20),
	gamebookers_home_odds		varchar(20),
	gamebookers_draw_odds		varchar(20),
	gamebookers_away_odds		varchar(20),
	interwetten_home_odds		varchar(20),
	interwetten_draw_odds		varchar(20),
	interwetten_away_odds		varchar(20),
	ladbrokes_home_odds			varchar(20),
	ladbrokes_draw_odds			varchar(20),
	ladbrokes_away_odds			varchar(20),
	sporting_bet_home_odds		varchar(20),
	sporting_bet_draw_odds		varchar(20),
	sporting_bet_away_odds		varchar(20),
	william_hill_home_odds		varchar(20),
	william_hill_draw_odds		varchar(20),
	william_hill_away_odds		varchar(20),
	stan_james_home_odds		varchar(20),
	stan_james_draw_odds		varchar(20),
	stan_james_away_odds		varchar(20),
	vc_bet_home_odds			varchar(20),
	vc_bet_draw_odds			varchar(20),
	vc_bet_away_odds			varchar(20),
	blue_square_home_odds		varchar(20),
	blue_square_draw_odds		varchar(20),
	blue_square_away_odds		varchar(20),
	betbrain_num_1X2			varchar(20),
	betbrain_max_home_odds		varchar(20),
	betbrain_avg_home_odds		varchar(20),
	betbrain_max_draw_odds		varchar(20),
	betbrein_avg_draw_odds		varchar(20),
	betbrain_max_away_odds		varchar(20),
	betbrain_avg_away_odds		varchar(20),
	betbrain_num_ou				varchar(20),
	betbrain_max_o25			varchar(20),
	betbrain_avg_o25			varchar(20),
	betbrain_max_u25			varchar(20),
	betbrain_avg_u25			varchar(20),
	betbrain_num_asian_h		varchar(20),
	betbrain_size_asian_h		varchar(20),
	betbrain_max_asian_h_home	varchar(20),
	betbrain_avg_asian_h_home	varchar(20),
	betbrain_max_asian_h_away	varchar(20),
	betbrain_avg_asian_h_away	varchar(20)
	);



import into source_files.SCO_SC0_2007_08
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2007_08.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;

	




/***********************************
	Schott. Premier League Historie 2006/07
*************************************/


drop table source_files.SCO_SC0_2006_07;

create table source_files.SCO_SC0_2006_07
	(
	Division					varchar(20),
	Match_Date					varchar(20),
	HomeTeam 					varchar(20),
	AwayTeam					varchar(20),
	full_time_home_goals		varchar(20),
	full_time_away_goals		varchar(20),
	full_time_result			varchar(20),
	half_time_home_goals		varchar(20),
	half_time_away_goals		varchar(20),
	half_time_result			varchar(20),
	referee						varchar(50),
	home_shots					varchar(20),
	away_shots					varchar(20),
	home_shots_target			varchar(20),
	away_shots_target			varchar(20),
	home_fouls					varchar(20),
	away_fouls					varchar(20),
	home_corners				varchar(20),
	away_corners				varchar(20),
	home_yellow					varchar(20),
	away_yellow					varchar(20),
	home_red					varchar(20),
	away_red					varchar(20),
	bet365_home_odds			varchar(20),
	bet365_draw_odds			varchar(20),
	bet365_away_odds			varchar(20),
	bet_win_home_odds			varchar(20),
	bet_win_draw_odds			varchar(20),
	bet_win_away_odds			varchar(20),
	gamebookers_home_odds		varchar(20),
	gamebookers_draw_odds		varchar(20),
	gamebookers_away_odds		varchar(20),
	interwetten_home_odds		varchar(20),
	interwetten_draw_odds		varchar(20),
	interwetten_away_odds		varchar(20),
	ladbrokes_home_odds			varchar(20),
	ladbrokes_draw_odds			varchar(20),
	ladbrokes_away_odds			varchar(20),
	sporting_bet_home_odds		varchar(20),
	sporting_bet_draw_odds		varchar(20),
	sporting_bet_away_odds		varchar(20),
	william_hill_home_odds		varchar(20),
	william_hill_draw_odds		varchar(20),
	william_hill_away_odds		varchar(20),
	stan_james_home_odds		varchar(20),
	stan_james_draw_odds		varchar(20),
	stan_james_away_odds		varchar(20),
	vc_bet_home_odds			varchar(20),
	vc_bet_draw_odds			varchar(20),
	vc_bet_away_odds			varchar(20),
	betbrain_num_1X2			varchar(20),
	betbrain_max_home_odds		varchar(20),
	betbrain_avg_home_odds		varchar(20),
	betbrain_max_draw_odds		varchar(20),
	betbrein_avg_draw_odds		varchar(20),
	betbrain_max_away_odds		varchar(20),
	betbrain_avg_away_odds		varchar(20),
	betbrain_num_ou				varchar(20),
	betbrain_max_o25			varchar(20),
	betbrain_avg_o25			varchar(20),
	betbrain_max_u25			varchar(20),
	betbrain_avg_u25			varchar(20),
	betbrain_num_asian_h		varchar(20),
	betbrain_size_asian_h		varchar(20),
	betbrain_max_asian_h_home	varchar(20),
	betbrain_avg_asian_h_home	varchar(20),
	betbrain_max_asian_h_away	varchar(20),
	betbrain_avg_asian_h_away	varchar(20)
	);



import into source_files.SCO_SC0_2006_07
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2006_07.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;



/***********************************
	Schott. Premier League Historie 2005/06
*************************************/


drop table source_files.SCO_SC0_2005_06;

create table source_files.SCO_SC0_2005_06
	(
	Division					varchar(20),
	Match_Date					varchar(20),
	HomeTeam 					varchar(20),
	AwayTeam					varchar(20),
	full_time_home_goals		varchar(20),
	full_time_away_goals		varchar(20),
	full_time_result			varchar(20),
	half_time_home_goals		varchar(20),
	half_time_away_goals		varchar(20),
	half_time_result			varchar(20),
	referee						varchar(50),
	home_shots					varchar(20),
	away_shots					varchar(20),
	home_shots_target			varchar(20),
	away_shots_target			varchar(20),
	home_fouls					varchar(20),
	away_fouls					varchar(20),
	home_corners				varchar(20),
	away_corners				varchar(20),
	home_yellow					varchar(20),
	away_yellow					varchar(20),
	home_red					varchar(20),
	away_red					varchar(20),
	bet365_home_odds			varchar(20),
	bet365_draw_odds			varchar(20),
	bet365_away_odds			varchar(20),
	bet_win_home_odds			varchar(20),
	bet_win_draw_odds			varchar(20),
	bet_win_away_odds			varchar(20),
	gamebookers_home_odds		varchar(20),
	gamebookers_draw_odds		varchar(20),
	gamebookers_away_odds		varchar(20),
	interwetten_home_odds		varchar(20),
	interwetten_draw_odds		varchar(20),
	interwetten_away_odds		varchar(20),
	ladbrokes_home_odds			varchar(20),
	ladbrokes_draw_odds			varchar(20),
	ladbrokes_away_odds			varchar(20),
	sporting_bet_home_odds		varchar(20),
	sporting_bet_draw_odds		varchar(20),
	sporting_bet_away_odds		varchar(20),
	william_hill_home_odds		varchar(20),
	william_hill_draw_odds		varchar(20),
	william_hill_away_odds		varchar(20),
	stan_james_home_odds		varchar(20),
	stan_james_draw_odds		varchar(20),
	stan_james_away_odds		varchar(20),
	vc_bet_home_odds			varchar(20),
	vc_bet_draw_odds			varchar(20),
	vc_bet_away_odds			varchar(20),
	betbrain_num_1X2			varchar(20),
	betbrain_max_home_odds		varchar(20),
	betbrain_avg_home_odds		varchar(20),
	betbrain_max_draw_odds		varchar(20),
	betbrein_avg_draw_odds		varchar(20),
	betbrain_max_away_odds		varchar(20),
	betbrain_avg_away_odds		varchar(20),
	betbrain_num_ou				varchar(20),
	betbrain_max_o25			varchar(20),
	betbrain_avg_o25			varchar(20),
	betbrain_max_u25			varchar(20),
	betbrain_avg_u25			varchar(20),
	betbrain_num_asian_h		varchar(20),
	betbrain_size_asian_h		varchar(20),
	betbrain_max_asian_h_home	varchar(20),
	betbrain_avg_asian_h_home	varchar(20),
	betbrain_max_asian_h_away	varchar(20),
	betbrain_avg_asian_h_away	varchar(20)
	);



import into source_files.SCO_SC0_2005_06
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2005_06.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;



/***********************************
	Schott. Premier League Historie 2004/05
*************************************/


drop table source_files.SCO_SC0_2004_05;

create table source_files.SCO_SC0_2004_05
	(
	Division						varchar(20),
	Match_Date						varchar(20),
	HomeTeam 						varchar(20),
	AwayTeam						varchar(20),
	full_time_home_goals			varchar(20),
	full_time_away_goals			varchar(20),
	full_time_result				varchar(20),
	half_time_home_goals			varchar(20),
	half_time_away_goals			varchar(20),
	half_time_result				varchar(20),
	referee							varchar(50),
	home_shots						varchar(20),
	away_shots						varchar(20),
	home_shots_target				varchar(20),
	away_shots_target				varchar(20),
	home_fouls						varchar(20),
	away_fouls						varchar(20),
	home_corners					varchar(20),
	away_corners					varchar(20),
	home_yellow						varchar(20),
	away_yellow						varchar(20),
	home_red						varchar(20),
	away_red						varchar(20),
	bet365_home_odds				varchar(20),
	bet365_draw_odds				varchar(20),
	bet365_away_odds				varchar(20),
	bet_win_home_odds				varchar(20),
	bet_win_draw_odds				varchar(20),
	bet_win_away_odds				varchar(20),
	gamebookers_home_odds			varchar(20),
	gamebookers_draw_odds			varchar(20),
	gamebookers_away_odds			varchar(20),
	interwetten_home_odds			varchar(20),
	interwetten_draw_odds			varchar(20),
	interwetten_away_odds			varchar(20),
	ladbrokes_home_odds				varchar(20),
	ladbrokes_draw_odds				varchar(20),
	ladbrokes_away_odds				varchar(20),
	sporting_bet_home_odds			varchar(20),
	sporting_bet_draw_odds			varchar(20),
	sporting_bet_away_odds			varchar(20),
	william_hill_home_odds			varchar(20),
	william_hill_draw_odds			varchar(20),
	william_hill_away_odds			varchar(20),
	gamebookers_o25_odds			varchar(20),
	gamebookers_u25_odds			varchar(20),
	gamebookers_asian_h_home_odds	varchar(20),
	gamebookers_asian_h_away_odds	varchar(20),
	gamebookers_asian_h_size		varchar(20),
	ladbrokes_asian_h_home_odds		varchar(20),
	ladbrokes_asian_h_away_odds		varchar(20),
	ladbrokes_asian_h_size			varchar(20),
	bet365_asian_h_home_odds		varchar(20),
	bet365_asian_h_away_odds		varchar(20),
	bet365_asian_h_size				varchar(20)
	);



import into source_files.SCO_SC0_2004_05
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2004_05.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;


	
	


/***********************************
	Schott. Premier League Historie 2003/04
*************************************/


drop table source_files.SCO_SC0_2003_04;

create table source_files.SCO_SC0_2003_04
	(
	Division						varchar(20),
	Match_Date						varchar(20),
	HomeTeam 						varchar(20),
	AwayTeam						varchar(20),
	full_time_home_goals			varchar(20),
	full_time_away_goals			varchar(20),
	full_time_result				varchar(20),
	half_time_home_goals			varchar(20),
	half_time_away_goals			varchar(20),
	half_time_result				varchar(20),
	referee							varchar(50),
	home_shots						varchar(20),
	away_shots						varchar(20),
	home_shots_target				varchar(20),
	away_shots_target				varchar(20),
	home_fouls						varchar(20),
	away_fouls						varchar(20),
	home_corners					varchar(20),
	away_corners					varchar(20),
	home_yellow							varchar(20),
	away_yellow						varchar(20),
	home_red						varchar(20),
	away_red						varchar(20),
	bet365_home_odds				varchar(20),
	bet365_draw_odds				varchar(20),
	bet365_away_odds				varchar(20),
	gamebookers_home_odds			varchar(20),
	gamebookers_draw_odds			varchar(20),
	gamebookers_away_odds			varchar(20),
	interwetten_home_odds			varchar(20),
	interwetten_draw_odds			varchar(20),
	interwetten_away_odds			varchar(20),
	ladbrokes_home_odds				varchar(20),
	ladbrokes_draw_odds				varchar(20),
	ladbrokes_away_odds				varchar(20),
	sporting_odds_home_odds			varchar(20),
	sporting_odds_draw_odds			varchar(20),
	sporting_odds_away_odds			varchar(20),
	sporting_bet_home_odds			varchar(20),
	sporting_bet_draw_odds			varchar(20),
	sporting_bet_away_odds			varchar(20),
	william_hill_home_odds			varchar(20),
	william_hill_draw_odds			varchar(20),
	william_hill_away_odds			varchar(20),
	gamebookers_o25_odds			varchar(20),
	gamebookers_u25_odds			varchar(20),
	gamebookers_asian_h_home_odds	varchar(20),
	gamebookers_asian_h_away_odds	varchar(20),
	gamebookers_asian_h_size		varchar(20)
	);



import into source_files.SCO_SC0_2003_04
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\007_schottland\SCO_SC0_2003_04.csv'
	column separator = ','
	row separator = 'CRLF'
	skip=1;



	

/*****************
	Kontrolle
*****************/

select
	'SCO_SC0_2015_16' source_file,
	count(*) record_cnt
from
	source_files.SCO_SC0_2015_16
union
select
	'SCO_SC0_2014_15',
	count(*)
from
	source_files.SCO_SC0_2014_15
union
select
	'SCO_SC0_2013_14',
	count(*)
from
	source_files.SCO_SC0_2013_14
union
select
	'SCO_SC0_2012_13',
	count(*)
from
	source_files.SCO_SC0_2012_13
union
select
	'SCO_SC0_2011_12',
	count(*)
from
	source_files.SCO_SC0_2011_12
union
select
	'SCO_SC0_2010_11',
	count(*)
from
	source_files.SCO_SC0_2010_11
union
select
	'SCO_SC0_2009_10',
	count(*)
from
	source_files.SCO_SC0_2009_10
union
select
	'SCO_SC0_2008_09',
	count(*)
from
	source_files.SCO_SC0_2008_09
union
select
	'SCO_SC0_2007_08',
	count(*)
from
	source_files.SCO_SC0_2007_08
union
select
	'SCO_SC0_2006_07',
	count(*)
from
	source_files.SCO_SC0_2006_07
union
select
	'SCO_SC0_2005_06',
	count(*)
from
	source_files.SCO_SC0_2005_06
union
select
	'SCO_SC0_2004_05',
	count(*)
from
	source_files.SCO_SC0_2004_05
union
select
	'SCO_SC0_2003_04',
	count(*)
from
	source_files.SCO_SC0_2003_04
order by
	source_file
;
