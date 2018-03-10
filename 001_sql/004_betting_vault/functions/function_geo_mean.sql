
/************************************************
	script for geometric mean calculation 
	with R
	
v1.0:
	- initial


	
		
*************************************************/


	

create or replace r set script betting_dv.geo_mean(p_input double) returns double
as

run <- function(ctx)
{
	ctx$next_row(NA)
	exp(mean(log(ctx$p_input)))
}
/
;


