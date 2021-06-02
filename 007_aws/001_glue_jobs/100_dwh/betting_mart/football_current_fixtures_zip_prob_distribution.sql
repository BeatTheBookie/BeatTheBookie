/************************************************
	Betting mart view for Poisson distribution for
	different number of goals
	
	
v1.0:
	- initial
	
*************************************************/



create or replace view betting_mart.football_current_fixtures_zip_prob_distribution 
as
with home_away as
(
select 'home' home_away
union all
select 'away'
),
num_goals as
(
select '0 goals' num_goals union all
select '1 goal' num_goals union all
select '2 goals' num_goals union all
select '3 goals' num_goals union all
select '4 goals' num_goals union all
select '5 goals' num_goals union all
select '6 goals' num_goals union all
select '>=7 goals' num_goals
)
select
	division,
	season,
	match_date,
	home_team || ' - ' || away_team match_teams,
	home_away,
	case 
	   when home_away = 'home' then home_team
	   else away_team
	end team,
	case 
	   when home_away = 'home' then str.home_attacking_strength
	   else str.away_attacking_strength
	end attack_strength,
	case 
	   when home_away = 'home' then str.home_defence_strength
	   else str.away_defence_strength
	end defence_strength,
	case 
	   when home_away = 'home' then zip.home_expect_goals
	   else zip.away_expect_goals
	end expected_goals,
	num_goals num_goals_key,
	case
	 when home_away = 'home' then 
	 	 case 
	     when num_goals = '0 goals' then zip.prob_home_0
	     when num_goals = '1 goal' then zip.prob_home_1
	     when num_goals = '2 goals' then zip.prob_home_2
	     when num_goals = '3 goals' then zip.prob_home_3
	     when num_goals = '4 goals' then zip.prob_home_4
	     when num_goals = '5 goals' then zip.prob_home_5
	     when num_goals = '6 goals' then zip.prob_home_6
	     when num_goals = '>=7 goals' then zip.prob_home_7
	   end
	  else
	   case 
	     when num_goals = '0 goals' then zip.prob_away_0
	     when num_goals = '1 goal' then zip.prob_away_1
	     when num_goals = '2 goals' then zip.prob_away_2
	     when num_goals = '3 goals' then zip.prob_away_3
	     when num_goals = '4 goals' then zip.prob_away_4
	     when num_goals = '5 goals' then zip.prob_away_5
	     when num_goals = '6 goals' then zip.prob_away_6
	     when num_goals = '>=7 goals' then zip.prob_away_7
	   end
  end num_goals_value
from
	betting_dv.football_match_cur_b cur
	join home_away 
		on (1=1)
	join num_goals
	 on (1=1)
	join betting_dv.football_match_cur_l_s_zip_probs zip
		on (cur.football_match_cur_lid = zip.football_match_cur_lid)
	join betting_dv.football_match_cur_l_s_attack_defence_strength_30 str
	   on (cur.football_match_cur_lid = str.football_match_cur_lid)
;