	############################################
# Odds prediction
# - GS & PPG match rating
# - regression models:
#   - linear, polynomial, polynomial w/o outliers
#
###########################################

#load packages
library(exasol)
library(MASS)
library(rlm)


#conect to exasol
con <- dbConnect("exa", exahost = "192.168.164.130:8563",
                 uid = "sys", pwd = "exasol", schema = "betting_dv")


#load matchday data				 
matchday_data <- exa.readData(con, "			 
select
	division,
	season,
	played + 1 matchday,
	min(match_date) matchday_start,
	max(match_date) matchday_end
from
	(
	select
		division.division,
		season.season,
		table_l.match_date,
		min(table_s.played) played
	from
		betting_dv.FOOTBALL_DIVISION_TABLE_L table_l
		join betting_dv.FOOTBALL_DIVISION_TABLE_L_S	table_s
			on table_l.FOOTBALL_DIVISION_TABLE_LID = table_s.FOOTBALL_DIVISION_TABLE_LID
		join betting_dv.football_division_h division
			on table_l.football_division_hid = division.football_division_hid
		join betting_dv.football_season_h season
			on table_l.football_season_hid = season.football_season_hid
	where
		division.division = 'D1' and
		season.season >= '2012_2013'
	group by
		division.division,
		season.season,
		table_l.match_date	
	)
group by
	division,
	season,
	played 
order by
	1,2,3				 
")



for (row in 1:nrow(matchday_data)) {
	season <- matchday_data[row, "SEASON"]
	matchday <- matchday_data[row, "MATCHDAY"]

	print(paste("Running season", season, ", matchday", matchday))

	if(matchday %in% c(1,5,10,15,20,25,30)) {
		print(paste("-Rebuilding models at matchday", matchday))

		print("--Loading train data")
		
		#build sql
		gs.train_sql <- paste("
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
										season.season,
										rank() over (partition by season order by season) season_rang,
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
										his.match_date < to_date('",matchday_data[row, "MATCHDAY_START"],"','yyyy-mm-dd')
									)
								where
									season_rang <= 6
								)
							order by
							1
							", sub="")
								   
		ppg.train_sql <- paste("
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
										season.season,
										rank() over (partition by season order by season) season_rang,
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
										his.match_date < to_date('",matchday_data[row, "MATCHDAY_START"],"','yyyy-mm-dd')
									)
								where
									season_rang <= 6
								)
							order by
							1
							", sub="")				
								   
		#load train data						   
		gs.train_data = exa.readData(con,gs.train_sql)
		ppg.train_data = exa.readData(con,ppg.train_sql)
		
				
		#linear regression
		print("--Building linear regression")
		
		gs.lin_regr_home = lm(HOME_WIN_PERC ~ GS_MATCH_RATING, data=gs.train_data)
		gs.lin_regr_draw = lm(DRAW_PERC ~ GS_MATCH_RATING, data=gs.train_data)
		gs.lin_regr_away = lm(AWAY_WIN_PERC ~ GS_MATCH_RATING, data=gs.train_data)
		
		ppg.lin_regr_home = lm(HOME_WIN_PERC ~ PPG_MATCH_RATING, data=ppg.train_data)
		ppg.lin_regr_draw = lm(DRAW_PERC ~ PPG_MATCH_RATING, data=ppg.train_data)
		ppg.lin_regr_away = lm(AWAY_WIN_PERC ~ PPG_MATCH_RATING, data=ppg.train_data)
		
		#polynomial regression
		print("--Building polynomial regression")
		
		gs.poly_regr_home = lm(HOME_WIN_PERC ~ poly(GS_MATCH_RATING,2), data=gs.train_data)
		gs.poly_regr_draw = lm(DRAW_PERC ~ poly(GS_MATCH_RATING,2), data=gs.train_data)
		gs.poly_regr_away = lm(AWAY_WIN_PERC ~ poly(GS_MATCH_RATING,2), data=gs.train_data)
		
		ppg.poly_regr_home = lm(HOME_WIN_PERC ~ poly(PPG_MATCH_RATING,2), data=ppg.train_data)
		ppg.poly_regr_draw = lm(DRAW_PERC ~ poly(PPG_MATCH_RATING,2), data=ppg.train_data)
		ppg.poly_regr_away = lm(AWAY_WIN_PERC ~ poly(PPG_MATCH_RATING,2), data=ppg.train_data)
		
		#calculating cooks distance
		print("--Detecting outliers")
		
		gs.cooksd_home <- cooks.distance(gs.poly_regr_home)
		gs.cooksd_draw <- cooks.distance(gs.poly_regr_draw)
		gs.cooksd_away <- cooks.distance(gs.poly_regr_away)
		
		ppg.cooksd_home <- cooks.distance(ppg.poly_regr_home)
		ppg.cooksd_draw <- cooks.distance(ppg.poly_regr_draw)
		ppg.cooksd_away <- cooks.distance(ppg.poly_regr_away)
		
		print("--Building polynomial regression wo. outliers")
		
		#build new train data frames without outliers
		gs.train_data.woo_home <- gs.train_data[-as.numeric(names(gs.cooksd_home[(gs.cooksd_home>2*mean(gs.cooksd_home, na.rm=T))])),]
		gs.train_data.woo_draw <- gs.train_data[-as.numeric(names(gs.cooksd_draw[(gs.cooksd_draw>2*mean(gs.cooksd_draw, na.rm=T))])),]
		gs.train_data.woo_away <- gs.train_data[-as.numeric(names(gs.cooksd_away[(gs.cooksd_away>2*mean(gs.cooksd_away, na.rm=T))])),]
		
		ppg.train_data.woo_home <- ppg.train_data[-as.numeric(names(ppg.cooksd_home[(ppg.cooksd_home>2*mean(ppg.cooksd_home, na.rm=T))])),]
		ppg.train_data.woo_draw <- ppg.train_data[-as.numeric(names(ppg.cooksd_draw[(ppg.cooksd_draw>2*mean(ppg.cooksd_draw, na.rm=T))])),]
		ppg.train_data.woo_away <- ppg.train_data[-as.numeric(names(ppg.cooksd_away[(ppg.cooksd_away>2*mean(ppg.cooksd_away, na.rm=T))])),]
		
		#polynomial regression without outliers
		gs.poly_regr_home_woo = lm(HOME_WIN_PERC ~ poly(GS_MATCH_RATING,2), data=gs.train_data.woo_home)
		gs.poly_regr_draw_woo = lm(DRAW_PERC ~ poly(GS_MATCH_RATING,2), data=gs.train_data.woo_draw)
		gs.poly_regr_away_woo = lm(AWAY_WIN_PERC ~ poly(GS_MATCH_RATING,2), data=gs.train_data.woo_away)
		
		ppg.poly_regr_home_woo = lm(HOME_WIN_PERC ~ poly(PPG_MATCH_RATING,2), data=ppg.train_data.woo_home)
		ppg.poly_regr_draw_woo = lm(DRAW_PERC ~ poly(PPG_MATCH_RATING,2), data=ppg.train_data.woo_draw)
		ppg.poly_regr_away_woo = lm(AWAY_WIN_PERC ~ poly(PPG_MATCH_RATING,2), data=ppg.train_data.woo_away)
		
	}
  
	print(paste("-Predicting probabilities for matchday", matchday))
	
	print("--Loading prediction data")
  
	#build sql
	gs.pred_sql <- paste(" 
					select
						his.football_match_his_lid,
						rating.gs_match_rating
					from
						betting_dv.football_match_his_l his
						join betting_dv.football_match_his_l_s_statistic stat
							on (his.football_match_his_lid = stat.football_match_his_lid)
						join betting_dv.football_match_his_l_s_rating_features_7 rating
							on (his.football_match_his_lid = rating.football_match_his_lid)
						join betting_dv.football_division_h division
							on (his.football_division_hid = division.football_division_hid)
						join betting_dv.football_team_h home
							on (his.football_team_home_hid = home.football_team_hid)
						join betting_dv.football_team_h away
							on (his.football_team_away_hid = away.football_team_hid)
					where
						division.division = 'D1'
						and his.match_date >= to_date('",matchday_data[row, "MATCHDAY_START"],"','yyyy-mm-dd')
						and his.match_date <= to_date('",matchday_data[row, "MATCHDAY_END"],"','yyyy-mm-dd')
				", sub="")
	
	
	ppg.pred_sql <- paste(" 
					select
						his.football_match_his_lid,
						round(rating.ppg_match_rating,3) ppg_match_rating
					from
						betting_dv.football_match_his_l his
						join betting_dv.football_match_his_l_s_statistic stat
							on (his.football_match_his_lid = stat.football_match_his_lid)
						join betting_dv.football_match_his_l_s_rating_features_7 rating
							on (his.football_match_his_lid = rating.football_match_his_lid)
						join betting_dv.football_division_h division
							on (his.football_division_hid = division.football_division_hid)
						join betting_dv.football_team_h home
							on (his.football_team_home_hid = home.football_team_hid)
						join betting_dv.football_team_h away
							on (his.football_team_away_hid = away.football_team_hid)
					where
						division.division = 'D1'
						and his.match_date >= to_date('",matchday_data[row, "MATCHDAY_START"],"','yyyy-mm-dd')
						and his.match_date <= to_date('",matchday_data[row, "MATCHDAY_END"],"','yyyy-mm-dd')
					", sub="")
	
	#load pred data
	gs.pred_data = exa.readData(con,gs.pred_sql)
	ppg.pred_data = exa.readData(con,ppg.pred_sql)
	
	#linear regression prediction
	print("--Predict linear regression")
	gs.lin_pred_data <- gs.pred_data
	gs.lin_pred_data$PROB_HOME_WIN <- predict(gs.lin_regr_home, gs.lin_pred_data)
	gs.lin_pred_data$PROB_DRAW <- predict(gs.lin_regr_draw, gs.lin_pred_data)
	gs.lin_pred_data$PROB_AWAY_WIN <- predict(gs.lin_regr_away, gs.lin_pred_data)
	
	ppg.lin_pred_data <- ppg.pred_data
	ppg.lin_pred_data$PROB_HOME_WIN <- predict(ppg.lin_regr_home, ppg.lin_pred_data)
	ppg.lin_pred_data$PROB_DRAW <- predict(ppg.lin_regr_draw, ppg.lin_pred_data)
	ppg.lin_pred_data$PROB_AWAY_WIN <- predict(ppg.lin_regr_away, ppg.lin_pred_data)
	
	#polynomial regression prediction
	print("--Predict polynomial regression")
	gs.poly_pred_data <- gs.pred_data
	gs.poly_pred_data$PROB_HOME_WIN <- predict(gs.poly_regr_home, gs.poly_pred_data)
	gs.poly_pred_data$PROB_DRAW <- predict(gs.poly_regr_draw, gs.poly_pred_data)
	gs.poly_pred_data$PROB_AWAY_WIN <- predict(gs.poly_regr_away, gs.poly_pred_data)
	
	ppg.poly_pred_data <- ppg.pred_data
	ppg.poly_pred_data$PROB_HOME_WIN <- predict(ppg.poly_regr_home, ppg.poly_pred_data)
	ppg.poly_pred_data$PROB_DRAW <- predict(ppg.poly_regr_draw, ppg.poly_pred_data)
	ppg.poly_pred_data$PROB_AWAY_WIN <- predict(ppg.poly_regr_away, ppg.poly_pred_data)

	#polynomial (wo outliers) regression prediction
	print("--Predict polynomial regression wo outliers")
	gs.poly_woo_pred_data <- gs.pred_data
	gs.poly_woo_pred_data$PROB_HOME_WIN <- predict(gs.poly_regr_home_woo, gs.poly_woo_pred_data)
	gs.poly_woo_pred_data$PROB_DRAW <- predict(gs.poly_regr_draw_woo, gs.poly_woo_pred_data)
	gs.poly_woo_pred_data$PROB_AWAY_WIN <- predict(gs.poly_regr_away_woo, gs.poly_woo_pred_data)
	
	ppg.poly_woo_pred_data <- ppg.pred_data
	ppg.poly_woo_pred_data$PROB_HOME_WIN <- predict(ppg.poly_regr_home_woo, ppg.poly_woo_pred_data)
	ppg.poly_woo_pred_data$PROB_DRAW <- predict(ppg.poly_regr_draw_woo, ppg.poly_woo_pred_data)
	ppg.poly_woo_pred_data$PROB_AWAY_WIN <- predict(ppg.poly_regr_away_woo, ppg.poly_woo_pred_data)
		
	#correct probabilities
	print("--Correct probabilities")
	#check sum
	gs.lin_pred_data$CHECK_SUM <- gs.lin_pred_data$PROB_HOME_WIN + gs.lin_pred_data$PROB_DRAW + gs.lin_pred_data$PROB_AWAY_WIN 
	ppg.lin_pred_data$CHECK_SUM <- ppg.lin_pred_data$PROB_HOME_WIN + ppg.lin_pred_data$PROB_DRAW + ppg.lin_pred_data$PROB_AWAY_WIN
	gs.poly_pred_data$CHECK_SUM <- gs.poly_pred_data$PROB_HOME_WIN + gs.poly_pred_data$PROB_DRAW + gs.poly_pred_data$PROB_AWAY_WIN 
	ppg.poly_pred_data$CHECK_SUM <- ppg.poly_pred_data$PROB_HOME_WIN + ppg.poly_pred_data$PROB_DRAW + ppg.poly_pred_data$PROB_AWAY_WIN
	gs.poly_woo_pred_data$CHECK_SUM <- gs.poly_woo_pred_data$PROB_HOME_WIN + gs.poly_woo_pred_data$PROB_DRAW + gs.poly_woo_pred_data$PROB_AWAY_WIN 
	ppg.poly_woo_pred_data$CHECK_SUM <- ppg.poly_woo_pred_data$PROB_HOME_WIN + ppg.poly_woo_pred_data$PROB_DRAW + ppg.poly_woo_pred_data$PROB_AWAY_WIN
	
	#adapt probabilities proportional
	gs.lin_pred_data$COR_PROB_HOME_WIN <- gs.lin_pred_data$PROB_HOME_WIN / gs.lin_pred_data$CHECK_SUM
	gs.lin_pred_data$COR_PROB_DRAW <- gs.lin_pred_data$PROB_DRAW / gs.lin_pred_data$CHECK_SUM
	gs.lin_pred_data$COR_PROB_AWAY_WIN <- gs.lin_pred_data$PROB_AWAY_WIN / gs.lin_pred_data$CHECK_SUM
	
	ppg.lin_pred_data$COR_PROB_HOME_WIN <- ppg.lin_pred_data$PROB_HOME_WIN / ppg.lin_pred_data$CHECK_SUM
	ppg.lin_pred_data$COR_PROB_DRAW <- ppg.lin_pred_data$PROB_DRAW / ppg.lin_pred_data$CHECK_SUM
	ppg.lin_pred_data$COR_PROB_AWAY_WIN <- ppg.lin_pred_data$PROB_AWAY_WIN / ppg.lin_pred_data$CHECK_SUM
	
	gs.poly_pred_data$COR_PROB_HOME_WIN <- gs.poly_pred_data$PROB_HOME_WIN / gs.poly_pred_data$CHECK_SUM
	gs.poly_pred_data$COR_PROB_DRAW <- gs.poly_pred_data$PROB_DRAW / gs.poly_pred_data$CHECK_SUM
	gs.poly_pred_data$COR_PROB_AWAY_WIN <- gs.poly_pred_data$PROB_AWAY_WIN / gs.poly_pred_data$CHECK_SUM
	
	ppg.poly_pred_data$COR_PROB_HOME_WIN <- ppg.poly_pred_data$PROB_HOME_WIN / ppg.poly_pred_data$CHECK_SUM
	ppg.poly_pred_data$COR_PROB_DRAW <- ppg.poly_pred_data$PROB_DRAW / ppg.poly_pred_data$CHECK_SUM
	ppg.poly_pred_data$COR_PROB_AWAY_WIN <- ppg.poly_pred_data$PROB_AWAY_WIN / ppg.poly_pred_data$CHECK_SUM

	gs.poly_woo_pred_data$COR_PROB_HOME_WIN <- gs.poly_woo_pred_data$PROB_HOME_WIN / gs.poly_woo_pred_data$CHECK_SUM
	gs.poly_woo_pred_data$COR_PROB_DRAW <- gs.poly_woo_pred_data$PROB_DRAW / gs.poly_woo_pred_data$CHECK_SUM
	gs.poly_woo_pred_data$COR_PROB_AWAY_WIN <- gs.poly_woo_pred_data$PROB_AWAY_WIN / gs.poly_woo_pred_data$CHECK_SUM
	
	ppg.poly_woo_pred_data$COR_PROB_HOME_WIN <- ppg.poly_woo_pred_data$PROB_HOME_WIN / ppg.poly_woo_pred_data$CHECK_SUM
	ppg.poly_woo_pred_data$COR_PROB_DRAW <- ppg.poly_woo_pred_data$PROB_DRAW / ppg.poly_woo_pred_data$CHECK_SUM
	ppg.poly_woo_pred_data$COR_PROB_AWAY_WIN <- ppg.poly_woo_pred_data$PROB_AWAY_WIN / ppg.poly_woo_pred_data$CHECK_SUM
  
	#check sum 2
	gs.lin_pred_data$COR_CHECK_SUM <- gs.lin_pred_data$COR_PROB_HOME_WIN + gs.lin_pred_data$COR_PROB_DRAW + gs.lin_pred_data$COR_PROB_AWAY_WIN 
	ppg.lin_pred_data$COR_CHECK_SUM <- ppg.lin_pred_data$COR_PROB_HOME_WIN + ppg.lin_pred_data$COR_PROB_DRAW + ppg.lin_pred_data$COR_PROB_AWAY_WIN
	gs.poly_pred_data$COR_CHECK_SUM <- gs.poly_pred_data$COR_PROB_HOME_WIN + gs.poly_pred_data$COR_PROB_DRAW + gs.poly_pred_data$COR_PROB_AWAY_WIN 
	ppg.poly_pred_data$COR_CHECK_SUM <- ppg.poly_pred_data$COR_PROB_HOME_WIN + ppg.poly_pred_data$COR_PROB_DRAW + ppg.poly_pred_data$COR_PROB_AWAY_WIN
	gs.poly_woo_pred_data$COR_CHECK_SUM <- gs.poly_woo_pred_data$COR_PROB_HOME_WIN + gs.poly_woo_pred_data$COR_PROB_DRAW + gs.poly_woo_pred_data$COR_PROB_AWAY_WIN 
	ppg.poly_woo_pred_data$COR_CHECK_SUM <- ppg.poly_woo_pred_data$COR_PROB_HOME_WIN + ppg.poly_woo_pred_data$COR_PROB_DRAW + ppg.poly_woo_pred_data$COR_PROB_AWAY_WIN
  
	#merge regression results in prediction data frames
	#gs match rating
	gs.pred_data$LIN_REGR_PROB_HOME_WIN <- gs.lin_pred_data$COR_PROB_HOME_WIN
	gs.pred_data$LIN_REGR_PROB_DRAW     <- gs.lin_pred_data$COR_PROB_DRAW 
	gs.pred_data$LIN_REGR_PROB_AWAY_WIN <- gs.lin_pred_data$COR_PROB_AWAY_WIN
	  
	gs.pred_data$POLY_REGR_PROB_HOME_WIN <- gs.poly_pred_data$COR_PROB_HOME_WIN
	gs.pred_data$POLY_REGR_PROB_DRAW     <- gs.poly_pred_data$COR_PROB_DRAW
	gs.pred_data$POLY_REGR_PROB_AWAY_WIN <- gs.poly_pred_data$COR_PROB_AWAY_WIN
	
	gs.pred_data$POLY_REGR_WOO_PROB_HOME_WIN <- gs.poly_woo_pred_data$COR_PROB_HOME_WIN
	gs.pred_data$POLY_REGR_WOO_PROB_DRAW     <- gs.poly_woo_pred_data$COR_PROB_DRAW
	gs.pred_data$POLY_REGR_WOO_PROB_AWAY_WIN <- gs.poly_woo_pred_data$COR_PROB_AWAY_WIN
	
	#ppg match rating
	ppg.pred_data$LIN_REGR_PROB_HOME_WIN <- ppg.lin_pred_data$COR_PROB_HOME_WIN
	ppg.pred_data$LIN_REGR_PROB_DRAW     <- ppg.lin_pred_data$COR_PROB_DRAW 
	ppg.pred_data$LIN_REGR_PROB_AWAY_WIN <- ppg.lin_pred_data$COR_PROB_AWAY_WIN
	
	ppg.pred_data$POLY_REGR_PROB_HOME_WIN <- ppg.poly_pred_data$COR_PROB_HOME_WIN
	ppg.pred_data$POLY_REGR_PROB_DRAW     <- ppg.poly_pred_data$COR_PROB_DRAW
	ppg.pred_data$POLY_REGR_PROB_AWAY_WIN <- ppg.poly_pred_data$COR_PROB_AWAY_WIN
	
	ppg.pred_data$POLY_REGR_WOO_PROB_HOME_WIN <- ppg.poly_woo_pred_data$COR_PROB_HOME_WIN
	ppg.pred_data$POLY_REGR_WOO_PROB_DRAW     <- ppg.poly_woo_pred_data$COR_PROB_DRAW
	ppg.pred_data$POLY_REGR_WOO_PROB_AWAY_WIN <- ppg.poly_woo_pred_data$COR_PROB_AWAY_WIN
	
	print("--Writing predicted probs to sandbox")
	
	#for first prediction target table has to be created
	if (row == 1) {
	
		#write to target table
		EXAWriteTable(con = con, schema = 'SANDBOX', tbl_name = 'FOOTBALL_MATCH_HIS_L_S_GS_RATING_PROBS',	             overwrite = 'TRUE', data = gs.pred_data)
		EXAWriteTable(con = con, schema = 'SANDBOX', tbl_name = 'FOOTBALL_MATCH_HIS_L_S_PPG_RATING_PROBS',                overwrite = 'TRUE', data = ppg.pred_data)	  
	
	} else {
	
		#any futher predictions are just added
		EXAWriteTable(con = con, schema = 'SANDBOX', tbl_name = 'FOOTBALL_MATCH_HIS_L_S_GS_RATING_PROBS',	                overwrite = 'FALSE', data = gs.pred_data)
	    EXAWriteTable(con = con, schema = 'SANDBOX', tbl_name = 'FOOTBALL_MATCH_HIS_L_S_PPG_RATING_PROBS',overwrite = 'FALSE', data = ppg.pred_data)	
	  
	}
		
}
  

