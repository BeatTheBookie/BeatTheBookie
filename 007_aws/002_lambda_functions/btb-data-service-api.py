import json
import time
import boto3
import pandas as pd
import io



#
# query wrapper class for Athena queries
#

class QueryAthena:

    def __init__(self, query, database):
        self.database = 'btb-serving'
        self.folder = 'api/'
        self.bucket = 'btb-athena-query-results'
        self.s3_input = 's3://' + self.bucket + '/my_folder_input'
        self.s3_output =  's3://' + self.bucket + '/' + self.folder
        self.region_name = 'eu-central-1'
        self.query = query

    def load_conf(self, q):
        
        try:
            self.client = boto3.client('athena', region_name = self.region_name)
            
            response = self.client.start_query_execution(
                QueryString = q,
                    QueryExecutionContext={
                    'Database': self.database
                    },
                    ResultConfiguration={
                    'OutputLocation': self.s3_output,
                    }
            )
            self.filename = response['QueryExecutionId']
            print('Execution ID: ' + response['QueryExecutionId'])

        except Exception as e:
            print(e)
        return response                

    def run_query(self):
        queries = [self.query]
        for q in queries:
            res = self.load_conf(q)
        try:              
            query_status = None
            while query_status == 'QUEUED' or query_status == 'RUNNING' or query_status is None:
                query_status = self.client.get_query_execution(QueryExecutionId=res["QueryExecutionId"])['QueryExecution']['Status']['State']
                query_status2 = self.client.get_query_execution(QueryExecutionId=res["QueryExecutionId"])['QueryExecution']['Status']
                print(query_status2)
                if query_status == 'FAILED' or query_status == 'CANCELLED':
                    raise Exception('Athena query with the string "{}" failed or was cancelled'.format(self.query))
                time.sleep(0.2)
            print('Query "{}" finished.'.format(self.query))

            df = self.obtain_data()
            return df

        except Exception as e:
            print(e)      

    def obtain_data(self):
        try:
            self.resource = boto3.resource('s3', 
                                  region_name = self.region_name)
                                  
            print(self.bucket)
            print(self.folder)
            print(self.filename)
            
            # S3 Object
            res_obj = self.resource.Object(bucket_name=self.bucket, key=self.folder + self.filename + '.csv')
            response = res_obj.get()
            
            return pd.read_csv(io.BytesIO(response['Body'].read()), encoding='utf8')   
        except Exception as e:
            print(e)  

#
# get data from zip poisson model
#
def get_zip_poisson_model():
    
    query = 'select * from "btb-serving".btbs_zip_poisson_model'
    print('starting query')
    qa = QueryAthena(query=query, database='btb-serving')
    df_result = qa.run_query()

    return df_result
    
def get_zip_poisson_model_his():
    
    query = 'select * from "btb-serving".btbs_zip_poisson_model_his'
    print('starting query')
    qa = QueryAthena(query=query, database='btb-serving')
    df_result = qa.run_query()

    return df_result


def lambda_handler(event, context):
    
    #
    # get API variables
    #
    
    print('...reading event information')
    
    v_path = str(event['path']).replace('/','')
    v_method = event['httpMethod']
    v_params = event['queryStringParameters']
    
    print('event: ' + str(event))
    print('path: ' + v_path)
    print('method: ' + v_method)
    print('params: ' + str(v_params))
    
    #
    # only GET method allowed
    #
    
    if v_method != "GET":
        return {
            'statusCode': 405,
            'body': json.dumps("Method not allowed")
        }    
    
    #
    # check the path to 
    #
    
    if v_path == "zip-poisson-model":
        
        #check parameters for zip poisson model
        if v_params is not None:
            #paramter: mode, default=pred
            if ("mode" in v_params):
                v_mode = v_params['mode']
            else:
                v_mode = 'pred'
        else:
            v_mode = 'pred'
        
            
        print('Execution-Mode: ' + v_mode)
        
        #differ between mode
        if v_mode == 'pred':
            df_result = get_zip_poisson_model()
        elif v_mode == 'hist':
            df_result = get_zip_poisson_model_his()
        else:
            return {
                'statusCode': 422,
                'body': json.dumps("Wrong parameter")
            }    
        
        return {
            'statusCode': 200,
            'body': df_result.to_json(orient='records')
        }
        
    elif v_path == 'auth-test':
        
        #no params allowed 
        if v_params is not None:
            return {
                'statusCode': 422,
                'body': json.dumps('Wrong paramters')
            }
    
        return {
            'statusCode': 200,
            'body': json.dumps('Authentication successful')
        }
        
    elif v_path == 'debug':
        
        print(v_params)
        print(len(v_params))
        
        if ("mode" in v_params):
            print ("mode found")
            
        if ("divisions" not in v_params):
            print ("no divisions")
                
        
    else:

        # TODO implement
        return {
            'statusCode': 400,
            'body': json.dumps('unknown')
        }
