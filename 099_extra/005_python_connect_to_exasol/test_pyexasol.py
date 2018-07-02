import pyexasol
import pandas

#connect to database
Con = pyexasol.connect(dsn='[IP]:8563', user='[user]', password = '[password]', schema = 'SANDBOX', compression=True)

#create empty copy of current fixtures tabl
Con.execute("Create table SANDBOX.CUR_FIXTURES as SELECT * FROM STAGE.SQUAWKA_CUR_FIXTURES where 1=0")

#export data to a pandas data frame
data_frame =  pandas.DataFrame
data_frame = Con.export_to_pandas('SELECT * FROM STAGE.SQUAWKA_CUR_FIXTURES')

print(data_frame.head())

#import from pandas data frame to Exasol
Con.import_from_pandas(data_frame,'CUR_FIXTURES')

Con.close()
