#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
200	sk1 	ath0	write	sf	add_flow	sk1:eth sk16:eth 100 100 2 100 true
218	sk1 	ath0	write	sf	add_flow	sk1:eth sk16:eth 100 100 2 100 false
229	sk1	ath0	read	sf	stats
229	sk16	ath0	read	sf	stats
