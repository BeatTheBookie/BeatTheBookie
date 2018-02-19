

/************************************************
	betting vault division table link satellite
	- satellite for all division tables at each possible date
	
v1.0:
	- initial

		
*************************************************/


create or replace view betting_dv.football_division_table_l_s as
select
	football_division_table_lid,
	rank() over (partition by football_division_hid, football_season_hid, match_date order by points desc, goal_difference desc, goals_for desc) rang,
	played,
	win,
	draw,
	loose,
	goals_for,
	goals_against,
	goal_difference,
	points
from
	(
	select
		tab.football_division_table_lid,
		tab.football_division_hid,
		tab.football_season_hid,
		tab.match_date,
		team.team,
		sum(case 
				when his.match_date is null then 0 
				else 1 
		end) played,
		sum(case 
				when tab.football_team_hid = his.football_team_home_hid and stat.full_time_result = 'H' then 1
			   	when tab.football_team_hid = his.football_team_away_hid and stat.full_time_result = 'A' then 1
		  	   	else 0
		end) win,
		sum(case
				when stat.full_time_result = 'D' then 1
				else 0
		end) draw,
		sum(case
				when tab.football_team_hid = his.football_team_home_hid and stat.full_time_result = 'A' then 1
				when tab.football_team_hid = his.football_team_away_hid and stat.full_time_result = 'H' then 1
				else 0
		end) loose,
		sum(case
				when tab.football_team_hid = his.football_team_home_hid then full_time_home_goals
				when tab.football_team_hid = his.football_team_away_hid then full_time_away_goals
				else 0
		end) goals_for,
		sum(case
				when tab.football_team_hid = his.football_team_home_hid then full_time_away_goals
				when tab.football_team_hid = his.football_team_away_hid then full_time_home_goals
				else 0
		end) goals_against,
		sum(case
				when tab.football_team_hid = his.football_team_home_hid then full_time_home_goals - full_time_away_goals
				when tab.football_team_hid = his.football_team_away_hid then full_time_away_goals - full_time_home_goals
				else 0
		end) goal_difference,
		sum(case
				when tab.football_team_hid = his.football_team_home_hid and stat.full_time_result = 'H' then 3
				when tab.football_team_hid = his.football_team_away_hid and stat.full_time_result = 'A' then 3
				when stat.full_time_result = 'D' then 1
				else 0
		end) points
	from
		betting_dv.football_division_table_l tab
		left join betting_dv.football_match_his_l his
			on (tab.football_division_hid = his.football_division_hid and
				tab.football_season_hid = his.football_season_hid and
				(tab.football_team_hid = his.football_team_home_hid or
				tab.football_team_hid = his.football_team_away_hid) and
				tab.match_date > his.match_date
				)
		left join betting_dv.football_match_his_l_s_statistic stat
			on (his.football_match_his_lid = stat.football_match_his_lid)
		join betting_dv.football_team_h team
			on tab.football_team_hid = team.football_team_hid
		join betting_dv.football_division_h division
			on tab.football_division_hid = division.football_division_hid
		join betting_dv.football_season_h season
			on tab.football_season_hid = season.football_season_hid
	group by
		tab.football_division_table_lid,
		tab.football_division_hid,
		tab.football_season_hid,
		tab.match_date,
		team.team
	)
;