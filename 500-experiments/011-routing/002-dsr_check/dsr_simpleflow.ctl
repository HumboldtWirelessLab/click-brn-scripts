#TIME	NODE(S)		DEVICE	MODE	ELEMENT	HANDLER		VALUE
100	FIRSTNODE 	ath0	write	sf	add_flow	FIRSTNODE:eth LASTNODE:eth 500 100 2 15000 true
118	FIRSTNODE 	ath0	write	sf	add_flow	FIRSTNODE:eth LASTNODE:eth 500 100 2 15000 false
129	FIRSTNODE	ath0	read	sf	stats
129	LASTNODE	ath0	read	sf	stats