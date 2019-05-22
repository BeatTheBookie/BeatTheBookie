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
  market_value_superiority,
                           round(sum(num_home_win) / count(*),4) perc_home_win,
                           round(sum(num_draw) / count(*),4) perc_draw,
                           round(sum(num_away_win) / count(*),4) perc_away_win
                           from
                           (
                           select
                           his.football_match_his_lid,
                           his.match_date,
                           his.home_team,
                           val_home.team_market_value,
                           his.away_team,
                           val_away.team_market_value,
                           round((val_home.team_market_value / 10000000),0) - round((val_away.team_market_value / 10000000),0) market_value_superiority,
                           case when stat.full_time_result = 'H' then 1 else 0 end num_home_win,
                           case when stat.full_time_result = 'D' then 1 else 0 end num_draw,
                           case when stat.full_time_result = 'A' then 1 else 0 end num_away_win
                           from
                           BETTING_DV.FOOTBALL_MATCH_HIS_B his
                           join BETTING_DV.FOOTBALL_MATCH_HIS_L_S_STATISTIC stat
                           on his.football_match_his_lid = stat.football_match_his_lid
                           join BETTING_DV.FOOTBALL_TEAM_H_S_MARKET_VALUES_SEASON_HIS val_home
                           on his.football_team_home_hid = val_home.football_team_hid and
                           his.match_date >= val_home.valid_from and
                           his.match_date < val_home.valid_to
                           join BETTING_DV.FOOTBALL_TEAM_H_S_MARKET_VALUES_SEASON_HIS val_away
                           on his.football_team_away_hid = val_away.football_team_hid and
                           his.match_date >= val_away.valid_from and
                           his.match_date < val_away.valid_to
                            where
                                --local.market_value_superiority >= -40 and
                                --local.market_value_superiority <= 40 and
                                his.season <> '2018_2019'
                           )
                           group by
                           1
                           order by
                           1
")





#load prediction data
pred_data = exa.readData(con,"
select
    his.football_match_his_lid,
                         round((val_home.team_market_value / 10000000),0) - round((val_away.team_market_value / 10000000),0) market_value_superiority
                         from
                         BETTING_DV.FOOTBALL_MATCH_HIS_B his
                         join BETTING_DV.FOOTBALL_MATCH_HIS_L_S_STATISTIC stat
                         on his.football_match_his_lid = stat.football_match_his_lid
                         join BETTING_DV.FOOTBALL_TEAM_H_S_MARKET_VALUES_SEASON_HIS val_home
                         on his.football_team_home_hid = val_home.football_team_hid and
                         his.match_date >= val_home.valid_from and
                         his.match_date < val_home.valid_to
                         join BETTING_DV.FOOTBALL_TEAM_H_S_MARKET_VALUES_SEASON_HIS val_away
                         on his.football_team_away_hid = val_away.football_team_hid and
                         his.match_date >= val_away.valid_from and
                         his.match_date < val_away.valid_to
                         where
                         season = '2018_2019'
")



#correlations test
with(train_data,cor(MARKET_VALUE_SUPERIORITY,PERC_HOME_WIN))
with(train_data,cor(MARKET_VALUE_SUPERIORITY,PERC_DRAW))
with(train_data,cor(MARKET_VALUE_SUPERIORITY,PERC_AWAY_WIN))

#plot distribution
plot(train_data$MARKET_VALUE_SUPERIORITY,train_data$PERC_HOME_WIN, xlab = "Market value superiority", ylab = "Home win percentage", col = "dark blue", pch = 22)
plot(train_data$MARKET_VALUE_SUPERIORITY,train_data$PERC_DRAW, xlab = "Market value superiority", ylab = "Draw percentage", col = "dark blue", pch = 22)
plot(train_data$MARKET_VALUE_SUPERIORITY,train_data$PERC_AWAY_WIN, xlab = "Market value superiority", ylab = "Away win percentage", col = "dark blue", pch = 22)

#linear regression
regr_home = lm(PERC_HOME_WIN ~ MARKET_VALUE_SUPERIORITY, data=train_data)
regr_draw = lm(PERC_DRAW ~ MARKET_VALUE_SUPERIORITY, data=train_data)
regr_away = lm(PERC_AWAY_WIN ~ MARKET_VALUE_SUPERIORITY, data=train_data)

#summary of linear regression
summary(regr_home)
summary(regr_draw)
summary(regr_away)

#linear regression diagnostic plots
plot(regr_home)
plot(regr_draw)
plot(regr_away)

#polynomial regression
poly_regr_home = lm(PERC_HOME_WIN ~ poly(MARKET_VALUE_SUPERIORITY,2), data=train_data)
poly_regr_draw = lm(PERC_DRAW ~ poly(MARKET_VALUE_SUPERIORITY,2), data=train_data)
poly_regr_away = lm(PERC_AWAY_WIN ~ poly(MARKET_VALUE_SUPERIORITY,2), data=train_data)

#summary of polynomial regression  
summary(poly_regr_home)
summary(poly_regr_draw)
summary(poly_regr_away)

#analytic plots for polynomial regression
plot(poly_regr_home)
plot(poly_regr_draw)
plot(poly_regr_away)

#compare linear and polynomial regression
plot(PERC_HOME_WIN ~ MARKET_VALUE_SUPERIORITY, data=train_data)
lines(train_data$MARKET_VALUE_SUPERIORITY, predict(regr_home), col="red")
lines(train_data$MARKET_VALUE_SUPERIORITY, predict(poly_regr_home), col="blue")

plot(PERC_DRAW ~ MARKET_VALUE_SUPERIORITY, data=train_data)
lines(train_data$MARKET_VALUE_SUPERIORITY, predict(regr_draw), col="red")
lines(train_data$MARKET_VALUE_SUPERIORITY, predict(poly_regr_draw), col="blue")

plot(PERC_AWAY_WIN ~ MARKET_VALUE_SUPERIORITY, data=train_data)
lines(train_data$MARKET_VALUE_SUPERIORITY, predict(regr_away), col="red")
lines(train_data$MARKET_VALUE_SUPERIORITY, predict(poly_regr_away), col="blue")

#cooks distance
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
EXAWriteTable(con = con, schema = 'SANDBOX', tbl_name = 'FOOTBALL_MATCH_HIS_L_S_MARKET_VALUE_SUPERIORITY_PROBS',
              overwrite = 'TRUE', data = pred_data)


