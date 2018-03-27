
/************************************************
	script for exponential moving average
	with Python
	
v1.0:
	- initial


	
		
*************************************************/


	
create or replace python set script betting_dv.ema(team varchar(1000), match_date timestamp, num_goals double, span double order by match_date) 
emits (team varchar(1000), match_date timestamp, ema double)
as

import pandas as pd
import numpy as np

def run(ctx):
	#create empty data frame with fixed number of rows
	v_num_rows = ctx.size()
	v_df = pd.DataFrame(index = np.arange(0, v_num_rows), columns= ['team','match_date','num_goals'])

	#read span parameter
	v_span = ctx.span

	#read input parameter into data frame
	for i in np.arange(0, v_num_rows):
		v_df.loc[i] = [ctx.team, ctx.match_date, ctx.num_goals]
		ctx.next()
	
	#calculate EMA
	v_df['ema'] = pd.ewma(v_df['num_goals'], span=v_span)
	
	#return all rows
	for index, row in v_df.iterrows():
		ctx.emit(row['team'], row['match_date'], row['ema'])
/

