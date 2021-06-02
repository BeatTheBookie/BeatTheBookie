import boto3
import pyexasol
from datetime import datetime


#sql script location
v_script_bucket = 'btb-scripts'
v_script_folder = 'dwh/betting_vault/'

#load parameter
dwh_host = '###'
dwh_port = '8563'
dwh_user = 'sys'
dwh_pass = '####'

#list of sql statement identifiers
sql_key_words = ['create or replace','select','truncate']

#connect to S3
s3 = boto3.resource('s3')


print('connect to DB')
print("timestamp =", datetime.now().time())


#connect to db
dwh_conn = pyexasol.connect(dsn=dwh_host + ':' + dwh_port, user=dwh_user, password=dwh_pass)

script_bucket = s3.Bucket(v_script_bucket)

#list all SQL files
for script_file in script_bucket.objects.filter(Prefix=v_script_folder).all():
    if script_file.key.endswith('.sql'):
        print('processing...  ' + script_file.key)
        print("timestamp =", datetime.now().time())
        
        i=1
        
        #read file
        script_file_body = script_file.get()['Body'].read().decode('utf-8')
        
        sql_statements = script_file_body.split(";")
        
        for sql in sql_statements:
            if any(keyword in sql for keyword in sql_key_words):
                print('processing...  sql statement #' + str(i))
                #print(sql)
                i=i+1
        
                dwh_conn.execute(sql)
        
print('close db connection')
print("timestamp =", datetime.now().time())
dwh_conn.close()
