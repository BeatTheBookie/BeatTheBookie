
#import urllib.parse
import urllib.request
import chromedriver_binary
import datetime
import pyexasol
import time
from bs4 import BeautifulSoup as bs
from selenium import webdriver

#build db connection
Con = pyexasol.connect(dsn='192.168.164.130:8563', user='sys', password = 'exasol', schema = 'sandbox', compression=True)

#empty dictionary
#
v_rows = 0
df_data = []

#web driver to simulate chrome browser
#browser = webdriver.Chrome('chromedriver.exe')
chrome_options = webdriver.ChromeOptions()
chrome_options.add_argument("--headless")
chrome_options.add_argument("--disable-gpu")
chrome_options.add_argument("window-size=1024,768")
chrome_options.add_argument("--no-sandbox")


####
#different urls

#Bundesliga current season
#v_url = 'https://understat.com/league/Bundesliga/2019'

#v_season = '2019_2020'
#v_division = 'D1'

#Premier League
v_url = 'https://understat.com/league/EPL/2019'

v_season = '2019_2020'
v_division = 'E0'

#Serie A
#v_url = 'https://understat.com/league/Serie_A/2014'

#v_season = '2014_2015'
#v_division = 'I1'

#La Liga
#v_url = 'https://understat.com/league/La_liga/2014'

#v_season = '2014_2015'
#v_division = 'SP1'

#Ligue 1
#v_url = 'https://understat.com/league/Ligue_1/2014'

#v_season = '2014_2015'
#v_division = 'F1'



####



# Initialize a new browser
browser = webdriver.Chrome(chrome_options=chrome_options)
browser.get(v_url)

#set button to loop through weeks
prev_button = browser.find_element_by_class_name('calendar-prev')
next_button = browser.find_element_by_class_name('calendar-next')

#manual week limiter
num_weeks = 300
iter_week = 1

#loop control is handled inside the loop
do_loop = True
last_loop = False
loop_backwards = True


#loop as long prev button is enabled
while do_loop == True:

    v_dates = browser.find_elements_by_class_name('calendar-date-container')

    #store, whether results for date
    date_got_results = False

    #loop over date container
    for v_date in v_dates:

        #save match date
        v_match_date = datetime.datetime.strptime(v_date.find_element_by_class_name('calendar-date').text,'%A, %B %d, %Y').date()

        print(v_match_date)

        #loop over game per date
        v_matches = v_date.find_elements_by_class_name('calendar-game')

        #loop over matches
        for v_match in v_matches:

            v_match_info = v_match.find_element_by_class_name('match-info')

            #get link match info, if match has already a result
            if v_match_info.get_attribute('data-isresult') == 'true':
                v_match_href = v_match_info.get_attribute('href')

                date_got_results = True

                ####
                # open match info site to read stats
                ####

                browser_match = webdriver.Chrome(chrome_options=chrome_options)
                browser_match.get(v_match_href)

                #sleep as sometimes not all data is
                time.sleep(2)

                #stat label has to be click, so that schema with
                #statistics can be read
                schema_buttons = browser_match.find_elements_by_tag_name('label')
                for schema_button in schema_buttons:
                    if schema_button.get_attribute('for') == 'scheme3':
                        schema_button.click()

                #get schema blocks
                v_schema_blocks = browser_match.find_elements_by_class_name('scheme-block')

                #loop over all schema blocks,
                #but only the stats schema block is interesting
                for v_schema_block in v_schema_blocks:

                    if v_schema_block.get_attribute('data-scheme') == 'stats':

                        #get single stats lines
                        v_stat_lines = v_schema_block.find_elements_by_class_name('progress-bar')

                        #loop over single stat lines
                        for v_stat_line in v_stat_lines:

                            #differ between interesting stat lines
                            if v_stat_line.find_element_by_class_name('progress-title').text == 'TEAMS':
                                v_home_team = v_stat_line.find_element_by_class_name('progress-home').text
                                v_away_team = v_stat_line.find_element_by_class_name('progress-away').text

                            if v_stat_line.find_element_by_class_name('progress-title').text == 'GOALS':
                                v_home_goals = v_stat_line.find_element_by_class_name('progress-home').text
                                v_away_goals = v_stat_line.find_element_by_class_name('progress-away').text

                            if v_stat_line.find_element_by_class_name('progress-title').text == 'xG':
                                v_home_xgoals = v_stat_line.find_element_by_class_name('progress-home').text
                                v_away_xgoals = v_stat_line.find_element_by_class_name('progress-away').text

                            if v_stat_line.find_element_by_class_name('progress-title').text == 'SHOTS':
                                v_home_shots = v_stat_line.find_element_by_class_name('progress-home').text
                                v_away_shots = v_stat_line.find_element_by_class_name('progress-away').text

                            if v_stat_line.find_element_by_class_name('progress-title').text == 'SHOTS ON TARGET':
                                v_home_shots_on_target = v_stat_line.find_element_by_class_name('progress-home').text
                                v_away_shots_on_target = v_stat_line.find_element_by_class_name('progress-away').text

                            if v_stat_line.find_element_by_class_name('progress-title').text == 'DEEP':
                                v_home_deep = v_stat_line.find_element_by_class_name('progress-home').text
                                v_away_deep = v_stat_line.find_element_by_class_name('progress-away').text

                            if v_stat_line.find_element_by_class_name('progress-title').text == 'PPDA':
                                v_home_ppda = v_stat_line.find_element_by_class_name('progress-home').text
                                v_away_ppda = v_stat_line.find_element_by_class_name('progress-away').text

                            if v_stat_line.find_element_by_class_name('progress-title').text == 'xPTS':
                                v_home_xpts = v_stat_line.find_element_by_class_name('progress-home').text
                                v_away_xpts = v_stat_line.find_element_by_class_name('progress-away').text


                browser_match.close()

                #stats output to data frame
                df_data.append(
                    [v_season, v_division, v_match_date, v_home_team, v_away_team, v_home_goals, v_away_goals, v_home_xgoals, v_away_xgoals,
                     v_home_shots, v_away_shots, v_home_shots_on_target, v_away_shots_on_target, v_home_deep, v_away_deep,
                     v_home_ppda, v_away_ppda, v_home_xpts, v_away_xpts])

                #print(v_match_date, v_home_team, v_away_team, v_home_goals, v_away_goals, v_home_xgoals, v_away_xgoals)


    #click button for next dates

    #get intial loop direction
    if iter_week == 1 and not (prev_button.is_enabled()):
        loop_backwards = False

    elif iter_week == 1 and prev_button.is_enabled():
        loop_backwards = True

    #click to next page dependend on loop direction
    if loop_backwards == True:
        prev_button.click()
        iter_week = iter_week + 1
    else:
        # ordering has changed -> next button has to be clicked
        next_button.click()
        iter_week = iter_week + 1

    #check exit criteria
    if loop_backwards == False:

        #page got no more results -> stop looping
        if date_got_results == False:
            do_loop = False

    else:

        #end loop, when limiter is reached
        if iter_week >= num_weeks:
            do_loop = False


        #Check loop criteria
        #- as long more weeks for the season are existing -> button is enabled
        #- first week in the season
        if not(prev_button.is_enabled()) and last_loop == True:
            do_loop = False
        # when no more weeks are available -> last loop for last week
        if not(prev_button.is_enabled()) and last_loop == False:
            last_loop = True
            print('last loop set')


browser.close()


#import data frame to db
#Con.execute('delete from understat_match_team_stats where division = ' + v_division + ' and season = ' + v_season)
Con.import_from_iterable(df_data,'understat_match_team_stats')

Con.close()