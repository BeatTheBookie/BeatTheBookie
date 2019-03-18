
/************************************************
	UDF for transfermarkt market values web scraper
	for seasonal data
	
v1.0:
	- initial
	
*************************************************/



drop script if exists stage.webscr_transfermarkt_market_values_season;


create or replace PYTHON3 scalar script stage.webscr_transfermarkt_market_values_season
	(p_division varchar(3), p_url varchar(100), p_num_years decimal(2,0))
 emits 
	(division varchar(5), season varchar(4), team varchar(50), num_players varchar(100), team_market_value varchar(100))
as
import urllib.parse
import urllib.request
from bs4 import BeautifulSoup as bs

def run(ctx):
	v_url = ctx.p_url
	v_num_years = ctx.p_num_years
	v_division = ctx.p_division

	v_user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36'
	v_headers = {'User-Agent': v_user_agent}

	#load web site
	v_request = urllib.request.Request(url=v_url,headers=v_headers)
	v_response = urllib.request.urlopen(v_request)

	#soup parsing
	soup = bs(v_response, 'html.parser')
	#print(soup.prettify())

	v_year_select = soup.find('div', attrs={'class': 'inline-select'})
	v_year_list = v_year_select.findAll('option')
	
	i = 0

	for v_year in v_year_list:
		v_season_id = (v_year["value"])

		v_url_year =  v_url + '/plus/?saison_id=' + v_season_id

		v_request_year = urllib.request.Request(url=v_url_year,headers=v_headers)
		v_response_year = urllib.request.urlopen(v_request_year)

		# soup parsing
		soup_year = bs(v_response_year, 'html.parser')

		v_table = soup_year.find('table', attrs={'class': 'items'})
		v_table_body = v_table.find('tbody')
		v_table_rows = v_table_body.findAll('tr')

		#print(v_table_rows)

		for v_table_row in v_table_rows:

			#print(v_table_row)
			v_table_columns = v_table_row.findAll('td')

			v_team = v_table_columns[2].text.strip()
			v_num_players = v_table_columns[3].text.strip()
			v_team_market_value = v_table_columns[8].text.strip()
			
			
			ctx.emit(v_division, v_season_id, v_team, v_num_players, v_team_market_value)

		#year limiter
		i += 1
		if i >= v_num_years:
			break
			
;