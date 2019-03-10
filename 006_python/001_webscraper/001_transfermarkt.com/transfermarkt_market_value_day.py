import urllib.request
from bs4 import BeautifulSoup as bs



#different urls
p_url = 'https://www.transfermarkt.de/1-bundesliga/marktwerteverein/wettbewerb/L1'
#v_url = 'http://www.transfermarkt.de/2-bundesliga/startseite/wettbewerb/L2/saison_id/2018'
#p_url = 'http://www.transfermarkt.de/2-bundesliga/startseite/wettbewerb/L2/'
p_num_days = 100

v_url = p_url
v_num_days = p_num_days

#defined user agent
v_user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36'
v_headers = {'User-Agent': v_user_agent}

#load web site
v_request = urllib.request.Request(url=v_url,headers=v_headers)
v_response = urllib.request.urlopen(v_request)

#soup parsing
soup = bs(v_response, 'html.parser')
#print(soup.prettify())

v_day_select = soup.find('div', attrs={'class':'inline-select'})
v_day_list = v_day_select.findAll('option')

i=0

for v_day in v_day_list:
    v_day_filter = v_day["value"]

    v_url_day = v_url + '/plus/?stichtag=' + v_day_filter

    v_request_day = urllib.request.Request(url=v_url_day, headers=v_headers)
    v_response_day = urllib.request.urlopen(v_request_day)

    # soup parsing
    soup_year = bs(v_response_day, 'html.parser')

    v_table = soup_year.find('table', attrs={'class': 'items'})
    v_table_body = v_table.find('tbody')
    v_table_rows = v_table_body.findAll('tr')

    # print(v_table_rows)

    for v_table_row in v_table_rows:
        # print(v_table_row)
        v_table_columns = v_table_row.findAll('td')

        v_team = v_table_columns[2].text.strip()
        v_team_market_value = v_table_columns[4].text.strip()

        print(v_day_filter,'    ', v_team,' ', v_team_market_value)


    #last x years
    i += 1
    if i >= v_num_days:
        break