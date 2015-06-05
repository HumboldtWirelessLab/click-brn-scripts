#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
10	node1 	ath0	write	sf	add_flow	node1:eth node2:eth 100 100 0 1600 true
18	node1 	ath0	write	sf	add_flow	node1:eth node2:eth 100 100 0 1600 false
19	node1	ath0	read	sf	stats
19	node2	ath0	read	sf	stats
