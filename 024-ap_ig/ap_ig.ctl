#TIME	NODE(S)	DEVICE	MODE	ELEMENT	       HANDLER		VALUE
5	sk1	ath0 	write   device_wifi/qc flow_insert      1000 2000 1500 1
8	sk1	ath0    read	device_wifi/qc flow_stats
9	sk2	ath0 	write   device_wifi/qc flow_insert      1000 2000 1500 1
12	sk2	ath0    read	device_wifi/qc flow_stats
13	sk1	ath0 	write   device_wifi/qc flow_insert      1000 2000 1500 1
13	sk2	ath0 	write   device_wifi/qc flow_insert      1000 2000 1500 1
16	sk1	ath0    read	device_wifi/qc flow_stats
16	sk2	ath0    read	device_wifi/qc flow_stats
	       