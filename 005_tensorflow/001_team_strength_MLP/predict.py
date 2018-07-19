import pyexasol
import scipy
import pandas
import tflearn


#Build connection
v_Con = pyexasol.connect(dsn='192.168.164.130:8563', user='sys', password = 'exasol', schema = 'SANDBOX', compression=True)

#read prediction data set
df_data = v_Con.export_to_pandas("""
select
    his.football_match_his_lid,
	str.home_attacking_strength,
	str.home_defence_strength,
	str.away_attacking_strength,
	str.away_defence_strength
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
	season.season in ('2017_2018')
                                    """)

#rebuild layers
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
model = tflearn.DNN(v_net)

#load saved weights
model.load('C:/Users/ado/Documents/betting db/099_dokumentation/Tensorflow/v01/trained_model/relu_adam_001.tf_model')

#prediction
prediction = model.predict(df_data[df_data.columns[1:5]])

#add predictions to data frame
df_data['PROB_HOME_WIN'] = prediction[:,0]
df_data['PROB_DRAW'] = prediction[:,1]
df_data['PROB_AWAY_WIN'] = prediction[:,2]

print(df_data.dtypes)
print(df_data.head())

#write predictions to db table
v_Con.import_from_pandas(df_data,'TEAM_STRENGTH_MLP')

#Close connection
v_Con.close()