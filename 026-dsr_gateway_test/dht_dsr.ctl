#TIME	NODE(S)		DEVICE	MODE	ELEMENT		HANDLER		VALUE
50	LASTNODE	ath0	write	brngw/gateway	add_gateway	100 192.168.0.2 false
60	LASTNODE	ath0	read	brngw/gateway	known_gateways
60	FIRSTNODE	ath0	read	brngw/gateway	known_gateways
60	FIRSTNODE	ath0	write	sf		add_flow	FIRSTNODE:eth LASTNODE:eth 1000 100 2 100 true		1
95	LASTNODE	ath0	read	mirror_cnt	count
95	FIRSTNODE	ath0	read	sf		stats
95	FIRSTNODE	ath0	read	sf_dst		stats
