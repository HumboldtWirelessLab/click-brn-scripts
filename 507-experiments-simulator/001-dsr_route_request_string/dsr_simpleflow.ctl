#TIME	NODE(S)		DEVICE	MODE	ELEMENT	HANDLER		VALUE
200	FIRSTNODE 	ath0	write	sf	add_flow	FIRSTNODE:eth LASTNODE:eth 2000 100 2 6000 true
218	FIRSTNODE 	ath0	write	sf	add_flow	FIRSTNODE:eth LASTNODE:eth 2000 100 2 6000 false
229	FIRSTNODE	ath0	read	sf	stats
229	LASTNODE	ath0	read	sf	stats
