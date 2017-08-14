#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
200	node16 	DEV0	write	sf	add_flow	node16:eth node1:eth 1000 100 2 100 true
218	node16 	DEV0	write	sf	add_flow	node16:eth node1:eth 1000 100 2 100 false
219	node16	DEV0	read	sf	stats
219	node1	DEV0	read	sf	stats
