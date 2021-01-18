
import asyncio
import json
import pandas as pd
import aiohttp

from understat import Understat

import boto3

s3 = boto3.resource('s3')

client = boto3.client('s3')

    
v_bucket = 'btb-understat'

lst_leagues = [
                "bundesliga"
                ,"la_liga"
                ,"serie_a"
                ,"ligue_1"
                ,"rfpl"
                ,"EPL"
                ]


lst_seasons = [
 #           {"param_season" : "2014", "directory_season" : "2014_15"},
 #           {"param_season" : "2015", "directory_season" : "2015_16"},
 #           {"param_season" : "2016", "directory_season" : "2016_17"},
 #           {"param_season" : "2017", "directory_season" : "2017_18"},
 #           {"param_season" : "2018", "directory_season" : "2018_19"},
 #           {"param_season" : "2019", "directory_season" : "2019_20"},
            {"param_season" : "2020", "directory_season" : "2020_21"}
            ]
            
            
#
# function to load understat data
#

async def load_fixtures(league, season):
    async with aiohttp.ClientSession() as session:
        
        understat = Understat(session)

        fixtures = await understat.get_league_results(
                    league,
                    season["param_season"]
                )
        
        df_fixtures = pd.DataFrame(fixtures)
        
        await session.close()
        
        return df_fixtures
        
        

#loop over list of leagues
for league in lst_leagues:
    
    for season in lst_seasons:
        
        loop = asyncio.get_event_loop()
        df_fixtures = loop.run_until_complete(load_fixtures(league, season))
        
        #df_fixtures = await load_fixtures(league, season)
    
        v_file_name = v_file_name = 'fixtures/' + season["directory_season"] + '/' + league + '/'  + season["directory_season"] + '_' + league + '.json'  
        
        print("writing file " + v_file_name)
        
        client.put_object(Body=bytes(df_fixtures.to_json(orient='records', lines=True).encode('UTF-8')), Bucket=v_bucket, Key=v_file_name)
    
