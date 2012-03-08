#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
10	sk110 	ath0	write	sf	add_flow	sk110:eth sk111:eth 300 100 2 8000 true
18	sk110 	ath0	write	sf	add_flow	sk110:eth sk111:eth 300 100 2 8000 false
19	sk110	ath0	read	sf	stats
19	sk111	ath0	read	sf	stats
