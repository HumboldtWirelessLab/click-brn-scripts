#TIME	NODE(S)		DEVICE	MODE	ELEMENT		HANDLER		VALUE
50	LASTNODE	ath0	write	brngw/gateway	add_gateway	100 192.168.0.2 false
70	LASTNODE	ath0	read	brngw/gateway	known_gateways
70	FIRSTNODE	ath0	read	brngw/gateway	known_gateways
70	FIRSTNODE	ath0	write	sf		add_flow	FIRSTNODE:eth LASTNODE:eth 1000 100 2 35000 true		1
105	LASTNODE	ath0	read	mirror_cnt	count
105	FIRSTNODE	ath0	read	sf		stats
105	FIRSTNODE	ath0	read	sf_dst		stats
#105	LASTNODE	ath0	read	brngw/gateway	known_gateways
#105	FIRSTNODE	ath0	read	brngw/gateway	known_gateways
