#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
1	sk1 	ath0	write	sf	add_flow	sk1:eth sk16:eth 1000 100 2 100 true
12	sk1 	ath0	write	sf	add_flow	sk1:eth sk16:eth 1000 100 2 100 false
19	sk1	ath0	read	sf	stats
19	sk16	ath0	read	sf	stats
