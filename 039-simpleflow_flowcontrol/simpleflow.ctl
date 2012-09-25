#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
10	sk1 	ath0	write	sf	add_flow	sk1:eth sk2:eth 100 100 0 1600 true
18	sk1 	ath0	write	sf	add_flow	sk1:eth sk2:eth 100 100 0 1600 false
19	sk1	ath0	read	sf	stats
19	sk2	ath0	read	sf	stats
