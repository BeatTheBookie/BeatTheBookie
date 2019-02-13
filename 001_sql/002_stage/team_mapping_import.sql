


alter session set NLS_DATE_FORMAT='DD.MM.YYYY';

truncate table stage.team_mapping;

import into stage.team_mapping
	from local csv file '[source directory]\team_mapping.csv'
	column separator = ';'
	row separator = 'CRLF'
	skip=1;
