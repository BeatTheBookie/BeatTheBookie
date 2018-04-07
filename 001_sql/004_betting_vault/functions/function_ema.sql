
/************************************************
	script for exponential moving average
	with Python
	
v1.0:
	- initial


	
parameter:
group_param -> the group for which the EMA should be calculated e.g the home team
order_param -> order criteria for series
series -> series used for EMA calculation
	
		
*************************************************/


	
create or replace python set script betting_dv.ema(group_param varchar(1000), order_param varchar(1000), series double, span double order by order_param) 
emits (group_param varchar(1000), order_param varchar(1000), series double, ema double)
as

import pandas as pd
import numpy as np

def run(ctx):
	#create empty data frame with fixed number of rows
	v_num_rows = ctx.size()
	v_df = pd.DataFrame(index = np.arange(0, v_num_rows), columns= ['group_param','order_param','series'])

	#read span parameter
	v_span = ctx.span

	#read input parameter into data frame
	for i in np.arange(0, v_num_rows):
		v_df.loc[i] = [ctx.group_param, ctx.order_param, ctx.series]
		ctx.next()
	
	#calculate EMA
	v_df['ema'] = pd.ewma(v_df['series'], span=v_span)
	
	#return all rows
	for index, row in v_df.iterrows():
		ctx.emit(row['group_param'], row['order_param'], row['series'], row['ema'])
/

