

/************************************************
	betting vault division table link satellite
	- satellite for all division tables at each possible date
	
v1.0:
	- initial
	
v2.0:
	- added points needed to reach 1st, cl, el, promotion
	or relagation

		
*************************************************/


create or replace table betting_dv.football_division_table_l_s
as
with base_table as
(
select
	football_division_table_lid,
	football_division_hid,
	football_season_hid,
	match_date,
	row_number() over (partition by football_division_hid, football_season_hid, match_date order by points desc, goal_difference desc, goals_for desc) rang,
	games_played,
	win,
	draw,
	loss,
	goals_for,
	goals_against,
	goal_difference,
	points
from
	(
	select
		tab.football_division_table_lid,
		tab.football_division_hid,
		--division.division,
		tab.football_season_hid,
		tab.match_date,
		team.team,
		sum(case 
				when his.match_date is null then 0 
				else 1 
		end) games_played,
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
		end) loss,
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
		left join raw_dv.football_match_his_l his
			on (tab.football_division_hid = his.football_division_hid and
				tab.football_season_hid = his.football_season_hid and
				(tab.football_team_hid = his.football_team_home_hid or
				tab.football_team_hid = his.football_team_away_hid) and
				tab.match_date > his.match_date
				)
		left join raw_dv.football_match_his_l_s_statistic stat
			on (his.football_match_his_lid = stat.football_match_his_lid)
		join raw_dv.football_team_h team
			on tab.football_team_hid = team.football_team_hid
		join raw_dv.football_division_h division
			on tab.football_division_hid = division.football_division_hid
		join raw_dv.football_season_h season
			on tab.football_season_hid = season.football_season_hid
	where
		division.division in ('D1','D2','E0','F1','I1','SP1')
	group by
		tab.football_division_table_lid,
		tab.football_division_hid,
		tab.football_season_hid,
		tab.match_date,
		team.team
	)
),
point_targets as
(
select
  b.football_division_hid,
  b.football_season_hid,
  b.match_date,
  max(cfg.num_teams) num_teams,
  --points of different important places
  --champion, cl, el, relegation, promotion
  max(case when t.rang = 1 then points else null end) points_1st, 
  max(case when t.rang = cfg.num_cl then points else null end) points_cl,
  max(case when t.rang = (cfg.num_el + cfg.num_cl) then points else null end) points_el,
  max(case when t.rang = (cfg.num_teams - cfg.num_rel + 1) then points else null end) points_rel,
  max(case when t.rang = cfg.num_prom then points else null end) points_prom
from
  base_table t
  join betting_dv.football_division_table_b b
    on t.football_division_table_lid = b.football_division_table_lid
  join meta.division_table_config cfg
    on b.division = cfg.division and
       b.season = cfg.season
group by
  1,2,3
)
select  
  t.football_division_table_lid,
  b.team,
  t.match_date,
  t.rang,
  t.games_played,
  ((p.num_teams * 2) - 2) - t.games_played games_left,
  t.win,
  t.draw,
  t.loss,
  t.goals_for,
  t.goals_against,
  t.goal_difference,
  t.points,
  p.points_1st - t.points points_to_1st,
  p.points_cl - t.points points_to_cl,
  p.points_el - t.points points_to_el,
  p.points_rel - t.points points_to_rel,
  p.points_prom - t.points points_to_prom
from
  base_table t
  join betting_dv.football_division_table_b b
    on t.football_division_table_lid = b.football_division_table_lid
  join point_targets p
    on t.football_division_hid = p.football_division_hid and
      t.football_season_hid = p.football_season_hid and
      t.match_date = p.match_date
;