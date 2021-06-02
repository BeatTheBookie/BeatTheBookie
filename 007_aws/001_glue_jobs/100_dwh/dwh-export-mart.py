#
# job parameter
# numpy==1.9.5, pyarrow==2.0.0, awswrangler, pyexasol
# --no-index --ignore-installed --find-links=http://btb-python-repository.s3-website.eu-central-1.amazonaws.com/index.html --trusted-host btb-python-repository.s3-website.eu-central-1.amazonaws.com
#


import boto3
import pyexasol
import awswrangler as wr
from datetime import datetime


#sql script location
v_serving_bucket = 's3://btb-serving-layer'
v_serving_database = 'btb-serving'

#load parameter
dwh_host = '#####'
dwh_port = '8563'
dwh_user = 'sys'
dwh_pass = '####'


#
# connect to s3 and delete all tables and files from serving
# layer
#

print('delete S3 files')
print("timestamp =", datetime.now().time())

boto3.setup_default_session(region_name = 'eu-central-1')
                           
#get dataframe of all tables
df_athena_tables = wr.catalog.tables(database=v_serving_database)

for index, row in df_athena_tables.iterrows():
    v_table = row["Table"]
    print("...deleting table & data " + v_table)
       
    #delete table
    wr.catalog.delete_table_if_exists(database=v_serving_database, table=v_table)


#drop all objects from repo bucket
files = wr.s3.list_objects(v_serving_bucket)
wr.s3.delete_objects(files)

    
    
#
# connect to exasol and get all mart tables
#
    
print('connect to DB')
print("timestamp =", datetime.now().time())


#connect to db
dwh_conn = pyexasol.connect(dsn=dwh_host + ':' + dwh_port, user=dwh_user, password=dwh_pass)


#get all objects
print('... getting all mart tables and views')

v_sql = "SELECT object_name FROM exa_all_objects WHERE root_name = 'BETTING_MART'"

df_tables = dwh_conn.export_to_pandas(v_sql)

#iter over all tables
for index, row in df_tables.iterrows():
    print('... exporting table ' + row["OBJECT_NAME"])
    
    #sql to read table data
    v_sql = "select * from betting_mart." + row["OBJECT_NAME"]
    
    df_data = dwh_conn.export_to_pandas(v_sql)
    
    #export to parquet
    wr.s3.to_parquet(
                df=df_data,
                path= v_serving_bucket + '/' + row["OBJECT_NAME"] + '/',
                dataset=True,
                database="btb-serving",
                table=row["OBJECT_NAME"]
                )
    
    print("timestamp =", datetime.now().time())

    
#close connection
print('closing DB connection')
print("timestamp =", datetime.now().time())