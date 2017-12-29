############################################
# GS Match-Rating
# - linear regression
# - polynomial regression
#
###########################################

#load packages
library(exasol)
library(MASS)
library(rlm)


#conect to exasol
con <- dbConnect("exa", exahost = "192.168.164.130:8563",
                 uid = "sys", pwd = "exasol", schema = "betting_dv")



#load train data
train_data <- exa.readData(con, "
select
	gs_match_rating,
                           round(num_home_win / num_games, 4) home_win_perc,
                           round(num_draw / num_games, 4) draw_perc,
                           round(num_away_win / num_games, 4) away_win_perc
                           from
                           (
                           select distinct
                           gs_match_rating,
                           count(*) over (partition by gs_match_rating) num_games,
                           sum(num_home_win) over (partition by gs_match_rating) num_home_win,
                           sum(num_draw) over (partition by gs_match_rating) num_draw,
                           sum(num_away_win) over (partition by gs_match_rating) num_away_win
                           from
                           (
                           select
                           his.match_date,
                           home.team home_team,
                           away.team away_team,
                           stat.full_time_result,
                           rating.gs_match_rating,
                           decode(stat.full_time_result,'H',1,0) num_home_win,
                           decode(stat.full_time_result,'D',1,0) num_draw,
                           decode(stat.full_time_result,'A',1,0) num_away_win	
                           from
                           betting_dv.football_match_his_l his
                           join betting_dv.football_match_his_l_s_statistic stat
                           on (his.football_match_his_lid = stat.football_match_his_lid)
                           join betting_dv.football_match_his_l_s_rating_features_7 rating
                           on (his.football_match_his_lid = rating.football_match_his_lid)
                           join betting_dv.football_season_h season
                           on (his.football_season_hid = season.football_season_hid)
                           join betting_dv.football_division_h division
                           on (his.football_division_hid = division.football_division_hid)
                           join betting_dv.football_team_h home
                           on (his.football_team_home_hid = home.football_team_hid)
                           join betting_dv.football_team_h away
                           on (his.football_team_away_hid = away.football_team_hid)
                           where
                           division.division = 'D1' and
                           season.season in ('2016_2017','2015_2016','2014_2015','2013_2014','2012_2013','2011_2012')
                           )
                           )
                           order by
                           1
")





#load prediction data
pred_data = exa.readData(con,"
select
	his.football_match_his_lid,
                         rating.gs_match_rating,
                         NULL prob_home_win,
                         NULL prob_draw,
                         NULL prob_away_win
                         from
                         betting_dv.football_match_his_l his
                         join betting_dv.football_match_his_l_s_statistic stat
                         on (his.football_match_his_lid = stat.football_match_his_lid)
                         join betting_dv.football_match_his_l_s_gs_match_rating rating
                         on (his.football_match_his_lid = rating.football_match_his_lid)
                         join betting_dv.football_season_h season
                         on (his.football_season_hid = season.football_season_hid)
                         join betting_dv.football_division_h division
                         on (his.football_division_hid = division.football_division_hid)
                         join betting_dv.football_team_h home
                         on (his.football_team_home_hid = home.football_team_hid)
                         join betting_dv.football_team_h away
                         on (his.football_team_away_hid = away.football_team_hid)
                         where
                         division.division = 'D1' 
                         and season.season in ('2017_2018')
")



#correlations test
with(train_data,cor(GS_MATCH_RATING,HOME_WIN_PERC))
with(train_data,cor(GS_MATCH_RATING,DRAW_PERC))
with(train_data,cor(GS_MATCH_RATING,AWAY_WIN_PERC))

#linear regression
regr_home = lm(HOME_WIN_PERC ~ GS_MATCH_RATING, data=train_data)
regr_draw = lm(DRAW_PERC ~ GS_MATCH_RATING, data=train_data)
regr_away = lm(AWAY_WIN_PERC ~ GS_MATCH_RATING, data=train_data)

#summary of linear regression
summary(regr_home)
summary(regr_draw)
summary(regr_away)

#linear regression diagnostic plots
plot(regr_home)
plot(regr_draw)
plot(regr_away)

#polynomial regression
poly_regr_home = lm(HOME_WIN_PERC ~ poly(GS_MATCH_RATING,2), data=train_data)
poly_regr_draw = lm(DRAW_PERC ~ poly(GS_MATCH_RATING,2), data=train_data)
poly_regr_away = lm(AWAY_WIN_PERC ~ poly(GS_MATCH_RATING,2), data=train_data)

#summary of polynomial regression  
summary(poly_regr_home)
summary(poly_regr_draw)
summary(poly_regr_away)

#analytic plots for polynomial regression
plot(poly_regr_home)
plot(poly_regr_draw)
plot(poly_regr_away)

#compare linear and polynomial regression
plot(HOME_WIN_PERC ~ GS_MATCH_RATING, data=train_data)
lines(train_data$GS_MATCH_RATING, predict(regr_home), col="red")
lines(train_data$GS_MATCH_RATING, predict(poly_regr_home), col="blue")

plot(DRAW_PERC ~ GS_MATCH_RATING, data=train_data)
lines(train_data$GS_MATCH_RATING, predict(regr_draw), col="red")
lines(train_data$GS_MATCH_RATING, predict(poly_regr_draw), col="blue")

plot(AWAY_WIN_PERC ~ GS_MATCH_RATING, data=train_data)
lines(train_data$GS_MATCH_RATING, predict(regr_away), col="red")
lines(train_data$GS_MATCH_RATING, predict(poly_regr_away), col="blue")

#prediction
pred_data$PROB_HOME_WIN <- predict(poly_regr_home, pred_data)
pred_data$PROB_DRAW <- predict(poly_regr_draw, pred_data)
pred_data$PROB_AWAY_WIN <- predict(poly_regr_away, pred_data)

#check sum
pred_data$check_sum <- pred_data$PROB_HOME_WIN + pred_data$PROB_DRAW + pred_data$PROB_AWAY_WIN 

#adapt probabilities proportional
pred_data$COR_PROB_HOME_WIN <- pred_data$PROB_HOME_WIN / pred_data$check_sum
pred_data$COR_PROB_DRAW <- pred_data$PROB_DRAW / pred_data$check_sum
pred_data$COR_PROB_AWAY_WIN <- pred_data$PROB_AWAY_WIN / pred_data$check_sum

#2nd check-summe
pred_data$cor_check_sum <- pred_data$COR_PROB_HOME_WIN + pred_data$COR_PROB_DRAW + pred_data$COR_PROB_AWAY_WIN 


#write to target table
EXAWriteTable(con = con, schema = 'BETTING_DV', tbl_name = 'FOOTBALL_MATCH_HIS_L_S_LINEAR_REGR_PROBS',
              overwrite = 'TRUE', data = pred_data)


