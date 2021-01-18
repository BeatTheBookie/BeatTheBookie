import asyncio
import json
import pandas as pd
import aiohttp
import sys

from understat import Understat

import boto3

s3 = boto3.resource('s3')

client = boto3.client('s3')

v_bucket = 'btb-understat'

lst_leagues = [
                "bundesliga"
                ,"la_liga"
                ,"serie_a"
                , "ligue_1"
                , "rfpl"
                , "EPL"
                ]


lst_seasons = [
#            {"param_season" : "2014", "directory_season" : "2014_15"},
#            {"param_season" : "2015", "directory_season" : "2015_16"},
#            {"param_season" : "2016", "directory_season" : "2016_17"},
#            {"param_season" : "2017", "directory_season" : "2017_18"},
#            {"param_season" : "2018", "directory_season" : "2018_19"},
#            {"param_season" : "2019", "directory_season" : "2019_20"},
            {"param_season" : "2020", "directory_season" : "2020_21"}
            ]
            
            

async def load_match_player_stats(league, season):
    async with aiohttp.ClientSession() as session:
        
        understat = Understat(session)
        
        #first fixtures are needed to get shot for each match
        fixtures = await understat.get_league_results(
                    league,
                    season["param_season"]
                )
        
        
        #loop over each fixture and get match shots
        for fixture in fixtures:
            
            try:
                match_players = await understat.get_match_players(fixture['id'])
            except:
                print("Unexpected error for fixture-id " + fixture['id'])
            
            #print(match_players["h"])
            
            #extract home match shots
            df_match_players = pd.DataFrame(match_players["h"]).transpose()
            df_match_players = df_match_players.append(pd.DataFrame(match_players["a"]).transpose())
            df_match_players["match_id"] = fixture['id']
            
            v_file_name = 'match-player-stats/' + season["directory_season"] + '/' + league + '/' + season["directory_season"] + '_' + league + '_' + fixture['id'] + '.json'  

            print("writing file " + v_file_name)
        
            client.put_object(Body=bytes(df_match_players.to_json(orient='records', lines=True).encode('UTF-8')), Bucket=v_bucket, Key=v_file_name)
        
        await session.close()



#loop over list of leagues
for league in lst_leagues:
    
    for season in lst_seasons:
            
        #call lodaing file for each league / season combination
        
        loop = asyncio.get_event_loop()
        df_fixtures = loop.run_until_complete(load_match_player_stats(league, season))
        
        #await load_match_player_stats(league, season)