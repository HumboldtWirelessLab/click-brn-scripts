#TIME	NODE(S)		DEVICE	MODE	ELEMENT			HANDLER		VALUE
#0	FIRSTNODE 	ath0	write	routing/routing/gfwd	debug		4		
0	FIRSTNODE 	ath0	write	routing/routing/grt	add		LASTNODE:eth 200 75 0
5	FIRSTNODE 	ath0	write	routing/routing/grt	add		LASTNODE:eth 200 75 0
5	FIRSTNODE	ath0	write	sf			add_flow	FIRSTNODE:eth LASTNODE:eth 1000 100 2 5000 true
6	FIRSTNODE 	ath0	write	routing/routing/grt	add		LASTNODE:eth 200 75 0
7	FIRSTNODE 	ath0	write	routing/routing/grt	add		LASTNODE:eth 200 75 0
8	FIRSTNODE 	ath0	write	routing/routing/grt	add		LASTNODE:eth 200 75 0
9	FIRSTNODE 	ath0	write	routing/routing/grt	add		LASTNODE:eth 200 75 0
10	FIRSTNODE 	ath0	write	routing/routing/grt	add		LASTNODE:eth 200 75 0
10	FIRSTNODE	ath0	read	sf			stats		
10	LASTNODE	ath0	read	sf			stats		
