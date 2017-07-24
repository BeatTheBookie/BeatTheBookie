
/************************************************
	script for ZIP calculation 
	with R Package VGAM
	(zero inflated poisson distribution)
	
v1.0:
	- initial


	
		
*************************************************/


	

create or replace r scalar script betting_dv.r_zip(p_x double, p_mean double,p_prob_extra_zero number) returns double
as
library("VGAM")
run <- function(ctx)
{
	dzipois(ctx$p_x, ctx$p_mean, ctx$p_prob_extra_zero)
}
/
;



