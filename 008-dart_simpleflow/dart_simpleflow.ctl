#TIME	NODE(S)		DEVICE	MODE	ELEMENT			HANDLER		VALUE
35	FIRSTNODE 	ath0	write	dht/dhtroutemaintenance activestart 	true
80	FIRSTNODE 	ath0	write	sf			add_flow	FIRSTNODE:eth LASTNODE:eth 1000 200 2 10000 true
