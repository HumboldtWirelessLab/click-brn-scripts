#TIME	NODE(S)		DEVICE	MODE	ELEMENT	HANDLER		VALUE
200	FIRSTNODE	ath0	write	sf	add_flow	FIRSTNODE:eth LASTNODE:eth 1000 100 2 18000 true
219	FIRSTNODE	ath0	read	sf	stats
219	LASTNODE	ath0	read	sf	stats
