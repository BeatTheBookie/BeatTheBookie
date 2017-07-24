
/************************************************
	script for factorial
	calulation
	
v1.0:
	- initial

		
*************************************************/

	

create or replace lua scalar script betting_dv.factorial(p_num number) returns number
as

function factorial(p_num)
	local v_faculty
	local v_cnt

	v_faculty = p_num
	v_cnt = p_num - 1
	
	if p_num == 0 then
		return 1
	else
		
		while v_cnt > 0
		do
			v_faculty = v_faculty * v_cnt
			v_cnt = v_cnt - 1
		end

	end
	
	return v_faculty
end

function run(ctx)
	return factorial(ctx.p_num)
end
/

