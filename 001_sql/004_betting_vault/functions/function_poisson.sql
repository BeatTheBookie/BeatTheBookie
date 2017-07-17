
/************************************************
	script for poisson calculation

	
v1.0:
	- initial

v2.0:
	- separate script for factorial calculation

v3.0:
	- changed to R
		
*************************************************/


create or replace R scalar script betting_dv.poisson(p_x number, p_mean number) returns number
as

run <- function(ctx)
{
	dpois(ctx$p_x, ctx$p_mean)
}
/


