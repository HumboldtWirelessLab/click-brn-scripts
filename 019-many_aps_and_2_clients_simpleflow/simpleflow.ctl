#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
15	sk1 	ath0	write	sf	add_flow	sk1:eth 00:00:00:00:00:0f 1000 100 2 100 true
20	sk1 	ath0	write	sf	add_flow	sk1:eth 00:00:00:00:00:0f 1000 100 2 100 false
21	sk1	ath0	read	sf	stats
21	sk16	ath0	read	sf	stats
