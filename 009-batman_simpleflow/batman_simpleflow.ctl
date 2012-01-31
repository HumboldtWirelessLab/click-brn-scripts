#TIME	NODE(S)		DEVICE	MODE	ELEMENT	HANDLER		VALUE
200	sk1 		ath0	write	sf	add_flow	sk1:eth LASTNODE:eth 1000 100 2 18000 true
218	sk1 		ath0	write	sf	add_flow	sk1:eth LASTNODE:eth 1000 100 2 18000 false
219	sk1		ath0	read	sf	stats
219	LASTNODE	ath0	read	sf	stats
