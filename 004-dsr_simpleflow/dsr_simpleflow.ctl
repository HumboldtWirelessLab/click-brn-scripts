#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
100	sk1 	ath0	write	sf	add_flow	sk1:eth sk100:eth 1000 100 2 100 true
118	sk1 	ath0	write	sf	add_flow	sk1:eth sk100:eth 1000 100 2 100 false
119	sk1	ath0	read	sf	stats
119	sk100	ath0	read	sf	stats
