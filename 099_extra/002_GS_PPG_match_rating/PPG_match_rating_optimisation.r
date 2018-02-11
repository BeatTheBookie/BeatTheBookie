############################################
# PPG Match-Rating
# - linear regression
# - polynomial regression
# - polynomial regression without outliers
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
	ppg_match_rating,
                           round(num_home_win / num_games, 4) home_win_perc,
                           round(num_draw / num_games, 4) draw_perc,
                           round(num_away_win / num_games, 4) away_win_perc
                           from
                           (
                           select distinct
                           ppg_match_rating,
                           count(*) over (partition by ppg_match_rating) num_games,
                           sum(num_home_win) over (partition by ppg_match_rating) num_home_win,
                           sum(num_draw) over (partition by ppg_match_rating) num_draw,
                           sum(num_away_win) over (partition by ppg_match_rating) num_away_win
                           from
                           (
                           select
                           his.match_date,
                           home.team home_team,
                           away.team away_team,
                           stat.full_time_result,
                           round(rating.ppg_match_rating,3) ppg_match_rating,
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








#correlations test
cor(train_data$PPG_MATCH_RATING,train_data$HOME_WIN_PERC)
cor(train_data$PPG_MATCH_RATING,train_data$DRAW_PERC)
cor(train_data$PPG_MATCH_RATING,train_data$AWAY_WIN_PERC)
  
#plot distribution
plot(train_data$PPG_MATCH_RATING,train_data$HOME_WIN_PERC, xlab = "PPG match rating", ylab = "Home win percentage", col = "dark blue", pch = 22)
plot(train_data$PPG_MATCH_RATING,train_data$DRAW_PERC, xlab = "PPG match rating", ylab = "Draw percentage", col = "dark blue", pch = 22)
plot(train_data$PPG_MATCH_RATING,train_data$AWAY_WIN_PERC, xlab = "PPG match rating", ylab = "Away win percentage", col = "dark blue", pch = 22)

#linear regression
regr_home = lm(HOME_WIN_PERC ~ PPG_MATCH_RATING, data=train_data)
regr_draw = lm(DRAW_PERC ~ PPG_MATCH_RATING, data=train_data)
regr_away = lm(AWAY_WIN_PERC ~ PPG_MATCH_RATING, data=train_data)

#summary of linear regression
summary(regr_home)
summary(regr_draw)
summary(regr_away)

#linear regression diagnostic plots
plot(regr_home)
plot(regr_draw)
plot(regr_away)

#polynomial regression
poly_regr_home = lm(HOME_WIN_PERC ~ poly(PPG_MATCH_RATING,2), data=train_data)
poly_regr_draw = lm(DRAW_PERC ~ poly(PPG_MATCH_RATING,2), data=train_data)
poly_regr_away = lm(AWAY_WIN_PERC ~ poly(PPG_MATCH_RATING,2), data=train_data)

#summary of polynomial regression  
summary(poly_regr_home)
summary(poly_regr_draw)
summary(poly_regr_away)

#analytic plots for polynomial regression
plot(poly_regr_home)
plot(poly_regr_draw)
plot(poly_regr_away)

#compare linear and polynomial regression
plot(HOME_WIN_PERC ~ PPG_MATCH_RATING, data=train_data)
lines(train_data$PPG_MATCH_RATING, predict(regr_home), col="red")
lines(train_data$PPG_MATCH_RATING, predict(poly_regr_home), col="blue")

plot(DRAW_PERC ~ PPG_MATCH_RATING, data=train_data)
lines(train_data$PPG_MATCH_RATING, predict(regr_draw), col="red")
lines(train_data$PPG_MATCH_RATING, predict(poly_regr_draw), col="blue")

plot(AWAY_WIN_PERC ~ PPG_MATCH_RATING, data=train_data)
lines(train_data$PPG_MATCH_RATING, predict(regr_away), col="red")
lines(train_data$PPG_MATCH_RATING, predict(poly_regr_away), col="blue")


#detect outliers for regression home
cooksd <- cooks.distance(poly_regr_home)
plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance")  # plot cook's distance
abline(h = 2*mean(cooksd, na.rm=T), col="red")  # add cutoff line
text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>2*mean(cooksd, na.rm=T),names(cooksd),""), col="red")  # add labels

#detect outliers for regression draw
cooksd <- cooks.distance(poly_regr_draw)
plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance")  # plot cook's distance
abline(h = 2*mean(cooksd, na.rm=T), col="red")  # add cutoff line
text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>2*mean(cooksd, na.rm=T),names(cooksd),""), col="red")  # add labels

#detect outliers for regression awy
cooksd <- cooks.distance(poly_regr_away)
plot(cooksd, pch="*", cex=2, main="Influential Obs by Cooks distance")  # plot cook's distance
abline(h = 2*mean(cooksd, na.rm=T), col="red")  # add cutoff line
text(x=1:length(cooksd)+1, y=cooksd, labels=ifelse(cooksd>2*mean(cooksd, na.rm=T),names(cooksd),""), col="red")  # add labels

#delete outlier rows
train_data_wo_o_home <- train_data[c(-1,-2,-3,-4,-35,-36), ]
train_data_wo_o_draw <- train_data[c(-3,-32,-34), ]
train_data_wo_o_away <- train_data[c(-1,-2,-3,-35,-36), ]


#polynomial regression
poly_regr_home_wo_outl = lm(HOME_WIN_PERC ~ poly(PPG_MATCH_RATING,2), data=train_data_wo_o_home)
poly_regr_draw_wo_outl = lm(DRAW_PERC ~ poly(PPG_MATCH_RATING,2), data=train_data_wo_o_draw)
poly_regr_away_wo_outl = lm(AWAY_WIN_PERC ~ poly(PPG_MATCH_RATING,2), data=train_data_wo_o_away)


#summary of polynomial regression  
summary(poly_regr_home_wo_outl)
summary(poly_regr_draw_wo_outl)
summary(poly_regr_away_wo_outl)

#compare with and without outliers train_data_wo_o_home
plot(HOME_WIN_PERC ~ PPG_MATCH_RATING, data=train_data)
lines(train_data$PPG_MATCH_RATING, predict(poly_regr_home), col="red")
lines(train_data_wo_o_home$PPG_MATCH_RATING, predict(poly_regr_home_wo_outl), col="blue")

plot(DRAW_PERC ~ PPG_MATCH_RATING, data=train_data)
lines(train_data$PPG_MATCH_RATING, predict(poly_regr_draw), col="red")
lines(train_data_wo_o_draw$PPG_MATCH_RATING, predict(poly_regr_draw_wo_outl), col="blue")

plot(AWAY_WIN_PERC ~ PPG_MATCH_RATING, data=train_data)
lines(train_data$PPG_MATCH_RATING, predict(poly_regr_away), col="red")
lines(train_data_wo_o_away$PPG_MATCH_RATING, predict(poly_regr_away_wo_outl), col="blue")


