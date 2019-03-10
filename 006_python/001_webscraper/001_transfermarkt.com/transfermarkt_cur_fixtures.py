
#import urllib.parse
import urllib.request
from bs4 import BeautifulSoup as bs
#from lxml import html

#different urls
v_url = 'http://www.transfermarkt.de/1-bundesliga/startseite/wettbewerb/L1'
#v_url = 'http://www.transfermarkt.de/2-bundesliga/startseite/wettbewerb/L2/saison_id/2018'
#v_url = 'https://www.transfermarkt.de/premier-league/startseite/wettbewerb/GB1'

#defined user agent
v_user_agent = 'Mozilla/5.0 (Windows NT 10.0; Win64; x64) AppleWebKit/537.36 (KHTML, like Gecko) Chrome/70.0.3538.102 Safari/537.36'
v_headers = {'User-Agent': v_user_agent}

#load web site
v_request = urllib.request.Request(url=v_url,headers=v_headers)
v_response = urllib.request.urlopen(v_request)

#soup parsing
soup = bs(v_response, 'html.parser')
#print(soup.prettify())

#get current matchday and each single match
v_cur_matchday = soup.find('div', attrs={'id':'spieltagtabs-2'})
v_match_info = v_cur_matchday.findAll('tr', attrs={'class':'begegnungZeile'})

i=0

#loop throw all match infos
while i < len(v_match_info):
    #extract single values
    home_team = v_match_info[i].findAll('td', attrs={'class': 'verein-heim'})
    away_team = v_match_info[i].findAll('td', attrs={'class': 'verein-gast'})
    match_date = v_match_info[i].findAll('span', attrs={'class': 'spielzeitpunkt'})

    if len(match_date) == 1:
        last_match_date =  match_date
    else:
        match_date = last_match_date

    print(home_team[0].text.strip() + ' - ' + away_team[0].text.strip() + ' (' + match_date[0].text.strip() + ' )')

    i += 1

