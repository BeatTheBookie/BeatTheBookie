import urllib.request
from bs4 import BeautifulSoup as bs



#different urls
#v_url = 'http://www.transfermarkt.de/1-bundesliga/startseite/wettbewerb/L1/'
#v_url = 'http://www.transfermarkt.de/2-bundesliga/startseite/wettbewerb/L2/saison_id/2018'
p_url = 'http://www.transfermarkt.de/2-bundesliga/startseite/wettbewerb/L2/'
p_num_years = 2

v_url = p_url
v_num_years = p_num_years

#defined user agent
v_user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36'
v_headers = {'User-Agent': v_user_agent}

#load web site
v_request = urllib.request.Request(url=v_url,headers=v_headers)
v_response = urllib.request.urlopen(v_request)

#soup parsing
soup = bs(v_response, 'html.parser')
#print(soup.prettify())

v_year_select = soup.find('div', attrs={'class':'inline-select'})
v_year_list = v_year_select.findAll('option')

#counter variable
i=0

#loop over year list
for v_year in v_year_list:
    v_season_id = (v_year["value"])

    #build sub site URL
    v_url_year =  v_url + '/plus/?saison_id=' + v_season_id

    #read sub site
    v_request_year = urllib.request.Request(url=v_url_year, headers=v_headers)
    v_response_year = urllib.request.urlopen(v_request_year)

    # soup parsing
    soup_year = bs(v_response_year, 'html.parser')

    v_table = soup_year.find('table', attrs={'class': 'items'})
    v_table_body = v_table.find('tbody')
    v_table_rows = v_table_body.findAll('tr')

    # print(v_table_rows)

    #loop over table rows
    for v_table_row in v_table_rows:
        # print(v_table_row)
        v_table_columns = v_table_row.findAll('td')

        #extract values
        v_team = v_table_columns[2].text.strip()
        v_num_players = v_table_columns[3].text.strip()
        v_team_market_value = v_table_columns[8].text.strip()

        print(v_season_id,' ', v_team,' ', v_num_players,'  ', v_team_market_value)

    #last x years break
    i += 1
    if i >= v_num_years:
        break