
/********

Bridge table for division table link to
get also the business key

******/

create or replace view betting_dv.football_division_table_b as
select
  tab.football_division_table_lid,
  tab.football_division_hid,
  d.division,
  tab.football_season_hid,
  s.season,
  tab.football_team_hid,
  t.team,
  tab.match_date
from
  betting_dv.football_division_table_l tab
  join raw_dv.football_division_h d
    on tab.football_division_hid = d.football_division_hid
  join raw_dv.football_season_h s
    on tab.football_season_hid = s.football_season_hid
  join raw_dv.football_team_h t
    on tab.football_team_hid = t.football_team_hid      
;