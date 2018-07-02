import pyexasol
import scipy
import pandas
from sklearn.model_selection import train_test_split
import tflearn


#Build connection
v_Con = pyexasol.connect(dsn='[IP]:8563', user='[username]', password = '[password]', schema = 'BETTING_DV', compression=True)

#read train data
df_data = v_Con.export_to_pandas("""
select
	str.home_attacking_strength,
	str.home_defence_strength,
	str.away_attacking_strength,
	str.away_defence_strength,
    case when stat.full_time_result = 'H' then 1 else 0 end home_win,
    case when stat.full_time_result = 'D' then 1 else 0 end draw,
    case when stat.full_time_result = 'A' then 1 else 0 end away_win
from
	betting_dv.football_match_his_l his
	join betting_dv.football_match_his_l_s_statistic stat
		on his.football_match_his_lid = stat.football_match_his_lid
	join betting_dv.football_match_his_l_s_attack_defence_strength_30 str
		on his.football_match_his_lid = str.football_match_his_lid
	join betting_dv.football_division_h division
		on his.football_division_hid = division.football_division_hid
	join betting_dv.football_season_h season
		on his.football_season_hid = season.football_season_hid
	join betting_dv.football_team_h home
		on his.football_team_home_hid = home.football_team_hid
	join betting_dv.football_team_h away
		on his.football_team_away_hid = away.football_team_hid
where
	division.division = 'D1' and
	season.season in ('2016_2017','2015_2016','2014_2015','2013_2014','2012_2013','2011_2012','2010_2011')
                                    """)

#Close connection
v_Con.close()

#split predictors and outcome
df_x = df_data[df_data.columns[0:4]]
df_y = df_data[df_data.columns[4:7]]

print(df_x.head())
print(df_y.head())

#split train and validation data set
df_x_train, df_x_val, df_y_train, df_y_val = train_test_split(df_x, df_y, test_size=0.1, random_state=41)



#build layers
#input layer 4 inputs
#3 hidden layers each 30 neurons
#output layer 3 outputs
v_net = tflearn.input_data(shape=[None, 4], name="InputLayer")

v_net = tflearn.fully_connected(v_net, 10, activation="relu", bias=False,
                                    weights_init="truncated_normal",
                                    bias_init="zeros",
                                    trainable=True,
                                    restore=True,
                                    reuse=False,
                                    scope=None,
                                    name="FullyConnectedLayer_relu")

v_net = tflearn.fully_connected(v_net, 3,
                              activation="softmax",
                              name="OutputLayer")

v_net = tflearn.regression(v_net,
                            optimizer=tflearn.Adam(learning_rate=0.01, epsilon=0.01),
                            metric=tflearn.metrics.accuracy(),
                            loss="categorical_crossentropy"
                            )

#define model
model = tflearn.DNN(v_net,
                        tensorboard_dir='c:/temp/tensorflow/output/logs/',
                        best_val_accuracy=0.50,
                        best_checkpoint_path='c:/temp/tensorflow/output/ckpt/',
                        tensorboard_verbose=0)



#train model
model.fit(df_x_train.values, df_y_train.values,
            n_epoch=500,
            batch_size=10,
            show_metric=True,
            validation_set=(df_x_val.values,df_y_val.values),
            shuffle=None,
            snapshot_step=100,
            snapshot_epoch=False,
            run_id = 'relu_adam_001')


#save the model
model.save('C:/Users/ado/Documents/betting db/099_dokumentation/Tensorflow/v01/relu_adam_001.tf_model')
