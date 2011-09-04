#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
200	sk1 	ath0	write	sf	add_flow	sk1:eth sk49:eth 1000 100 2 100 true
218	sk1 	ath0	write	sf	add_flow	sk1:eth sk49:eth 1000 100 2 100 false
219	sk1	ath0	read	sf	stats
219	sk49	ath0	read	sf	stats
