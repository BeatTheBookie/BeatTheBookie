


alter session set NLS_DATE_FORMAT='DD.MM.YYYY';

truncate table stage.team_mapping;

import into stage.team_mapping
	from local csv file 'C:\Users\ado\Documents\betting db\001_quelldaten\001_manuell\team_mapping.csv'
	column separator = ';'
	row separator = 'CRLF'
	skip=1;