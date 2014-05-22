#TIME	NODE(S)	DEVICE	MODE	ELEMENT	HANDLER		VALUE
13	sk1 	ath0	write	sf	add_flow	sk1:eth FF-FF-FF-FF-FF-FF 50 1504 2 1000 true 1 1000
19	sk1	ath0	read	sf	stats
19	sk2	ath0	read	sf	stats
