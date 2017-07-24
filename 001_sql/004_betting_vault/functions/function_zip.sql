
/************************************************
	script for ZIP calculation
	(zero inflated poisson distribution)
	
v1.0:
	- initial

v2.0:
		- separate script for factorial calculation
	
		
*************************************************/


	

create or replace lua scalar script betting_dv.zip(p_x double, p_mean double, p_prob_zeros double) returns double
as
import('factorial')

function zip(p_x, p_mean, p_prob_zeros)
	local v_return
	local v_faculty
	local v_cnt


	if p_x == 0 then
		
		v_return = p_prob_zeros + (1 - p_prob_zeros) * math.exp(p_mean * -1)
		
	else
		
		v_faculty = factorial.factorial(p_x)
		
				
		v_return = (1 - p_prob_zeros) * (math.pow(p_mean, p_x) * math.exp(p_mean * -1)) / v_faculty
	end	
	

	return v_return
end

function run (ctx)
	return zip(ctx.p_x, ctx.p_mean, ctx.p_prob_zeros)
end
/
;

/*
create or replace r scalar script betting_dv.r_zip(p_x double, p_mean double,p_prob_extra_zero number) returns double
as
library("VGAM")
run <- function(ctx)
{
	dzipois(ctx$p_x, ctx$p_mean, ctx$p_prob_extra_zero)
}
/
*/



