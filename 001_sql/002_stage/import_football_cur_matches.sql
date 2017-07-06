


alter session set NLS_DATE_FORMAT='DD.MM.YYYY';

truncate table stage.football_cur_matches;

import into stage.football_cur_matches
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\001_manuell\man_current_matches.csv'
	column separator = ';'
	row separator = 'CRLF'
	skip=1;