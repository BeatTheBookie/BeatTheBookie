import boto3

#get aws client
client = boto3.client('s3')
response = client.list_buckets()

#
# define variables
#

v_bucket = 'btb-raw-layer'
v_file_prefix = 'football-data.co.uk/'

v_base_url = 'https://www.football-data.co.uk/mmz4281/'

lst_leagues = ["D1","D2","E0","F1","I1","SP1"]


lst_seasons = [
#            {"url_season" : "1112", "directory_season" : "2011_12"},
#            {"url_season" : "1213", "directory_season" : "2012_13"},
#            {"url_season" : "1314", "directory_season" : "2013_14"},
#            {"url_season" : "1415", "directory_season" : "2014_15"},
#            {"url_season" : "1516", "directory_season" : "2015_16"},
#            {"url_season" : "1617", "directory_season" : "2016_17"},
#            {"url_season" : "1718", "directory_season" : "2017_18"},
#            {"url_season" : "1819", "directory_season" : "2018_19"},
#            {"url_season" : "1920", "directory_season" : "2019_20"},
            {"url_season" : "2122", "directory_season" : "2021_22"}
            ]


import requests

for season in lst_seasons:
    
    for league in lst_leagues:
        
        v_file_url = v_base_url + season["url_season"] + '/' + league + '.csv'
        v_file_name = v_file_prefix + league + '_' + season["directory_season"] + '/' + league + '_' + season["directory_season"] + '.csv'
        
        #print('v_file_url:' + v_file_url)
        #print('v_file_name:' + v_file_name)
        #print('v_bucket:' + v_bucket)        
           
        file_request = requests.get(v_file_url, stream=True)
        
        if file_request.status_code == 200:
            
            file_data = file_request.raw
            
            try:
                client.upload_fileobj(file_data, v_bucket, v_file_name)
            except ClientError as e:
                print(error(e))
            
            print('File successfully loaded [' + v_file_url + ']')
            
        else:
            print('File is not existing & will be skipped [' + v_file_url + ']')                      
      