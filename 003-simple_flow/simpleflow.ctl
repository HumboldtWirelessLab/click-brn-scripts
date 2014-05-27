#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
#5	sk110 	ath0	write	sf	add_flow	sk110:eth FF-FF-FF-FF-FF-FF 0  1501 0 1000 true 4 0
#7	sk110 	ath0	write	sf	add_flow	sk110:eth FF-FF-FF-FF-FF-FF 100 1502 0 1000 true 1 0
#9	sk110 	ath0	write	sf	add_flow	sk110:eth FF-FF-FF-FF-FF-FF 0  1503 0 1000 true 4 1000
13	sk110 	ath0	write	sf	add_flow	sk110:eth sk111:eth 50 1504 2 1000 true 1 1000
19	sk110	ath0	read	sf	stats
19	sk111	ath0	read	sf	stats
