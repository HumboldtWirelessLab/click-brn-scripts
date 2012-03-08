#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
15	sk1 	ath0	write	sf	add_flow	sk1:eth sk8:eth 1000 100 2 10000 true
20	sk1 	ath0	write	sf	add_flow	sk1:eth sk8:eth 1000 100 2 10000 false
21	sk1	ath0	read	sf	stats
21	sk8	ath0	read	sf	stats
